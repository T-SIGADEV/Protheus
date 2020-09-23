#Include "Protheus.Ch"
#Include "totvs.ch"
#Include "RestFul.ch"
#Include 'FWMVCDef.ch'
#Include 'FWEditPanel.CH'

/* #########################################################################################
// -----------------------------------------+----------------------------------------------+
// Modulo :FINANCEIRO                                                                      |
// Fonte  :FINETWS()                                                                       |
// -----------+-------------------+--------------------------------------------------------+
// Data       | Autor             | Descricao                                              |
// -----------+-------------------+--------------------------------------------------------+
// 21/08/2019 | Michael M. Castro | Rotina que Realiza a Integração Para FINNET            |
// -----------+-------------------+--------------------------------------------------------+
// #########################################################################################*/

User Function FINETWS()

Local cUrl        := 'https://api.portaldeboletos.com.br/api/v1/boletos'
Local cWsStatus   := 'https://api.portaldeboletos.com.br/api/v1'
Local aHeadStr    := {}
Local oRestClient := FWRest():New(cUrl)
Local oStatus     := FWRest():New(cWsStatus)
Local jSonPar	  := JsonObject():New()
Local jIdent 	  := JsonObject():New()
Local JDados 	  := JsonObject():New() 
Local cJson       := ""
Local cIdFinet    := ""
Local cGRetJson   := ""
Local ObjJsStat   := Nil
Local cRetStatus  := ""
Local cErroRet    := ""
Local lConexao    := .F.
Local i           := 0
Local aDados      := {}
Local cStatWF     := ""	               
Local cDescWf     := ""
Local lEnvWF      := .F.
Local cRetCBar    := ""
Local cRetLDig    := ""
Local cNossoNum   := ""
Local cBanco      := ""

//Carrega o Modelo de Dados MVC
Local oMdlPCV := FwLoadModel("MLFINT03") 

//Dados cliente
Local cEndMlt     := ""
Local cNumMlt     := ""

//Dados do Pagador
Local cTipoCli    := ""
Local cEndPag     := ""      
Local cNumEnd     := ""  
Local nPosEnd     := 0
Local cCmpEnd     := ""
Local cBairro     := ""
Local cMunicp     := ""
Local cUF         := ""            
Local cEmail      := ""
Local nPosEml     := 0
Local cEmlSacAv   := GetNewPar("MV_EMLSAV","cobranca2@teste.com.br")
Local lDocIdEmp   := GetNewPar("ML_IDDOCEP",.F.)

//Dados Titulo
Local cEspBco     := ""

Default cIdCnab := Space(TamSX3("E1_IDCNAB")[1])

//Varivel Retorno Json em Objet
Private ObjJsRet    := Nil

oRestClient:setPath("")

aAdd(aHeadStr,'Content-Type:application/json')

jSonPar['dadosBeneficiario']        := {}

jIdent['identificador']			    := cIdFinet            

jIdent['beneficiario_inscricao'] 	:= SM0->M0_CGC

jSonPar['dadosBeneficiario'] := jIdent

jSonPar['dados'] := {}
  
