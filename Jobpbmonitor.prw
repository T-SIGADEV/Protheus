#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

** Criado por: Alessandro de Farias - amjgfarias@gmail.com - Em: 12/04/2020

User Function JobPbMnt
StartJob("U_PbMonitor",GetEnvServer(),.F., { "03", "01" } ) // atencao aqui
Return

User Function PbMonitor(aDados)
local oSrv     := nil
local nIdx     := 0
local aServers := {}
local aTmp     := {}
Local aSrv     := {}
Local aLogins  := {}
Local cPBTimeI := Time()
Local dPBData  := Date()
Local aEmpr    := {}
Local cBody
Local nn
Local aInfoSrv := {}
Local aInfoServ:= {}

If aDados <> Nil
	aEmpr := aClone(aDados)
Else
	aEmpr := { "03", "01" }
Endif

aadd(aSrv, { "IP/Host","Porta","Ambiente","Ativo","Observacao" } )
Aadd(aLogins, { "IDThread","Login Protheus", "Estação", "Ambiente", "Data/Hora Conexão", "Tempo", "Rotina", "Tipo da thread", "Ambiente/Server","Observacoes" } )

// ip, porta, nome do ambiente, observacao, se lista os usuarios conectados
aadd(aServers, { "192.168.1.250",12001,"Monitor"       ,"Master"     ,.F.})
aadd(aServers, { "192.168.1.250", 6931,"Environment"   ,"Slave 1"    ,.T.})
aadd(aServers, { "192.168.1.250", 6932,"Environment"   ,"Slave 2"    ,.T.})
aadd(aServers, { "192.168.1.250", 6933,"Environment"   ,"Slave 3"    ,.T.})
aadd(aServers, { "192.168.1.250", 6934,"Environment"   ,"Slave 4"    ,.T.})
aadd(aServers, { "192.168.1.250", 6969,"EnvJobs"       ,"Jobs"       ,.T.})
aadd(aServers, { "192.168.1.250", 6970,"Environment"   ,"Braenge"    ,.T.})
aadd(aServers, { "192.168.1.250", 6935,"Environment"   ,"WebApp"     ,.T.})
aadd(aServers, { "192.168.1.15" , 4970,"Environment"   ,"Compilacao" ,.T.})
aadd(aServers, { "192.168.1.15" , 1960,"WebServiceCli" ,"WebServices",.T.})
aadd(aServers, { "192.168.1.15" , 1961,"PortalCli"     ,"Portais"    ,.T.})

//aServers := {}
//aadd(aServers, { "192.168.1.250", 6970,"Environment"   ,"Braenge"    ,.T.})

For nIdx := 1 to len(aServers)
	oSrv := rpcconnect( aServers[nIdx,1], aServers[nIdx,2], aServers[nIdx,3], aEmpr[01], aEmpr[02] )
	if valtype(oSrv) == "O"
		oSrv:callproc("RPCSetType", 3)
		aTmp  := oSrv:callproc("GetUserInfoArray") // chama a funcao remotamente no server, retornando a lista de usuarios conectados
		If aServers[nIdx,5]
			For nn:=1 To Len(aTmp)
				Aadd(aLogins, { aTmp[nn][3],aTmp[nn][1],aTmp[nn][2],aTmp[nn][6],aTmp[nn][7],aTmp[nn][8],aTmp[nn][5],iif(Len(aTmp[nn])>=15,aTmp[nn][15],"."),aServers[nIdx,3]+"/"+cValToChar(aServers[nIdx,2]),aTmp[nn][11] } )
			Next nn
		Endif
		aTmp := nil
		aAdd(aSrv, { aServers[nIdx,1], aServers[nIdx,2], aServers[nIdx,3], "S", aServers[nIdx,4] } )
		oSrv:callproc("RpcClearEnv")
		rpcdisconnect(oSrv)
	else
		aAdd(aSrv, { aServers[nIdx,1], aServers[nIdx,2], aServers[nIdx,3], "N", aServers[nIdx,4] } )
	endif
Next nIdx

RpcClearEnv()
RpcSetType(3)
RpcSetEnv( aEmpr[01], aEmpr[02] )
If Empty(__cUSerID)
	cUserName  := 'Administrador'
	__cUSerID  := '000000'
Endif
PtInternal( 1, "PbMonitor - Emp: " + cEmpAnt )
TcInternal( 1, "PbMonitor - Emp: " + cEmpAnt )

aSecao := {}
aAdd(aSecao, {'ThreadId', cValToChar(ThreadId()) } )
aAdd(aSecao, {'Data / Hora Inicio', DTOC( dPBData ) + ' / ' + cPBTimeI } )
aAdd(aSecao, {'Duracao', ElapTime( cPBTimeI, Time() ) } )
aAdd(aSecao, {'Build Protheus', GetBuild() } )
aAdd(aSecao, {'Build TOP', TCGetBuild() } )
aAdd(aSecao, {'Environment', GetEnvServer()  } )
aAdd(aSecao, {'StartPath', GetSrvProfString( 'StartPath', '' )  } )
aAdd(aSecao, {'RootPath', GetSrvProfString( 'RootPath', '' )  } )
aAdd(aSecao, {'Versao', GetVersao()  } )
aAdd(aSecao, {'Release', GetRPORelease()  } )
aAdd(aSecao, {'Usuario TOTVS', __cUserId + '-' + cUserName } )
aAdd(aSecao, {'Computer Name', GetComputerName() } )

