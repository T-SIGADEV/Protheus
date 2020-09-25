#include "protheus.ch"
 
User Function MyTReport()
 
Local oReport := TReport():New('TITULO',"MyTReport",/*cPerg*/,{|oReport| __PRPrint(oReport)},,,,,,,,)
Local nI
Local oBreak
 
oReport:SetTotalInLine(.F.)
oReport:SetTitle('Protheus Report Utility')
oReport:SetLineHeight(30)
oReport:SetColSpace(1)
oReport:SetLeftMargin(0)
oReport:oPage:SetPageNumber(1)
oReport:cFontBody := 'Courier New'
oReport:nFontBody := 6
oReport:lBold := .F.
oReport:lUnderLine := .F.
oReport:lHeaderVisible := .T.
oReport:lFooterVisible := .T.
oReport:lParamPage := .F.
 
oTREPORT02:= TRSection():New(oReport,'Contas a Receber',,,,,,,,,,,,,,,,,,,)
oTREPORT02:SetTotalInLine(.F.)
oTREPORT02:SetTotalText('Contas a Receber')
oTREPORT02:lUserVisible := .T.
oTREPORT02:lHeaderVisible := .F.
oTREPORT02:SetLineStyle(.F.)
oTREPORT02:SetLineHeight(30)
oTREPORT02:SetColSpace(1)
oTREPORT02:SetLeftMargin(0)
oTREPORT02:SetLinesBefore(0)
oTREPORT02:SetCols(0)
oTREPORT02:SetHeaderSection(.T.)
oTREPORT02:SetHeaderPage(.F.)
oTREPORT02:SetHeaderBreak(.F.)
oTREPORT02:SetLineBreak(.F.)
oTREPORT02:SetAutoSize(.F.)
oTREPORT02:SetPageBreak(.F.)
oTREPORT02:SetClrBack(16777215)
oTREPORT02:SetClrFore(0)
oTREPORT02:SetBorder('')
oTREPORT02:SetBorder('',,,.T.)
oTREPORT02:aTable := {}
oTREPORT02:AddTable('SE1')
oTREPORT02:AddTable('SA1')
oTREPORT02:OnPrintLine({|| If(SE1->E1_FILIAL $ '01|02|', .T., .F.)})
 
 
TRCell():New(oTREPORT02,'__NEW__001','','',,,,,,,,,,,,)
oTREPORT02:Cell("__NEW__001"):SetName("A1_NOME")
oTREPORT02:Cell("A1_NOME"):cAlias := "SA1"
oTREPORT02:Cell("A1_NOME"):SetTitle("Nome")
oTREPORT02:Cell("A1_NOME"):SetSize(40)
oTREPORT02:Cell("A1_NOME"):SetPicture("@!")
oTREPORT02:Cell("A1_NOME"):SetAutoSize(.F.)
oTREPORT02:Cell("A1_NOME"):SetLineBreak(.F.)
oTREPORT02:Cell("A1_NOME"):SetHeaderSize(.F.)
oTREPORT02:Cell("A1_NOME"):nAlign := 1
oTREPORT02:Cell("A1_NOME"):nHeaderAlign := 1
oTREPORT02:Cell("A1_NOME"):SetClrBack(16777215)
oTREPORT02:Cell("A1_NOME"):SetClrFore(0)
oTREPORT02:Cell("A1_NOME"):cOrder := "A0"
oTREPORT02:Cell("A1_NOME"):nType := 1
oTREPORT02:Cell("A1_NOME"):cFormula := ""
oTREPORT02:Cell("A1_NOME"):cRealFormula := ""
oTREPORT02:Cell("A1_NOME"):cUserFunction := ""
oTREPORT02:Cell("A1_NOME"):lVisible := .T.
oTREPORT02:Cell("A1_NOME"):SetBorder("")
oTREPORT02:Cell("A1_NOME"):SetBorder("",,,.T.)
 
TRCell():New(oTREPORT02,'__NEW__002','','',,,,,,,,,,,,)
oTREPORT02:Cell("__NEW__002"):SetName("E1_PREFIXO")
oTREPORT02:Cell("E1_PREFIXO"):cAlias := "SE1"
oTREPORT02:Cell("E1_PREFIXO"):SetTitle("Prefixo")
oTREPORT02:Cell("E1_PREFIXO"):SetSize(3)
oTREPORT02:Cell("E1_PREFIXO"):SetPicture("@!")
oTREPORT02:Cell("E1_PREFIXO"):SetAutoSize(.F.)
oTREPORT02:Cell("E1_PREFIXO"):SetLineBreak(.F.)
oTREPORT02:Cell("E1_PREFIXO"):SetHeaderSize(.F.)
oTREPORT02:Cell("E1_PREFIXO"):nAlign := 1
oTREPORT02:Cell("E1_PREFIXO"):nHeaderAlign := 1
oTREPORT02:Cell("E1_PREFIXO"):SetClrBack(16777215)
oTREPORT02:Cell("E1_PREFIXO"):SetClrFore(0)
oTREPORT02:Cell("E1_PREFIXO"):cOrder := "A1"
oTREPORT02:Cell("E1_PREFIXO"):nType := 1
oTREPORT02:Cell("E1_PREFIXO"):cFormula := ""
oTREPORT02:Cell("E1_PREFIXO"):cRealFormula := ""
oTREPORT02:Cell("E1_PREFIXO"):cUserFunction := ""
oTREPORT02:Cell("E1_PREFIXO"):lVisible := .T.
oTREPORT02:Cell("E1_PREFIXO"):SetBorder("")
oTREPORT02:Cell("E1_PREFIXO"):SetBorder("",,,.T.)
 
