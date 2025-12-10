#INCLUDE "Protheus.ch"
//BLOCOS DE CODIGOS
User Function Blocos()
	local nItem := 450
	local nResultado := 0
	Local bBloco1 := { |H| E:=15,Z:=30, R:= (E * Z) - H, R } 
    
    //E * Z = 15 * 30 = 450
    //R = 450 – 450 = 0

	nResultado := Eval(bBloco1, nItem)

	// Exibe o resultado para conferência
	Alert("Resultado: " + cValToChar(nResultado))

Return
