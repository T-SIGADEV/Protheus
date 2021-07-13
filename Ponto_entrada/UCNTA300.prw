#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"


/*/{Protheus.doc} UCNTA300
===============================================================================
Ponto de entrada do modelo CNTA300 - Gestão de contratos
===============================================================================
@author uilon.eugenio
@type function
@since 17/04/2018
@version 1.0
@return object, xRet - retorno do MVC depende do processo executado
@history 15/03/2021, uilon.eugenio, adicionado documentaçao no novo padrao.	
@history 15/03/2021, uilon.eugenio, Validar campos TCU. OBS obrigatorio para Natureza 5. Card #556
@history 15/03/2021, uilon.eugenio, Validar campos TCU. OBS obrigatorio para Categoria 1 ou 40. Card #556
@history 15/03/2021, uilon.eugenio, Validar campos aba TCU. não considerar obrigatorio para modalidades CD / CDP / CT / CTP / DL / IN e as iniciadas A. Card #556
@history 16/06/2021, uilon.eugenio, De volta ao card #566
/*/
User Function CNTA300()
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oModel	:= FwModelActive()
	Local cIdPoint	:= ''
	Local cMoldel  := ''
	Local oModelAux
	
	If Valtype(oModel) == 'O' .and. aParam <> Nil 

		cIdPoint := aParam[2]
		cMoldel  := aParam[3]
		IF cIdPoint $ 'FORMPOS|MODELCOMMITNTTS|FORMPRE|FORMCOMMITTTSPRE' //com esse if eu reduzo a quantidade de situações analisadas no case
//
			Do Case
				Case (cIdPoint == 'MODELCOMMITNTTS')
				if oModel:nOperation == 3 //.or. oModel:nOperation == 4
					if EmptY(CN9->CN9_REVISA)
						//Preenche acessos do contrato
						u_sigcta52(CN9->CN9_NUMERO)
						u_sigctb52(CN9->CN9_NUMERO, CN9->CN9_GESTOR)					
					EndIF
				EndIf

				Case (cIdPoint == 'FORMPOS' .and. cMoldel == 'CN9MASTER') //Após validar o modelo principal
					if oModel:GetModel('CN9MASTER'):GetValue("CN9_ESPCTR") == '1' // 1-Compra 2-Venda					
						xRet := CNISupRegras():ValidaModeloGCTByTCU(oModel:GetModel('CN9MASTER'))					
					EndIf
					if  oModel:nOperation == 4
						oModelAux := oModel:GetModel('CNNDETAIL')							
						LoadGrpAcces(oModelAux,oModel:GetModel('CN9MASTER'):GetValue("CN9_NUMERO"),oModel:GetModel('CN9MASTER'):GetValue("CN9_FILIAL"))
						LoadGestAcces(oModelAux,oModel:GetModel('CN9MASTER'):GetValue("CN9_GESTOR"),oModel:GetModel('CN9MASTER'):GetValue("CN9_NUMERO"),oModel:GetModel('CN9MASTER'):GetValue("CN9_FILIAL"))
					EndIf
					
				// Case (cIdPoint == 'FORMPRE' .and. cMoldel == 'CN9MASTER') //cMoldel == 'CN9MASTER' 
					
				OtherWise

			EndCase
		EndIf
	EndIF	
	//FORMCOMMITTTSPRE

Return xRet