TRCell():New(oTREPORT02,'__NEW__003','','',,,,,,,,,,,,)
oTREPORT02:Cell("__NEW__003"):SetName("E1_NUM")
oTREPORT02:Cell("E1_NUM"):cAlias := "SE1"
oTREPORT02:Cell("E1_NUM"):SetTitle("No. Titulo")
oTREPORT02:Cell("E1_NUM"):SetSize(9)
oTREPORT02:Cell("E1_NUM"):SetPicture("@!")
oTREPORT02:Cell("E1_NUM"):SetAutoSize(.F.)
oTREPORT02:Cell("E1_NUM"):SetLineBreak(.F.)
oTREPORT02:Cell("E1_NUM"):SetHeaderSize(.F.)
oTREPORT02:Cell("E1_NUM"):nAlign := 1
oTREPORT02:Cell("E1_NUM"):nHeaderAlign := 1
oTREPORT02:Cell("E1_NUM"):SetClrBack(16777215)
oTREPORT02:Cell("E1_NUM"):SetClrFore(0)
oTREPORT02:Cell("E1_NUM"):cOrder := "A2"
oTREPORT02:Cell("E1_NUM"):nType := 1
oTREPORT02:Cell("E1_NUM"):cFormula := ""
oTREPORT02:Cell("E1_NUM"):cRealFormula := ""
oTREPORT02:Cell("E1_NUM"):cUserFunction := ""
oTREPORT02:Cell("E1_NUM"):lVisible := .T.
oTREPORT02:Cell("E1_NUM"):SetBorder("")
oTREPORT02:Cell("E1_NUM"):SetBorder("",,,.T.)
 
TRCell():New(oTREPORT02,'__NEW__004','','',,,,,,,,,,,,)
oTREPORT02:Cell("__NEW__004"):SetName("E1_PARCELA")
oTREPORT02:Cell("E1_PARCELA"):cAlias := "SE1"
oTREPORT02:Cell("E1_PARCELA"):SetTitle("Parcela")
oTREPORT02:Cell("E1_PARCELA"):SetSize(1)
oTREPORT02:Cell("E1_PARCELA"):SetPicture("@!")
oTREPORT02:Cell("E1_PARCELA"):SetAutoSize(.F.)
oTREPORT02:Cell("E1_PARCELA"):SetLineBreak(.F.)
oTREPORT02:Cell("E1_PARCELA"):SetHeaderSize(.F.)
oTREPORT02:Cell("E1_PARCELA"):nAlign := 1
oTREPORT02:Cell("E1_PARCELA"):nHeaderAlign := 1
oTREPORT02:Cell("E1_PARCELA"):SetClrBack(16777215)
oTREPORT02:Cell("E1_PARCELA"):SetClrFore(0)
oTREPORT02:Cell("E1_PARCELA"):cOrder := "A3"
oTREPORT02:Cell("E1_PARCELA"):nType := 1
oTREPORT02:Cell("E1_PARCELA"):cFormula := ""
oTREPORT02:Cell("E1_PARCELA"):cRealFormula := ""
oTREPORT02:Cell("E1_PARCELA"):cUserFunction := ""
oTREPORT02:Cell("E1_PARCELA"):lVisible := .T.
oTREPORT02:Cell("E1_PARCELA"):SetBorder("")
oTREPORT02:Cell("E1_PARCELA"):SetBorder("",,,.T.)
 
TRCell():New(oTREPORT02,'__NEW__005','','',,,,,,,,,,,,)
oTREPORT02:Cell("__NEW__005"):SetName("E1_CLIENTE")
oTREPORT02:Cell("E1_CLIENTE"):cAlias := "SE1"
oTREPORT02:Cell("E1_CLIENTE"):SetTitle("Cliente")
oTREPORT02:Cell("E1_CLIENTE"):SetSize(6)
oTREPORT02:Cell("E1_CLIENTE"):SetPicture("@!")
oTREPORT02:Cell("E1_CLIENTE"):SetAutoSize(.F.)
oTREPORT02:Cell("E1_CLIENTE"):SetLineBreak(.F.)
oTREPORT02:Cell("E1_CLIENTE"):SetHeaderSize(.F.)
oTREPORT02:Cell("E1_CLIENTE"):nAlign := 1
oTREPORT02:Cell("E1_CLIENTE"):nHeaderAlign := 1
oTREPORT02:Cell("E1_CLIENTE"):SetClrBack(16777215)
oTREPORT02:Cell("E1_CLIENTE"):SetClrFore(0)
oTREPORT02:Cell("E1_CLIENTE"):cOrder := "A4"
oTREPORT02:Cell("E1_CLIENTE"):nType := 1
oTREPORT02:Cell("E1_CLIENTE"):cFormula := ""
oTREPORT02:Cell("E1_CLIENTE"):cRealFormula := ""
oTREPORT02:Cell("E1_CLIENTE"):cUserFunction := ""
oTREPORT02:Cell("E1_CLIENTE"):lVisible := .T.
oTREPORT02:Cell("E1_CLIENTE"):SetBorder("")
oTREPORT02:Cell("E1_CLIENTE"):SetBorder("",,,.T.)
 
