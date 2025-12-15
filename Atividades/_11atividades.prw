#INCLUDE "protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
User Function TRANSACAO()
	Local cCliente := "000001"
	Local cLoja  := "01"
	Local cProdut := "000001"

	If SELECT("SX6") > 0
        Alert("PROTHEUS ABERTO")
    Else
        RpcSetType(3)
        PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"
    EndIf

	dBselectArea("SZ1")
    ////bloco de transação, comando usado em cenários TopConnect/SQL (Oracle, SQL Server etc.)
    //está mais ligado à transação do banco SQL.
	
	Begin Transaction 
		RecLock("SZ1",.T.)
		Z1_FILIAL := xFilial()
		Z1_CLIENT := cCliente
		Z1_LOJA   := cLoja
		Z1_PRODUT := cProdut
		Z1_UM     := "PC"
		Z1_UMCLI  := "CX"
		Z1_TIPO   := "M"
		Z1_FATOR  := 1
		MsUnlock()
	End Transaction

    //função por isso o escopo e assim do framework Protheus,
	//controlam transação no contexto do SX8 / banco ISAM/Top/CTree,
	//normalmente usadas em conjunto com RollBackSX8().

	BeginTran() 
	RecLock("SZ1",.T.)
	Z1_FILIAL := xFilial()
	Z1_CLIENT := cCliente
	Z1_LOJA   := cLoja
	Z1_PRODUT := cProdut
	Z1_UM     := "PC"
	Z1_UMCLI  := "CX"
	Z1_TIPO   := "M"
	Z1_FATOR  := 1
	MsUnlock()

	DisarmTransaction()
	EndTran() 
    MsUnlockAll()

	RESET ENVIRONMENT


Return
