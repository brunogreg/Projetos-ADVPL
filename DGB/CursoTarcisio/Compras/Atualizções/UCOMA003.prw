#INCLUDE   'PROTHEUS.CH'

User Function UCOMA003()

	Local cCod        := "000002"
	Local cLoja       := "00"
	Local cNome       := "BRUNO COUTO"
	Local cNomeFant   := "TESTE LTDA"
	Local cEndereco   := "RUA TESTE, 123"
	Local cBairro     := "Centro"
	Local cTp         := "F"          // 1=Cliente 2=Fornecedor
	Local cEST        := "MG"
	Local cCodMun     := "22306"    // Código do Município de Divinopolis
	Local cDescMun    := "DIVINOPOLIS"
	Local cCep        := "35500148"
	Local cIE         := ""
	Local cCNPJ       := ""
	Local cCodPais    := "105"       // Código do Brasil
	Local cEMail      := ""
    Local cDDD        := "37"
    Local cTelefone   := "984031068"
    Local cTipPessoa  := "F"         // J=Jurídica F=Física

	lDeuCerto := .F.

//Pegando o modelo de dados, setando a operação de inclusão
	oModel := FWLoadModel("CRMA980") //Rotina Cadastro de Clientes
	oModel:SetOperation(3) //A1_FILIAL+A1_CGC
	oModel:Activate() //Ativa o modelo de dados

//Pegando o model dos campos da SA1
	oSA1Mod:= oModel:getModel("SA1MASTER") //("CRMA980") //Rotina Cadastro de Clientes
	oSA1Mod:setValue("A1_COD",       cCod        ) // Codigo
	oSA1Mod:setValue("A1_LOJA",      cLoja       ) // Loja
	oSA1Mod:setValue("A1_NOME",      cNome       ) // Nome
	oSA1Mod:setValue("A1_NREDUZ",    cNomeFant   ) // Nome reduz.
	oSA1Mod:setValue("A1_END",       cEndereco   ) // Endereco
	oSA1Mod:setValue("A1_BAIRRO",    cBairro     ) // Bairro
	oSA1Mod:setValue("A1_TIPO",      cTp         ) // Tipo
	oSA1Mod:setValue("A1_EST",       cEST        ) // Estado
	oSA1Mod:setValue("A1_COD_MUN",   cCodMun     ) // Codigo Municipio
	oSA1Mod:setValue("A1_MUN",       cDescMun    ) // Municipio
	oSA1Mod:setValue("A1_CEP",       cCep        ) // CEP
	oSA1Mod:setValue("A1_INSCR",     cIE         ) // Inscricao Estadual
	oSA1Mod:setValue("A1_CGC",       cCNPJ       ) // CNPJ/CPF
	oSA1Mod:setValue("A1_PAIS",      cCodPais    ) // Pais
	oSA1Mod:setValue("A1_EMAIL",     cEMail      ) // E-Mail
	oSA1Mod:setValue("A1_DDD",       cDDD        ) // DDD
	oSA1Mod:setValue("A1_TEL",       cTelefone   ) // Fone
	oSA1Mod:setValue("A1_PESSOA",    cTipPessoa  ) // Tipo Pessoa

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

Return(Nil)