TRCell():New(oTREPORT02,'__NEW__006','','',,,,,,,,,,,,)
oTREPORT02:Cell("__NEW__006"):SetName("E1_LOJA")
oTREPORT02:Cell("E1_LOJA"):cAlias := "SE1"
oTREPORT02:Cell("E1_LOJA"):SetTitle("Loja")
oTREPORT02:Cell("E1_LOJA"):SetSize(1)
oTREPORT02:Cell("E1_LOJA"):SetPicture("@!")
oTREPORT02:Cell("E1_LOJA"):SetAutoSize(.F.)
oTREPORT02:Cell("E1_LOJA"):SetLineBreak(.F.)
oTREPORT02:Cell("E1_LOJA"):SetHeaderSize(.F.)
oTREPORT02:Cell("E1_LOJA"):nAlign := 1
oTREPORT02:Cell("E1_LOJA"):nHeaderAlign := 1
oTREPORT02:Cell("E1_LOJA"):SetClrBack(16777215)
oTREPORT02:Cell("E1_LOJA"):SetClrFore(0)
oTREPORT02:Cell("E1_LOJA"):cOrder := "A5"
oTREPORT02:Cell("E1_LOJA"):nType := 1
oTREPORT02:Cell("E1_LOJA"):cFormula := ""
oTREPORT02:Cell("E1_LOJA"):cRealFormula := ""
oTREPORT02:Cell("E1_LOJA"):cUserFunction := ""
oTREPORT02:Cell("E1_LOJA"):lVisible := .T.
oTREPORT02:Cell("E1_LOJA"):SetBorder("")
oTREPORT02:Cell("E1_LOJA"):SetBorder("",,,.T.)
 
TRPosition():New(oTREPORT02,'SA1',1,{ || xFilial()+SE1->(E1_CLIENTE+E1_LOJA) } )
 
oBreak := TRBreak():New(oTREPORT02,{|| oTREPORT02:Cell('E1_CLIENTE'):uPrint+oTREPORT02:Cell('E1_LOJA'):uPrint },'Sub-Total',.F.)
 
TRFunction():New(oTREPORT02:Cell('E1_CLIENTE'),, 'COUNT',oBreak ,,,,.F.,.F.,.F., oTREPORT02)
 
oTREPORT02:LoadOrder()
 
oReport:PrintDialog()
 
Return
  
#include "protheus.ch"
#include "report.ch"
 
User Function Exemplo1()
Local oReport
Local oSA1
Local oSC5
Local oSC6
 
Pergunte("REPORT",.F.)
 
DEFINE REPORT oReport NAME "MYREPORT" TITLE "Pedidos de Venda" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}
 
    DEFINE SECTION oSA1 OF oReport TITLE "Cliente" TABLES "SA1" //TOTAL IN COLUMN //PAGE HEADER
    oSA1:SetPageBreak()
 
        DEFINE CELL NAME "A1_COD" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_NOME" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_VEND" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_MCOMPRA" OF oSA1 ALIAS "SA1"
 
    DEFINE SECTION oSC5 OF oSA1 TITLE "Pedido" TABLE "SC5" //PAGE HEADER
 
        DEFINE CELL NAME "NUM" OF oSC5 TITLE "Pedido" SIZE 10
        DEFINE CELL NAME "C5_NUM" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_TIPO" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_VEND1" OF oSC5 ALIAS "SC5"
         
        // Conta quantos pedidos foram feitos para este cliente
        DEFINE FUNCTION FROM oSC5:Cell("C5_NUM") OF oSA1 FUNCTION COUNT TITLE "Pedidos"
 
 
        DEFINE SECTION oSC6 OF oSC5 TITLE "Itens" TABLE "SC6","SB1" TOTAL TEXT "Valor total do pedido" TOTAL IN COLUMN //PAGE HEADER
 
            DEFINE CELL NAME "C6_ITEM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRODUTO" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "B1_DESC" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "B1_GRUPO" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "C6_UM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_QTDVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRCVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_VALOR" OF oSC6 ALIAS "SC6"
             
            // Conta quantidade de itens dos pedidos e imprime somente no final da pagina
            DEFINE FUNCTION FROM oSC6:Cell("C6_ITEM") FUNCTION COUNT END PAGE
            // Faz a somatoria do pedido
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION SUM
            // Guarda o maior valor entre os itens de pedido, imprime no final da seção e depois no final do relatório
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MAX TITLE "Maior Valor"
            // Guarda o menor valor entre os itens de pedido mas não imprime no final da seção mas imprime no final do relatório
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MIN NO END SECTION TITLE "Menor Valor"
            // Guarda a média entre os itens de pedido não imprime no final da seção mas imprime no final do relatório
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION AVERAGE NO END SECTION TITLE "Valor Médio"
 
