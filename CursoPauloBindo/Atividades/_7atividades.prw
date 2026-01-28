#INCLUDE "Protheus.ch"
//CHAMANDO FUNCOES
User Function Diretiva()

	Local nValor1 := 10
	Local nValor2 := 20
	Local nResultado :=0

	nResultado := Recebe(@nValor1, nValor2) //chama a funçao recebe e ainda mantenm o valor dela usando o @

	ALERT(cValToChar(nResultado)) // Convert pra texto 

Return

Static Function Recebe(nValor1, nValor2) //recebendo parametros

	Local nRetorno := 0 
	nValor1 := 20 //alterado pra 20

    nRetorno := nValor1 * nValor2

Return(nRetorno)
