#Include "protheus.ch"
#Include "tbiconn.ch"// Para poder usar o prepare
#Include "tbicode.ch"// Para poder usar o prepare

User Function PARAMETRO()

	Local dParam 

	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"
	
	dParam := GetMV("MV_ULMES") // Carrega o parâmetro MV_ULMES

	//GetMV(MV_ULMES") -pega um parametro que exista
	//GetNewPar(MV_ULMES,"teste",xFilial("sc5")) - considera que o parametro pode nao existir por isso devemos passar o nome do parametro, o que ele vai exibir se nao encontrar e em qual filial ele deve conferir.
	//SuperGetMV(MV_ULMES,.t.,"teste",xFilial("sc5")) diferente do getnewpar ele exibe um help (.t./.f.)
	
	dParam := dParam + 90 // Soma 90 dias

	// Grava o novo conteúdo no parâmetro
	PutMV("MV_ULMES", dParam)

	// Exibe o valor atualizado
	MsgInfo("Novo valor do MV_ULMES: " + Dtoc(dParam))

	// Simula fechamento do Protheus
	RESET ENVIRONMENT

Return
