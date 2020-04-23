#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "fileio.ch"
#INCLUDE "TopConn.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} FISTRFNFE

@author Marcio Rodrigo Lapidusas | mlapidusas@gmail.com
@since 23/04/2020
@version 1.0
/*/
//-------------------------------------------------------------------
User Function FISTRFNFE()

	aAdd(aRotina, {"@ Envia DANFE/XML", "U_EnvXMLDanfe", 0, 2, 0, NIL})

Return(Nil)

//-------------------------------------------------------------------
/*/{Protheus.doc} EnvXMLDanfe
Definição do modelo de Dados

@author marcio.rodrigo
@since 23/04/2020
@version 1.0
/*/
//-------------------------------------------------------------------
User Function EnvXMLDanfe()
Local aArea     := GetArea()
Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cIdEnt	:= ""
Local cXMLNFe   := ""

    If(Empty(cURL))
        Alert("Erro na URL do TSS!!!")
        Return(Nil)
    EndIf

    cIdEnt := GetIdEnt(cURL)
    If(Empty(cIdEnt))
        Alert("Erro ao recuperar entidade do TSS!!!")
        Return(Nil)
    EndIf

    cXMLNFe := GetXMLNFe(cURL, cIdEnt)
    If(Empty(cXMLNFe))
        Alert("Erro ao recuperar XML do TSS!!!")
        Return(Nil)
    EndIf

    GerXMLDanfe(cIdEnt, cXMLNFe)

    RestArea(aArea)

Return(Nil)

//-------------------------------------------------------------------
/*/{Protheus.doc} GerXMLDanfe
Definição do modelo de Dados

