#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

** Alterado por: Alessandro de Farias - amjgfarias@gmail.com - Em: 01/05/2020

User Function JobSqlRebuild
StartJob("U_RNJBQG194",GetEnvServer(),.F., { "Teste" } )
Return


User Function RNJBQG194
Local aSM0      := {}
Local nI
Local nNUMJOBS  := 0
Local nJOBS     := 5

OpenSM0()

DbSelectArea("SM0")
//Set Filter To Alltrim(M0_CODIGO) $ '04'
SM0->( dbGotop() )
DO While ! SM0->( Eof() )
	If Alltrim(SM0->M0_CODFIL) <> "01"
		SM0->( dbSkip() )
		Loop
	Endif
	Aadd(aSM0, { SM0->M0_CODIGO, SM0->M0_CODFIL } )
	SM0->( dbSkip() )
EndDo
SM0->(dbCloseArea())
XX8->(dbCloseArea())
XX9->(dbCloseArea())

For nI := 1 To Len(aSM0)
	Sleep( 1000 )	// aguarda 1 segundos para que as jobs IPC subam.
	StartJob("U_QG194",GetEnvServer(),.F., { aSM0[nI][1], aSM0[nI][2] } )
	nNUMJOBS := VerifJob()
	If nNUMJOBS > nJOBS
		do while .T. .And. !KillApp()
			If VerifJob() < nJOBS
				Exit
			Endif
		enddo
	Endif
Next nI

do while .T. .And. !KillApp()
	If VerifJob() == 0
		Exit
	Endif
enddo

Return

Static Function VerifJob()
Local aLCKFile := Directory( GetPathSemaforo() + 'QG194*.LCK' )
Local I
For I:=1 To Len( aLCKFile )
	FErase( GetPathSemaforo() + aLCKFile[I][1] )
Next I
Sleep( 1000 )	// aguarda 1 segundos para que as jobs IPC subam.
Return Len( aLCKFile )


User Function QG194(aCodigos)
Local cFiltro
Local nHdl

nHdl := fCreate( GetPathSemaforo() + "QG194" + aCodigos[1] + ".LCK" )
If nHDL < 0
	ConOut( "ERRO NO QG194 DA EMPRESA: " + aCodigos[1] + " "  + DTOC(Date()) + " - " + Time() )
	Return .F.
EndIf

RpcClearEnv()
Sleep( 1000 )	// aguarda 1 segundos para que as jobs IPC subam.
RpcSetEnv( aCodigos[01], aCodigos[02] )
PtInternal( 1, "QG194 - Emp: " + aCodigos[01] )
TcInternal( 1, "QG194 - Emp: " + aCodigos[01] )
__cLogSiga := "NNNNNNNNNN"
SetModulo( "SIGACFG", "CFG" )
SetFunName("U_QG194")
//__cinternet := "" // Alterado para branco para habilitar a atualizacao da procregua e incproc, a funcao RpcSetEnv declara essa variavel com o conteudo "AUTOMATICA".
cUserName  := 'Administrador'
__cUSerID  := '000000'

DbSelectArea("SX2")
************** usar filtro para facilitar a otimizacao.
cFiltro := 'LEFT(X2_CHAVE,1)=="Z".Or.LEFT(X2_CHAVE,2)=="SZ"'
//cFiltro := 'X2_CHAVE=="ZZR"'
//cFiltro := 'LEFT(X2_CHAVE,2)=="NV"'
SX2->( DbSetFilter( {|| &cFiltro}, cFiltro ) )

SX3->( dbSetOrder(1) )
SIX->( dbSetOrder(1) )
SX2->( dbSetOrder(1) )
SX2->( DbGoTop() )

Do While ! SX2->( Eof() )
	
	If SX3->( dbSeek(SX2->X2_CHAVE) ) .And. SIX->( dbSeek(SX2->X2_CHAVE) )
		SqlRebuild(SX2->X2_CHAVE)
	Endif
	
	SX2->( DbSkip())
	
Enddo

FClose( nHDL )
FErase( GetPathSemaforo() + "QG194" + aCodigos[1] + ".LCK" )

Return


Static Function SqlRebuild(_cAlias)
Local cFile := RetSqlName(_cAlias)
Local cExec := ""

// se nao existe a tabela no banco, saio da rotina
If ! TcCanOpen(cFile)
	Return
Endif

Begin Transaction
ChkFile(_cAlias,.F.)
End Transaction

If Select(_cAlias) > 0
	(_cAlias)->(DbCloseArea())
Endif

cExec := "alter table " + cFile + " rebuild with ( data_compression=page, fillfactor = 95, pad_index = on ) "
ConOut(cExec)
If TcSqlExec( cExec ) <> 0
	VarInfo("TCSqlExec",TCSqlError())
Endif

cExec := "alter index " + cFile + "_PK on " + cFile + " rebuild with ( data_compression=page, fillfactor = 95, pad_index = on ) "
ConOut(cExec)
If TcSqlExec( cExec ) <> 0
	VarInfo("TCSqlExec",TCSqlError())
Endif

If ! Empty(SX2->X2_UNICO)
	cExec := "alter index " + cFile + "_UNQ on " + cFile + " rebuild with ( data_compression=page, fillfactor = 95, pad_index = on ) "
	ConOut(cExec)
	If TcSqlExec( cExec ) <> 0
		VarInfo("TCSqlExec",TCSqlError())
	Endif
Endif

SIX->( DbSeek(_cAlias) )
Do While ! SIX->( Eof() ) .And. _cAlias == SIX->INDICE
	cExec := "alter index " + cFile + SIX->ORDEM + " on " + cFile + " rebuild with ( data_compression=page, fillfactor = 95, pad_index = on ) "
	ConOut(cExec)
	If TcSqlExec( cExec ) <> 0
		VarInfo("TCSqlExec",TCSqlError())
	Endif
	SIX->( DbSkip() )
Enddo
TCRefresh( cFile )

Return