JDados['pagador_tipo_inscricao']        := cTipoCli
JDados['pagador_inscricao'] 	        := AllTrim(SA1->A1_CGC)
JDados['pagador_nome'] 	                := AllTrim(SubStr(U_RetCharE(SA1->A1_NOME,1,1) ,1,40))
JDados['pagador_endereco_logradouro'] 	:= cEndPag
JDados['pagador_endereco_numero'] 	    := cNumEnd
JDados['pagador_endereco_complemento'] 	:= cCmpEnd
JDados['pagador_endereco_bairro'] 	    := cBairro
JDados['pagador_endereco_cidade'] 	    := cMunicp
JDados['pagador_endereco_uf'] 	        := cUF
JDados['pagador_endereco_cep'] 	        := PADR(IIF(Empty(SA1->A1_ENDCOB),SA1->A1_CEP,SA1->A1_CEPCOB),8)
JDados['pagador_email'] 	            := cEmail
JDados['sacador_tipo_inscricao'] 	    := "2"
JDados['sacador_inscricao'] 	        := AllTrim(SM0->M0_CGC)
JDados['sacador_nome'] 	                := AllTrim(Substr(SM0->M0_NOME,1,40))
JDados['sacador_endereco_logradouro'] 	:= cEndMlt
JDados['sacador_endereco_numero'] 	    := cNumMlt
JDados['sacador_endereco_complemento'] 	:= AllTrim(SM0->M0_COMPCOB)
JDados['sacador_endereco_bairro'] 	    := AllTrim(SM0->M0_BAIRCOB)
JDados['sacador_endereco_cidade'] 	    := AllTrim(SM0->M0_CIDCOB)
JDados['sacador_endereco_uf'] 	        := AllTrim(SM0->M0_ESTCOB)
JDados['sacador_endereco_cep'] 	        := AllTrim(SM0->M0_CEPCOB)
JDados['sacador_email'] 	            := cEmlSacAv
JDados['documento_numero'] 	            := AllTrim(SE1->E1_IDCNAB)
JDados['documento_nosso_numero'] 	    := "000" + AllTrim(SEE->EE_CODEMP) + AllTrim(SE1->E1_NUMBCO)

//******************************************************************
//Inclusão da Nova TAG ID EMPRESA DE PARA FINNET PORTAL DE BOLETOS 
//******************************************************************
If lDocIdEmp  
    JDados['documento_identificador_empresa'] := SE1->E1_NUM + SE1->E1_PARCELA        
EndIf

JDados['documento_data'] 	            := ConvData(dDataBase)
JDados['documento_data_processamento'] 	:= ConvData(SE1->E1_EMISSAO)
JDados['documento_data_vencimento'] 	:= ConvData(SE1->E1_VENCREA)
JDados['documento_valor'] 	            := cVlrTit
JDados['documento_especie'] 	        := AllTrim(SEE->EE_ESPFNET)
JDados['documento_codigo_protesto'] 	:= SEE->EE_CODPROT
JDados['documento_dias_protesto'] 	    := cValToChar(SEE->EE_DIAPROT)
JDados['documento_codigo_multa'] 	    := SEE->EE_CODMULT
JDados['documento_percentual_multa'] 	:= StrTran(AllTrim(Transform(SEE->EE_PERMULT,"@E 999.99")),",",".")
JDados['documento_valor_multa'] 	    := StrTran(AllTrim(Transform(SEE->EE_VALMULT,"@E 999.99")),",",".")
JDados['documento_dias_multa'] 	        := cValToChar(SEE->EE_DIAMULT)
JDados['documento_codigo_juros'] 	    := SEE->EE_CODJURO
JDados['documento_percentual_juros'] 	:= StrTran(AllTrim(Transform(SEE->EE_PERJURO,"@E 999.99")),",",".")
JDados['documento_valor_juros'] 	    := StrTran(AllTrim(Transform(SEE->EE_VALJURO,"@E 999.99")),",",".")
JDados['documento_dias_juros'] 	        := cValToChar(SEE->EE_DIASJUR)
JDados['documento_codigo_desconto'] 	:= SEE->EE_CODDESC
JDados['documento_percentual_desconto'] := StrTran(AllTrim(Transform(SEE->EE_PERDESC,"@E 999.99")),",",".")
JDados['documento_valor_desconto'] 	    := StrTran(AllTrim(Transform(SEE->EE_VALDESC,"@E 999.99")),",",".")
JDados['documento_data_desconto'] 	    := IIF(Empty(SEE->EE_DTADESC),"",ConvData(SEE->EE_DTADESC))
JDados['documento_mensagem'] 	        := AllTrim(SEE->EE_MSGFNET)
JDados['documento_pagamento_parcial'] 	:= SEE->EE_PGPARC
JDados['documento_qtde_pagamento_parcial'] := cValToChar(SEE->EE_QPGPARC)

jSonPar['dados'] := JDados

