#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"

//--------------------------------------------------------------------
/*/{Protheus.doc} UPDTAMCP
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  20/05/2019
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDTAMCP

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAÇÃO DE TAMANHO DE CAMPOS"
Local   cDesc1    := "Esta rotina tem objetivo ajustar o tamanho dos campos de acordo com os arquivos"
Local   cDesc2    := "de configuração selecionados."
Local   cDesc3    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros"
Local   cDesc4    := "usuários  ou  jobs utilizando  o sistema.  É EXTREMAMENTE recomendavél  que  se  faça um"
Local   cDesc5    := "BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para que caso "
Local   cDesc6    := "ocorram eventuais falhas, esse backup possa ser restaurado."
Local   cDesc7    := ""
Local   cMsg      := ""
Local   lOk       := .F.

Private lIsUsrAdm := .F.

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
	TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
aAdd( aSay, cDesc6 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

FormBatch(  cTitulo,  aSay,  aButton )

If lOk
	aMarcadas := EscEmpresa( )
	
	If !Empty( aMarcadas )
		oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, .F.) }, "Atualizando", "Aguarde, atualizando ...", .F. )
		oProcess:Activate( )
		
		If lOk
			Final( "Atualização Realizada." )
		Else
			Final( "Atualização não Realizada." )
		EndIf
		
	Else
		Final( "Atualização não Realizada." )
		
	EndIf
	
EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  20/05/2019
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas, lAuto )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ""
Local   cFile     := ""
Local   cFileLog  := ""
Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
Local   cTCBuild  := "TCGetBuild"
Local   cTexto    := ""
Local   cTopBuild := ""
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nPos      := 0
Local   nRecno    := 0
Local   nX        := 0
Local   oDlg      := NIL
Local   oFont     := NIL
Local   oMemo     := NIL
Local   aSX3      := NIL

Private aArqUpd   := {}

If ( lOpen := MyOpenSm0(.T.) )
	
	dbSelectArea( "SM0" )
	dbGoTop()
	
	While !SM0->( EOF() )
		// Só adiciona no aRecnoSM0 se a empresa for diferente
		If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
			.AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
			aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
		EndIf
		SM0->( dbSkip() )
	End
	
	SM0->( dbCloseArea() )
	
	If lOpen
		
		For nI := 1 To Len( aRecnoSM0 )
			
			If ! ( lOpen := MyOpenSm0(.F.) )
				MsgStop( "Atualização da empresa " + aRecnoSM0[nI][2] + " não efetuada." )
				Exit
			EndIf
			
			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )
			
			RpcSetType( 3 )
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )
			
			PtInternal( 1, "UPDTAMCP - Emp: " + cNumEmp + " - " + "update de dicionários" )
			TcInternal( 1, "UPDTAMCP - Emp: " + cNumEmp + " - " + "update de dicionários" )
			
			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.
			
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( " Dados Ambiente" )
			AutoGrLog( " --------------------" )
			AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
			//AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
			//AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
			AutoGrLog( " Data / Hora Ínicio.: " + DtoC( Date() )  + " / " + Time() )
			AutoGrLog( " Environment........: " + GetEnvServer()  )
			AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
			AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
			AutoGrLog( " Versão.............: " + GetVersao(.T.) )
			AutoGrLog( " Usuário TOTVS .....: " + __cUserId + " " +  cUserName )
			AutoGrLog( " Computer Name......: " + GetComputerName() )
			
			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( " Dados Thread" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Usuário da Rede....: " + aInfo[nPos][1] )
				AutoGrLog( " Estação............: " + aInfo[nPos][2] )
				AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
				AutoGrLog( " Environment........: " + aInfo[nPos][6] )
				AutoGrLog( " Conexão............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			
			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
			EndIf
			
			If ! lIsUsrAdm
				
				lIsUsrAdm := MyFWAuthAdmin( )
				
				If ! lIsUsrAdm
					RpcClearEnv()
					AutoGrLog( "Usuario não possui permissão de administrador." )
					Return .F.
				EndIf
				
				If ! MsgNoYes( "Confirma a atualização dos dicionários ?", "Confirmacao" )
					Return .F.
				EndIf
				
				If ! fGetArqs( @aSX3 )
					AutoGrLog( "Nenhuma informacao encontrada para processamento." )
					Return .F.
				EndIf
			EndIf
			
			oProcess:SetRegua1( 8 )
			
			//------------------------------------
			// Atualiza o dicionário SX3
			//------------------------------------
			FSAtuSX3( aSX3 )
			
			oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos" )
			
			// Alteração física dos arquivos
			__SetX31Mode( .F. )
			
			If FindFunction(cTCBuild)
				cTopBuild := &cTCBuild.()
			EndIf
			
			For nX := 1 To Len( aArqUpd )
				
				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
						! aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
						TcInternal( 25, "CLOB" )
					EndIf
				EndIf
				
				If Select( aArqUpd[nX] ) > 0
					(aArqUpd[nX])->(dbCloseArea())
				EndIf
				
				PtInternal( 1, "UPDTAMCP - Emp: " + cNumEmp + " Tab: " + aArqUpd[nX] + " update de dicionários" )
				TcInternal( 1, "UPDTAMCP - Emp: " + cNumEmp + " Tab: " + aArqUpd[nX] + " update de dicionários" )
				
				X31UpdTable( aArqUpd[nX] )
				
				If __GetX31Error()
					Alert( __GetX31Trace() )
					MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
					AutoGrLog( "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] )
				EndIf
				
				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf
				
			Next nX
			
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
			AutoGrLog( Replicate( "-", 128 ) )
			
			RpcClearEnv()
			
		Next nI
		
		If !lAuto
			
			cTexto := LeLog()
			
			Define Font oFont Name "Mono AS" Size 5, 12
			
			Define MsDialog oDlg Title "Atualização concluida." From 3, 0 to 340, 417 Pixel
			
			@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
			oMemo:bRClicked := { || AllwaysTrue() }
			oMemo:oFont     := oFont
			
			Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
			MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel
			
			Activate MsDialog oDlg Center
			
		EndIf
		
	EndIf
	
Else
	
	lRet := .F.
	
EndIf

Return lRet


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  20/05/2019
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX3( aSX3 )
Local cAlias    := ""
Local cAliasAtu := ""
Local cMsg      := ""
Local cSeqAtu   := ""
Local cX3Campo  := ""
Local cX3Dado   := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nPosCpo   := 1
Local nPosTam   := 2
Local nPosDec   := 3
Local nPosPic   := 4
Local nTamSeek  := Len( SX3->X3_CAMPO )

AutoGrLog( "Ínicio da Atualização" + " SX3" + CRLF )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )
	
	SX3->( dbSetOrder( 2 ) )
	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )
		AutoGrLog( aSX3[nI][nPosCpo] + " - Nao encontrado." )
	ElseIf SX3->X3_TIPO != "N"
		AutoGrLog( aSX3[nI][nPosCpo] + " - Tipo de campo diferente de numerico." )
	ElseIf !Empty( SX3->X3_GRPSXG )
		AutoGrLog( aSX3[nI][nPosCpo] + " - Pertence ao grupo " + SX3->X3_GRPSXG )
	ElseIf SX3->X3_TAMANHO == aSX3[nI][nPosTam] .And. SX3->X3_DECIMAL == aSX3[nI][nPosDec]
		AutoGrLog( aSX3[nI][nPosCpo] + " - Nao precisa ser alterado." )
	Else
		AutoGrLog( aSX3[nI][nPosCpo] + " - Tamanho alterado de " + CValToChar( SX3->X3_TAMANHO ) + "/" + CValToChar( SX3->X3_DECIMAL ) +;
		" para " + CValToChar( aSX3[nI][nPosTam] ) + "/" + CValToChar( aSX3[nI][nPosDec] ))
		RecLock( "SX3", .F. )
		SX3->X3_TAMANHO := aSX3[nI][nPosTam]
		SX3->X3_DECIMAL := aSX3[nI][nPosDec]
		SX3->X3_PICTURE := aSX3[nI][nPosPic]
		SX3->( MsUnlock( ) )
		
		If !( SX3->X3_ARQUIVO $ cAlias )
			cAlias += SX3->X3_ARQUIVO + "/"
			aAdd( aArqUpd, SX3->X3_ARQUIVO )
		EndIf
	EndIf
	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )
	
Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )


Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa
Função genérica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as seleções feitas.
Se não for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Parâmetro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta só com Empresas
// 3 - Monta só com Filiais de uma Empresa
//
// Parâmetro  aMarcadas
// Vetor com Empresas/Filiais pré marcadas
//
// Parâmetro  cEmpSel
// Empresa que será usada para montar seleção
//---------------------------------------------
Local   aRet      := {}
Local   aSalvAmb  := GetArea()
Local   aSalvSM0  := {}
Local   aVetor    := {}
Local   cMascEmp  := "??"
Local   cVar      := ""
Local   lChk      := .F.
Local   lOk       := .F.
Local   lTeveMarc := .F.
Local   oNo       := LoadBitmap( GetResources(), "LBNO" )
Local   oOk       := LoadBitmap( GetResources(), "LBOK" )
Local   oDlg, oChkMar, oLbx, oMascEmp, oSay
Local   oButDMar, oButInv, oButMarc, oButOk, oButCanc
Local   aMarcadas := {}

If !MyOpenSm0(.F.)
	Return aRet
EndIf

dbSelectArea("SM0")
aSalvSM0 := SM0->( GetArea() )
dbSetOrder(1)
dbGoTop()

Do While !SM0->( EOF() )
	If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
		aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	EndIf
	dbSkip()
Enddo

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title "" From 0, 0 To 280, 395 Pixel

oDlg:cToolTip := "Tela para Múltiplas Seleções de Empresas/Filiais"
oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualização"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos" Message "Marca / Desmarca"+ CRLF + "Todos" Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

// Marca/Desmarca por mascara
@ 113, 51 Say   oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Máscara Empresa ( ?? )"  Of oDlg
oSay:cToolTip := oMascEmp:cToolTip
@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Seleção" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "máscara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "máscara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDTAMCP" ) ) ) ;
Message "Confirma a seleção e efetua" + CRLF + "o processamento" Of oDlg
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
Message "Cancela o processamento" + CRLF + "e abandona a aplicação" Of oDlg
oButCanc:SetCss( CSSBOTAO )

Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos
Função auxiliar para marcar/desmarcar todos os ítens do ListBox ativo

@param lMarca  Contéudo para marca .T./.F.
@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} InvSelecao
Função auxiliar para inverter a seleção do ListBox ativo

@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} RetSelecao
Função auxiliar que monta o retorno com as seleções

@param aRet    Array que terá o retorno das seleções (é alterado internamente)
@param aVetor  Vetor do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
	EndIf
Next nI

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaMas
Função para marcar/desmarcar usando máscaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a máscara (???)
@param lMarDes  Marca a ser atribuída .T./.F.

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] := lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} VerTodos
Função auxiliar para verificar se estão todos marcados ou não

@param aVetor   Vetor do ListBox
@param lChk     Marca do CheckBox do marca todos (referncia)
@param oChkMar  Objeto de CheckBox do marca todos

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0
Função de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  20/05/2019
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MyOpenSM0(lShared)

If lShared
	OpenSm0()
Else
	OpenSm0Excl()
Endif

Return .T.
//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  20/05/2019
@obs    Gerado por EXPORDIC - V.6.0.0.1 EFS / Upd. V.5.0.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function LeLog()
Local cRet  := ""
Local cFile := NomeAutoLog()
Local cAux  := ""

FT_FUSE( cFile )
FT_FGOTOP()

While !FT_FEOF()
	
	cAux := FT_FREADLN()
	
	If Len( cRet ) + Len( cAux ) < 1048000
		cRet += cAux + CRLF
	Else
		cRet += CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		cRet += "Tamanho de exibição maxima do LOG alcançado." + CRLF
		cRet += "LOG Completo no arquivo " + cFile + CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		Exit
	EndIf
	
	FT_FSKIP()
End

FT_FUSE()

Return cRet
//--------------------------------------------------------------------
/*/{Protheus.doc} fGetArqs
Função para carregamento dos arquivos de configuração.

