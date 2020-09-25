#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FILTEREX.CH"
// Função Dummy
Function __FwRestModel__()
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} FwRestModel
Classe base para controlar o acesso aos registros relacionados ao
modelo de dados.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Class FwRestModel
    Data cName
    Data cAlias
    Data cQryAlias
    Data aFields
    Data oModel
    Data lXml
    Data lActivate
    Data cFilter
    Data cOldFilter
    Data nStatus
    Data cStatus
    Data aQueryString
    Data lDebug
    Method Activate()
    Method DeActivate()
    Method OnError()
    Method SetModel()
    Method ClearModel()
    Method SetName()
    Method GetName()
    Method SetAsXml()
    Method SetAsJson()
    Method StartGetFormat()
    Method EscapeGetFormat()
    Method EndGetFormat()
    Method SetAlias()
    Method GetAlias()
    Method HasAlias()
    Method Seek()
    Method Skip()
    Method Total()
    Method GetData()
    Method SaveData()
    Method DelData()
    Method SetFilter()
    Method GetFilter()
    Method ClearFilter()
    Method DecodePK()
    Method ConvertPK()
    Method GetStatusResponse()
    Method SetStatusResponse()
    Method SetQueryString()
    Method GetQueryString()
    Method GetQSValue()
    Method GetHttpHeader()
    Method SetFields()
    Method debuger()
EndClass
//-------------------------------------------------------------------
/*/{Protheus.doc} Activate
Método de ativação da classe.
@return lActivate       Indica que a classe foi ativada.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method Activate() Class FwRestModel
Default self:lDebug := .F.
    self:lXml   := .T.
Return self:lActivate := .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} DeActivate
Método de desativação da classe.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method DeActivate() Class FwRestModel
    FwFreeObj(self:aQueryString)
    FwFreeObj(self:aFields)
    self:lActivate := .F.
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} OnError
Método que será executado quando algum erro ocorrer no rest.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method OnError() Class FwRestModel
    self:DeActivate()
    self:ClearModel()
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} SetModel
Método para setar o modelo de dados que será utilizado.
E força a configuração do alias a ser utilizado.
@param  oModel  Objeto do modelo de dados
@return oModel  Objeto do modelo de dados setado.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method SetModel(oModel) Class FwRestModel
    self:oModel := oModel
    self:SetAlias()
Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ClearModel
Método para efetuar o desroy do modelo de dados.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method ClearModel() Class FwRestModel
    If self:oModel != Nil
        self:oModel:Destroy()
        self:oModel := Nil
    EndIf
    self:ClearFilter()
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} SetName
Método para setar o nome do rest do modelo de dados.
@return cName   Nome do rest do modelo de dados.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method SetName(cName) Class FwRestModel
Return self:cName := cName
//-------------------------------------------------------------------
/*/{Protheus.doc} GetName
Método para retornar o nome do rest do modelo de dados.
@return cName   Nome do rest do modelo de dados.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method GetName() Class FwRestModel
Return self:cName
//-------------------------------------------------------------------
/*/{Protheus.doc} SetAsXml
Método para setar o retorno do rest como XML.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method SetAsXml() Class FwRestModel
    self:lXml := .T.
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} SetAsJson
Método para setar o retorno do rest como JSON.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method SetAsJson() Class FwRestModel
    self:lXml := .F.
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} StartGetFormat
Método retornar o conteúdo inicial do dado de retorno.
@param  nTotal          Quantidade total de registros do alias que podem ser retornados.
@param  nCount          Quantidade de registros a serem retornados.
@param  nStartIndex Index inicial do registro que será retornado.
@return cRet                Conteúdo inicial
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method StartGetFormat(nTotal, nCount, nStartIndex) Class FwRestModel
Local cRet := ""
    If self:lXml
        cRet += '<?xml version="1.0" encoding="UTF-8"?>'
        cRet += '<result>'
        cRet += i18n('<total>#1</total><count>#2</count><startindex>#3</startindex>', {nTotal, nCount, nStartIndex})
        cRet += '<resources>'
    Else
        cRet += i18n('{"total":#1,"count":#2,"startindex":#3,"resources":[', {nTotal, nCount, nStartIndex})
    EndIf
Return cRet
//-------------------------------------------------------------------
/*/{Protheus.doc} EscapeGetFormat
Método retornar o caracter a ser inserido entre os registros a serem
retornados.
@return cRet    Caracter de escape.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method EscapeGetFormat() Class FwRestModel
Local cRet := ""
    If !self:lXml
        cRet := ","
    EndIf