@author marcio.rodrigo
@since 23/04/2020
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function GerXMLDanfe(cIdEnt, cXMLNFe)
Local _nX				:= 0
Local oDANFE			:= Nil	//objeto da classe FwMsPrinter
Local oSetup			:= Nil	//objeto da classe FwPrintSetup
Local nFlags			:= 0	//indica quais opcoes estarao disponiveis na configuracao da impressao
Local nDestination		:= 1	//SERVER
Local nOrientation		:= 1	//PORTRAIT
Local nPrintType		:= 6	//PDF
Local lLoja				:= .T.
Local cFilePrintert		:= ""
Local cPathInServer		:= "\temp\"	//GetTempPath()
Local aAnexo			:= {}
Local nTipo				:= 0
Local lServer			:= .T.
Local lAdjustToLegacy	:= .F.
Local lDisableSetup		:= .T.
Local lPDFAsPNG			:= .F.
Local lViewPDF			:= .F.
Local cHtml				:= ""
Local cAssunto			:= ""
Local cDirModel			:= "\system\"
Local cModel			:= "email_env_nfe.html"
Local nHandle			:= 0
Local nLength			:= 0
Local cEmail            := ""

    cFilePrintert := SF2->F2_CHVNFE + "_" + DTOS(Date()) + "_" + StrTran(Time(),":","")

    //-------------------------------------------------------------------------------------------------------------------------------------
    //FWPrintSetup
    //-------------------------------------------------------------------------------------------------------------------------------------
    nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN	//indica quais opcoes estarao disponiveis
    oSetup := FWPrintSetup():New(nFlags, "DANFE")
    oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
    oSetup:SetPropert(PD_ORIENTATION , nOrientation)
    oSetup:SetPropert(PD_DESTINATION , nDestination)
    oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
    oSetup:SetPropert(PD_PAPERSIZE   , DMPAPER_A4)
    oSetup:CQTDCOPIA := "01"
    oSetup:aOptions[PD_VALUETYPE] := cPathInServer

    //-------------------------------------------------------------------------------------------------------------------------------------
    //FWMsPrinter
    //-------------------------------------------------------------------------------------------------------------------------------------
    oDANFE := FWMsPrinter():New(cFilePrintert, IMP_PDF, lAdjustToLegacy, cPathInServer, lDisableSetup, /*[lTReport]*/, /*[@oPrintSetup]*/, /*[ cPrinter]*/, lServer, lPDFAsPNG, /*[ lRaw]*/, lViewPDF, /*[ nQtdCopy]*/ )
    oDANFE:SetResolution(78) //Tamanho estipulado para a Danfe
    oDANFE:SetPortrait()
    oDANFE:SetParm( "-RFS")
    //oDANFE:SetLandscape() //Paisagem
    oDANFE:SetPaperSize(DMPAPER_A4)
    oDANFE:SetMargin(60,60,60,60)
    oDANFE:nDevice := IMP_PDF
    oDANFE:cPathPDF := cPathInServer
    oDANFE:SetCopies(1)

    //---------------------------------------------------------------------------------------------------------------------
    //FUNCAO DENTRO DO DANFEII
    U_PrtNfeSef(cIdEnt, Nil, Nil, oDANFE, oSetup, cFilePrintert, lLoja, nTipo)
    FreeObj(oSetup)
    FreeObj(oDANFE)
    oSetup := Nil
    oDANFE := Nil
    DelClassIntf()

    //---------------------------------------------------------------------------------------------------------------------
    //Cria o arquivo XML
    nHandle := fCreate(cPathInServer + cFilePrintert + ".xml", Nil, Nil, .F.)
    If fWrite(nHandle, cXMLNFe, Len(cXMLNFe)) < Len(cXMLNFe)
        Alert("erro ao criar o arquivo XML.")
        Return(Nil)
    Else
        fClose(nHandle)
    EndIf

	//-----------------------------------------------------------------------------------------------------
	//EFETUA A ABERTURA DO ARQUIVO MODELO
	nHandle := FOpen(cDirModel + cModel)
	If nHandle == -1
		MsgInfo("Arquivo modelo '" + cModel + "' não localizado, tente novamente!!!")
		Return(Nil)
	EndIf

	nLength := FSeek(nHandle,0,FS_END)
	FSeek(nHandle,0)
	If nHandle > 0
		FRead(nHandle, cHtml, nLength)
		FClose(nHandle)
	Else
		MsgInfo("Erro na leitura do arquivo modelo " + cModel + ", tente novamente")
		Return(Nil)
	EndIf

	//-----------------------------------------------------------------------------------------------------
	//PROCESSA O ARQUIVO MODELO (TSS)
	cBodyMail := ""
	cTemplate := cHtml
	
	While !Empty(cTemplate)
		nPosIni := At("<%=",cTemplate)
		nPosFim := At("%>" ,SubStr(cTemplate,nPosIni+3))
		If nPosIni <> 0 .And. nPosFim <> 0
			cBodyMail += SubStr(cTemplate,1,nPosIni-1)	
			cMacro := ""
			lBreak := .F.
			bErro  := ErrorBlock({|e| lBreak := .T. })
			Begin Sequence
				cMacro := SubStr(cTemplate,nPosIni+3,nPosFim-1)
				cMacro := &(cMacro)
				If lBreak
					Break
				EndIf		
				Recover
				cMacro := "Error"
			End Sequence
			ErrorBlock(bErro)		
			cBodyMail += cMacro		
			cTemplate := SubStr(cTemplate,nPosIni+nPosFim+4)
		Else
			cBodyMail += cTemplate
			cTemplate := ""
	    EndIf    
	EndDo

	//-----------------------------------------------------------------------------------------------------
	//PREPARA PARA ENVIO DO E-MAIL
    aAdd(aAnexo, {cFilePrintert + ".xml", cPathInServer + cFilePrintert + ".xml"})
    aAdd(aAnexo, {cFilePrintert + ".pdf", cPathInServer + cFilePrintert + ".pdf"})

	cAssunto := "XML e DANFE"
    cEmail   := FWInputBox("Informe o email de destino (se mais de um, separar por ';'", "")

	Processa({|| u_EnvMail(cEmail,;					                //_cPara
							"",;		        					//_cCc
							"",;									//_cBCC
							cAssunto,;								//_cTitulo
							aAnexo,;								//_aAnexo
							cBodyMail,;								//_cMsg
							.T.)}, "Aguarde, enviando e-mail...")	//_lAudit

	//-----------------------------------------------------------------------------------------------------
	//PORCARIA DO .REL NAO APAGA SOZINHO
    aAdd(aAnexo, {cFilePrintert + ".rel", cPathInServer + cFilePrintert + ".rel"})
	For _nX := 1 to Len(aAnexo)
		FErase(aAnexo[_nX][02])
	Next _nX

Return(Nil)