@author TOTVS Protheus
@since  14/07/2019
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function fGetArqs( aSX3 )

Local lRet		:= .F.
Local lOk		:= .F.
Local oDlg
Local aVlrUnit	:= { "0    ", "0    ", Space( 100 ), Space( 200 ) }
Local aQuant	:= { "0    ", "0    ", Space( 100 ), Space( 200 ) }
Local aLinhas	:= { }
Local nX		:= 0

Define MsDialog oDlg Title "Ajusta Dicionario" From 0,0 To 260, 777 Pixel

@ 005,005 To 115, 200 Label "Valor Unitario" Of oDlg Pixel
@ 015,010 Say "Tamanho" Size 120,007 Of oDlg Pixel
@ 023,010 MsGet aVlrUnit[1] Picture "99999" Size 50,10 Pixel of oDlg Valid fPic( aVlrUnit )

@ 040,010 Say "Decimal" Size 120,007 Of oDlg Pixel
@ 048,010 MsGet aVlrUnit[2] Picture "99999" Size 50,10 Pixel of oDlg Valid fPic( aVlrUnit )

@ 065,010 Say "Picture" Size 120,007 Of oDlg Pixel
@ 073,010 MsGet aVlrUnit[3] Picture "@!" Size 121,10 Pixel of oDlg READONLY

