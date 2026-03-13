//Bibliotecas
#include "Protheus.ch"
#include "Totvs.ch"

/*/{Protheus.doc} 
MT410ACE
@type    Function
@author  Bruno Gregório
@since   12/03/2026
@description Pegunta se o usuário deseja continuar manipulando pedidos antes das 9h da manhã, caso seja um usuário administrador ele tem a opção de continuar ou não, caso contrário não poderá prosseguir.
/*/
User Function MT410ACE()

	//Declaração de variáveis
	Local aArea := FWGetArea()
	Local lContinua := .T.
	Local nOpcao := PARAMIXB[1]

	//se for antes das 8h30 não permitir prosseguir
	If Time() <= "08:30:00"
		lContinua := .F.

		if ! IsBlind() .And. FWIsAdmin()
			lContinua := FWAlertYesNo(;
				"Pedidos não podem ser manipulados antes das 8h30, " + ;
				"mas você como Administrador, deseja continuar?", ;
				"Continua (Opção " + cValToChar(nOpcao) + ")?" ;
				)
		EndIf
	EndIf
	//Finalização
	FWRestArea(aArea)
Return lContinua