cJson := JsonPar:ToJson()

cJson := EncodeUTF8(cJson)

//Retira a Barra não pode enviar no Json
cJson := StrTran(cJson,"\","")
cJson := StrTran(cJson,"/","")

//Seta os Paranetros do Json
oRestClient:SetPostParams(cJson)

//*************************************
//Tentativa de Conexão com a Finnet
//*************************************
Do While i < 3 .And. !lConexao 

    //*****************************************
    //Verifica o Status do Serviço Finnet
    //*****************************************
    oStatus:setPath("/healthcheck")
    oStatus:Get()
    cRetStatus:= oStatus:GetResult()

    //Converte o Json em Objeto
    FWJsonDeserialize(DecodeUtf8(cRetStatus),@ObjJsStat) 

    //Verifica se possui Conexão Ativa com a Finnet
    If ObjJsStat:status == "true"

        lConexao := .T. //Conseguiu conexão

        //Grava Data e Hora do Envio
        oMdlPCV:Activate()
        oMdlPCV:SetValue('PCVMASTER', 'PCV_DTENV'	, Date() )
        oMdlPCV:SetValue('PCVMASTER', 'PCV_HSENV'	, SubsTr(Time(),1,5) )
        oMdlPCV:SetValue('PCVMASTER', 'PCV_STATUS'	, "E")

        If oMdlPCV:VldData()
            oMdlPCV:CommitData()
        Else
            If !IsBlind() //.T. = Sem Interface com Usuario / .F. = Interface com o Usuario
                MsgAlert(oMdlPCV:GetErrorMessage())
            Else
                Conout(oMdlPCV:GetErrorMessage())
            EndIf
        EndIf
        
        oMdlPCV:DeActivate()

        //Realiza a Conexão com a Finnet enviando o Json
        If oRestClient:Post(aHeadStr)
            
            cGRetJson := oRestClient:GetResult()

            //Converte o Json em Objeto
            FWJsonDeserialize(DecodeUtf8(cGRetJson),@ObjJsRet)    

            If ObjJsRet:Status == "success" //Boleto Registrado com Sucesso
                //Grava Data e Hora do Retorno
                oMdlPCV:Activate()
                oMdlPCV:SetValue('PCVMASTER', 'PCV_DTRET'	, Date() )
                oMdlPCV:SetValue('PCVMASTER', 'PCV_HSRET'	, SubsTr(Time(),1,5) )
                oMdlPCV:SetValue('PCVMASTER', 'PCV_DESRET'	, ObjJsRet:Status)
                oMdlPCV:SetValue('PCVMASTER', 'PCV_STATUS'	, "I" )
                oMdlPCV:SetValue('PCVMASTER', 'PCV_LDSRET'	, ObjJsRet:Message )
                oMdlPCV:SetValue('PCVMASTER', 'PCV_IDHASH'	, ObjJsRet:Registro:Dados:Documento_Hash)
                oMdlPCV:SetValue('PCVMASTER', 'PCV_RESULT'	, "")

                cRetLDig := ObjJsRet:Registro:Dados:documento_linha_digitavel
                cRetLDig := StrTran(StrTran(cRetLDig,".","")," ", "")
                oMdlPCV:SetValue('PCVMASTER', 'PCV_LINDIG'	, cRetLDig)
                
                cRetCBar := ObjJsRet:Registro:Dados:documento_codigo_barras
                cRetCBar := StrTran(StrTran(cRetCBar,".","")," ", "")
                oMdlPCV:SetValue('PCVMASTER', 'PCV_CODBAR'	, cRetCBar)
                
                //*********************************************************
                //*Verifica se o campo NUMBCO está em branco para Realizar 
                //*a Gravação do Numero Bancario do Retorno do Banco
                //*********************************************************
                If Empty(PCV->PCV_NUMBCO)
                    cNossoNum := Val(AllTrim(ObjJsRet:Registro:Dados:documento_nosso_numero))
                    cBanco := PCV->PCV_BANCO
                    Do Case //Case para saber o tamanho do Nosso Numero igual o do fonte MLTBOLETO.PRW
                        Case cBanco == "001"
                            cNossoNum := StrZero(Left(cNossoNum,10),10)
                        Case cBanco $ "033/353"
                            cNossoNum := StrZero(cNossoNum,8)
                        Case cBanco == "237"
                            cNossoNum := StrZero(cNossoNum,12)
                        Case cBanco == "341"
                            cNossoNum := StrZero(cNossoNum,9)
                        Case cBanco == "399"
                            cNossoNum := StrZero(cNossoNum,11)
                        Case cBanco == "422"
                            cNossoNum := StrZero(cNossoNum,9)                        
                        Case cBanco == "479"
                            cNossoNum := StrZero(cNossoNum,11)
                        Case cBanco == "745"
                            cNossoNum := StrZero(cNossoNum,12)
                    EndCase

                    DbSelectArea("SE1")
                    RecLock("SE1",.F.)
                        SE1->E1_NUMBCO  := cNossoNum
                        SE1->E1_CODDIG  := cRetLDig
                        SE1->E1_CODBAR  := cRetCBar
                    MsUnlock()    
                    oMdlPCV:SetValue('PCVMASTER', 'PCV_NUMBCO'	, cNossoNum)
                EndIf
        
                If oMdlPCV:VldData()
                    oMdlPCV:CommitData()
                Else
                    If !IsBlind() //.T. = Sem Interface com Usuario / .F. = Interface com o Usuario
                        MsgAlert(oMdlPCV:GetErrorMessage())
                    Else
                        Conout(oMdlPCV:GetErrorMessage())
                    EndIf
                EndIf
                
                oMdlPCV:DeActivate()

            Else //Falha ao Tentar Registra Boleto
                cErroRet := VerErro() //Chama rotina para verificar se ouve algum Erro                                
                cErroRet += CRLF + CRLF
                cErroRet += "---- JSON Enviado ----" + CRLF + CRLF
                cErroRet += cJson

                //Grava Data e Hora do Retorno
                oMdlPCV:Activate()
                oMdlPCV:SetValue('PCVMASTER', 'PCV_DTRET'	, Date() )
                oMdlPCV:SetValue('PCVMASTER', 'PCV_HSRET'	, SubsTr(Time(),1,5) )
                oMdlPCV:SetValue('PCVMASTER', 'PCV_DESRET'	, ObjJsRet:Status)
                oMdlPCV:SetValue('PCVMASTER', 'PCV_LDSRET'	, ObjJsRet:Message)
                oMdlPCV:SetValue('PCVMASTER', 'PCV_RESULT'	, cErroRet)
        
                If oMdlPCV:VldData()
                    oMdlPCV:CommitData()
                Else
                    If !IsBlind() //.T. = Sem Interface com Usuario / .F. = Interface com o Usuario
                        MsgAlert(oMdlPCV:GetErrorMessage())
                    Else
                        Conout(oMdlPCV:GetErrorMessage())
                    EndIf
                EndIf
                
                oMdlPCV:DeActivate()

                cStatWF := ObjJsRet:Status             
                cDescWf := ObjJsRet:Message
                lEnvWF  := .T.
                
            EndIf

        Else

            cErroRet += "---- JSON Enviado ----" + CRLF + CRLF
            cErroRet += cJson

            //Grava Data e Hora do Retorno
            oMdlPCV:Activate()            
            oMdlPCV:SetValue('PCVMASTER', 'PCV_RESULT'	, cErroRet)

            If oMdlPCV:VldData()
                oMdlPCV:CommitData()
            Else
                If !IsBlind() //.T. = Sem Interface com Usuario / .F. = Interface com o Usuario
                    MsgAlert(oMdlPCV:GetErrorMessage())
                Else
                    Conout(oMdlPCV:GetErrorMessage())
                EndIf
            EndIf

        Endif

    EndIf

    i++ //Contador

    Sleep(5000) //5 Segundos e tenta novamente 

EndDo

//************************************************
//Verifica se conseguiu conexão com a Finnet
//************************************************
If !lConexao
    //Grava Data e Hora do Envio Erro de Conexão
    oMdlPCV:Activate()
    oMdlPCV:SetValue('PCVMASTER', 'PCV_DTENV'	, Date() )
    oMdlPCV:SetValue('PCVMASTER', 'PCV_HSENV'	, SubsTr(Time(),1,5) )
    oMdlPCV:SetValue('PCVMASTER', 'PCV_STATUS'	, "E")
    oMdlPCV:SetValue('PCVMASTER', 'PCV_DESRET'	, "Falha de Conexão" )
    oMdlPCV:SetValue('PCVMASTER', 'PCV_LDSRET'	, "Sem Conexão com o Servidor da Finnet, houve 3 Tentativas." )

    If oMdlPCV:VldData()
        oMdlPCV:CommitData()
    Else
        If !IsBlind() //.T. = Sem Interface com Usuario / .F. = Interface com o Usuario
            MsgAlert(oMdlPCV:GetErrorMessage())
        Else
            Conout(oMdlPCV:GetErrorMessage())
        EndIf
    EndIf
    
    oMdlPCV:DeActivate()
 
    cStatWF := "Falha de Conexão"              
    cDescWf := "Sem Conexão com o Servidor da Finnet, houve 3 Tentativas."
    lEnvWF  := .T.
EndIf

//Envia WorkFlow para o Financeiro
If lEnvWF
    aAdd(aDados,{'EMPRESA','FILIAL','PREFIXO','TITULO','PARCELA','IDCNAB', "STATUS", "DESCRICAO"})
    aAdd(aDados,{   FwCodEmp(),;
                    FwCodFil(),;
                    PCV->PCV_PREFIX,;
                    PCV->PCV_TITULO,;
                    PCV->PCV_PARCEL,;
                    PCV->PCV_IDCNAB,;
                    cStatWF,;	               
                    cDescWf;
                    })	    

    //Envia WorkFlow
    EnviaWf(aDados)
EndIf

Return

/* #########################################################################################
// -----------------------------------------+----------------------------------------------+
// Modulo :FINANCEIRO                                                                      |
// Fonte  :ConvData()                                                                      |
// -----------+-------------------+--------------------------------------------------------+
// Data       | Autor             | Descricao                                              |
// -----------+-------------------+--------------------------------------------------------+
// 21/08/2019 | Michael M. Castro | Rotina Converte a Data Padrão FINNET AAAA-MM-DD        |
// -----------+-------------------+--------------------------------------------------------+
// #########################################################################################*/
Static Function ConvData(dData)

Local cDia := SubStr(DtoS(dData),7,2)
Local cMes := SubStr(DtoS(dData),5,2)
Local cAno := SubStr(DtoS(dData),1,4)

Return (cAno +"-"+cMes+"-"+cDia)

/* #########################################################################################
// -----------------------------------------+----------------------------------------------+
// Modulo :FINANCEIRO                                                                      |
// Fonte  :VerErro()                                                                       |
// -----------+-------------------+--------------------------------------------------------+
// Data       | Autor             | Descricao                                              |
// -----------+-------------------+--------------------------------------------------------+
// 22/08/2019 | Michael M. Castro | Rotina verifica se possui alguma Erro no Retorno       |
// -----------+-------------------+--------------------------------------------------------+
// #########################################################################################*/
Static Function VerErro()

Local cRetLog  := ""
Local i        := 0
Local cStrJson := ""
Local lRetJson := .F.
Local nCont    := 0

//Adiciono no Array os Possiveis Erros FINNET
Private aErros  := {'pagador_tipo_inscricao',;        
            'pagador_inscricao',; 	        
            'pagador_nome',; 	                
            'pagador_endereco_logradouro',; 	
            'pagador_endereco_numero',; 	    
            'pagador_endereco_complemento',; 	
            'pagador_endereco_bairro',; 	    
            'pagador_endereco_cidade',; 	    
            'pagador_endereco_uf',; 	        
            'pagador_endereco_cep',; 	        
            'pagador_email',; 	            
            'sacador_tipo_inscricao',; 	    
            'sacador_inscricao',; 	        
            'sacador_nome',; 	                
            'sacador_endereco_logradouro',; 	
            'sacador_endereco_numero',; 	    
            'sacador_endereco_complemento',; 	
            'sacador_endereco_bairro',; 	    
            'sacador_endereco_cidade',; 	    
            'sacador_endereco_uf',; 	        
            'sacador_endereco_cep',; 	        
            'sacador_email',; 	            
            'documento_numero',; 	            
            'documento_nosso_numero',; 	    
            'documento_data',; 	            
            'documento_data_processamento',; 	
            'documento_data_vencimento',; 	
            'documento_valor',; 	            
            'documento_especie',; 	        
            'documento_codigo_protesto',; 	
            'documento_dias_protesto',; 	    
            'documento_codigo_multa',; 	    
            'documento_percentual_multa',; 	
            'documento_valor_multa',; 	    
            'documento_dias_multa',; 	        
            'documento_codigo_juros',; 	    
            'documento_percentual_juros',; 	
            'documento_valor_juros',; 	    
            'documento_dias_juros',; 	        
            'documento_codigo_desconto',; 	
            'documento_percentual_desconto',; 
            'documento_valor_desconto',; 	    
            'documento_data_desconto',; 	    
            'documento_mensagem',; 	        
            'documento_pagamento_parcial',; 	
            'documento_qtde_pagamento_parcial';
            }

//Verifico se a Variavel é um Objeto 
If Type("ObjJsRet:Erros") <> "U"     

    For i:= 1 To Len(aErros)

       lRetJson := AttIsMemberOf( ObjJsRet:Erros, Upper(aErros[i]) )

       If lRetJson   
            If nCont == 0
                cRetLog += "Erro(s) Retorno Finnet"
                cRetLog += CHR(13)+CHR(10) + CHR(13)+CHR(10)
            EndIf       
            nCont++
            cString  := "ObjJsRet:Erros:"+Upper(aErros[i])+"[1]"            
            cStrJson := &(cString)            
            cRetLog += cValToChar(nCont) +" - "+ cStrJson
            cRetLog += CHR(13)+CHR(10)          
        EndIf

    Next

EndIf

Return cRetLog

/* #########################################################################################
// -----------------------------------------+----------------------------------------------+
// Modulo :FINANCEIRO                                                                      |
// Fonte  :EnviaWf()                                                                       |
// -----------+-------------------+--------------------------------------------------------+
// Data       | Autor             | Descricao                                              |
// -----------+-------------------+--------------------------------------------------------+
// 28/08/2019 | Michael M. Castro | Rotina que Realiza o Envio do WORKFLOW p/ Financeiro   |
// -----------+-------------------+--------------------------------------------------------+
// #########################################################################################*/
Static Function EnviaWf(aDados)

Local cHtml		:= ""  
Local cFrom		:= AllTrim(SuperGetMv("MV_WFMAIL",.T.,"workflow@teste.com.vc")) 
Local cSubject	:= ""
Local cTo		:= AllTrim(SuperGetMv("MV_WFINET",.T.,"")) 
Local cBCC		:= "michael.castro@teste.com.br"
Local cTipo	    := "T" 
Local cMsg1     := "" 

cSubject := "Titulo "+Alltrim(SM0->M0_NOME)+" não Integrado na Finnet"
cCabec	 := "Titulo Não Integrado - "+Alltrim(SM0->M0_NOME)
cMsg1	 := "Prezados executar a integração com a Finnet desse titulo Manual ou dentro de alguns minutos o Robô tentará integrar novamente."

cHtml	:= U_MLCMX28(cCabec,cMsg1,cTipo,aDados) //Converte em HTML

U_SendMail( cFrom, cSubject, cHtml, cTo,,cBCC,, .T. ) 

Return