@ 090,010 Say "Arquivo" Size 120,007 Of oDlg Pixel
@ 098,010 MsGet aVlrUnit[4] Picture "@!" Size 121,10 Pixel of oDlg READONLY
DEFINE SBUTTON FROM 098, 132 TYPE 14 OF oDlg ENABLE ACTION ( fGetFile( @aVlrUnit ) )

@ 005,204 To 115, 386 Label " Quantidade " Of oDlg Pixel
@ 015,209 Say "Tamanho" Size 120,007 Of oDlg Pixel
@ 023,209 MsGet aQuant[1] Picture "99999" Size 50,10 Pixel of oDlg Valid fPic( aQuant )

@ 040,209 Say "Decimal" Size 120,007 Of oDlg Pixel
@ 048,209 MsGet aQuant[2] Picture "99999" Size 50,10 Pixel of oDlg Valid fPic( aQuant )

@ 065,209 Say "Picture" Size 120,007 Of oDlg Pixel
@ 073,209 MsGet aQuant[3] Picture "@!" Size 121,10 Pixel of oDlg READONLY

@ 090,209 Say "Arquivo" Size 120,007 Of oDlg Pixel
@ 098,209 MsGet aQuant[4] Picture "@!" Size 121,10 Pixel of oDlg READONLY
DEFINE SBUTTON FROM 098, 331 TYPE 14 OF oDlg ENABLE ACTION ( fGetFile( @aQuant ) )