oReport:PrintDialog()
Return
 
Static Function PrintReport(oReport)
#IFDEF TOP
    Local cAlias := GetNextAlias()
 
    MakeSqlExp("REPORT")
     
    BEGIN REPORT QUERY oReport:Section(1)
     
    BeginSql alias cAlias
        SELECT A1_COD,A1_NOME,A1_VEND,A1_MCOMPRA,
            C5_NUM NUM,C5_NUM,C5_TIPO,C5_VEND1,C5_CLIENTE,
            C6_ITEM,C6_PRODUTO,C6_UM,C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_NUM,
            B1_DESC,B1_GRUPO
         
        FROM %table:SA1% SA1, %table:SC5% SC5, %table:SC6% SC6, %table:SB1% SB1
         
        WHERE A1_FILIAL = %xfilial:SA1% AND SA1.%notDel% AND
            C5_FILIAL = %xfilial:SC5% AND SC5.%notDel% AND C5_CLIENTE = A1_COD AND
            C6_FILIAL = %xfilial:SC6% AND SC6.%notDel% AND C6_NUM = C5_NUM AND
            B1_FILIAL = %xfilial:SB1% AND SB1.%notDel% AND B1_COD = C6_PRODUTO
         
        ORDER BY A1_FILIAL,A1_COD,
            C5_FILIAL,C5_NUM,
            C6_FILIAL,C6_ITEM
    EndSql
     
    END REPORT QUERY oReport:Section(1) PARAM mv_par01
     
    oReport:Section(1):Section(1):SetParentQuery()
    oReport:Section(1):Section(1):SetParentFilter({|cParam| (cAlias)->C5_CLIENTE == cParam},{|| (cAlias)->A1_COD})
     
    oReport:Section(1):Section(1):Section(1):SetParentQuery()
    oReport:Section(1):Section(1):Section(1):SetParentFilter({|cParam| (cAlias)->C6_NUM == cParam},{|| (cAlias)->C5_NUM})
 
    oReport:Section(1):Print()
#ENDIF
Return
 
#include "protheus.ch"
#include "report.ch"
 
User Function Exemplo2()
Local oReport
Local oSA1
Local oSC5
Local oSC6
 
Pergunte("REPORT",.F.)
 
DEFINE REPORT oReport NAME "MYREPORT" TITLE "Pedidos de Venda" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}
 
    DEFINE SECTION oSA1 OF oReport TITLE "Cliente" TABLES "SA1" //TOTAL IN COLUMN //PAGE HEADER
    //oSA1:SetHeaderSection(.F.)
    //oSA1:SetPuageBreak()
 
        DEFINE CELL NAME "A1_COD" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_NOME" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_VEND" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_MCOMPRA" OF oSA1 ALIAS "SA1"
 
    DEFINE SECTION oSC5 OF oSA1 TITLE "Pedido" TABLE "SC5" //PAGE HEADER
 
        DEFINE CELL NAME "NUM" OF oSC5 TITLE "Pedido" SIZE 10
        DEFINE CELL NAME "C5_NUM" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_TIPO" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_VEND1" OF oSC5 ALIAS "SC5"
 
        DEFINE FUNCTION FROM oSC5:Cell("C5_NUM") OF oSA1 FUNCTION COUNT TITLE "Pedidos"
 
 
        DEFINE SECTION oSC6 OF oSC5 TITLE "Itens" TABLE "SC6","SB1" TOTAL TEXT "Valor total do pedido" TOTAL IN COLUMN //PAGE HEADER
        //oSC6:SetHeaderSection(.F.)
 
            DEFINE CELL NAME "C6_ITEM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRODUTO" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "B1_DESC" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "B1_GRUPO" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "C6_UM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_QTDVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRCVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_VALOR" OF oSC6 ALIAS "SC6"
             
            //oSC6:Cell("C6_VALOR"):Disable()
 
            DEFINE FUNCTION FROM oSC6:Cell("C6_ITEM") FUNCTION COUNT END PAGE
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION SUM
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MAX TITLE "Maior Valor"
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MIN NO END SECTION TITLE "Menor Valor"
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION AVERAGE NO END SECTION TITLE "Valor Médio"
 
oReport:PrintDialog()
Return
 
