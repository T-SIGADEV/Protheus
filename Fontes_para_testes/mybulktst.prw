User Function myBulk()
 
    Local oBulk as object
    Local aStruct as array
    Local nX as numeric
    Local lCanUseBulk as logical
 
    aStruct := {}
 
    aAdd( aStruct, { 'FIELD1', 'C', 10, 0 } )
    aAdd( aStruct, { 'FIELD2', 'N', 10, 2 } )
    aAdd( aStruct, { 'FIELD3', 'M', 10, 0 } )
    aAdd( aStruct, { 'FIELD4', 'D', 8, 0 } )
    aAdd( aStruct, { 'FIELD5', 'L', 1, 0 } )
 
    FWDBCreate( 'BULKTBL', aStruct , 'TOPCONN' , .T.)
 
    oBulk := FwBulk():New('BULKTBL')
    lCanUseBulk := FwBulk():CanBulk() // Este método não depende da classe FWBulk ser inicializada por NEW
    if lCanUseBulk
        oBulk:SetFields(aStruct)
    endif
 
    For nX := 1 to 5
        if lCanUseBulk     
            oBulk:AddData({cValToChar(nX),(nX,nX),cValToChar(nX),Date(),mod(nX,2)==0})
        else
            RecLock("BULKTBL",.T.)
                BULKTBL->FIELD1     := cValToChar(nX)
                BULKTBL->FIELD2      := (nX,nX)
                BULKTBL->FIELD3      := cValToChar(nX)
                BULKTBL->FIELD4      := Date()
                BULKTBL->FIELD5      := mod(nX,2)==0
            MsUnLock()
        endif      
    Next
    if lCanUseBulk
        oBulk:Close()
        oBulk:Destroy()
        oBulk := nil
    endif
Return