DEFINE SBUTTON FROM 117, 005 TYPE 1 OF oDlg ENABLE ACTION ( lOk := .T., oDlg:End( ) )
DEFINE SBUTTON FROM 117, 037 TYPE 2 OF oDlg ENABLE ACTION ( lOk := .F., oDlg:End( ) )

Activate MsDialog oDlg Centered

If lOk
	aSX3 := { }
	If !Empty( aVlrUnit[ 4 ] )
		aLinhas := Separa( MemoRead( aVlrUnit[ 4 ] ), CRLF )
		For nX := 1 to Len( aLinhas )
			If !Empty( aLinhas[ nX ] )
				AAdd( aSX3, {	AllTrim( aLinhas[ nX ] ),;
				Val( aVlrUnit[ 1 ] ),;
				Val( aVlrUnit[ 2 ] ),;
				AllTrim( aVlrUnit[ 3 ] )} )
			EndIf
		Next nX
	EndIf
	
	If !Empty( aQuant[ 4 ] )
		aLinhas := Separa( MemoRead( aQuant[ 4 ] ), CRLF )
		For nX := 1 to Len( aLinhas )
			If !Empty( aLinhas[ nX ] )
				AAdd( aSX3, {	AllTrim( aLinhas[ nX ] ),;
				Val( aQuant[ 1 ] ),;
				Val( aQuant[ 2 ] ),;
				AllTrim( aQuant[ 3 ] )} )
			EndIf
		Next nX
	EndIf
	
	lRet := Len( aSX3 ) > 0
EndIf

Return lRet
//--------------------------------------------------------------------
/*/{Protheus.doc} fPic
Função para geração da nova picture do campos.

@author TOTVS Protheus
@since  14/07/2019
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function fPic( aDados )

Local lRet 		:= .T.
Local cInteiros	:= ""
Local nInteiros	:= 0
Local cDecimais	:= ""
Local nDecimais	:= 0

If !Empty( aDados[ 1 ] ) .And. Val( aDados[ 1 ] ) > 0
	If !Empty( aDados[ 2 ] )
		nDecimais := Val( AllTrim( aDados[ 2 ] ) )
		cDecimais := Replicate( "9", nDecimais )
		
		If nDecimais > 0
			nDecimais++
		EndIf
	EndIf
	
	nInteiros := Val( AllTrim( aDados[ 1 ] ) )
	nInteiros -= nDecimais
	cInteiros := Replicate( "9", nInteiros )
	
	If nInteiros > 0// .And. ( nDecimais == 0 .Or. nInteiros > ( nDecimais + 1 ) )
		aDados[ 3 ] := "@E " + fAjuPic( AllTrim( cInteiros ) )
		
		If !Empty( cDecimais )
			aDados[ 3 ] += "." + cDecimais
		EndIf
	Else
		lRet := .F.
		aDados[ 3 ] := ""
	EndIf
Else
	aDados[ 2 ]	:= "0    "
	aDados[ 3 ] := ""
EndIf

Return lRet
//--------------------------------------------------------------------
/*/{Protheus.doc} fGetFile
Função para seleção do arquivo de configuração.