//-------------------------------------------------------------------
/*/{Protheus.doc} GetXMLNFe
Definição do modelo de Dados

@author marcio.rodrigo
@since 23/04/2020
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function GetXMLNFe(cURL, cIdEnt)
Local lRet			:= .F.
Local cMsg			:= ""
Local oWsdl			:= Nil
Local cMsgRet		:= ""
Local oXML			:= Nil
Local cXMLNFe       := ""
Private cError   	:= ""
Private cWarning 	:= ""

	oWsdl := Nil
	oWsdl := TWsdlManager():New()
	oWsdl:nTimeout := 120

	lRet := oWsdl:ParseURL(ALLTRIM(cURL) + "/NFESBRA.apw?wsdl")
	If lRet == .F.
		conout("Erro(1): " + oWsdl:cError)
		Return(cXMLNFe)
	EndIf

	// Define a operação
	lRet := oWsdl:SetOperation("RETORNAFX")
	If lRet == .F.
		conout("Erro(2): " + oWsdl:cError)
		Return(cXMLNFe)
	EndIf

	cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nfs="http://webservices.totvs.com.br/nfsebra.apw">'
	cMsg += '   <soapenv:Header/>'
   	cMsg += '<soapenv:Body>'
	cMsg += '      <nfs:RETORNAFX>'
	cMsg += '         <nfs:USERTOKEN>TOTVS</nfs:USERTOKEN>'
	cMsg += '         <nfs:ID_ENT>' + cIdEnt + '</nfs:ID_ENT>'
	cMsg += '         <nfs:IDINICIAL>' + SF2->F2_SERIE + SF2->F2_DOC + '</nfs:IDINICIAL>'
	cMsg += '         <nfs:IDFINAL>' + SF2->F2_SERIE + SF2->F2_DOC + '</nfs:IDFINAL>'
	cMsg += '         <nfs:DIASPARAEXCLUSAO>0</nfs:DIASPARAEXCLUSAO>'
	cMsg += '         <nfs:DATADE>20010101</nfs:DATADE>'
	cMsg += '         <nfs:DATAATE>20491231</nfs:DATAATE>'
	cMsg += '         <nfs:CNPJDESTINICIAL></nfs:CNPJDESTINICIAL>'
	cMsg += '         <nfs:CNPJDESTFINAL>ZZZZZZZZZZZZZZ</nfs:CNPJDESTFINAL>'
	cMsg += '      </nfs:RETORNAFX>'
	cMsg += '   </soapenv:Body>'
	cMsg += '</soapenv:Envelope>'

	// Envia uma mensagem SOAP personalizada ao servidor
	lRet := oWsdl:SEndSoapMsg(cMsg)
	If lRet == .F.
		conout("Erro(3): " + oWsdl:cError)
		Return(cXMLNFe)
	EndIf

	cMsgRet := oWsdl:GetSoapResponse()
	oXML := XmlParser(cMsgRet,'_',@cError,@cWarning)	//Realiza parser no XML recebido por parâmetro em Variável.

	//Verifica Leitura
	If !(Empty(cError)) .OR. !(Empty(cWarning)) .OR. ValType(oXml) <> "O"
		Alert('Erro processamento do XML')
		Return(cXMLNFe)
	EndIf

    If(XmlChildEx(oXML, "_SOAP_ENVELOPE") != NIL .AND.;
        XmlChildEx(oXML:_SOAP_ENVELOPE, "_SOAP_BODY") != NIL .AND.;
        XmlChildEx(oXML:_SOAP_ENVELOPE:_SOAP_BODY, "_RETORNAFXRESPONSE") != NIL .AND.;
        XmlChildEx(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_RETORNAFXRESPONSE, "_RETORNAFXRESULT") != NIL .AND.;
        XmlChildEx(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_RETORNAFXRESPONSE:_RETORNAFXRESULT, "_NOTAS") != NIL .AND.;
        XmlChildEx(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_RETORNAFXRESPONSE:_RETORNAFXRESULT:_NOTAS, "_NFES3") != NIL .AND.;
        XmlChildEx(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_RETORNAFXRESPONSE:_RETORNAFXRESULT:_NOTAS:_NFES3, "_NFE") != NIL .AND.;
        XmlChildEx(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_RETORNAFXRESPONSE:_RETORNAFXRESULT:_NOTAS:_NFES3:_NFE, "_XML") != NIL)
        cXMLNFe := oXML:_SOAP_ENVELOPE:_SOAP_BODY:_RETORNAFXRESPONSE:_RETORNAFXRESULT:_NOTAS:_NFES3:_NFE:_XML:TEXT
	EndIf

	FreeObj(oWsdl)
    oWsdl := Nil

	FreeObj(oXml)
	oXml := Nil
	DelClassIntf()	//Exclui todas classes de interface da thread

Return(cXMLNFe)

//-------------------------------------------------------------------
/*/{Protheus.doc} GetIdEnt
Definição do modelo de Dados

