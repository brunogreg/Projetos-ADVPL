//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MT410TOK
Ponto de Entrada na validação ao clicar no botão Confirmar
@type  Function
@author Atilio
@since 03/08/2023
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784353
/*/

User Function MT410TOK()
    Local aArea      := FWGetArea()
    Local lContinua  := .T.
    Local cVendedor  := ""
    Local cTipoPed   := ""

    //Pega o campo de vendedor e de tipo de pedido
    cVendedor := M->C5_VEND1
    cTipoPed  := M->C5_TIPO

    //Se for um pedido normal (tipo N) e o não tiver vendedor preenchido
    If cTipoPed == "N" .And. Empty(cVendedor)
        ExibeHelp("Help_MT410TOK", "Para pedido do tipo Normal (N), é obrigatório preencher o campo de código do vendedor!", "Preencha a informação no campo C5_VEND1")
        lContinua := .F.
    EndIf

    FWRestArea(aArea)
Return lContinua
