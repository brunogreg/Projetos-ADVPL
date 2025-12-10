#Include "protheus.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

User Function MANIPULACAO()

	// Emulação de abertura do ambiente Protheus
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"
	
	// INCLUSÃO NA TABELA SZ1
	
	DbSelectArea("SZ1")
	//SZ1->(DbAppend())
	RecLock("SZ1", .T.)
	SZ1->Z1_FILIAL := FWFilial()  // filial corrente
	SZ1->Z1_CLIENT := "000001"
	SZ1->Z1_LOJA   := "01"
	SZ1->Z1_PRODUT := "000001"
	SZ1->Z1_UM     := "PC"
	SZ1->Z1_UMCLI  := "CX"
	SZ1->Z1_TIPO   := "M"
	SZ1->Z1_FATOR  := 1

	//SZ1->(DbCommit())
	MsUnlock()
	
	// BUSCA NA TABELA SA1 (Cliente)
	
	DbSelectArea("SA1")	
	DbSetOrder(1) // Normalmente A1_FILIAL + A1_COD + A1_LOJA
	If SA1->(DbSeek(FWFilial() + "000001" + "01")) // FWfilial -Ele garante que sua aplicação use a filial que o usuário realmente está trabalhando, e não a filial da tabela.
		MsgInfo("Nome do Cliente: " + SA1->A1_NOME)
	Else
		MsgInfo("Cliente não encontrado.")
	EndIf
	
	// BUSCA NA TABELA SB1 (Produto)
	
	DbSelectArea("SB1")
	DbSetOrder(1) // Normalmente B1_FILIAL + B1_COD
	If SB1->(DbSeek(FWFilial() + "000001"))
		MsgInfo("Nome do Produto: " + SB1->B1_DESC)
	Else
		MsgInfo("Produto não encontrado.")
	EndIf
	
	// FECHAMENTO DO AMBIENTE
	
	RESET ENVIRONMENT
Return