Static Function PrintReport(oReport)
#IFDEF TOP
    Local cAlias1 := GetNextAlias()
    Local cAlias2 := GetNextAlias()
    Local cAlias3 := GetNextAlias()
 
    MakeSqlExp("REPORT")
     
    BEGIN REPORT QUERY oReport:Section(1)
     
    BeginSql alias cAlias1
        SELECT A1_COD,A1_NOME,A1_VEND,A1_MCOMPRA
        FROM %table:SA1% SA1
        WHERE A1_FILIAL = %xfilial:SA1% AND SA1.%notDel%
        ORDER BY A1_FILIAL,A1_COD
    EndSql
     
    END REPORT QUERY oReport:Section(1) PARAM mv_par01
 
 
    BEGIN REPORT QUERY oReport:Section(1):Section(1)
     
    BeginSql alias cAlias2
        SELECT C5_NUM NUM,C5_NUM,C5_TIPO,C5_VEND1
        FROM %table:SC5% SC5
        WHERE C5_FILIAL = %xfilial:SC5% AND SC5.%notDel% AND C5_CLIENTE = %report_param: (cAlias1)->A1_COD%
        ORDER BY C5_FILIAL,C5_NUM
    EndSql
     
    END REPORT QUERY oReport:Section(1):Section(1)
 
 
    BEGIN REPORT QUERY oReport:Section(1):Section(1):Section(1)
     
    BeginSql alias cAlias3
        SELECT C6_ITEM,C6_PRODUTO,C6_UM,C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_NUM,
            B1_DESC,B1_GRUPO
        FROM %table:SC6% SC6, %table:SB1% SB1
        WHERE C6_FILIAL = %xfilial:SC6% AND SC6.%notDel% AND C6_NUM = %report_param: (cAlias2)->C5_NUM% AND
            B1_FILIAL = %xfilial:SB1% AND SB1.%notDel% AND B1_COD = C6_PRODUTO
        ORDER BY C6_FILIAL,C6_NUM,C6_ITEM
    EndSql
     
    END REPORT QUERY oReport:Section(1):Section(1):Section(1)
     
    oReport:Section(1):Print()
#ENDIF
Return
 
#include "protheus.ch"
#include "report.ch"
 
User Function Exemplo3()
Local oReport
Local oSA1
Local oSC5
Local oSC6
 
Pergunte("REPORT",.F.)
 
DEFINE REPORT oReport NAME "MYREPORT" TITLE "Pedidos de Venda" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}
 
    DEFINE SECTION oSA1 OF oReport TITLE "Cliente" TABLES "SA1" //TOTAL IN COLUMN //PAGE HEADER
    //oSA1:SetHeaderSection(.F.)
    //oSA1:SetPageBreak()
 
        DEFINE CELL NAME "A1_COD" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_NOME" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_VEND" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_MCOMPRA" OF oSA1 ALIAS "SA1"
 
    DEFINE SECTION oSC5 OF oSA1 TITLE "Pedido" TABLE "SC5" //PAGE HEADER
 
        DEFINE CELL NAME "NUM" OF oSC5 TITLE "Pedido" SIZE 10
        DEFINE CELL NAME "C5_NUM" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_TIPO" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_VEND1" OF oSC5 ALIAS "SC5"
 
        DEFINE FUNCTION FROM oSC5:Cell("C5_NUM") OF oSA1 FUNCTION COUNT TITLE "Pedidos"
 
 
        DEFINE SECTION oSC6 OF oSC5 TITLE "Itens" TABLE "SC6","SB1" TOTAL TEXT "Valor total do pedido" TOTAL IN COLUMN //PAGE HEADER
        //oSC6:SetHeaderSection(.F.)
 
            DEFINE CELL NAME "C6_ITEM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRODUTO" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "B1_DESC" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "B1_GRUPO" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "C6_UM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_QTDVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRCVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_VALOR" OF oSC6 ALIAS "SC6"
             
            //oSC6:Cell("C6_VALOR"):Disable()
 
            DEFINE FUNCTION FROM oSC6:Cell("C6_ITEM") FUNCTION COUNT END PAGE
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION SUM
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MAX TITLE "Maior Valor"
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MIN NO END SECTION TITLE "Menor Valor"
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION AVERAGE NO END SECTION TITLE "Valor Médio"
 
oReport:PrintDialog()
Return
 
Static Function PrintReport(oReport)
#IFDEF TOP
    Local cAlias := GetNextAlias()
    Local cSql := ""
 
    Local oSA1 := oReport:Section(1)
    Local oSC5 := oReport:Section(1):Section(1)
    Local oSC6 := oReport:Section(1):Section(1):Section(1)
    MakeSqlExp("REPORT")
     
    If !Empty(mv_par02)
        cSql += "AND B1_GRUPO >= '"+mv_par02+"'"
    EndIf
 
    If !Empty(mv_par03)
        cSql += "AND B1_GRUPO <= '"+mv_par03+"'"
    EndIf
     
    cSql := "%"+cSql+"%"
     
    BEGIN REPORT QUERY oSA1
     
    BeginSql alias cAlias
        SELECT A1_COD,A1_NOME,A1_VEND,A1_MCOMPRA,
            C5_NUM NUM,C5_NUM,C5_TIPO,C5_VEND1,C5_CLIENTE,
            C6_ITEM,C6_PRODUTO,C6_UM,C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_NUM,
            B1_DESC,B1_GRUPO
         
        FROM %table:SA1% SA1, %table:SC5% SC5, %table:SC6% SC6, %table:SB1% SB1
         
        WHERE A1_FILIAL = %xfilial:SA1% AND SA1.%notDel% AND
            C5_FILIAL = %xfilial:SC5% AND SC5.%notDel% AND C5_CLIENTE = A1_COD AND
            C6_FILIAL = %xfilial:SC6% AND SC6.%notDel% AND C6_NUM = C5_NUM AND
            B1_FILIAL = %xfilial:SB1% AND SB1.%notDel% AND B1_COD = C6_PRODUTO
            %exp:cSql%
         
        ORDER BY A1_FILIAL,A1_COD,
            C5_FILIAL,C5_NUM,
            C6_FILIAL,C6_ITEM
    EndSql
     
    END REPORT QUERY oSA1 PARAM mv_par01
     
    oSC5:SetParentQuery()
    oSC5:SetParentFilter({|cParam| (cAlias)->C5_CLIENTE == cParam},{|| (cAlias)->A1_COD})
     
    oSC6:SetParentQuery()
    oSC6:SetParentFilter({|cParam| (cAlias)->C6_NUM == cParam},{|| (cAlias)->C5_NUM})
 
    oSA1:Print()
