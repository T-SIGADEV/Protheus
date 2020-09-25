#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function mata311()//Nome da rotina

	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''
	Local lIsGrid    := .F.
	Local nLinha     := 0
	Local nQtdLinhas := 0
	Local cMsg       := ''
	Local _cUser	:= UsrRetName(RetCodUsr())

	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		lIsGrid    := ( Len( aParam ) > 3 )

		//If lIsGrid

		//     nQtdLinhas := oObj:GetQtdLine()

		//   nLinha     := oObj:nLine

		//EndIf

		If     cIdPonto == 'MODELPOS'
			cMsg := 'Chamada na validação total do modelo.' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF
			xRet := ApMsgYesNo( cMsg + 'Continua ?' )

		ElseIf cIdPonto == 'FORMPOS'

			cMsg := 'Chamada na validação total do formulário.' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF
			If      lIsGrid
				cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
			Else
				cMsg += 'É um FORMFIELD' + CRLF
			EndIf
			
			xRet := ApMsgYesNo( cMsg + 'Continua ?' )

		ElseIf cIdPonto == 'FORMLINEPRE'
		
			If aParam[5] == 'DELETE'
				cMsg := 'Chamada na pre validação da linha do formulário. ' + CRLF
				cMsg += 'Onde esta se tentando deletar a linha' + CRLF
				cMsg += 'ID ' + cIdModel + CRLF
				cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
				xRet := ApMsgYesNo( cMsg + 'Continua ?' )

			EndIf

		ElseIf cIdPonto == 'FORMLINEPOS'
			cMsg := 'Chamada na validação da linha do formulário.' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF
			cMsg += 'É um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
			cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
			xRet := ApMsgYesNo( cMsg + 'Continua ?' )

		ElseIf cIdPonto == 'MODELCOMMITTTS'
			ApMsgInfo('Chamada apos a gravação total do modelo e dentro da transação.')
		ElseIf cIdPonto == 'MODELCOMMITNTTS'
			ApMsgInfo('Chamada apos a gravação total do modelo e fora da transação.')
		ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
			ApMsgInfo('Chamada apos a gravação da tabela do formulário.')
		ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
			ApMsgInfo('Chamada apos a gravação da tabela do formulário.')
		ElseIf cIdPonto == 'MODELCANCEL'
		cMsg := 'Deseja Realmente Sair ?'
			xRet := ApMsgYesNo( cMsg )

		ElseIf cIdPonto == 'BUTTONBAR'
			xRet := { {'Salvar', 'SALVAR', { || u_TESTEX() } } }
		EndIf

	EndIf
Return xRet

User Function TESTEX()

	ALert ("passou")
	oModelx := FWModelActive()//->//Carregando Model Ativo
	oModelxDet := oModelx:GetModel('DA1DETAIL') //->Carregando grid de dados a partir o ID que foi instanciado no fonte.
	//oModelxDet:SetValue('DA1_DESCRI','TESTE')//-> Utilizando função para atribuir valor ao campo em tempo de execução

Return