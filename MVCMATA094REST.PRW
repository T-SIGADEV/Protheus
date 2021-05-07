#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWBROWSE.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'RWMAKE.CH'

 
// #DEFINE OP_LIB	"001" // Liberado
// #DEFINE OP_EST	"002" // Estornar
// #DEFINE OP_SUP	"003" // Superior
// #DEFINE OP_TRA	"004" // Transferir Superior
// #DEFINE OP_REJ	"005" // Rejeitado
// #DEFINE OP_BLQ	"006" // Bloqueio
// #DEFINE OP_VIW	"007" // Visualizacao 

PUBLISH USER MODEL REST NAME ApprovalDocuments RESOURCE OBJECT oRestApprovalDocuments

Class oRestApprovalDocuments From FwRestModel
    // Data lSm0Closed
 
    Method Activate()
    Method SaveData()


EndClass
 
Method Activate(_cOperation) Class oRestApprovalDocuments 
 ::cIdService := 'ApprovalDocuments'
 ::cIdUser    := __cuserId   
 
Return _Super:Activate() //Activate FWRestModelObject

 

/*/{Protheus.doc} MVCMATA094REST
        Exemplo de API MVC com execauto de aprovação de documentos MATA094
@type Function
@author uilon.eugenio
@since  09/10/18
@version 12.1.17
@param ,
@return nil, 
@see    http://tdn.totvs.com/display/framework/SetRestFault
        http://tdn.totvs.com/display/framework/FWLogMsg
        http://tdn.totvs.com/display/framework/FWRestModel+-+API+RESTful+dos+modelos+de+dados+do+Protheus
        https://tdn.totvs.com/pages/releaseview.action?pageId=543090187
@obs 09/10/18 - Construção inicial do fonte para uso no barramento
/*/
User Function MVCMATA094REST() //dummy

Return nil
 

/*/{Protheus.doc} ModelDef
Modelo MVC para CTD - CRs 
@type Function
@since  09/10/18
@return oModel, Objeto com o modelo da rotina
/*/
Static Function ModelDef()
Local oModel
Local _cFields   := 'CR_FILIAL|CR_NUM|CR_TIPO|CR_USER|CR_APROV|CR_NIVEL|CR_STATUS|CR_DATALIB|CR_TOTAL|CR_EMISSAO|CR_USERLIB|CR_LIBAPRO|CR_VALLIB|CR_OBS|CR_GRUPO|CR_ITGRP|CR_MOEDA'
Local oStruAlias := iif(Empty(_cFields), FWFormStruct(1,'SCR') ,FWFormStruct(1,"SCR",{|cCampo| ( Alltrim(cCampo) $ _cFields )}))

oModel := MPFormModel():New('MSIWBSA10',{|| PreValida(oModel)},{|oModel| PosValida(oModel)},{|oModel|,fCommit(oModel)},{|oModel|,fCancel(oModel)}) // Cria o objeto do Modelo de Dados
 
oModel:AddFields('ZW0FIELD',nil,oStruAlias)
oModel:SetPrimaryKey({'CR_TIPO','CR_NUM','CR_NIVEL'})
 
Return oModel
 
/*/{Protheus.doc} PreValida
Modelo MVC para CTD - CRs 
@type Function
@since  09/10/18
@return lRet, PreValidação a ser executado dentro do modelo
/*/
Static Function PreValida(oModel)
Local lRet := .T.
/*validações*/ 
Return lRet
 
 
/*/{Protheus.doc} PosValida
Modelo MVC para CTD - CRs 
@type Function
@since  09/10/18
@return lRet, PosValidação a ser executado dentro do modelo
/*/
Static Function PosValida(oModel)
Local lRet := .T.
Local nOperation := oModel:GetOperation()
 
If nOperation == MODEL_OPERATION_INSERT
 
EndIf
 
if nOperation == MODEL_OPERATION_UPDATE .or. nOperation == MODEL_OPERATION_INSERT
 
EndIf
 
If nOperation <> MODEL_OPERATION_DELETE
 
EndIf
 
Return lRet
 
 
/*/{Protheus.doc} fCommit
Modelo MVC para CTD - CRs 
@type Function
@since  09/10/18
@return lRet, Validação no momento da gravação dos dados
/*/
Static Function fCommit(oModel)
Local lRet := .T.
Local nOperation := oModel:GetOperation()
 