#ENDIF
Return
  
#include "protheus.ch"
#include "report.ch"
 
User Function Exemplo4()
Local oReport
Local oSA1
Local oSC5
Local oSC6
 
Pergunte("REPORT",.F.)
 
DEFINE REPORT oReport NAME "MYREPORT" TITLE "Pedidos de Venda" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}
 
    DEFINE SECTION oSA1 OF oReport TITLE "Cliente" TABLES "SA1" //TOTAL IN COLUMN //PAGE HEADER
    //oSA1:SetHeaderSection(.F.)
    //oSA1:SetPageBreak()
 
        DEFINE CELL NAME "A1_COD" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_NOME" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_VEND" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_MCOMPRA" OF oSA1 ALIAS "SA1"
 
    DEFINE SECTION oSC5 OF oSA1 TITLE "Pedido" TABLE "SC5" //PAGE HEADER
 
        DEFINE CELL NAME "NUM" OF oSC5 TITLE "Pedido" SIZE 10
        DEFINE CELL NAME "C5_NUM" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_TIPO" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_VEND1" OF oSC5 ALIAS "SC5"
 
        DEFINE FUNCTION FROM oSC5:Cell("C5_NUM") OF oSA1 FUNCTION COUNT TITLE "Pedidos"
 
 
        DEFINE SECTION oSC6 OF oSC5 TITLE "Itens" TABLE "SC6","SB1" TOTAL TEXT "Valor total do pedido" TOTAL IN COLUMN //PAGE HEADER
        //oSC6:SetHeaderSection(.F.)
 
            DEFINE CELL NAME "C6_ITEM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRODUTO" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "B1_DESC" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "B1_GRUPO" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "C6_UM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_QTDVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRCVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_VALOR" OF oSC6 ALIAS "SC6"
             
            //oSC6:Cell("C6_VALOR"):Disable()
 
            DEFINE FUNCTION FROM oSC6:Cell("C6_ITEM") FUNCTION COUNT END PAGE
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") OF oSA1 FUNCTION SUM
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION SUM NO END REPORT
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MAX TITLE "Maior Valor"
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MIN NO END SECTION TITLE "Menor Valor"
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION AVERAGE NO END SECTION TITLE "Valor Médio"
 
oReport:PrintDialog()
Return
 
Static Function PrintReport(oReport)
#IFDEF TOP
    Local cAlias := GetNextAlias()
 
    MakeSqlExp("REPORT")
     
    BEGIN REPORT QUERY oReport:Section(1)
     
    BeginSql alias cAlias
        SELECT A1_COD,A1_NOME,A1_VEND,A1_MCOMPRA,
            C5_NUM NUM,C5_NUM,C5_TIPO,C5_VEND1,C5_CLIENTE,
            C6_ITEM,C6_PRODUTO,C6_UM,C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_NUM,
            B1_DESC,B1_GRUPO
         
        FROM %table:SA1% SA1, %table:SC5% SC5, %table:SC6% SC6, %table:SB1% SB1
         
        WHERE A1_FILIAL = %xfilial:SA1% AND SA1.%notDel% AND
            C5_FILIAL = %xfilial:SC5% AND SC5.%notDel% AND C5_CLIENTE = A1_COD AND
            C6_FILIAL = %xfilial:SC6% AND SC6.%notDel% AND C6_NUM = C5_NUM AND
            B1_FILIAL = %xfilial:SB1% AND SB1.%notDel% AND B1_COD = C6_PRODUTO
         
        ORDER BY A1_FILIAL,A1_COD,
            C5_FILIAL,C5_NUM,
            C6_FILIAL,C6_ITEM
    EndSql
     
    END REPORT QUERY oReport:Section(1) PARAM mv_par01
     
    oReport:Section(1):Section(1):SetParentQuery()
    oReport:Section(1):Section(1):SetParentFilter({|cParam| (cAlias)->C5_CLIENTE == cParam},{|| (cAlias)->A1_COD})
     
    oReport:Section(1):Section(1):Section(1):SetParentQuery()
    oReport:Section(1):Section(1):Section(1):SetParentFilter({|cParam| (cAlias)->C6_NUM == cParam},{|| (cAlias)->C5_NUM})
 
    oReport:Section(1):Print()
