#include "protheus.ch"
#include "vkey.ch"
#include "Rwmake.ch"
#include "msmgadd.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE ENTER Chr(13)+Chr(10)
User Function softl1()
	Local xx := 0

	// CONFERENCIA E ABRIR PROTHEUS
	
	If SELECT("SX6") >0 //verifica se sx6 está aberto
		ALERT("PROTHEUS ABERTO") 
	Else
		RpcSetType(3) 
		PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" // Emulando a abertura do Protheus
	EndIf

	dbSelectArea("SA1") //Abrindo a tabela sa1
	dbSetOrder(1) // No indice 1

	BEGINTRAN() //A partir do momento em que você executa BEGINTRAN(), todas as operações de gravacao, ficam pendentes até que você finalize a transação com ENDTRAN()

	For xx:= 1 To 10 //10 cadastros

		cNumero := Getsxenum()

			RecLock("SA1", .T.) // Trava a tabela para fazer alteracoes
			A1_FILIAL	:= xFilial()
			A1_COD		:= cNumero
			A1_LOJA		:= "01"
			A1_NOME		:= "TESTE DE NUMERACAO "+cValToChar(xx) //converter para 1,2,3
			A1_PESSOA	:= "F"
			A1_NREDUZ	:= "TESTE"+cValToChar(xx)
			A1_END		:= "RUA TESTE"
			A1_BAIRRO	:= "TESTE"
			A1_TIPO		:= "F"
			A1_EST		:= "SP"
			A1_COD_MUN 	:= "00105"
			A1_MUN		:= "ADAMANTINA"
			A1_NATUREZ	:= "1.00001"
			MsUnlock() // Destrava a tabela apos ter feito meus ajustes

			If cNumero == "000010"
				RollBackSx8() // Desfaz as acoes feitas
				DisarmTransaction() //É usado geralmente quando você quer evitar que uma transação ainda ativa cause rollback automático devido a erros posteriores
			else
				Confirmsx8() //confirma meus ajustes	
			EndIf

	Next

	ENDTRAN() // finaliza o bloco transacional BEGINTRAN()
	MsUnlockAll() // Destrava tudo

	RESET ENVIRONMENT // encerra a ação

Return



