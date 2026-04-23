//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function zOO04
Função de exemplo, demonstrando a instância de uma TDialog
@type  Function
@author Atilio
@since 03/05/2022
/*/

User Function zOO04()
    Local oDlgAux
    Local nJanAltu   := 200
    Local nJanLarg   := 400
    Local lDimPixels := .T.
    Local lCentraliz := .T.
    Local bBlocoIni  := {||}
    Local cJanTitulo := "Tela usando TDialog"

    //Cria a dialog
    oDlgAux := TDialog():New(0, 0, nJanAltu, nJanLarg, cJanTitulo, , , , , , /*nCorFundo*/, , , lDimPixels)

    //Ativa e exibe a janela
    oDlgAux:Activate(, , , lCentraliz, , , bBlocoIni)
Return
