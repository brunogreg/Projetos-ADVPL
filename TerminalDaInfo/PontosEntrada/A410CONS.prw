//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function A410CONS
Ponto de Entrada para adicionar botões no Outras Ações dentro do Pedido de Venda
@type    Function
@author  Bruno Gregorio
@since   13/03/2026
@see     https://tdn.totvs.com/pages/releaseview.action?pageId=6784033
/*/
User Function A410CONS()

    Local aArea   := FWGetArea()
    Local aBotoes := {}

    // Adiciona botão "Entrega" no menu Outras Ações
    // Estrutura: {ID do botão, {|| função chamada}, "* Texto longo", "* Texto curto"}
    aAdd(aBotoes, {'DBG07', {|| u_zPeEnch()}, "* Atualizar Data de Entrega", "* Entrega"})

    FWRestArea(aArea)

Return aBotoes

/*/{Protheus.doc} User Function zPeEnch
Atualiza a Data de Entrega dos itens do Pedido de Venda para a data de hoje
@type    Function
@author  Bruno Gregorio
@since   13/03/2026
/*/
User Function zPeEnch()

    Local aArea       := FWGetArea()
    Local nLinha      := 1
    Local nPosDatEnt  := GDFieldPos("C6_ENTREG")  // Posição da coluna C6_ENTREG na grid
    Local cMensagem   := ""

    // Se a pergunta for confirmada pelo usuário
    If FWAlertYesNo("Confirma a alteração da Data de Entrega para Hoje (coluna " + cValToChar(nPosDatEnt) + ")?", "Continua")

        // Percorre todas as linhas digitadas na grid
        For nLinha := 1 To Len(aCols)

            // Se a linha atual não estiver apagada
            If ! GDDeleted(nLinha)

                // Guarda o valor antigo pra exibir na mensagem
                // GDFieldGet é o mesmo que: aCols[nLinha][nPosDatEnt]
                cMensagem += "Era " + dToC(GDFieldGet("C6_ENTREG", nLinha)) + CRLF

                // Atualiza o campo com a data de hoje
                // GDFieldPut é o mesmo que: aCols[nLinha][nPosDatEnt] := Date()
                GDFieldPut("C6_ENTREG", Date(), nLinha)

            EndIf

        Next

        // Se tiver mensagem com valores antigos, exibe em tela
        If ! Empty(cMensagem)
            ShowLog(cMensagem)
        EndIf

        // Atualiza a tela da grid
        GetDRefresh()

    EndIf

    FWRestArea(aArea)

Return