Return cRet
//-------------------------------------------------------------------
/*/{Protheus.doc} EndGetFormat
Método retornar o conteúdo final do dado de retorno.
@return cRet    Conteúdo final
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method EndGetFormat() Class FwRestModel
Local cRet := ""
    If self:lXml
        cRet := "</resources>"
        cRet += "</result>"
    Else
        cRet := "]}"
    EndIf
Return cRet
//-------------------------------------------------------------------
/*/{Protheus.doc} SetAlias
Método responsável por setar o alias a ser utilizado.
Se o mesmo não for informado, será utilizado o alias do field
principal do modelo de dados.
@return lRet    Indica se o alias foi preenchido
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method SetAlias(cAlias) Class FwRestModel
    If Empty(cAlias)
        If !Empty(self:oModel)
            self:cAlias := MPGetModelAlias(self:oModel)
        EndIf
    Else
        self:cAlias := cAlias
    EndIf
Return !Empty(self:cAlias)
//-------------------------------------------------------------------
/*/{Protheus.doc} GetAlias
Método responsável por retornar o alias.
@return cAlias  Alias
@author Felipe Bonvicini Conti
@since 05/04/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Method GetAlias() Class FwRestModel
Return self:cAlias
//-------------------------------------------------------------------
/*/{Protheus.doc} HasAlias
Método responsável informar se o alias foi setado, se não força efetuar
o setAlias().
@return lRet    Indica se o alias foi preenchido
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method HasAlias() Class FwRestModel
Local lRet := .T.
    If Empty(self:cAlias)
        self:SetAlias()
        lRet := !Empty(self:cAlias)
    EndIf
Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} Seek
Método responsável buscar um registro em específico no alias selecionado.
Se o parametro cPK não for informaodo, indica que deve-se ser posicionado
no primeiro registro da tabela.
@param  cPK                     PK do registro.
@return lRet    Indica se foi encontrado algum registro.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method Seek(cPK) Class FwRestModel
Local lRet := .F.
Local cQry
Local cPkFilter
    If self:HasAlias()
        If !Empty(cPK)
            cPkFilter := FWAToS(self:oModel:GetPrimaryKey(),"||") + " = '" + cPk + "'"
            If (self:cAlias)->(FieldPos(PrefixoCpo(self:cAlias)+"_FILIAL")) > 0
                cPkFilter := PrefixoCpo(self:cAlias)+"_FILIAL||" + cPkFilter
            EndIf
            self:SetFilter(cPkFilter)
        Endif
        cQry := createQueryAlias(@self:cQryAlias, self:cAlias, self:cFilter)
        If self:lDebug .And. self:GetQSValue("showQuery") == "true"
            i18nConOut("[FWRESTMODELOBJECT] Query: #1#2", {CRLF, cQry})
        EndIf
        If !(self:cQryAlias)->(Eof())
            (self:cAlias)->(dbGoTo((self:cQryAlias)->R_E_C_N_O_))
            lRet := !(self:cAlias)->(Eof())
        EndIf
    Endif
Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} Skip
Método responsável passar para o proximo registro do alias.
@return lRet    Indica se o alias não chegou ao fim.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method Skip(nSkip) Class FwRestModel
Local lRet := .F.
    If self:HasAlias()
        If !(self:cQryAlias)->(Eof())
            (self:cQryAlias)->(DbSkip(nSkip))
            (self:cAlias)->(dbGoTo((self:cQryAlias)->R_E_C_N_O_))
            lRet := !(self:cAlias)->(Eof())
        EndIf
    EndIf
Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} Total
Método responsável retornar a quantidade total de regitros do alias.
Contagem é feita atravez de query.
@return nTotal  Quantidade total de registros.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method Total() Class FwRestModel
Local nTotal     := 0
Local cQueryPart := ""
    If self:HasAlias()
        cQueryPart += GetFromQryAlias(self:cAlias)
        cQueryPart += GetWhereQryAlias(self:cAlias, self:cFilter)
        nTotal := FWTblCount(self:cQryAlias, cQueryPart, .F.)
    EndIf