aInfoServ := GetSrvInfo()
aAdd( aInfoSrv, { "Nome do Servidor",aInfoServ[1] } )
aAdd( aInfoSrv, { "Sistema Operacional",aInfoServ[2] } )
aAdd( aInfoSrv, { "Informacao adicional",aInfoServ[3] } )
aAdd( aInfoSrv, { "Memoia Fisica",aInfoServ[4] } )
aAdd( aInfoSrv, { "Nr. de Processadores (Nucleos)",aInfoServ[5] } )
aAdd( aInfoSrv, { "Velocidade do processador (Ghz)",aInfoServ[6] } )
aAdd( aInfoSrv, { "Descricao do processador",aInfoServ[7] } )
If len(aInfoServ)>=11
	for nIdx := 1 to len(aInfoServ[11])
		aAdd( aInfoSrv, { "interface de rede "+cValToChar(nIdx), aInfoServ[11][nIdx][1] } )
		aAdd( aInfoSrv, { "Mac Address da interface "+cValToChar(nIdx), aInfoServ[11][nIdx][2] } )
	next nIdx
Endif

cBody := ""
cBody += "<b>Servidores</b> <P>"
cBody += "<P>"
cBody	+= TabelaHTML( aSrv, .T., "100%" )
cBody += "<b>Conexoes ativas</b> <P>"
cBody	+= TabelaHTML( aLogins, .T., "100%" )
cBody += "<b>Dados da thread atual</b> <P>"
cBody	+= TabelaHTML( aSecao, .F., "100%" )
cBody += "<b>Informacoes do servidor</b> <P>"
cBody	+= TabelaHTML( aInfoSrv, .F., "100%" )
cBody += "<P>"


// coloca aqui sua funcao de envio de e-mails
U_SduMandaEmail( "alessandro@farias.net.br"/*cPara*/, "alessandro.farias@pernambucoconstrutora.com.br"/*cCopia*/, ""/*cConhCopia*/, "Monitoramento Protheus"/*cAssunto*/, Nil/*_cDe*/, cBody/*cTexto*/, .T./*lHtml*/,Nil/*cFile*/,.F./*lConfMaiRead*/,Nil/*aPWD*/,.F./*lJob*/ )

Return


** Criado por: Alessandro de Farias - amjgfarias@gmail.com - Em: 12/06/2007
Static Function TabelaHTML(aDados, lCabec, cWidth, lRodape, aCl, cDirecao, lSpan)
Local cBuffer := ""
Local ni      := 1
Local nj      := 1
Local cCol    := ""
Local uValue  := Nil

aCl	  := Iif(aCl==Nil, {}, aCl )

If ValType(cWidth)=="U"
	cBuffer+='<table border="1">'
Else
	cBuffer+='<table border="1" width="' + cWidth + '">'
EndIf

For ni := 1 To Len(aDados)
	cBuffer+='<tr>'
	For nj := 1 To Len(aDados[ni])
		if Len(aDados[ni]) < Len(aDados[1]) .and. lSpan
			cCol:= " colspan='x' "
			cCol:= StrTran(cCol,"x",Alltrim(Str(Len(aDados[1]))))
		Endif
		uValue := aDados[ni][nj]
		Do Case
			Case ValType(uValue) == "D"
				uValue := NIL
				uValue := dtoc(aDados[ni][nj])
			Case ValType(uValue) == "N"
				uValue := NIL
				uValue := Alltrim(Str(aDados[ni][nj]))
			Case ValType(uValue) == "U"
				uValue := ""
			Case ValType(uValue) == "A"
				uValue := NIL
				uValue := ""
		EndCase
		If lCabec .And. ni==1
			If cDirecao == "L"
				cBuffer += ' <td'+cCol+'><b> <align="left">' + HTMLEnc(uValue) + '</b></td>'
			ElseIf cDirecao == "R"
				cBuffer += ' <td'+cCol+'><b> <align="Right">' + HTMLEnc(uValue) + '</b></td>'
			ElseIf cDirecao == "C"
				cBuffer += ' <td'+cCol+'><b> <align="Center">' + HTMLEnc(uValue) + '</b></td>'
			ElseIf cDirecao == Nil
				cBuffer += '<td'+cCol+'><b>' + HTMLEnc(aDados[ni][nj]) + '</b></td>'
			Endif
		Else
			If Len(aCl) > 0 .And. aScan( aCl, nj ) > 0
				If cDirecao == "L"
					cBuffer += ' <td'+cCol+' align="left" >' + HTMLEnc(uValue) + '</td>'
				ElseIf cDirecao == "R"
					cBuffer += ' <td'+cCol+' align="Right" >' + HTMLEnc(uValue) + '</td>'
				ElseIf cDirecao == "C"
					cBuffer += ' <td'+cCol+' align="Center" >' + HTMLEnc(uValue) + '</td>'
				ElseIf cDirecao == Nil
					cBuffer += '<td'+cCol+'>' + HTMLEnc(uValue) + '</td>'
				Endif
			Else
				cBuffer += '<td'+cCol+'>' + HTMLEnc(uValue) + '</td>'
			Endif
		EndIf
	Next nj
	cBuffer+='</tr>'
Next ni

cBuffer+="</table>"

Return cBuffer


Static Function HTMLEnc(uString)
Local cBuffer := uString
Do Case
	Case ValType(uString)=="C"
		cBuffer = Strtran(cBuffer, "&", "&amp;")
		cBuffer = Strtran(cBuffer, '"', "&quot;")
		cBuffer = Strtran(cBuffer, "<", "&lt;")
		cBuffer = Strtran(cBuffer, ">", "&gt;")
	Case ValType(uString)=="N"
		cBuffer = Alltrim(Str(uString))
EndCase
Return cBuffer

