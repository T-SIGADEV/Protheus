// Coloco o FWBrowse dentro de um dialog
oDespesBrw := fwBrowse():New()
oDespesBrw:setDataArray()
oDespesBrw:setArray( aDespes )
oDespesBrw:disableConfig()
oDespesBrw:disableReport()
oDespesBrw:setOwner( oPanelDw )

oDespesBrw:addColumn({"Despesa"                , {||aDespes[oDespesBrw:nAt,01]}, "C", pesqPict("ZEE","ZEE_CODDES")    , 1, tamSx3("ZEE_CODDES")[1]/2    ,                            , .T. , , .F.,, "xEETDESPES",, .F., .T.,                                    , "xEETDESPES"    })
oDespesBrw:addColumn({"Descrição"            , {||aDespes[oDespesBrw:nAt,02]}, "C", pesqPict("ZEE","ZEE_DESPES")    , 1, tamSx3("ZEE_DESPES")[1]/2    ,                            , .F. , , .F.,, "xZEEDESPES",, .F., .T.,                                    , "xZEEDESPES"    })
oDespesBrw:addColumn({"Tabela Pré Cálculo"    , {||aDespes[oDespesBrw:nAt,03]}, "C", pesqPict("ZEE","ZEE_CODIGO")    , 1, tamSx3("ZEE_CODIGO")[1]/2    ,                            , .F. , , .F.,, "xZEECODIGO",, .F., .T.,                                    , "xZEECODIGO"    })
oDespesBrw:addColumn({"Moeda Pré Cálculo"    , {||aDespes[oDespesBrw:nAt,04]}, "C", pesqPict("ZEE","ZEE_MOEDA")    , 1, tamSx3("ZEE_MOEDA")[1]/2    ,                            , .F. , , .F.,, "xZEEMOEDA"    ,, .F., .T.,                                    , "xZEEMOEDA"    })
oDespesBrw:addColumn({"Valor Pré Cálculo"    , {||aDespes[oDespesBrw:nAt,05]}, "N", pesqPict("ZEE","ZEE_VALOR")    , 2, tamSx3("ZEE_VALOR")[1]        , tamSx3("ZEE_VALOR")[2]    , .F. , , .F.,, "xValPreCal",, .F., .T.,                                    , "xValPreCal"    })
oDespesBrw:addColumn({"Documento"            , {||aDespes[oDespesBrw:nAt,06]}, "C", pesqPict("SE2","E2_NUM")        , 1, tamSx3("E2_NUM")[1]        , tamSx3("E2_NUM")[2]        , .T. , , .F.,, "xEETDOCTO"    ,, .F., .T.,                                    , "xEETDOCTO"    })
oDespesBrw:addColumn({"Série"                , {||aDespes[oDespesBrw:nAt,07]}, "C", pesqPict("SF1","F1_SERIE")    , 1, tamSx3("F1_SERIE")[1]        , tamSx3("F1_SERIE")[2]        , .T. , , .F.,, "xC7XSERIE"    ,, .F., .T.,                                    , "xC7XSERIE"    })
oDespesBrw:addColumn({"Espécie"                , {||aDespes[oDespesBrw:nAt,08]}, "C", pesqPict("SF1","F1_ESPECIE")    , 1, tamSx3("F1_ESPECIE")[1]    , tamSx3("F1_ESPECIE")[2]    , .T. , , .F.,, "xC7XESPECI",, .F., .T.,                                    , "xC7XESPECI"    })
oDespesBrw:addColumn({"Operação"            , {||aDespes[oDespesBrw:nAt,09]}, "C", pesqPict("SD1","D1_OPER")    , 1, tamSx3("D1_OPER")[1]        , tamSx3("D1_OPER")[2]        , .T. , , .F.,, "xC7XOPER"    ,, .F., .T.,                                    , "xC7XOPER"    })
oDespesBrw:addColumn({"Emissão"                , {||aDespes[oDespesBrw:nAt,10]}, "D", pesqPict("SE2","E2_EMISSAO")    , 1, tamSx3("E2_EMISSAO")[1]    , tamSx3("E2_EMISSAO")[2]    , .T. , , .F.,, "xEETDESADI",, .F., .T.,                                     , "xEETDESADI"    })
oDespesBrw:addColumn({"Valor Documento"        , {||aDespes[oDespesBrw:nAt,11]}, "N", pesqPict("SE2","E2_VALOR")    , 2, tamSx3("E2_VALOR")[1]        , tamSx3("E2_VALOR")[2]        , .T. , , .F.,, "xEETVALORR",, .F., .T.,                                    , "xEETVALORR"    })
oDespesBrw:addColumn({"Adiantamento"        , {||aDespes[oDespesBrw:nAt,12]}, "C", pesqPict("EET","EET_BASEAD")    , 1, tamSx3("EET_BASEAD")[1]    , tamSx3("EET_BASEAD")[2]    , .T. , , .F.,, "xEETBASEAD",, .F., .T., { "S=Sim","N=Não" }                , "xEETBASEAD"    })
oDespesBrw:addColumn({"Moeda"                , {||aDespes[oDespesBrw:nAt,13]}, "C", pesqPict("EET","EET_ZMOED")    , 1, tamSx3("EET_ZMOED")[1]        , tamSx3("EET_ZMOED")[2]    , .T. , , .F.,, "xEETZMOED"    ,, .F., .T., { "1=R$","2=US$","3=EUR","4=GBP" }    , "xEETZMOED"    })
oDespesBrw:addColumn({"Taxa Neg."            , {||aDespes[oDespesBrw:nAt,14]}, "N", pesqPict("EET","EET_ZTX")    , 2, tamSx3("EET_ZTX")[1]        , tamSx3("EET_ZTX")[2]        , .T. , , .F.,, "xEETZTX"    ,, .F., .T.,                                    , "xEETZTX"        })
oDespesBrw:addColumn({"Valor Moeda"            , {||aDespes[oDespesBrw:nAt,15]}, "N", pesqPict("EET","EET_ZVLMOE")    , 2, tamSx3("EET_ZVLMOE")[1]    , tamSx3("EET_ZVLMOE")[2]    , .T. , , .F.,, "xEETZVLMOE",, .F., .T.,                                    , "xEETZVLMOE"    })
oDespesBrw:addColumn({"Observação"            , {||aDespes[oDespesBrw:nAt,16]}, "C", pesqPict("EET","EET_ZOBS")    , 1, tamSx3("EET_ZOBS")[1]        , tamSx3("EET_ZOBS")[2]        , .T. , , .F.,, "xEETZOBS"    ,, .F., .T.,                                    , "xEETZOBS"    })
oDespesBrw:addColumn({"Pago Por"            , {||aDespes[oDespesBrw:nAt,17]}, "C", pesqPict("EET","EET_PAGOPO")    , 1, tamSx3("EET_PAGOPO")[1]    , tamSx3("EET_PAGOPO")[2]    , .T. , , .F.,, "xEETPAGOPO",, .F., .T., {    "1=Despachante","2=Exportador" }, "xEETPAGOPO"    })
oDespesBrw:addColumn({"Recebido Por"        , {||aDespes[oDespesBrw:nAt,18]}, "C", pesqPict("EET","EET_RECEBE")    , 1, tamSx3("EET_RECEBE")[1]    , tamSx3("EET_RECEBE")[2]    , .T. , , .F.,, "xEETRECEBE",, .F., .T.,                                    , "xEETRECEBE"    })
oDespesBrw:addColumn({"Ref. Rec."            , {||aDespes[oDespesBrw:nAt,19]}, "C", pesqPict("EET","EET_REFREC")    , 1, tamSx3("EET_REFREC")[1]    , tamSx3("EET_REFREC")[2]    , .T. , , .F.,, "xEETREFREC",, .F., .T.,                                    , "xEETREFREC"    })
oDespesBrw:addColumn({"Evento"                , {||aDespes[oDespesBrw:nAt,20]}, "C", pesqPict("EET","EET_EVENT")    , 1, tamSx3("EET_EVENT")[1]        , tamSx3("EET_EVENT")[2]    , .T. , , .F.,, "xEETEVENT"    ,, .F., .T.,                                    , "xEETEVENT"    })
oDespesBrw:addColumn({"Data Desemb."        , {||aDespes[oDespesBrw:nAt,21]}, "D", pesqPict("EET","EET_DTDEMB")    , 1, tamSx3("EET_DTDEMB")[1]    , tamSx3("EET_DTDEMB")[2]    , .T. , , .F.,, "xEETDTDEMB",, .F., .T.,                                    , "xEETDTDEMB"    })
oDespesBrw:addColumn({"Vencimento"            , {||aDespes[oDespesBrw:nAt,22]}, "D", pesqPict("EET","EET_DTVENC")    , 1, tamSx3("EET_DTVENC")[1]    , tamSx3("EET_DTVENC")[2]    , .T. , , .F.,, "xEETDTVENC",, .F., .T.,                                    , "xEETDTVENC"    })
oDespesBrw:addColumn({"Natureza"            , {||aDespes[oDespesBrw:nAt,23]}, "C", pesqPict("EET","EET_NATURE")    , 1, tamSx3("EET_NATURE")[1]    , tamSx3("EET_NATURE")[2]    , .T. , , .F.,, "xEETNATURE",, .F., .T.,                                    , "xEETNATURE"    })
oDespesBrw:addColumn({"Prefixo"                , {||aDespes[oDespesBrw:nAt,24]}, "C", pesqPict("EET","EET_PREFIX")    , 1, tamSx3("EET_PREFIX")[1]    , tamSx3("EET_PREFIX")[2]    , .T. , , .F.,, "xEETPREFIX",, .F., .T.,                                    , "xEETPREFIX"    })
oDespesBrw:addColumn({"Centro Custo"        , {||aDespes[oDespesBrw:nAt,25]}, "C", pesqPict("EET","EET_ZCCUST")    , 1, tamSx3("EET_ZCCUST")[1]    , tamSx3("EET_ZCCUST")[2]    , .F. , , .F.,, "xEETZCCUST",, .F., .T.,                                    , "xEETZCCUST"    })
oDespesBrw:addColumn({"Item Ctb.Deb"        , {||aDespes[oDespesBrw:nAt,26]}, "C", pesqPict("EET","EET_ZITEMD")    , 1, tamSx3("EET_ZITEMD")[1]    , tamSx3("EET_ZITEMD")[2]    , .F. , , .F.,, "xEETZITEMD",, .F., .T.,                                    , "xEETZITEMD"    })
oDespesBrw:addColumn({"NF FORNEC"            , {||aDespes[oDespesBrw:nAt,27]}, "C", pesqPict("EET","EET_ZNFORN")    , 1, tamSx3("EET_ZNFORN")[1]    , tamSx3("EET_ZNFORN")[2]    , .T. , , .F.,, "xEETZNFORN",, .F., .T.,                                    , "xEETZNFORN"    })