#ENDIF
Return
 
#include "protheus.ch"
#include "report.ch"
 
User Function Exemplo5()
Local oReport
Local oSA1
Local oSC5
Local oSC6
 
Pergunte("REPORT",.F.)
 
DEFINE REPORT oReport NAME "MYREPORT" TITLE "Pedidos de Venda" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}
 
    DEFINE SECTION oSA1 OF oReport TITLE "Cliente" TABLES "SA1" //TOTAL IN COLUMN //PAGE HEADER
    //oSA1:SetHeaderSection(.F.)
    //oSA1:SetPageBreak()
 
        DEFINE CELL NAME "A1_COD" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_NOME" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_VEND" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_MCOMPRA" OF oSA1 ALIAS "SA1"
 
    DEFINE SECTION oSC5 OF oSA1 TITLE "Pedido" TABLE "SC5" //PAGE HEADER
 
        DEFINE CELL NAME "NUM" OF oSC5 TITLE "Pedido" SIZE 10
        DEFINE CELL NAME "C5_NUM" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_TIPO" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_VEND1" OF oSC5 ALIAS "SC5"
 
        DEFINE FUNCTION FROM oSC5:Cell("C5_NUM") OF oSA1 FUNCTION COUNT TITLE "Pedidos"
 
 
        DEFINE SECTION oSC6 OF oSC5 TITLE "Itens" TABLE "SC6","SB1" TOTAL TEXT "Valor total do pedido" TOTAL IN COLUMN //PAGE HEADER
        //oSC6:SetHeaderSection(.F.)
 
            DEFINE CELL NAME "C6_ITEM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRODUTO" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "B1_DESC" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "B1_GRUPO" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "C6_UM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_QTDVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRCVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_VALOR" OF oSC6 ALIAS "SC6"
             
            //oSC6:Cell("C6_VALOR"):Disable()
 
            DEFINE FUNCTION FROM oSC6:Cell("C6_ITEM") FUNCTION COUNT END PAGE
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION SUM
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MAX TITLE "Maior Valor"
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MIN NO END SECTION TITLE "Menor Valor"
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION AVERAGE NO END SECTION TITLE "Valor Médio"
 
oReport:PrintDialog()
Return
 
Static Function PrintReport(oReport)
#IFDEF TOP
    Local cAlias := GetNextAlias()
 
    MakeSqlExp("REPORT")
     
    BEGIN REPORT QUERY oReport:Section(1)
     
    BeginSql alias cAlias
        SELECT A1_COD,A1_NOME,A1_VEND,A1_MCOMPRA,
            C5_NUM NUM,C5_NUM,C5_TIPO,C5_VEND1,C5_CLIENTE,
            C6_ITEM,C6_PRODUTO,C6_UM,C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_NUM,
            B1_DESC,B1_GRUPO
         
        FROM %table:SA1% SA1, %table:SC5% SC5, %table:SC6% SC6, %table:SB1% SB1
         
        WHERE A1_FILIAL = %xfilial:SA1% AND SA1.%notDel% AND
            C5_FILIAL = %xfilial:SC5% AND SC5.%notDel% AND C5_CLIENTE = A1_COD AND
            C6_FILIAL = %xfilial:SC6% AND SC6.%notDel% AND C6_NUM = C5_NUM AND
            B1_FILIAL = %xfilial:SB1% AND SB1.%notDel% AND B1_COD = C6_PRODUTO
         
        ORDER BY A1_FILIAL,A1_COD,
            C5_FILIAL,C5_NUM,
            C6_FILIAL,C6_ITEM
    EndSql
     
    END REPORT QUERY oReport:Section(1) PARAM mv_par01
     
    oReport:Section(1):Section(1):SetParentQuery()
    oReport:Section(1):Section(1):SetParentFilter({|cParam| (cAlias)->C5_CLIENTE == cParam},{|| (cAlias)->A1_COD})
     
    oReport:Section(1):Section(1):Section(1):SetParentQuery()
    oReport:Section(1):Section(1):Section(1):SetParentFilter({|cParam| (cAlias)->C6_NUM == cParam},{|| (cAlias)->C5_NUM})
    oReport:Section(1):Section(1):Section(1):SetLineCondition({|| (cAlias)->B1_GRUPO >= mv_par02 .and. (cAlias)->B1_GRUPO <= mv_par03})
 
    oReport:Section(1):Print()
#ENDIF
Return
 
#include "protheus.ch"
#include "report.ch"
 
User Function Exemplo6()
Local oReport
Local oSA1
Local oBreak
 
Pergunte("REPORT",.F.)
 
DEFINE REPORT oReport NAME "MYREPORT" TITLE "Pedidos de Venda" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}
 
    DEFINE SECTION oSA1 OF oReport TITLE "Cliente" TABLES "SA1" //TOTAL IN COLUMN //PAGE HEADER
    //oSA1:SetHeaderSection(.F.)
    //oSA1:SetPageBreak()
 
        DEFINE CELL NAME "A1_COD" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_NOME" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_VEND" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_MCOMPRA" OF oSA1 ALIAS "SA1"
         
        DEFINE BREAK oBreak OF oSA1 WHEN oSA1:Cell("A1_VEND")
         
        DEFINE FUNCTION FROM oSA1:Cell("A1_COD") FUNCTION COUNT BREAK oBreak
        DEFINE FUNCTION FROM oSA1:Cell("A1_MCOMPRA") FUNCTION SUM BREAK oBreak
 
