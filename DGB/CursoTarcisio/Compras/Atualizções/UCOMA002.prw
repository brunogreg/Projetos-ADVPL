#include "TOTVS.ch"

User Function UCOMA002()

	Local cNumero    := "00001235"
	Local cPrefixo   := "TST"
	Local cParcela   := "01"
	Local cTipo      := "NF"
	Local cNatureza  := "001"
	Local cCliente   := "000000"
	Local cLoja      := "00"
	Local cNomCli    := "Gregorio LTDA"
	Local dEmissao   := CTod("28/01/2026")
	Local dVencto    := CTod("28/01/2026")
	Local dVencReal  := CTod("28/01/2026")
	Local nValor     := 1500.00	
	Local cHist      := "Pagamento com atraso"

	Local aVetSE1    := {}
	Local lMsErroAuto:= .F.

//Prepara o array para o execauto
	aVetSE1 := {}
	aAdd(aVetSE1, {"E1_FILIAL",  FWxFilial("SE1"),  Nil})
	aAdd(aVetSE1, {"E1_NUM",     cNumero,           Nil})
	aAdd(aVetSE1, {"E1_PREFIXO", cPrefixo,          Nil})
	aAdd(aVetSE1, {"E1_PARCELA", cParcela,          Nil})
	aAdd(aVetSE1, {"E1_TIPO",    cTipo,             Nil})
	aAdd(aVetSE1, {"E1_NATUREZ", cNatureza,         Nil})
	aAdd(aVetSE1, {"E1_CLIENTE", cCliente,          Nil})
	aAdd(aVetSE1, {"E1_LOJA",    cLoja,             Nil})
	aAdd(aVetSE1, {"E1_NOMCLI",  cNomCli,           Nil})
	aAdd(aVetSE1, {"E1_EMISSAO", dEmissao,          Nil})
	aAdd(aVetSE1, {"E1_VENCTO",  dVencto,           Nil})
	aAdd(aVetSE1, {"E1_VENCREA", dVencReal,         Nil})
	aAdd(aVetSE1, {"E1_VALOR",   nValor,            Nil})	
	aAdd(aVetSE1, {"E1_HIST",    cHist,             Nil})
	aAdd(aVetSE1, {"E1_MOEDA",   1,                 Nil})

	//Chama a rotina automática
	lMsErroAuto := .F.
	MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 3)

	//Se houve erro, mostra o erro ao usuário e desarma a transação
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
    Else
        MsgInfo("Título gerado com sucesso!","Atenção!")
	EndIf


Return(Nil)