oDespesBrw:setEditCell( .T. , { || vldDoc() } )

oDespesBrw:setInsert( .T. )
oDespesBrw:setLineOk( { || chkLineOk() } )

oDespesBrw:aColumns[1]:XF3 := 'SYB'

oDespesBrw:setAfterAddLine( { || posIncLine() } )

oDespesBrw:activate( .T. )

//----------------------------------------------------------------
// Executa apos a inclusao de uma nova linha
// Inicializa o array com os tamanhos para liberar digitacao
//----------------------------------------------------------------
static function posIncLine()
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDESPES"    ):nOrder ] := space( tamSx3( "ZEE_CODDES" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEEDESPES"    ):nOrder ] := space( tamSx3( "YB_DESCR" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEECODIGO"    ):nOrder ] := space( tamSx3( "ZEE_CODIGO" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xZEEMOEDA"    ):nOrder ] := space( tamSx3( "ZEE_MOEDA" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xValPreCal"    ):nOrder ] := 0
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDOCTO"    ):nOrder ] := space( tamSx3( "E2_NUM" )[1]         )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xC7XSERIE"    ):nOrder ] := space( tamSx3( "F1_SERIE" )[1]         )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xC7XESPECI"    ):nOrder ] := space( tamSx3( "F1_ESPECIE" )[1]     )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xC7XOPER"        ):nOrder ] := space( tamSx3( "D1_OPER" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDESADI"    ):nOrder ] := cToD("//")
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETVALORR"    ):nOrder ] := 0
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETBASEAD"    ):nOrder ] := space( tamSx3( "EET_BASEAD" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZMOED"    ):nOrder ] := space( tamSx3( "EET_ZMOED" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZTX"        ):nOrder ] := 0
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZVLMOE"    ):nOrder ] := 0
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZOBS"        ):nOrder ] := space( tamSx3( "EET_ZOBS" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETPAGOPO"    ):nOrder ] := space( tamSx3( "EET_PAGOPO" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETRECEBE"    ):nOrder ] := space( tamSx3( "EET_RECEBE" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETREFREC"    ):nOrder ] := space( tamSx3( "EET_REFREC" )[1]     )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETEVENT"    ):nOrder ] := space( tamSx3( "YB_EVENT" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDTDEMB"    ):nOrder ] := cToD("//")
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETDTVENC"    ):nOrder ] := cToD("//")
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETNATURE"    ):nOrder ] := space( tamSx3( "YB_NATURE" )[1]        )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETPREFIX"    ):nOrder ] := space( tamSx3( "EET_PREFIX" )[1]     )
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZCCUST"    ):nOrder ] := "2404"
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZITEMD"    ):nOrder ] := "12"
    aDespes[ oDespesBrw:at() , oDespesBrw:GetColByID("xEETZNFORN"    ):nOrder ] := space( tamSx3( "EET_ZNFORN" )[1]        )
return