FWFormCommit(oModel)
 
Return lRet
 
 
/*/{Protheus.doc} fCancel
Modelo MVC para CTD - CRs 
@type Function
@since  09/10/18
@return lRet, Validação no momento do cancelmento do modelo
/*/
Static Function fCancel(oModel)
Local lRet := .T.
Local nOperation := oModel:GetOperation()
 
FWFormCancel(oModel)
 
Return lRet
 

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
        18/06/2019 -> Descobrimos apos muito debug e sofrimento que o corno do MaAlcDoc nao erra de maneira alguma. retorna .F. se ainda tiver proximos niveis e .T. se for a aprovação for a completa.
        20/06/2019 ->
        
STATIC cOperID	:= 	"000"	  // Variavel para armazenar a operação que foi executada
STATIC oModelCT	:= NIL
 
#DEFINE OP_LIB	"001" // Liberado
#DEFINE OP_EST	"002" // Estornar
#DEFINE OP_SUP	"003" // Superior
#DEFINE OP_TRA	"004" // Transferir Superior
#DEFINE OP_REJ	"005" // Rejeitado
#DEFINE OP_BLQ	"006" // Bloqueio
#DEFINE OP_VIW	"007" // Visualizacao 
/*/
Method SaveData(cPK, cData, cError) Class oRestApprovalDocuments

    Local _oObj
    Local lRet := .T.
    Local _cNivel
    Private CFIELDSC7 := ''
    Private oModelCT	:= NIL
    Private aCamposC7 := {}
    Private aCamposDBL:= {}


/*
STATIC cOperID	:= 	"000"	  // Variavel para armazenar a operação que foi executada
STATIC oModelCT	:= NIL
STATIC aCamposC7 := {}
STATIC aCamposDBL:= {}
STATIC cFieldSC7 := ''

    If Empty(cPk)
        ::cOperation := 'POST'        
    Else           
        ::cOperation := 'PUT'
        lRet := .T.
    EndIf

    if lRet

        lRet := ::CanExecute(::cIdService,::cOperation)      

        if lRet
        */
            if FWJsonDeserialize(cData,@_oObj)
                DbSelectArea('SCR')
                SCR->(DbSetOrder(1))
                SCR->(DbSeek(cPK)) // posiciona no primeiro aprovador deste nível
                _cFilBkp := cFilant
                cFilant  := SCR->CR_FILIAL
                _cNum    := SCR->CR_NUM
                _cNivel  := SCR->CR_NIVEL
                _cbranch := SCR->CR_FILIAL

                // Posiciona corretamente o aprovador subistituto                
                WHILE (SCR->CR_USER <> __cuserId) .and. !SCR->(Eof()) .and. SCR->CR_NUM == _cNum .and. _cNivel == SCR->CR_NIVEL .and. _cbranch == SCR->CR_FILIAL 
                    SCR->(DbSkip())                            
                EndDo
                
                if ( _cbranch+_cNum+_cNivel+__cuserId <>   SCR->CR_FILIAL+SCR->CR_NUM+SCR->CR_NIVEL+SCR->CR_USER  )
                    lRet := .F.
                    cError := " Documento nao encontrado para o aprovador"
                    return lRet
                EndIF
                // if _oObj:lisEstorno
                    A094SetOp( '002' ) //-- Seta operacao de Estornar
                // else
                    if Val(_oObj:TOTAL) > 0
                        A094SetOp( '001' ) //-- Seta operacao de aprovacao de documentos
                    Else
                        A094SetOp( '005' ) //-- Seta operacao de rejeição de documentos
                    EndIf
                // EndIf

                oModel094 := FwLoadModel("MATA094")
                oModel094:SetOperation(MODEL_OPERATION_UPDATE)
                oModel094:Activate()
                oModel094:GetModel("FieldSCR"):SetValue('CR_OBS'      ,AllTrim(_oObj:OBSERVACAO))
                
                If !(oModel094:VldData() .And. oModel094:CommitData())
                    lRet := .F.
                    cError := "Campo: "+oModel094:GetErrorMessage()[4]+" Erro : "+oModel094:GetErrorMessage()[6]+" Solucao: "+oModel094:GetErrorMessage()[7]
                EndIf
                oModel094:DeActivate()
                    
                cFilant :=  _cFilBkp 
            EndIF
            /*
        EndIf
    EndIF
*/
Return lRet

