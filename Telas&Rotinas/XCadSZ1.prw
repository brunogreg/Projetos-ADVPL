#INCLUDE "Protheus.ch" 
#INCLUDE "TOTVS.ch"

// Cadastro com AxCadastro - SZ1
User Function XCadSZ1()
	Local cAlias  := "SZ1"
	Local cTitulo := "TELA TESTE CADASTRO SIMPLES - SZ1"
	Local cVldExc := ".T." //"U_VldExc"  // Função de validação de exclusão
	Local cVldAlt := ".T." //VldAlt()  // Função de validação de alteração

	// Seleciona a área e ordena
	dbSelectArea(cAlias)
	dbSetOrder(1)

	// Chamada do framework padrão de cadastro
	AxCadastro(cAlias, cTitulo, cVldExc, cVldAlt)

Return Nil

// Função de Validação de Alteração
sTATIC Function VldAlt()
	Local lRet    := .T.
	Local aArea   := GetArea()
	Local nOpcao  := 0

	MsgStop( RetCodUsr(), "Atenção")


	// Verifica se o usuário não é o admin ou se é uma inclusão
	If alltrim(RetCodUsr()) <> "000000" //.Or. __cAccType == "I"
		lRet := '.T.' //AxAltera(cAlias, nReg, nOpc)
	Else
		MsgStop("Usuário não autorizado para alterar!", "Atenção")
		lRet :='.F.'
	EndIf

	If nOpcao == 1
		MsgInfo("Alteração concluída com sucesso!", "Sucesso")
	EndIf

	RestArea(aArea)
Return lRet

// Função de Validação de Exclusão
User Function VldExc(cAlias, nReg, nOpc)
	Local lRet    := .T.
	Local aArea   := GetArea()
	Local nOpcao  := 0

	nOpcao := AxExclui(cAlias, nReg, nOpc)

	If nOpcao == 1
		MsgInfo("Exclusão concluída com sucesso!", "Sucesso")
	EndIf

	RestArea(aArea)
Return lRet
