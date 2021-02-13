#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"

Static _lCleanCQX := .T.

** Criado   por: Alessandro de Farias - amjgfarias@gmail.com - Em: 20/10/07
** Alterado por: Alessandro de Farias - amjgfarias@gmail.com - Em: 22/03/20

User Function JobCTB190()
StartJob("U_JbCTB190",GetEnvServer(),.F., { "01", "01" } )
Return

User Function JbCTB190()
Local nNUMJOBS := 0
Local nJOBS    := 10
Local aSM0	   := {}
Local nI

OpenSM0()

DbSelectArea("SM0")
//Set Filter To M0_CODIGO $ '33'
SM0->( dbSetOrder(1) )
SM0->( dbGotop() )
DO While ! SM0->( Eof() )
	If SM0->M0_CODFIL <> "01"
		SM0->( dbSkip() )
		Loop
	Endif
	Aadd(aSM0,{ Alltrim(SM0->M0_CODIGO),Alltrim(SM0->M0_CODFIL) })
	SM0->( dbSkip() )
EndDo

SM0->(dbCloseArea())
XX8->(dbCloseArea())
XX9->(dbCloseArea())

For nI := 1 To Len(aSM0)
	StartJob("U_RNJBCTB19"  ,GetEnvServer(),.F., { aSM0[nI][1], aSM0[nI][2] } )
	nNUMJOBS := VerifJob()
	If nNUMJOBS > nJOBS
		do while .T. .And. !KillApp()
			Sleep( 1000 )	// aguarda 1 segundo
			If VerifJob() < nJOBS
				Exit
			Endif
		enddo
	Endif
Next nI

do while .T. .And. !KillApp()
	Sleep( 1000 )	// aguarda 1 segundo
	If VerifJob() == 0
		Exit
	Endif
enddo

Return


Static Function VerifJob()
Local aLCKFile := Directory( GetPathSemaforo() + 'JBCTB190*.LCK' )
Local I
For I:=1 To Len( aLCKFile )
	FErase( GetPathSemaforo() + aLCKFile[I][1] )
Next I
Sleep( 1000 )	// aguarda 1 segundo
Return Len( aLCKFile )


User Function RNJBCTB19(aCodigos)
Local nHdl
Local dDtaIni     := STOD('19991231')
Local dDtaFim     := STOD('20211231')
Local aButtons		:= {}
Local cQuery      := ""
Local nNy, nMY, nMM, aYears
Local bBlock
Local cTimeI      := Time()
Local cGTimeI     := Time()
Local cGTimeF
Local aDatas

bBlock      := ErrorBlock( { |e| ChecErro(e) } )

FErase( GetPathSemaforo() + "JBCTB190" + aCodigos[01] + ".LCK" )
nHdl := FCREATE( GetPathSemaforo() + "JBCTB190" + aCodigos[01] + ".LCK" )
If nHDL < 0
	ConOut( "ERRO no JBCTB190 em " + aCodigos[01] + " "  + DTOC(Date()) + " - " + Time() )
	Return .F.
EndIf

RpcClearEnv()
RpcSetType(3)
RpcSetEnv( aCodigos[01],aCodigos[02],,,"CTB","CTB19_"+aCodigos[01] )
SetModulo( "SIGACTB", "CTB" )
__cLogSiga := "NNNNNNNNNN"
//__cinternet := "" // Alterado para branco para habilitar a atualizacao da procregua e incproc,
//						  // a funcao RpcSetEnv declara essa variavel com o conteudo "AUTOMATICA".
If Select("SX2") == 0
	ConOut("Erro RPC CTBA190")
	FClose( nHDL )
	FErase( GetPathSemaforo() + "JBCTB190" + aCodigos[01] + ".LCK" )
	RpcClearEnv()
	Return
Endif

PtInternal( 1, "JOBCTB190 - Emp: " + aCodigos[01] )
TcInternal( 1, "JOBCTB190 - Emp: " + aCodigos[01] )

cAcesso      := Left(cAcesso,107)+"N"+Substr(cAcesso,109,Len(cAcesso)-108) // Gravar Resposta Parametros
cAcesso      := Left(cAcesso,149)+"N"+Substr(cAcesso,151,Len(cAcesso)-150) // Gravar Resposta Parametros por Empresa

cQuery := "SELECT CTG_EXERC FROM "+RetSqlName("CTG")+" WHERE D_E_L_E_T_<>'*' AND CTG_EXERC <> '    ' " + CRLF
cQuery += "GROUP BY CTG_EXERC " + CRLF
cQuery += "ORDER BY CTG_EXERC " + CRLF
MPSysOpenQuery( cQuery, "TRBCTG" )

If TRBCTG->(Eof())
	ConOut("Erro CTBA190 - Sem calendario para reprocessemnto")
	FClose( nHDL )
	FErase( GetPathSemaforo() + "JBCTB190" + aCodigos[01] + ".LCK" )
	RpcClearEnv()
	Return
Endif

