#INCLUDE "TOTVS.CH"
#INCLUDE "FILEIO.CH"

** Criado por: Alessandro de Farias - amjgfarias@gmail.com - Em: 10/04/2021

User Function xnuremake
Local nI, nJ
Local cOrigem := "d:\r27\protheus_data\temp\"
Local aPastas := {"menu_pasta1","menu_pasta2","menu_pasta2"}
Local aDir    := {}
Local dDestino:= "D:\R27\protheus_data\temp\novos_menus"
For nI:=1 To Len(aPastas)
	aDir := Directory( cOrigem+aPastas[nI]+"\*.xnu" )
	For nJ:=1 To Len(aDir)
		If ! 'copy' $ lower(aDir[nJ][01])
			ConOut( cOrigem+aPastas[nI]+"\"+aDir[nJ][01] + " -> " + lower(dDestino+"\"+aPastas[nI]+aDir[nJ][01]) )
			remake( cOrigem+aPastas[nI]+"\"+aDir[nJ][01], lower(dDestino+"\"+aPastas[nI]+aDir[nJ][01]) )
		Endif
	Next nJ
Next nI
Return


Static Function remake( cMenu, cNewNemnu )
Local cLine   := Access := ''
Local aLinhas := {}
Local nI      := 1
FT_FUSE( cMenu )
FT_FGOTOP()
Do While ! FT_FEOF()
	cLine := FT_FREADLN()
	If Lower('<Access>') $ Lower( cLine ) .And. Lower('</Access>') $ Lower( cLine )
		Access := Substr( cLine, At('>',cLine)+1 )
		Access := Substr( Access, 1, At('<',Access)-1)
		Access := padr(lower(Left(Access,10)),10)
		cLine  := ' 				'+'<Access>'+Access+'</Access>'
	Endif
	If Lower('<Module>') $ Lower( cLine ) .And. Lower('</Module>') $ Lower( cLine )
		Module := Substr( cLine, At('>',cLine)+1 )
		Module := Substr( Module, 1, At('<',Module)-1)
		If Empty(Module) .Or. Module == "0"
			Module := '06'
		Endif
		cLine  := '				'+'<Module>'+Module+'</Module>'
	Endif
	If Lower('<Version>') $ Lower( cLine ) .And. Lower('</Version>') $ Lower( cLine )
		Version := Substr( cLine, At('>',cLine)+1 )
		Version := Substr( Version, 1, At('<',Version)-1)
		If Empty(Version)
			Version := '10.1'
		Endif
		cLine  := '	'+'<Version>'+Version+'</Version>'
	Endif
	If Lower('<Type>') $ Lower( cLine ) .And. Lower('</Type>') $ Lower( cLine )
		cType := Substr( cLine, At('>',cLine)+1 )
		cType := Substr( cType, 1, At('<',cType)-1)
		If Empty(cType) .Or. cType == "0"
			cType := '03'
		Endif
		cLine  := '				'+'<Type>'+cType+'</Type>'
	Endif
	If !Empty(Alltrim(cLine))
		aAdd(aLinhas,cLine)
	Endif
	FT_FSKIP()
Enddo
FT_FUSE()
For nI:=1 To Len(aLinhas)
	If nI == 1
		fErase(cNewNemnu)
	Endif
	grv2txt( cNewNemnu, aLinhas[nI] )
Next nI
Return


Static Function grv2txt( cArquivo, cTexto )
Local nHdl := 0
If !File(cArquivo)
	nHdl := FCreate(cArquivo)
Else
	nHdl := FOpen(cArquivo, FO_READWRITE)
Endif
FSeek(nHdl,0,FS_END)
cTexto += Chr(13)+Chr(10)
FWrite(nHdl, cTexto, Len(cTexto))
FClose(nHdl)
Return
