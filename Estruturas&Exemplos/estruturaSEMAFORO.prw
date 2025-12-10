#Include "Protheus.ch"

User Function AjustaTitulos()
    Local lLocked := .F.

    // 1. Tentativa de travar a tabela SE2
    lLocked := LockByName("SE2")

    If !lLocked
        FWAlert("Não foi possível bloquear a tabela SE2. Outro processo está usando.")
        Return .F.
    EndIf

    Begin Sequence
        
        FWAlert("Tabela SE2 bloqueada. Iniciando processamento...")

        dbSelectArea("SE2")
        SE2->(dbSetOrder(1))
        SE2->(dbGoTop())

        While !SE2->(EoF())

            // Travar o registro antes de alterar
            RecLock("SE2", .F.)

            SE2->E2_VALOR += 10  // Exemplo de ajuste
            SE2->(MsUnlock())    // Libera o registro

            SE2->(dbSkip())
        EndDo

        FWAlert("Processamento concluído com sucesso.")

    Recover

        FWAlert("Erro durante o processamento. A tabela será liberada.")
        
    End Sequence

    // 2. Sempre liberar a tabela
    UnLockByName("SE2")

Return .T.
