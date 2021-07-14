QG365Office()
Static Function QG365Office

PutMV("MV_RELAUTH",".T.")
PutMV("MV_RELTIME","120")
PutMV("MV_PORSMTP","587")
PutMV("MV_RHAUTEN",".F.")
PutMv("MV_RELSSL" ,".T.")
PutMv("MV_RELTLS" ,".T.")

PutMV("MV_WFPOP3" ,"outlook.office365.com")
PutMV("MV_WFSMTP" ,"smtp.office365.com:587")
PutMV("MV_RELSERV","smtp.office365.com:587")
PutMV("MV_RHSERV" ,"smtp.office365.com") // -->NAO COLOCAR :PORTA <--

PutMV("MV_WFACC"  ,"email@www.com.br")
PutMV("MV_WFMAIL" ,"email@www.com.br")
PutMV("MV_WFMAILT","email@www.com.br")
PutMV("MV_RELACNT","email@www.com.br")
PutMV("MV_RELFROM","email@www.com.br")
PutMV("MV_EMCONTA","email@www.com.br")
PutMv("MV_WFADMIN","email@www.com.br")
PutMv("MV_MAILADT","email@www.com.br")
PutMV("MV_RELAUSR","email@www.com.br")
PutMV("MV_RHCONTA","email@www.com.br")
PutMV("MV_CVMAIL" ,"email@www.com.br")

PutMV("MV_WFPASSW","@senha@123")
PutMV("MV_EMSENHA","@senha@123")
PutMV("MV_RELAPSW","@senha@123")
PutMV("MV_RELPSW" ,"@senha@123")
PutMV("MV_RHSENHA","@senha@123")

PutMV("MV_WFAUTSE","@senha@123")
PutMV("MV_WFAUTUS","email@www.com.br")
PutMV("MV_WFMLBOX","WFPERCOL")

Return
