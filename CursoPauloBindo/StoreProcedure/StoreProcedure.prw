#Include"Protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

User Function StoreProc()
	Local aRet := {}
	Local i := 0

	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"
//VERIFICA SE A PROCEDURE EXISTE
	If TCSPExist("VERIFICA_CLIENTE")

		//Executa a Stored Procedure Teste
		aRet := TCSPExec("VERIFICA_CLIENTE","TESTE")

		if aRet <> nil

			For i:= 1 to Len(aRet)
				//Mostra os valores de retorno
				aRet[i]
			Next

		Else
			MsgStop("Mensagem: "+TCSQLError(),"Erro executando Stored Procedure")
		Endif

	else
		MsgAlert("Store Procedure VERIFICA_CLIENTE não econtrada","Operação inválida")
	EndIf
	RESET ENVIRONMENT
Return