Return nTotal
//-------------------------------------------------------------------
/*/{Protheus.doc} GetData
Método responsável por retornar o registro do modelo no formato XML
ou JSON.
@param  lFieldDetail    Indica se retorna o registro com informações detalhadas
@param  lFieldVirtual   Indica se retorna o registro com campos virtuais
@param  lFieldEmpty     Indica se retorna o registro com campos nao obrigatorios vazios
@param  lFirstLevel     Indica se deve retornar todos os modelos filhos ou nao
@param  lInternalID     Indica se deve retornar o ID como informação complementar das linhas do GRID
@return cRet        Retorna o registro nos formatos XML ou JSON
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method GetData(lFieldDetail, lFieldVirtual, lFieldEmpty, lFirstLevel, lInternalID) Class FwRestModel
Local cRet
    self:oModel:SetOperation(MODEL_OPERATION_VIEW)
    Self:oModel:Activate()
    If self:lXml
        cRet := Self:oModel:GetXmlData(lFieldDetail,,,lFieldVirtual,,lFieldEmpty,.F./*lDefinition*/,,.T./*lPK*/,.T./*lPKEncoded*/,self:aFields,lFirstLevel,lInternalID)
    Else
        cRet := Self:oModel:GetJsonData(lFieldDetail,,lFieldVirtual,,lFieldEmpty,.T./*lPK*/,.T./*lPKEncoded*/,self:aFields,lFirstLevel,lInternalID)
    EndIf
    Self:oModel:DeActivate()
Return cRet
//-------------------------------------------------------------------
/*/{Protheus.doc} SaveData
Método responsável por salvar o registro recebido pelo metodo PUT ou POST.
Se o parametro cPK não for informado, significa que é um POST.
@param  cPK         PK do registro.
@param  cData       Conteúdo a ser salvo
@param  @cError Retorna o alguma mensagem de erro
@return lRet        Indica se o registro foi salvo
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method SaveData(cPK, cData, cError) Class FwRestModel
local lRet := .T.
Default cData   := ""
    If Empty(cPk)
        self:oModel:SetOperation(MODEL_OPERATION_INSERT)
    Else
        self:oModel:SetOperation(MODEL_OPERATION_UPDATE)
        lRet := self:Seek(cPK)
    EndIf
    If lRet
        self:oModel:Activate()
        If self:lXml
            lRet := self:oModel:LoadXMLData(cData)
        Else
            lRet := self:oModel:LoadJsonData(cData)
        EndIf
        If lRet
            If self:oModel:lModify // Verifico se o modelo sofreu alguma alteração
                If !(self:oModel:VldData() .And. self:oModel:CommitData())
                    lRet := .F.
                    cError := ErrorMessage(self:oModel:GetErrorMessage())
                EndIf
            Else
                lRet := .F.
                self:SetStatusResponse(304, "Not Modified")
            EndIf
        Else
            cError := ErrorMessage(self:oModel:GetErrorMessage())
        EndIf
        Self:oModel:DeActivate()
    Else
        cError := i18n("Invalid record '#1' on table #2", {cPK, self:cAlias})
    EndIf
Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} DelData
Método responsável por remover um registro.
@param  cPK         PK do registro.
@param  @cError Retorna o alguma mensagem de erro
@return lRet        Indica se o registro foi removido
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method DelData(cPK, cError) Class FwRestModel
local lRet := .F.
    If !Empty(cPK)
        If self:Seek(cPK)
            self:oModel:SetOperation(MODEL_OPERATION_DELETE)
            self:oModel:Activate()
            lRet := self:oModel:VldData() .And. self:oModel:CommitData()
            If !lRet
                cError := ErrorMessage(self:oModel:GetErrorMessage())
            EndIf
            Self:oModel:DeActivate()
        Else
            cError := i18n("Invalid record '#1' on table #2", {cPK, self:cAlias})
        EndIf
    EndIf
Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} SetFilter
Método responsável por setar algum filtro que tenha sido informado
por Query String no REST.
@param  cFilter Valor do filtro a ser aplicado no alias
@return lRet        Indica se o filtro foi aplicado corretamente
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method SetFilter(cFilter) Class FwRestModel
    self:cFilter := Alltrim(cFilter)
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} GetFilter
Método para retornar o conteúdo do filtro.
@return cFilter     Conteúdo do filtro
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method GetFilter() Class FwRestModel
Return self:cFilter
//-------------------------------------------------------------------
/*/{Protheus.doc} GetFilter
Método responsável pro limpar o filtro setado.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method ClearFilter() Class FwRestModel
    self:cFilter := ""
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} DecodePK
Método para indicar se deve ser feito o decode do paramtro cPK recebido
no REST
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method DecodePK() Class FwRestModel
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} ConvertPK
Método responsável por converter a PK.
@author Felipe Bonvicini Conti
@since 25/06/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method ConvertPK(cPK) Class FwRestModel
    If self:DecodePK()
        cPK := Decode64(cPK)
    EndIf
