//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MA035BUT
Função para adicionar botões no Outras Ações do Grupo de Produtos
@type  Function
@author Atilio
@since 20/06/2023
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6087601
/*/

User Function MA035BUT()
    Local aArea    := FWGetArea()
    Local aBotoes  := {}

    //Adiciona botões no Outras Ações
    aAdd(aBotoes, {'BITMAP', {|| fBotao() }, "* Botão Customizado"})

    FWRestArea(aArea)
Return aBotoes

Static Function fBotao()
    Local aArea    := FWGetArea() //Obtém a área atual para depois restaurar
    Local aAreaSBM := SBM->(FWGetArea())  //Obtém a área do SBM para depois restaurar

    Alert("oi")

    //Pula um registro qualquer
    DbSkip()

    //Posiciona no último registro
    SBM->(DbGoBottom())

    FWRestArea(aAreaSBM) //Restaura a área do SBM para evitar que o usuário fique "preso" nela  
    FWRestArea(aArea) //Restaura a área original para evitar que o usuário fique "preso" nela
Return