oReport:PrintDialog()
Return
 
Static Function PrintReport(oReport)
#IFDEF TOP
    Local cAlias := GetNextAlias()
 
    MakeSqlExp("REPORT")
     
    BEGIN REPORT QUERY oReport:Section(1)
     
    BeginSql alias cAlias
        SELECT A1_COD,A1_NOME,A1_VEND,A1_MCOMPRA
        FROM %table:SA1% SA1
        WHERE A1_FILIAL = %xfilial:SA1% AND SA1.%notDel%
        ORDER BY A1_FILIAL,A1_VEND
    EndSql
     
    END REPORT QUERY oReport:Section(1) PARAM mv_par01
     
    oReport:Section(1):Print()
#ENDIF
Return
 
#include "protheus.ch"
#include "report.ch"
 
User Function Exemplo7()
Local oReport
Local oSA1
Local oSC5
Local oSC6
 
Pergunte("REPORT",.F.)
 
DEFINE REPORT oReport NAME "MYREPORT" TITLE "Pedidos de Venda" PARAMETER "REPORT" ACTION {|oReport| PrintReport(oReport)}
 
    DEFINE SECTION oSA1 OF oReport TITLE "Cliente" TABLES "SA1" //TOTAL IN COLUMN //PAGE HEADER
    //oSA1:SetHeaderSection(.F.)
    //oSA1:SetPageBreak()
 
        DEFINE CELL NAME "A1_COD" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_NOME" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_VEND" OF oSA1 ALIAS "SA1"
        DEFINE CELL NAME "A1_MCOMPRA" OF oSA1 ALIAS "SA1"
 
    DEFINE SECTION oSC5 OF oSA1 TITLE "Pedido" TABLE "SC5" //PAGE HEADER
 
        DEFINE CELL NAME "NUM" OF oSC5 TITLE "Pedido" SIZE 10
        DEFINE CELL NAME "C5_NUM" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_TIPO" OF oSC5 ALIAS "SC5"
        DEFINE CELL NAME "C5_VEND1" OF oSC5 ALIAS "SC5"
 
        DEFINE FUNCTION FROM oSC5:Cell("C5_NUM") OF oSA1 FUNCTION COUNT TITLE "Pedidos"
 
 
        DEFINE SECTION oSC6 OF oSC5 TITLE "Itens" TABLE "SC6","SB1" TOTAL TEXT "Valor total do pedido" TOTAL IN COLUMN //PAGE HEADER
        //oSC6:SetHeaderSection(.F.)
 
            DEFINE CELL NAME "C6_ITEM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRODUTO" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "B1_DESC" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "B1_GRUPO" OF oSC6 ALIAS "SB1"
            DEFINE CELL NAME "C6_UM" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_QTDVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_PRCVEN" OF oSC6 ALIAS "SC6"
            DEFINE CELL NAME "C6_VALOR" OF oSC6 ALIAS "SC6"
             
            //oSC6:Cell("C6_VALOR"):Disable()
 
            DEFINE FUNCTION FROM oSC6:Cell("C6_ITEM") FUNCTION COUNT END PAGE
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION SUM
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MAX TITLE "Maior Valor"
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION MIN NO END SECTION TITLE "Menor Valor"
            DEFINE FUNCTION FROM oSC6:Cell("C6_VALOR") FUNCTION AVERAGE NO END SECTION TITLE "Valor Médio"
 
oReport:PrintDialog()
Return
 
Static Function PrintReport(oReport)
 
MakeAdvplExpr("REPORT")
     
DbSelectArea("SA1")
DbSetOrder(1)
     
If ( !Empty(mv_par01) )
    oReport:Section(1):SetFilter(mv_par01)
EndIf
     
oReport:Section(1):Section(1):SetRelation({|| xFilial("SC5")+SA1->A1_COD},"SC5",3,.T.)
oReport:Section(1):Section(1):SetParentFilter({|cParam| SC5->C5_CLIENTE == cParam},{|| SA1->A1_COD})
 
oReport:Section(1):Section(1):Section(1):SetRelation({|| xFilial("SC6")+SC5->C5_NUM},"SC6",1,.T.)
oReport:Section(1):Section(1):Section(1):SetParentFilter({|cParam| SC6->C6_NUM == cParam},{|| SC5->C5_NUM})
     
TRPosition():New(oReport:Section(1):Section(1):Section(1),"SB1",1,{|| xFilial("SB1")+SC6->C6_PRODUTO})
oReport:Section(1):Section(1):Section(1):SetLineCondition({|| SB1->B1_GRUPO >= MV_PAR02 .and. SB1->B1_GRUPO <= MV_PAR03})
 
oReport:Section(1):Print()
Return