@author TOTVS Protheus
@since  14/07/2019
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function fGetFile( aDados )

Local lRet 		:= .F.
Local cArquivo	:= cGetFile ( "Arquivo INI (*.ini)|*.ini" , "Selecione o arquivo para processamento.", 1, "", .T., GETF_LOCALHARD, .F. )

If !Empty( cArquivo )
	If !File( cArquivo )
		Help ( " ", 1, "UPDTAMCP",, "Arquivo não encontrado.", 3, 0 )
	Else
		lRet := .T.
		aDados[ 4 ] := cArquivo
	EndIf
EndIf

Return lRet
//--------------------------------------------------------------------
/*/{Protheus.doc} MyFWAuthAdmin
Função que checa se usuario eh administrador.

@author TOTVS Protheus
@since  18/07/2019
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MyFWAuthAdmin( )

Local oFont
Local oDlg
Local oPanel
Local oBmp

Local oUsuario
Local cTmsUsu	:= Space( 40 )

Local oSenha
Local cSenha	:= Space( 10 )

Local oOk
Local oCancel

Local lEndDlg	:= .T.
Local lRet		:= .F.

DEFINE FONT oFont NAME 'Arial' SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlg FROM 040,030 TO 190,310 TITLE "Login" PIXEL OF oMainWnd

@ 000,000 MSPANEL oPanel OF oDlg FONT oFont SIZE 200,200 LOWERED

@ 000,000 BITMAP oBmp RESNAME 'LOGIN' oF oPanel SIZE 045,076 NOBORDER WHEN .F. PIXEL ADJUST

@ 005,070 SAY "Usuario" SIZE 60,07 OF oPanel PIXEL FONT oFont //'Usuario'
@ 015,070 MSGET oUsuario VAR cTmsUsu SIZE 60,10 OF oPanel PIXEL FONT oFont

@ 030,070 SAY "Senha" SIZE 53,07 OF oPanel PIXEL FONT oFont //'Senha'
@ 040,070 MSGET oSenha VAR cSenha SIZE 60,10 PASSWORD OF oPanel PIXEL FONT oFont

DEFINE SBUTTON oOk FROM 60,70 TYPE 1 ENABLE OF oPanel PIXEL ACTION (lRet := VldPass(cTmsUsu,cSenha), oDlg:End( ))

DEFINE SBUTTON oCancel FROM 60,100 TYPE 2 ENABLE OF oPanel PIXEL ACTION ( oDlg:End( ) )

ACTIVATE MSDIALOG oDlg CENTERED VALID lEndDlg

Return lRet
//--------------------------------------------------------------------
/*/{Protheus.doc} VldPass
Checa usuario e senha.

@author TOTVS Protheus
@since  18/07/2019
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function VldPass(cTmsUsu,cSenha)

Local lRet := .F.

cTmsUsu := AllTrim(cTmsUsu)
cSenha	:= AllTrim(cSenha)

PswOrder(2)
If	PswSeek(cTmsUsu)
	If	! PswName(cSenha)
		Help('',1,'USR_EXIST') //"Codigo de usuario nao existe"
		lRet := .F.
	Else
		lRet := .T.
	EndIf
Else
	Help('',1,'USR_EXIST') //"Codigo de usuario nao existe"
	lRet := .F.
EndIf

Return( lRet )
//--------------------------------------------------------------------
/*/{Protheus.doc} fAjuPic
Ajusta picture.

@author TOTVS Protheus
@since  18/07/2019
@version 1.0
/*/
//--------------------------------------------------------------------

Static Function fAjuPic( cInteiros, cPict )

Local cRet 		:= ""
Local nX		:= 0
Local nSize		:= Len( AllTrim( cInteiros ) )
Local nQtdVir	:= 0

For nX := nSize to 1 Step -1
	cRet := SubStr( cInteiros, nX, 1 ) + cRet
	nQtdVir++
	If nQtdVir % 3 == 0
		cRet := "," + cRet
	EndIf
Next nX

If Left( cRet, 1 ) == ","
	cRet := SubStr( cRet, 2 )
EndIf

Return cRet