@author marcio.rodrigo
@since 23/04/2020
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function GetIdEnt(cURL)
Local lRet			:= .F.
Local cMsg			:= ""
Local oWsdl			:= Nil
Local cMsgRet		:= ""
Local oXML			:= Nil
Local cIdEnt        := ""
Private cError   	:= ""
Private cWarning 	:= ""

	oWsdl := Nil
	oWsdl := TWsdlManager():New()
	oWsdl:nTimeout := 120

	lRet := oWsdl:ParseURL(ALLTRIM(cURL) + "/SPEDADM.apw?wsdl")
	If lRet == .F.
		conout("Erro(1): " + oWsdl:cError)
		Return(cIdEnt)
	EndIf

	// Define a operação
	lRet := oWsdl:SetOperation("GETADMEMPRESASID")
	If lRet == .F.
		conout("Erro(2): " + oWsdl:cError)
		Return(cIdEnt)
	EndIf

	cMsg := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sped="http://webservices.totvs.com.br/spedadm.apw">'
	cMsg += '   <soapenv:Header/>'
	cMsg += '   <soapenv:Body>'
	cMsg += '      <sped:GETADMEMPRESASID>'
	cMsg += '         <sped:USERTOKEN>TOTVS</sped:USERTOKEN>'
	cMsg += '         <sped:CNPJ>' + ALLTRIM(SM0->M0_CGC) + '</sped:CNPJ>'
	cMsg += '         <sped:CPF></sped:CPF>'
	cMsg += '         <sped:IE>' + ALLTRIM(SM0->M0_INSC) + '</sped:IE>'
	cMsg += '         <sped:UF>' + ALLTRIM(SM0->M0_ESTCOB) + '</sped:UF>'
	cMsg += '      </sped:GETADMEMPRESASID>'
	cMsg += '   </soapenv:Body>'
	cMsg += '</soapenv:Envelope>'

	// Envia uma mensagem SOAP personalizada ao servidor
	lRet := oWsdl:SEndSoapMsg(cMsg)
	If lRet == .F.
		conout("Erro(3): " + oWsdl:cError)
		Return(cIdEnt)
	EndIf

	cMsgRet := oWsdl:GetSoapResponse()
	oXML := XmlParser(cMsgRet,'_',@cError,@cWarning)	//Realiza parser no XML recebido por parâmetro em Variável.

	//Verifica Leitura
	If !(Empty(cError)) .OR. !(Empty(cWarning)) .OR. ValType(oXml) <> "O"
		Alert('Erro processamento do XML')
		Return(cIdEnt)
	EndIf

    If(XmlChildEx(oXML, "_SOAP_ENVELOPE") != NIL .AND.;
        XmlChildEx(oXML:_SOAP_ENVELOPE, "_SOAP_BODY") != NIL .AND.;
        XmlChildEx(oXML:_SOAP_ENVELOPE:_SOAP_BODY, "_GETADMEMPRESASIDRESPONSE") != NIL .AND.;
        XmlChildEx(oXML:_SOAP_ENVELOPE:_SOAP_BODY:_GETADMEMPRESASIDRESPONSE, "_GETADMEMPRESASIDRESULT") != NIL)
        cIdEnt := oXML:_SOAP_ENVELOPE:_SOAP_BODY:_GETADMEMPRESASIDRESPONSE:_GETADMEMPRESASIDRESULT:TEXT
	EndIf

	FreeObj(oWsdl)
    oWsdl := Nil

	FreeObj(oXml)
	oXml := Nil
	DelClassIntf()	//Exclui todas classes de interface da thread

Return(cIdEnt)