/*/{Protheus.doc} LoadGrpAcces
===============================================================================
Aplica regras do SIGCTA52 no model CNNDETAILS
===============================================================================
@author uilon.eugenio
@type function
@since 17/04/2018
@version 1.0
@param oModel, object, oModel corrente da tela
@param _cContra, character, Numero do contrato
@param _cFilial, character, Filial do contrato
@return object, sem retorno, este processo alimenta dados no modelo CNN
@history 15/03/2021, uilon.eugenio, adicionado documentaçao no novo padrao.	
/*/
static function LoadGrpAcces(oModel,_cContra,_cFilial)
	local _cGrupos := ''
	local _aGrupos := {}
	local _nTamGrp := 0
	local _nPosArr := 0
	Local lExist := .f.
	local _nPermis := 0
	local _nTotPerm := oModel:Length()
	// separa os grupos cadastrados na variável MV_XGRPCTR por vírgula
	_cGrupos := superGetMV('MV_XGRPCTR',.F.,'000001')
	_aGrupos := separa(_cGrupos, ',', .F.)
	_nTamGrp := len( _aGrupos )


	// adiciona permissão para cada grupo no parametro MV_XGRPCTR
	for _nPosArr := 1 to _nTamGrp
		for _nPermis := 1 to _nTotPerm
			oModel:GoLine(_nPermis)
			IF oModel:getValue("CNN_GRPCOD") == _aGrupos[_nPosArr]
				lExist := .T.
			EndIf
		next
		if !lExist
			nLines := oModel:Length()
			nNewLine := oModel:AddLine()
			if nLines == nNewLine
				oModel:AddLine()
			EndIf				
			oModel:GoLine(nNewLine)
			oModel:SetValue("CNN_FILIAL",_cFilial)
			oModel:SetValue("CNN_CONTRA",_cContra)
			oModel:SetValue("CNN_USRCOD",'      ')
			oModel:SetValue("CNN_GRPCOD",_aGrupos[_nPosArr])
			oModel:SetValue("CNN_TRACOD",'001') //acesso total
			nLines := oModel:Length()
			nNewLine  := oModel:AddLine()			
			if nLines == nNewLine
				//			Alert('AddLine nao funcionou. _nPosArr := '+cvaltochar(_nPosArr)+'usr cod '+oModel:getValue("CNN_USRCOD")+ ' grp cod '+oModel:getValue("CNN_GRPCOD")+ 'Tam atual ='+cValtochar(nLines))
				oModel:AddLine()
			EndIf
		EndIf		
		lExist := .f.
	next	
Return



/*/{Protheus.doc} LoadGestAcces
===============================================================================
Aplica regras do SIGCTB52 no model CNNDETAILS
===============================================================================
@author uilon.eugenio
@type function
@since 17/04/2018
@version 1.0
@param oModel, object, oModel corrente da tela
@param _cGestor, character, Codigo do usuario do gestor do contrato
@param _cContra, character, Numero do contrato
@param _cFilial, character, Filial do contrato
@return object, sem retorno, este processo alimenta dados no modelo CNN
@history 15/03/2021, uilon.eugenio, adicionado documentaçao no novo padrao.	
/*/
static function LoadGestAcces(oModel,_cGestor,_cContra,_cFilial)
	local _cPermis := '020,032,037'
	local _aPermis := {}
	local _nTamPer := 0
	local _nPosArr := 0
	Local lExist := .f.
	Local _nPermis := 0
	local _nTotPerm := oModel:Length()
	// verifica se as variáveis possuem valores// campo é obrigatorio, nao deve vir vazio
	if .not. empty(_cGestor) 
		// separa as permissões por vírgula
		_aPermis := separa(_cPermis, ',', .F.)
		_nTamPer := len( _aPermis )

		// adiciona permissões para o gestor do contrato
		for _nPosArr := 1 to _nTamPer
			for _nPermis := 1 to _nTotPerm //percorre todas as permissoes
				oModel:GoLine(_nPermis)
				IF oModel:getValue("CNN_USRCOD") == _cGestor .and. oModel:getValue("CNN_TRACOD") == _aPermis[_nPosArr]
					lExist := .T.
				EndIf
			next
			if !lExist
				nLines := oModel:Length()
				nNewLine := oModel:AddLine()
				if nLines == nNewLine
					//					Alert('AddLine nao funcionou. _nPosArr := '+cvaltochar(_nPosArr)+'usr cod '+oModel:getValue("CNN_USRCOD")+ ' grp cod '+oModel:getValue("CNN_GRPCOD")+ 'Tam atual ='+cValtochar(nLines))
					oModel:AddLine()
				EndIf				
				oModel:GoLine(nNewLine)
				oModel:SetValue("CNN_FILIAL",_cFilial)
				oModel:SetValue("CNN_CONTRA",_cContra)
				oModel:SetValue("CNN_USRCOD",_cGestor)
				oModel:SetValue("CNN_GRPCOD",'      ')
				oModel:SetValue("CNN_TRACOD",_aPermis[_nPosArr]) //acesso total
				nLines := oModel:Length()
				nNewLine  := oModel:AddLine()			
				if nLines == nNewLine
					oModel:AddLine()
				EndIf
			EndIf
			lExist := .f.
		next
	endif
Return

