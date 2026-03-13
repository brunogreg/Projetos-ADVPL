//Bibliotecas
#include "Protheus.ch"
#include "Totvs.ch"

/*/{Protheus.doc} M410LIOK
@type    Function
@author  Bruno Gregorio
@since   12/03/2026
@description esse ponto de entrada é um validador de linhas ele so permite voce adicionar linhas no 
grid caso sua data de entrega seja menor que 30 dias
/*/
User Function M410LIOK()

    //Declaração de variáveis
    Local aArea := FWGetArea()
    Local lRet  := .T.
    Local nLinha := n 
    Local dDataEntre := sToD("")
    Local dDataHoje := Date()
    Local nDiferenca := 0

    //Lógica do fonte
    //Pega a data de entrega da linha atual e a diferença dos dias com a data de hoje
    dDataEntre := GDFieldGet("C6_ENTREG", nLinha)
    nDiferenca := DateDiffDay(dDataEntre, dDataHoje)

    //se a data de entrega estiver atrasada ou a diferença for maior que 30 dias, não permite proceguir
    If (dDataEntre < dDataHoje) .Or. (nDiferenca > 30)
        ExibeHelp("Data de Entrega [" + dToC(dDataEntre) + "] é inválida. Verifique se a data está correta ou se o pedido não está atrasado.")
        lRet := .F.
    EndIf
    //Finalização
    RestArea(aArea)
Return lRet