aYears := {}
Do While ! TRBCTG->( Eof() )
	If Len(Alltrim(TRBCTG->CTG_EXERC)) == 4
		aAdd(aYears,TRBCTG->CTG_EXERC)
	Endif
	ConOut("TRBCTG - "+TRBCTG->CTG_EXERC)
	TRBCTG->( DbSkip() )
Enddo
TRBCTG->(DbCloseArea())

aTables := {}
aAdd(aTables,'CQ0') // SALDO POR CONTA NO MÊS
aAdd(aTables,'CQ1') // SALDO POR CONTA NO DIA
aAdd(aTables,'CQ2') // SALDO POR CENTRO CUSTO NO MÊS
aAdd(aTables,'CQ3') // SALDO CENTRO DE CUSTO NO DIA
aAdd(aTables,'CQ4') // SALDO ITEM CONTÁBIL NO MÊS
aAdd(aTables,'CQ5') // SALDO ITEM CONTÁBIL NO DIA
aAdd(aTables,'CQ6') // SALDO CLASSE VALOR NO MÊS
aAdd(aTables,'CQ7') // SALDO CLASSE DE VALOR NO DIA
aAdd(aTables,'CQ8') // SALDOS POR ENTIDADE NO MÊS
aAdd(aTables,'CQ9') // SALDO POR ENTIDADE NO DIA
aAdd(aTables,'CQA') // FILA DE SALDOS
aAdd(aTables,'CQB') // VARIAÇÃO CAMBIAL
aAdd(aTables,'CT3') // SALDOS CENTRO DE CUSTO
aAdd(aTables,'CT4') // SALDOS ITEM CONTÁBIL
aAdd(aTables,'CT6') // TOTAIS DE LOTES
aAdd(aTables,'CT7') // SALDOS PLANOS DE CONTAS
aAdd(aTables,'CTC') // SALDOS DO DOCUMENTO
aAdd(aTables,'CTF') // NUMERAÇÃO DE DOCUMENTO
aAdd(aTables,'CTI') // SALDOS DA CLASSE DE VALORES
aAdd(aTables,'CTU') // SALDOS TOTAIS POR ENTIDADE
aAdd(aTables,'CTV') // SALDOS ITEM X CENTRO DE CUSTO
aAdd(aTables,'CTW') // SALDOS CL VALOR X CENTRO CUSTO
aAdd(aTables,'CTX') // SALDOS CL VALOR X ITEM
aAdd(aTables,'CTY') // SALDOS CCUSTO X ITEM X CLVALOR
aAdd(aTables,'CVX') // SALDOS DIÁRIOS
aAdd(aTables,'CVY') // SALDOS MENSAIS ACUMULADOS
aAdd(aTables,'CVZ') // SALDO DE FECHAMENTO
aAdd(aTables,'CV6') // BACKUP LANCAMENTOS CONTABEIS
aAdd(aTables,'CV7') // FLAG DE ATUALIZAÇÃO DE SALDOS
aAdd(aTables,'CV8') // LOG DE PROCESSAMENTO
aAdd(aTables,'CVO') // FILA DE SALDOS 2

For nMY := 1 To Len( aTables )
	cFile := aTables[nMY]
	Begin Transaction
	ChkFile( cFile )
	End Transaction
	If Select(cFile) > 0
		(cFile)->(DbCloseArea())
	Endif
	If _lCleanCQX
		TcSqlExec("TRUNCATE TABLE "+RetSqlName(cFile))
	Endif
	Begin Transaction
	ChkFile( cFile )
	End Transaction
Next

DbSelectArea("SX6")
ProcLogIni( aButtons )

cGTimeI := Time()
aDatas  := {}

For nMY:=1 To Len(aYears)
	For nMM:=1 To 12
		dDtaIni := STOD( aYears[nMY] + StrZero(nMM,02) + "01" )
		dDtaFim := LastDay(dDtaIni)
		aSLD := {'8','7','6','5','4','3','2','1'}
		For nNy:=1 To Len(aSLD)
			oObj := Nil
			cTimeI := Time()
			PtInternal( 1, "Saldos Contabeis - Emp: " + cEmpAnt + " - Ano/Mes: " + aYears[nMY] + StrZero(nMM,02) )
			TcInternal( 1, "Saldos Contabeis - Emp: " + cEmpAnt + " - Ano/Mes: " + aYears[nMY] + StrZero(nMM,02) )
			Ctb190Proc(oObj,dDtaIni,dDtaFim,"01","ZZ",aSLD[nNy],.F.,"  ",cFilAnt)
			If aSLD[nNy] == "1"
				aAdd(aDatas, {dDtaIni,dDtaFim,aSLD[nNy],cTimeI,Time(),ElapTime(cTimeI,Time()) } )
			Endif
		Next nNy
	Next nMM
Next nMY
cGTimeF := Time()

VarInfo("RNJBCTB19",{cEmpAnt,aDatas})

FClose( nHDL )
FErase( GetPathSemaforo() + "JBCTB190" + aCodigos[01] + ".LCK" )

RpcClearEnv()

Return

Static Function ChecErro(e)
VarInfo("ChecErro", e:Description)
//BREAK
Return
