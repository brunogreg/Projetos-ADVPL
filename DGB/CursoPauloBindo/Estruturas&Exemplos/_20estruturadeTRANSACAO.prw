#Include "protheus.ch"
#Include "tbiconn.ch"
#Include "tbicode.ch"
#Include "TOTVS.ch"

User Function Transacao()
	Local cCliente := "000001"
	Local cLoja := "001"
	Local cProdut := "000001"

	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"

	dbSelectArea("SZ1")

	If ! dbUseArea(.T., , "SZ1", "SZ1", .T., .T.)
		ConOut("ERRO: tabela SZ1 não foi aberta!")
	EndIf

	Begin Transaction

		RecLock("SZ1", .T.)
		Z1_FILIAL := xFilial()
		Z1_CLIENT := cCliente
		Z1_LOJA   := cLoja
		Z1_PRODUT := cProdut
		Z1_UM     := "PC"
		Z1_UMCLI  := "CX"
		Z1_TIPO   := "M"
		Z1_FATOR  := 10
		MsUnlock()

	End Transaction


/*	BeginTran()
	RecLock("SZ1", .T.)
	Z1_FILIAL := xFilial()
	Z1_CLIENT := "000001"
	Z1_LOJA   := "01"
	Z1_PRODUT := "000001"
	Z1_UM     := "PC"
	Z1_UMCLI  := "CX"
	Z1_TIPO   := "M"
	Z1_FATOR  := 10
	MsUnlock()

	DisarmTransaction()
	EndTran()
	MsUnlockaLL()
*/
	RESET ENVIRONMENT

Return
