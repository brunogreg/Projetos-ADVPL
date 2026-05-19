//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MA410MNU
Ponto de Entrada para adicionar Outras Ações na tela do Pedido de Venda
@type  Function
@author Atilio
@since 03/08/2023
@see https://tdn.totvs.com/display/public/PROT/MA410MNU
/*/

User Function MA410MNU() //ponto de entrada
    Local aArea := GetArea()

    //Adiciona na variável do Menu
	aAdd(aRotina, {"* Data e Hora Atual", "u_zPeMnu()", 0, 2, 0, Nil}) //opação 2 é igual a visualizar  
	
	RestArea(aArea)
Return

/*/{Protheus.doc} User Function zPeMnu
Função de teste adicionada no outras ações do browse do pedido
@type  Function
@author Atilio
@since 03/08/2023
/*/

User Function zPeMnu()
    Local aArea     := FWGetArea()
    Local cMensagem := ""

    //Monta a mensagem e exibe
    cMensagem := "Você está posicionado no pedido [" + SC5->C5_NUM + "]" + CRLF
    cMensagem += "" + CRLF
    cMensagem += "Hoje é:         [" + dToC(Date()) + "]" + CRLF
    cMensagem += "A hora atual é: [" + Time() + "]" + CRLF
    ShowLog(cMensagem)

    FWRestArea(aArea)
Return
