#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/-----------------------------------------------------------------------------------
- Programa      : WSRESTFUL WSTITSE2
- Descrição     : Recebe dados para geração de Títulos a Pagar (SE2) na rotina FINA050 via ExecAuto.
- author        : Pedro Henrique
- since         : 22/01/2026
- version 1.0
-----------------------------------------------------------------------------------/*/

WSRESTFUL WSTitSe2 DESCRIPTION 'Recebe dados LOCX para geracao de Titulos a Pagar'
	WSMETHOD POST NEW DESCRIPTION 'Inclusao de registro'   WSSYNTAX '/WSTITSE2/receivetit'    PATH 'receivetit'   PRODUCES APPLICATION_JSON
END WSRESTFUL


/*/-----------------------------------------------------------------------------------
- Método        : WSMETHOD POST NEW
- Descrição     : Cria um novo título a pagar via ExecAuto (FINA050)
- type          : method POST
-----------------------------------------------------------------------------------/*/

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSTITSE2

	Local lRet              := .T.
	Local aDados            := {}
	Local jJson             := Nil
	Local cJson             := Self:GetContent()
	Local cError            := ''
	Local nCampo            := 0
	Local jResponse         := JsonObject():New()
	Local cDirLog           := "\locx_logs\"
	Local cArqLog           := ""
	Local cErrorLog         := ""
	Local aLogAuto          := {}
	Local nLinha            := 0
	Local cNum              := ""
	Local cFornec           := ""
	Local cLoja             := ""
	Local cPrefixo          := "LCX"

	Private lMsErroAuto     := .F.
	Private lMsHelpAuto     := .T.
	Private lAutoErrNoFile  := .T.

	// Garante diretório de log
	If !ExistDir(cDirLog)
		MakeDir(cDirLog)
	EndIf

	// Parse do JSON
	Self:SetContentType("application/json") // Define o content-type da resposta
	jJson  := JsonObject():New()
	cError := jJson:FromJson(cJson) // Retorna erro se JSON inválido

	If !Empty(cError) // se houve erro no parse
		Self:SetStatus(400)
		jResponse["errorId"]  := "BFREST-004"
		jResponse["error"]    := "JSON inválido"
		jResponse["solution"] := "Verifique a estrutura do JSON enviado"
		Self:SetResponse(EncodeUTF8(jResponse:ToJSON())) // Define a resposta com o erro
		Return .F.
	EndIf

	//Solicita o número sequencial do título a pagar dentro do Protheus
	cNum := GetSxeNum("SE2", "E2_NUM")

	// Dados do fornecedor
	
	cFornec := AllTrim(jJson:GetJsonObject("fornec"))
	cLoja   := AllTrim(jJson:GetJsonObject("loja"))
	cCgc    := jJson:GetJsonObject("cnpjcpfforn")

	// Normaliza CNPJ/CPF recebido via JSON
	cCgcJson := LimpaDoc(cCgc) 

	
	// Validação do Fornecedor + Loja
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1)) // A2_FILIAL + A2_COD + A2_LOJA

	If !SA2->(DbSeek( ;
			xFilial("SA2") + ;
			AvKey(cFornec, "A2_COD") + ;//avKey para garantir o tipo correto
			AvKey(cLoja,   "A2_LOJA") ))

		Self:SetStatus(400)
		jResponse["errorId"]  := "BFREST-006"
		jResponse["error"]    := "Fornecedor ou Loja inválidos"
		jResponse["solution"] := "Fornecedor/Loja não encontrados no cadastro (SA2)"
		Self:SetResponse(EncodeUTF8(jResponse:ToJSON()))
		Return .F.
	EndIf

	// Normaliza CNPJ da base
	cCgcSA2 := LimpaDoc(SA2->A2_CGC)

	// Validação segura
	If cCgcSA2 <> cCgcJson

		Self:SetStatus(400)

		jResponse["errorId"] := "BFREST-007"
		jResponse["error"]  := "CNPJ não confere com o fornecedor"

		jResponse["solution"] := ;
			"O código/loja informado pertence a outro CNPJ."

		jResponse["cnpjRecebido"] := cCgcJson
		jResponse["cnpjCadastro"] := cCgcSA2

		Self:SetResponse(EncodeUTF8(jResponse:ToJSON()))
		Return .F.

	EndIf

	DbSelectArea("SE2")

	aAdd(aDados, {"E2_FILIAL",      xFilial("SE2"),                 Nil})
	aAdd(aDados, {"E2_PREFIXO",     cPrefixo,                       Nil})
	aAdd(aDados, {"E2_NUM",         cNum,                           Nil})
	aAdd(aDados, {"E2_TIPO",        jJson:GetJsonObject("tipo"),    Nil})
	aAdd(aDados, {"E2_NATUREZ",     jJson:GetJsonObject("naturez"), Nil})

	// Fornecedor validado
	aAdd(aDados, {"E2_FORNECE",     SA2->A2_COD,                    Nil})
	aAdd(aDados, {"E2_LOJA",        SA2->A2_LOJA,                   Nil})
	aAdd(aDados, {"E2_NOMFOR",      SA2->A2_NOME,                   Nil})

	aAdd(aDados, {"E2_VENCTO",      jJson:GetJsonObject("vencto"),  Nil})
	aAdd(aDados, {"E2_VALOR",       jJson:GetJsonObject("valor"),   Nil})
	aAdd(aDados, {"E2_HIST",        jJson:GetJsonObject("hist"),    Nil})

	aAdd(aDados, {"E2_FORBCO",      jJson:GetJsonObject("forbco"),  Nil})
	aAdd(aDados, {"E2_FORAGE",      jJson:GetJsonObject("forage"),  Nil})
	aAdd(aDados, {"E2_FORCTA",      jJson:GetJsonObject("forcta"),  Nil})
	aAdd(aDados, {"E2_FCTADV",      jJson:GetJsonObject("fctadv"),  Nil})
	aAdd(aDados, {"E2_FORMPAG",     jJson:GetJsonObject("formpag"), Nil})
	aAdd(aDados, {"E2_CONTAD",      jJson:GetJsonObject("contad"),  Nil})
	aAdd(aDados, {"E2_CCD",         jJson:GetJsonObject("ccd"),     Nil})
	aAdd(aDados, {"E2_LINDIG",      jJson:GetJsonObject("lindig"),  Nil})
	aAdd(aDados, {"E2_XNOMSOL",     jJson:GetJsonObject("xnomsol"), Nil})
	aAdd(aDados, {"E2_XEMSOL",      jJson:GetJsonObject("xemasol"), Nil})

	// Conversão de campos data
	For nCampo := 1 To Len(aDados)
		If GetSX3Cache(aDados[nCampo][1], "X3_TIPO") == "D"
			aDados[nCampo][2] := sToD(StrTran(aDados[nCampo][2], "-", ""))
		EndIf
	Next

	aDados := FWVetByDic(aDados, 'SE2') //FWVetByDic para ajustar campos do dicionário

	MsExecAuto({|x,y| FINA050(x,y)}, aDados, 3)

	If lMsErroAuto
		aLogAuto := GetAutoGrLog() // Captura log do ExecAuto
		For nLinha := 1 To Len(aLogAuto)
			cErrorLog += aLogAuto[nLinha] + CRLF
		Next

		cArqLog := "WSTitSe2_" + dToS(Date()) + "_" + StrTran(Time(),":","-") + ".log"
		MemoWrite(cDirLog + cArqLog, cErrorLog)//MemoWrite para gerar o arquivo de log

		Self:SetStatus(500)
		jResponse["errorId"]  := "BFREST-005"
		jResponse["error"]    := "Erro no ExecAuto"
		jResponse["solution"] := "Erro ao incluir título. Log gerado em " + cDirLog + cArqLog
		lRet := .F.
	Else
		jResponse["note"] := "Título incluído com sucesso | " + "Numero: " + cNum
		lRet := .T.
	EndIf

	Self:SetResponse(EncodeUTF8(jResponse:ToJSON()))
Return lRet

/*/-----------------------------------------------------------------------------------
	- Programa      : LimpaDoc
	- Descrição     : Recebe dados do CNPJ/CPF e retorna o número do documento sem formatação.
	- author        : Pedro Henrique
	- since         : 26/01/2026
	- version 1.1
-----------------------------------------------------------------------------------/*/
Static Function LimpaDoc(cDoc)

	Local cRet := AllTrim(cDoc)

	If Empty(cRet)
		Return ""
	EndIf

	// Remove formatações comuns
	cRet := StrTran(cRet, ".", "")
	cRet := StrTran(cRet, "-", "")
	cRet := StrTran(cRet, "/", "")
	cRet := StrTran(cRet, " ", "")

Return cRet
