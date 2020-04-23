#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} MA410MNU
Description

@param xParam Parameter Description
@return xRet Return Description
@author YourName - mlapidusas@gmail.com
@since 03/04/2020
/*/
//--------------------------------------------------------------
User Function MA410MNU
Public bFiltraBrw
Public aFilBrw		:= {'SC5','.T.'}

	bFiltraBrw := {|| .T. }

	aAdd(aRotina,{'@ Lib. Cred/Est.','U_LibPedVen'		, 0, 2, 0, NIL})
	aAdd(aRotina,{'@ Transmissao'   ,'u_TransTraPed'    , 0, 2, 0, NIL})
	aAdd(aRotina,{'@ Monitor'       ,'u_TransMonPed'    , 0, 2, 0, NIL})
	aAdd(aRotina,{'@ DANFE'         ,'u_TransDanPed'    , 0, 2, 0, NIL})

Return(Nil)

//--------------------------------------------------------------
/*/{Protheus.doc} LibPedVen
Description

@param xParam Parameter Description
@return xRet Return Description
@author YourName - mlapidusas@gmail.com
@since 03/04/2020
/*/
//--------------------------------------------------------------
User Function LibPedVen
Local aArea		:= GetArea()
Local aAreaC5	:= SC5->(GetArea())
Local aAreaC9	:= SC9->(GetArea())
Local lBlq		:= .F.
Local lSC9		:= .F.

	dbSelectArea("SC9")
	SC9->(dbSetOrder(1))	//C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO+C9_BLEST+C9_BLCRED
	SC9->(dbGoTop())
	SC9->(dbSeek(SC5->C5_FILIAL + SC5->C5_NUM))
	While !SC9->(EOF()) .AND. (SC5->C5_FILIAL == SC9->C9_FILIAL) .AND. (SC5->C5_NUM == SC9->C9_PEDIDO)
		lSC9 := .T.

		If(ALLTRIM(SC9->C9_BLEST) <> '')
			lBlq := .T.
			Exit
		EndIf
		SC9->(dbSkip())
	EndDo

	If(lSC9)
		If(lBlq)
			A456LibMan("SC9")
		Else
			Alert("Pedido sem itens bloqueados!!!")
		EndIf
	Else
		Alert("Pedido não liberado!!!")
	EndIf

	RestArea(aAreaC5)
	RestArea(aAreaC9)
	RestArea(aArea)

Return(Nil)

//--------------------------------------------------------------
/*/{Protheus.doc} TransTraPed
Description

@param xParam Parameter Description
@return xRet Return Description
@author YourName - mlapidusas@gmail.com
@since 03/04/2020
/*/
//--------------------------------------------------------------
User Function TransTraPed
Local oProcess

	oProcess := MsNewProcess():New({|| _TransTraPed(@oProcess)}, "Transmissão de Notas Fiscais...", "Transmissão de Notas Fiscais...", .F.) 
	oProcess:Activate()

Return(Nil)

//--------------------------------------------------------------
/*/{Protheus.doc} TransTraPed
Description

