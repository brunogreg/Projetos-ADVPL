//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function M410LIOK
Ponto de Entrada na validação da linha do pedido
@type  Function
@author Atilio
@since 03/08/2023
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784149
/*/

User Function M410LIOK()
    Local aArea      := FWGetArea()
    Local lContinua  := .T.
    Local nLinha     := n
    Local dDataEntre := sToD("")
    Local dDataHoje  := Date()
    Local nDiferenca := 0

    //Pega a data de entrega da linha atual e a diferença dos dias com a data de hoje
    dDataEntre := GDFieldGet("C6_ENTREG", nLinha)
    nDiferenca := DateDiffDay(dDataEntre, dDataHoje)

    //Se a data de entrega estiver atrasada ou a diferença for maior que 30 dias, não permite prosseguir
    If dDataHoje > dDataEntre .Or. nDiferenca > 30
        ExibeHelp("Help_M410LIOK", "A data de entrega [" + dToC(dDataEntre) + "] esta atrasada ou esta mais que 30 dias da data de hoje", "Corrija a informação no campo C6_ENTREG na linha [" + cValToChar(nLinha) + "]")
        lContinua := .F.
    EndIf

    FWRestArea(aArea)
Return lContinua
