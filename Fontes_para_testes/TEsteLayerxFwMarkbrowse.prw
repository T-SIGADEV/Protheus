#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"
#include "TOTVS.CH"

User Function TesteFWLayerxFwMarkBrowse1()

	Local oLayer := FWLayer():new()
	Local aCampos                  := {}
	Private nLLFIS                 := 95
	Private aSize          := MsAdvSize()
	Private oLayerLFIS
	Private cCadastro          := " - Exemplo de Layer com tabela TEMP e FWBROWSE -"
	Private aHeader          := {}
	Private aRotina          := {}
	Private aUserFl        , uGrupo , GrUser
	Private lATFCOMPLUR        , lATFCARH
	Private cAliasN1                 := GetNextAlias()
	Private oDlgFil , oBrwLF
	Private aBkpFiltro , _cPesq
	Private bFiltraBrw := {|| Nil }
	Private cMarca                   := GetMark()

	SetKey( VK_F4, { || alert("F4 PRESSIONADO!!!!") } )
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbGotop()
	//String cQuery table SA1
	cQry := "select * from SA1990"
	//TCQUERY() define a Query propriamente dita
	tcQuery cQry new Alias "TMPZ01"
	//CSETFIELD () define o tipo das colunas a serem consideradas na Query.
	TcSetField("TMPZ01","A1_NOME","C",15,0)
	//Define o objeto MSDIALOG

	DEFINE MSDIALOG oDlg FROM aSize[7], 0 TO aSize[6], aSize[5] TITLE "FWLayer x FwMarkBrowse" PIXEL

	oDlg:lEscClose := .T.
	oLayer        := FWLayer():New()
	oLayer:init(oDlg,.F.) //Através desse método você define a inicialização do objeto como quem será o objeto pai. Exemplo: Dialog, Window, Panel e etc.
	oLayer:AddLine('MAIN',100, .F.) //Método responsável por adicionar linhas.
	oLayer:addCollumn('Col01',16,.F.,'MAIN')//Método responsável por adicionar a quantidade colunas desejada.
	oLayer:addWindow('Col01','C1_Win01','Selecione o Regitro',30,.T.,.F.,{|| Alert("Filtro Campus") },'MAIN',{|| Alert("Filtro Campus") })
	cBrowse := "Cmp"
	cMarca := "1W" //GetMark()
	linverte:=.F.
	aAdd(aCampos,{"A1_NOME",,"Campus",PesqPict("TMPZ01","A1_NOME")})
	oBrowCmp := FWMarkBrowse():New()
	oBrowCmp:SetAlias("TMPZ01")

	//oBrowCmp:oBrowse:SetOwner(oLayer:GetColPanel('Col01', "MAIN"))

	//No metodo SetOwner do browse deverá ser informado a janela que o browse deve ser adicionado, conforme exemplo abaixo.
	oBrowCmp:oBrowse:SetOwner(oLayer:getWinPanel('Col01','C1_Win01', "MAIN"))
	oBrowCmp:SetDescription("FwMarkBrowse") // Define o titulo do MarkBrowse
	oBrowCmp:SetOnlyFields({"A1_NOME"}) // Define os campos a serem mostrados no MarkBrowse
	oBrowCmp:SetFieldMark("A1_OK") // Define o campo utilizado para a marcacao
	oBrowCmp:SetMenuDef("")
	oBrowCmp:DisableDetails()
	oBrowCmp:DisableReport()
	oBrowCmp:DisableConfig()
	oBrowCmp:DisableLocate()
	oBrowCmp:DisableSeek()
	oBrowCmp:DisableSaveConfig()
	oBrowCmp:SetWalkThru(.F.)
	oBrowCmp:SetAmbiente(.F.)
	oBrowCmp:DisableFilter()
	oBrowCmp:SetFixedBrowse(.T.)
	oBrowCmp:Activate()
	//adcionado para teste 
	
	oLayer:addCollumn('Col02',84,.T.,'MAIN')
	oLayerLFIS := FWLayer():New()
	oLayerLFIS:Init(oLayer:GetColPanel('Col02', 'MAIN'), .F.)
	oLayerLFIS:AddLine('CENTER', nLLFIS, .F.)
	oLayerLFIS:AddCollumn('LFIS', 100, .T., "CENTER")
	cBrowse := "LFIS"
	oBrowLFIS := FWMBrowse():New()
	oBrowLFIS:SetAlias("SB2")
	oBrowLFIS:SetMenuDef("UNI406v2")
	oBrowLFIS:SetDescription("Teste FWLayer x FwMarkBrowse [ Pressione F4 para Pesquisa Personalizada ]")
	oBrowLFIS:SetOwner(oLayerLFIS:GetColPanel('LFIS', "CENTER"))
	oBrowLFIS:DisableDetails()
	//oBrowLFIS:DisableReport()
	//oBrowLFIS:DisableConfig()
	oBrowLFIS:SetWalkThru(.F.)
	oBrowLFIS:SetAmbiente(.F.)
	oBrowLFIS:ForceQuitButton()
	oBrowLFIS:SetFixedBrowse(.T.)
	//oBrowLFIS:bChange := bUpdBrwLFIS
	//SetFieldsBrowse(oBrowLFIS, "LFIS")
	oBrowLFIS:Activate()
	oBrwLF        := FWmBrwActive()
	oLayerLFIS:Show()
	
	ACTIVATE MSDIALOG oDlg CENTERED

Return