@param xParam Parameter Description
@return xRet Return Description
@author YourName - mlapidusas@gmail.com
@since 03/04/2020
/*/
//--------------------------------------------------------------
Static Function _TransTraPed(oProcess)
Local aArea := GetArea()
Local aPerg	:= {}

	oProcess:SetRegua1(1)
	oProcess:SetRegua2(4)

	oProcess:IncRegua2('.::Transmissão::.')
	
	//-----------------------------------------------------------------------
	//ETAPA 001
	//-----------------------------------------------------------------------
	oProcess:IncRegua2('(001) Verificando SEFAZ - TSS...')
	SpedNFeStatus()

	//---------------------------------------------------------------------------------------------------------------
	//FICA NA DECISÃO DO USUÁRIO DAR SEQUENCIA OU NAO NA EXECUCAO DO PROGRAMA, A PARTIR DA TELA EXIBIDA NA FUNCAO ANTERIOR (SpedNFeStatus)
	//CASO A SEFAZ ESTEJA EM CONTINGÊNCIA, NECESSÁRIO ENTRAR NA ROTINA E TROCAR A MODALIDADE DA TRANSMISSÃO...
	//---------------------------------------------------------------------------------------------------------------
	If !MsgBox("Executa ?", "Atenção", "YESNO")
		RestArea(aArea)
		Return(Nil)
	EndIf

	//-----------------------------------------------------------------------
	//ETAPA 002
	//-----------------------------------------------------------------------
	oProcess:IncRegua2('(002) Transmissão...')
	AutoNfeEnv(/*cEmpresa*/, /*cFilProc*/, /*cWait*/, /*cOpc*/, SC5->C5_SERIE, SC5->C5_NOTA, SC5->C5_NOTA)

	//-----------------------------------------------------------------------
	//ETAPA 003
	//-----------------------------------------------------------------------
	oProcess:IncRegua2('(003) Monitorando...')
	SpedNFe6Mnt(SC5->C5_SERIE, SC5->C5_NOTA, SC5->C5_NOTA, /*lCTe*/, /*lMDFe*/, /*cModel*/, /*lTMS*/, /*lAutoColab*/, .T./*lExibTela*/, /*lUsaColab*/, /*lNFCE*/)

	//-----------------------------------------------------------------------
	//ETAPA 004
	//-----------------------------------------------------------------------
	oProcess:IncRegua2('(004) Impressão DANFE...')
	Pergunte("NFSIGW", .F. , , , , ,  @aPerg)
	MV_PAR01 := SC5->C5_NOTA 		//Da Nota Fiscal ?              
	MV_PAR02 := SC5->C5_NOTA		//Ate a Nota Fiscal ?           
	MV_PAR03 := SC5->C5_SERIE  		//Da Serie ?                    
	MV_PAR04 := 2		   			//Tipo de Operacao ?            
	MV_PAR05 := 2   				//Imprime no verso ?            
	MV_PAR06 := 2					//Danfe Simplificado ?          
	MV_PAR07 := STOD("19900101")	//Data De ?                     
	MV_PAR08 := STOD("20491231")	//Data Até ?                    
	__SaveParam("NFSIGW", aPerg)
	SpedDanfe(0)



	RestArea(aArea)

Return(Nil)
//--------------------------------------------------------------
/*/{Protheus.doc} TransDanPed
Description

@param xParam Parameter Description
@return xRet Return Description
@author YourName - mlapidusas@gmail.com
@since 03/04/2020
/*/
//--------------------------------------------------------------
User Function TransDanPed
Local aArea := GetArea()
Local aPerg	:= {}

	Pergunte("NFSIGW", .F. , , , , ,  @aPerg)
	MV_PAR01 := SC5->C5_NOTA 		//Da Nota Fiscal ?              
	MV_PAR02 := SC5->C5_NOTA		//Ate a Nota Fiscal ?           
	MV_PAR03 := SC5->C5_SERIE  		//Da Serie ?                    
	MV_PAR04 := 2		   			//Tipo de Operacao ?            
	MV_PAR05 := 2   				//Imprime no verso ?            
	MV_PAR06 := 2					//Danfe Simplificado ?          
	MV_PAR07 := STOD("19900101")	//Data De ?                     
	MV_PAR08 := STOD("20491231")	//Data Até ?                    
	__SaveParam("NFSIGW", aPerg)

	SpedDanfe(0)

	RestArea(aArea)

Return(Nil)

//--------------------------------------------------------------
/*/{Protheus.doc} TransMonPed
Description

@param xParam Parameter Description
@return xRet Return Description
@author YourName - mlapidusas@gmail.com
@since 03/04/2020
/*/
//--------------------------------------------------------------
User Function TransMonPed
Local aArea := GetArea()

	//SpedNFe1Mnt()
	SpedNFe6Mnt(SC5->C5_SERIE, SC5->C5_NOTA, SC5->C5_NOTA, /*lCTe*/, /*lMDFe*/, /*cModel*/, /*lTMS*/, /*lAutoColab*/, .T./*lExibTela*/, /*lUsaColab*/, /*lNFCE*/)

	RestArea(aArea)

Return(Nil)
