//Bibliotecas
#include "Protheus.ch"
#include "Totvs.ch"

/*/{Protheus.doc} 
MA410MNU
@type    Function
@author  Bruno Gregorio
@since   12/03/2026
@description Adiciona um botao para em outra acoes que informa a data e a hora atual
/*/
User Function MA410MNU()

    //Declaração de variáveis
    Local aArea := FWGetArea()
    
    //Adiciona na variavel do Menu
    aAdd(aRotina, {"* Data e Hora Atual", "u_zPeMnu()", 0, 2, 0, Nil})  //2 visualizar 

    //Finalizacao
    RestArea(aArea)
Return Nil

User Function zPeMnu()

    Local aArea := FWGetArea()
    Local cMensagem := " "

    //Monta a mensagem e exibe para o usuario
    cMensagem := "Voce esta posicionado no pedido [" +SC5->C5_NUM + "]" + CRLF
    cMensagem += " " + CRLF
    cMensagem += "hoje sao: [" +dToC(Date()) + "]" + CRLF
    cMensagem += "e agora sao: [" + Time() + "]" + CRLF
    ShowLog(cMensagem)
   
    RestArea(aArea)
Return Nil
