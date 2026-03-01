#INCLUDE "PROTHEUS.CH"

User Function UCOMA004()

	Local oModel     := NIL
	Local oSA1Mod    := NIL
	Local aErro      := {}
	Local lDeuCerto  := .F.


	lDeuCerto := .F.

//Pegando o modelo de dados, setando a operação de inclusão
	oModel := FWLoadModel("UCOMA001") //Rotina Cadastro de Clientes
	oModel:SetOperation(3) //A1_FILIAL+A1_CGC
	oModel:Activate() //Ativa o modelo de dados

//Pegando o model dos campos da SA1
	oSA1Mod:= oModel:getModel("ZB1MASTER") //("CRMA980") //Rotina Cadastro de Clientes
	oSA1Mod:setValue("ZB1_FILIAL",       xFilial("ZB1")        ) // Codigo
	oSA1Mod:setValue("ZB1_DESCRI",      "Teste"       ) // Nome
	oSA1Mod:setValue("ZB1_PERIOD",    "1"   ) // Nome reduz.
	oSA1Mod:setValue("ZB1_SITUAC",       "1"   ) // Endereco

//Se conseguir validar as informações
	If oModel:VldData()

		//Tenta realizar o Commit
		If oModel:CommitData()
			lDeuCerto := .T.

			//Se não deu certo, altera a variável para false
		Else
			lDeuCerto := .F.
		EndIf

//Se não conseguir validar as informações, altera a variável para false
	Else
		lDeuCerto := .F.
	EndIf

//Se não deu certo a inclusão, mostra a mensagem de erro
	If ! lDeuCerto
		//Busca o Erro do Modelo de Dados
		aErro := oModel:GetErrorMessage()

		//Monta o Texto que será mostrado na tela
		AutoGrLog("Id do formulário de origem:"  + ' [' + AllToChar(aErro[01]) + ']')
		AutoGrLog("Id do campo de origem: "      + ' [' + AllToChar(aErro[02]) + ']')
		AutoGrLog("Id do formulário de erro: "   + ' [' + AllToChar(aErro[03]) + ']')
		AutoGrLog("Id do campo de erro: "        + ' [' + AllToChar(aErro[04]) + ']')
		AutoGrLog("Id do erro: "                 + ' [' + AllToChar(aErro[05]) + ']')
		AutoGrLog("Mensagem do erro: "           + ' [' + AllToChar(aErro[06]) + ']')
		AutoGrLog("Mensagem da solução: "        + ' [' + AllToChar(aErro[07]) + ']')
		AutoGrLog("Valor atribuído: "            + ' [' + AllToChar(aErro[08]) + ']')
		AutoGrLog("Valor anterior: "             + ' [' + AllToChar(aErro[09]) + ']')

		//Mostra a mensagem de Erro
		MostraErro()
	EndIf

//Desativa o modelo de dados
	oModel:DeActivate()



Return Nil
