//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MSDocVis
Ponto de entrada acionado na tela de Banco de Conhecimento
@type  Function
@author Atilio
@since 22/08/2023
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6087680
/*/

User Function MSDocVis()
    Local aArea     := FWGetArea()
    Local lContinua := .T.
    Local nPosRec   := Len(aHeader)
    Local bOrdem

    //Pergunta se o usuário quer ordenar
    If FWAlertYesNo("Deseja ordenar a grid, trazendo os mais recentes primeiro?", "Ordena?")

        //Monta o bloco de código e executa a ordenação
        bOrdem := {|x, y| x[nPosRec] > y[nPosRec]}
        aSort(aCols, , , bOrdem)
    EndIf

    FWRestArea(aArea)
Return lContinua