Return cPK
//-------------------------------------------------------------------
/*/{Protheus.doc} GetStatusResponse
Método responsável por retornar o codigo e descrição do status de retorno,
quando necessario.
@author Felipe Bonvicini Conti
@since 07/07/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method GetStatusResponse() Class FwRestModel
Local Ret
    If !(self:nStatus == Nil)
        Ret := {self:nStatus, self:cStatus}
    EndIf
Return Ret
//-------------------------------------------------------------------
/*/{Protheus.doc} SetStatusResponse
Método responsável por setar o codigo e descrição do status de retorno,
quando necessario.
@author Felipe Bonvicini Conti
@since 07/07/2015
@version P11, P12
/*/
//-------------------------------------------------------------------
Method SetStatusResponse(nStatus, cStatus) Class FwRestModel
    self:nStatus := nStatus
    self:cStatus := cStatus
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} SetQueryString
Método responsável por setar as query strings recebidas na requisicao.
@author Felipe Bonvicini Conti
@since 29/03/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Method SetQueryString(aQueryString) Class FwRestModel
Default aQueryString := {}
Return self:aQueryString := aQueryString
//-------------------------------------------------------------------
/*/{Protheus.doc} GetQueryString
Método responsável por retornar aa query strings recebidas na requisicao.
@author Felipe Bonvicini Conti
@since 29/03/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Method GetQueryString() Class FwRestModel
Return self:aQueryString
//-------------------------------------------------------------------
/*/{Protheus.doc} GetQSValue
Método responsável por buscar uma query string e retornar seu valor.
@author Felipe Bonvicini Conti
@since 29/03/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Method GetQSValue(cKey) Class FwRestModel
Local cValue := ""
Local nPos
    cKey := UPPER(cKey)
    nPos := aScan(self:aQueryString, {|x| x[1] == cKey})
    If nPos > 0
        cValue := self:aQueryString[nPos][2]
    EndIf
Return cValue
//-------------------------------------------------------------------
/*/{Protheus.doc} GetHttpHeader
Função de retorno do conteudo do cabeçalho HTTP.
@param cParam Parametro HTTP para busca
@return cReturn Valor do parametro HTTP solicitado. Se retornado NULL, o parametro não foi encontrado.
@author Felipe Bonvicini Conti
@since 30/03/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Method GetHttpHeader(cParam) Class FwRestModel
Return HTTPHeader(cParam)
//-------------------------------------------------------------------
/*/{Protheus.doc} SetFields
Método responsável por setar os campso que serao retornados no modelo
@param aFields Array com os campos a serem filtrados
@return lRet Retorna verdadeiro se os campos forem salvos corretamente
@author Felipe Bonvicini Conti
@since 29/03/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Method SetFields(aFields) Class FwRestModel
Default aFields := ""
    self:aFields := StrTokArr(aFields, ",")
Return Len(self:aFields) > 0
//-------------------------------------------------------------------
/*/{Protheus.doc} SetFields
Método responsável por setar os campso que serao retornados no modelo
@param lDebug Parametro para informara se o debug sera habilitado
@return lRet Indica se o begub foi abilitado
@author Felipe Bonvicini Conti
@since 29/03/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Method debuger(lDebug) Class FwRestModel
Default lDebug := .F.
Return self:lDebug := lDebug
// ********************* Functions *********************
//-------------------------------------------------------------------
/*/{Protheus.doc} ErrorMessage
Funcao responsavel por retonar o erro do modelo.
@param aErroMsg Array de erro do modelo de dados
@return cRet Formato texto do array de erro do modelo de dados
@author Felipe Bonvicini Conti
@since 05/04/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Static Function ErrorMessage(aErroMsg)
Local cRet := CRLF + " --- Error on Model ---" + CRLF
    cRet += "Id submodel origin: [" + aErroMsg[1] + "]" + CRLF
    cRet += "Id field origin: [" + aErroMsg[2] + "]" + CRLF
    cRet += "Id submodel error: [" + aErroMsg[3] + "]" + CRLF
    cRet += "Id field error: [" + aErroMsg[4] + "]" + CRLF
    cRet += "Id error: [" + aErroMsg[5] + "]" + CRLF
    cRet += "Error menssage: [" + aErroMsg[6] + "]" + CRLF
    cRet += "Solution menssage: [" + aErroMsg[7] + "]" + CRLF
    cRet += "Assigned value: [" + cValToChar( aErroMsg[8] ) + "]" + CRLF
    cRet += "Previous value: [" + cValToChar( aErroMsg[9] ) + "]" + CRLF
    aErroMsg := aSize(aErroMsg, 0)
Return cRet
//-------------------------------------------------------------------
/*/{Protheus.doc} GetFromQryAlias
Funcao responsavel por retornar a clausula from da query de dados
@param cTable Tablea principal
@return cFrom Clausula from da query
@author Felipe Bonvicini Conti
@since 05/04/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Static Function GetFromQryAlias(cTable)
Return " FROM " + RetSqlName( cTable )
//-------------------------------------------------------------------
/*/{Protheus.doc} GetWhereQryAlias
Funcao responsavel por retornar a clausula where da query de dados
@param cTable   Tablea principal
@param cFilter  Filtro da query
@return cWhere Clausula where da query
@author Felipe Bonvicini Conti
@since 05/04/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Static Function GetWhereQryAlias(cTable, cFilter)
Local cWhere
Local cUsrFilFilter
    cWhere := " WHERE D_E_L_E_T_ = ' '"
    //Introduz a segurança padrão de acesso as filiais do sistema
    If (cTable)->(FieldPos(PrefixoCpo(cTable)+"_FILIAL")) > 0
        cUsrFilFilter := FWSQLUsrFilial(cTable)
        If !Empty(cUsrFilFilter)
            cWhere += " AND " + cUsrFilFilter
        EndIf
    EndIf
    If !Empty(cFilter)
        cWhere += " AND " + cFilter
    EndIf
Return cWhere
//-------------------------------------------------------------------
/*/{Protheus.doc} GetWhereQryAlias
Funcao responsavel por retornar a query do modelo
@param cQryAlias    Alias da query
@param cTable       Tablea principal
@param cFilter      Filtro da query
@return cQuery Query
@author Felipe Bonvicini Conti
@since 05/04/2016
@version P11, P12
/*/
//-------------------------------------------------------------------
Static Function createQueryAlias(cQryAlias, cTable, cFilter)
Local oStatement
Local cQuery  := ""
    cQuery += "SELECT R_E_C_N_O_"
    cQuery += GetFromQryAlias(cTable)
    cQuery += GetWhereQryAlias(cTable, cFilter)
    oStatement := FWPreparedStatement():New(cQuery)
    cQuery     := oStatement:getFixQuery()
    cQuery     := ChangeQuery(cQuery)
    MPSysOpenQuery(cQuery, @cQryAlias)
    oStatement:Destroy()
    FwFreeObj(oStatement)
Return cQuery