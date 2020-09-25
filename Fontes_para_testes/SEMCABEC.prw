#Include 'protheus.ch'
#Include 'fwmvcdef.ch'
 
#Define MVC_TITLE 'GRID Sem Cabeçalho'
 
//-------------------------------------------------------------------
/*/{Protheus.doc} u_semcabec
    Função principal da rotina MVC. Chama direto a inclusão
@author  izac.ciszevski
@since   16.03.2020
/*/
//-------------------------------------------------------------------
Function u_xt18443()
    FWExecView( 'GRID Sem Cabeçalho', "VIEWDEF.SEMCABEC", MODEL_OPERATION_INSERT, , { || .T. }, , 30 )
Return
 
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
    Montagem do modelo dados para MVC
@author  izac.ciszevski
@since   16.03.2020
/*/
//-------------------------------------------------------------------
Static Function ModelDef()
    Local oModel  As Object
    Local oStrField As Object
    Local oStrGrid As Object
 
    // Estrutura Fake de Field
    oStrField := FWFormModelStruct():New()
    oStrField:AddTable( '' , { 'C_STRING1' } , MVC_TITLE , {|| ''} )
    oStrField:AddField( 'String 01' , 'Campo de texto' , 'C_STRING1' , 'C' , 15 )
 
    //Estrutura de Grid
    oStrGrid := FWFormStruct( 1, 'SB1' )
 
    oModel := MPFormModel():New( 'MIDMAIN' )
    oModel:AddFields('CABID', , oStrField )
    oModel:AddGrid( 'GRIDID', 'CABID', oStrGrid )
    oModel:SetRelation( 'GRIDID', { { 'C_STRING1', 'C_STRING1' } } )
 
    oModel:SetDescription( MVC_TITLE )
    oModel:SetPrimaryKey( { 'C_STRING1' } )
 
    // É necessário que haja alguma alteração na estrutura Field
    oModel:SetActivate( { | oModel | FwFldPut( "C_STRING1", "FAKE" ) } )
 
Return oModel
 
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Função estática do ViewDef
 
@author  izac.ciszevski
@since   16.03.2020
/*/
//-------------------------------------------------------------------
Static Function ViewDef()
Local oView    As Object
Local oModel   As Object
Local oStrCab  As Object
Local oStrGrid As Object
 
// Estrutura Fake de Field
oStrCab := FWFormViewStruct():New()
oStrCab:AddField( 'C_STRING1' , '01' , 'String 01' , 'Campo de texto', , 'C' )
 
//Estrutura de Grid
oStrGrid := FWFormStruct( 2, 'SB1' )
 
oModel  := FWLoadModel( 'SEMCABEC' )
oView   := FwFormView():New()
oView:SetModel( oModel )
 
oView:AddField('CAB', oStrCab, 'CABID')
oView:AddGrid('GRID', oStrGrid, 'GRIDID')
 
oView:CreateHorizontalBox( 'TOHID', 0 )
oView:CreateHorizontalBox( 'TOSHOW', 100 )
 
oView:SetOwnerView('CAB' , 'TOHID' )
oView:SetOwnerView('GRID', 'TOSHOW')
 
oView:SetDescription( MVC_TITLE )
 
Return oView