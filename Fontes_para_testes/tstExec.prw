

#include 'protheus.ch'

User Function tstExec(cStr, nX)
    Conout("Exec["+cValToChar(nX)+"] Rotina["+cStr+"]")
    Sleep(1000)
Return

User Function tstFWIPCWait()

    Local oIPC      := Nil
    Local nX        := 0
    Local cErro     :=''

    RpcSetType(3)
    RpcSetEnv("99","01")
    //--------------------------------------------
    //o nome do sem?foro do ipc. Este sem?foro ? ?nico por thread. Ou seja,
    //voc? n?o pode instanciar o ipcwait em looping (e nem faz muito sentido)
    //com o mesmo nome. O segundo par?metro parametro ? o tempo de
    // espera de cada thread de ipc. O Default ? 10000. ? o tempo que cada thread fiz em ex
    //esperando requisi??o.
    //--------------------------------------------
    oIPC := FWIPCWait():New("TSTFWIPCWAIT",3000)
    oIPC:SetThreads(1)
    //-----------------------------------------------------
    //diz para o Ipc que , em caso de erro em alguma thread ele deve continuar a processar
    //o default ? true (caso d? erro em alguma thread ele vai parar o processamento, e a partir deste momento
    //todos os Ipc:go n?o ir?o fazer mais nada). Setar como falso ? dizer que os processos que s?o enviados via
    //go s?o independentes, e um erro em um processo n?o inviabiliza o outro
    //------------------------------------------------------
    //oIpc:StopProcessOnError(.F.)
    oIPC:SetNoErrorStop(.T.)
    //------------------------------------------------------
    //? poss?vel n?o enviar este par?metros. Neste caso o ambiente n?o ser? aberto pelas threads de trabalho.
    //-----------------------------------------------------
    oIPC:SetEnvironment(cEmpAnt,cFilAnt)
    oIPC:Start("U_TSTEXEC")
    For nX := 1 To 2
        oIPC:Go("TSTVAI", nX)
    Next nX
    //---------------------------------------------------
    //n?o ? preciso ficar esperando nada para dar o stop. O pr?prio motor sabe se existe algo  em execu??o
    //e s? termina e volta para a rotina ap?s finalizar todas as execu??es.
    //--------------------------------------------------------------------

    oIPC:Stop()
    //---------------------------------------------------
    //captura o ?ltimo error.log gerado, caso exista
    //--------------------------------------------------
    cErro := oIpc:GetError()
    //-----------------------------------
    //o erro somente ? alimentado se o StopprocessOnError for true
    //-----------------------------------------------------
    Conout("Tem erro? "+cErro)
    oIPC := Nil

Return