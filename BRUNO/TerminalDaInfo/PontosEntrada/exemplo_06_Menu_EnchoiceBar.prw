//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function A410CONS
Ponto de Entrada para adicionar botões no Outras Ações dentro do Pedido de Venda
@type  Function
@author Atilio
@since 03/08/2023
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784033
/*/

User Function A410CONS()
    Local aArea   := FWGetArea()
    Local aBotoes := {}

    aAdd(aBotoes, {'DBG07', {|| u_zPeEnch()}, "* Atualizar Data de Entrega","* Entrega"} )

    FWRestArea(aArea)
Return aBotoes


/*/{Protheus.doc} User Function zPeEnch
Função que percorre as informações da grid e vem atualizando a data de entrega
@type  Function
@author Atilio
@since 03/08/2023
/*/

User Function zPeEnch()
    Local aArea      := FWGetArea()
    Local nLinha     := 1
    Local nPosDatEnt := GDFieldPos("C6_ENTREG")
    Local cMensagem  := ""

    //Se a pergunta for confirmada
    If FWAlertYesNo("Confirma a alteração da Data de Entrega para Hoje (coluna " + cValToChar(nPosDatEnt) + ")?", "Continua")
        //Percorre as linhas digitadas na grida
        For nLinha := 1 To Len(aCols)

            //Se a linha atual não estiver apagada
            If ! GDDeleted(nLinha)
                //A operação abaixo de buscar com GDFieldGet, é o mesmo que: aCols[nLinha][nPosDatEnt]
                cMensagem += "Era " + dToC( GDFieldGet("C6_ENTREG", nLinha) ) + CRLF

                //A operação abaixo de atualizar com GDFieldPut, é o mesmo que: aCols[nLinha][nPosDatEnt] := Date()
                GDFieldPut("C6_ENTREG", Date(), nLinha)
            EndIf
        Next

        //Se tiver mensagem, exibe em tela
        If ! Empty(cMensagem)
            ShowLog(cMensagem)
        EndIf

        //Atualiza a tela
        GetDRefresh()
    EndIf

    FWRestArea(aArea)
Return
