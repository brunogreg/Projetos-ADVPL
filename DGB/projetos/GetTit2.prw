#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/-----------------------------------------------------------------------------------
- Programa  : GetTit2.prw
- Descrição : WebService REST - Método GET. Recebe requisição do LocX e disponibiliza títulos da SE2 em formato JSON,
- Autor     : Bruno Gregório
- Desde     : 30/03/2026
-----------------------------------------------------------------------------------/*/

WSRESTFUL GetTit2 DESCRIPTION 'Lista titulos da SE2 originados do LocX'
    WSDATA id      AS STRING // string pois assim permite o usuario enviar um ID locx que tenha zeros a esquerda '001'
    WSDATA filtro  AS STRING
    WSDATA dataini AS STRING
    WSDATA datafim AS STRING

    WSMETHOD GET LIST  DESCRIPTION 'Retorna titulos'                         WSSYNTAX '/GetTit2/list?{filtro, dataini, datafim}'  PATH 'list'        PRODUCES APPLICATION_JSON
    WSMETHOD GET BYTID DESCRIPTION 'Retorna um titulo especifico pelo idLcx' WSSYNTAX '/GetTit2/titulo/{id}'                      PATH 'titulo/{id}' PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/-----------------------------------------------------------------------------------
- Função    : fValidaData
- Descrição : Valida se uma string é uma data válida no formato YYYYMMDD
              - Verifica se tem 8 caracteres
              - Verifica se são todos numéricos
              - Verifica se mês está entre 01 e 12
              - Verifica se dia é válido para o mês (incluindo ano bissexto)
- Retorno   : .T. = data válida / .F. = data inválida
-----------------------------------------------------------------------------------/*/
Static Function fValidaData(cData)
    Local nAno  := 0
    Local nMes  := 0
    Local nDia  := 0
    Local nPos  := 0
    Local nDiasNoMes := {31,28,31,30,31,30,31,31,30,31,30,31}

    // Verifica se tem exatamente 8 caracteres
    If Len(cData) <> 8 // olhar a questao de espaços
        Return .F.
    EndIf

    // Verifica se todos os caracteres são numéricos evitando receber letras ou simbolos
    For nPos := 1 To 8
        If !IsDigit(SubStr(cData, nPos, 1))
            Return .F.
        EndIf
    Next nPos

    nAno := Val(SubStr(cData,1,4))
    nMes := Val(SubStr(cData,5,2))
    nDia := Val(SubStr(cData,7,2))

    // Valida ano (aceita somente entre 2000 e 2099)
    If nAno < 2000 .Or. nAno > 2099
        Return .F.
    EndIf

    // Valida se é mês real de janeiro a dezembro
    If nMes < 1 .Or. nMes > 12
        Return .F.
    EndIf

    // Ajusta fevereiro em ano bissexto
    If (nAno % 4 == 0 .And. nAno % 100 <> 0) .Or. (nAno % 400 == 0)
        nDiasNoMes[2] := 29
    EndIf

    // Valida é um dia real
    If nDia < 1 .Or. nDia > nDiasNoMes[nMes]
        Return .F.
    EndIf

Return .T.

/*/-----------------------------------------------------------------------------------
- Método    : GET LIST
- Descrição : Retorna títulos vinculados ao LocX 
- Como usar : GET /GetTit2/list?filtro=pago&dataini=20260101&datafim=20261231
- Filtros   : filtro  = "pago", "aberto" ou "todos"
              dataini = data de inicio da requisição em formato YYYYMMDD (opcional)
              datafim = data final "ate"  da requisição em formato YYYYMMDD (opcional)
-----------------------------------------------------------------------------------/*/
WSMETHOD GET LIST WSSERVICE GetTit2

    Local aArea     := FWGetArea()             
    Local cFiltro   := "todos"
    Local aRetorno  := {}           
    Local oTitulo   := Nil          
    Local oResposta := Nil              
    Local cQuery    := ""           
    Local cAlias    := "QRY_LOCX"   
    Local cSt       := ""             // Campo E2_status
    Local cDataIni  := ""
    Local cDataFim  := ""

    BEGIN SEQUENCE 
        
        // Lê os query params via :: para referenciar os membros da classe (Propriedades ou metodos)
        If !Empty(::filtro)
            cFiltro := Lower(AllTrim(::filtro))
        EndIf

        If !Empty(::dataini)
            cDataIni := AllTrim(::dataini)
        EndIf

        If !Empty(::datafim)
            cDataFim := AllTrim(::datafim)
        EndIf

        // ----------------------------------------------------------
        // Valida o filtro
        // ----------------------------------------------------------        
        If !( cFiltro == "pago" .Or. cFiltro == "aberto" .Or. cFiltro == "todos" )
            Self:SetStatus(400)
            Self:SetContentType("application/json")
            Self:SetResponse('{"code": 400, "message": "O Filtro informado  invalido, verifique. Use: pago, aberto ou todos"}')
            RestArea(aArea)
            Return .T.
        EndIf

        // ----------------------------------------------------------
        // Valida as datas usando fValidaData
        // Só valida se o usuário informou
        // Aceita somente números no formato YYYYMMDD
        // Rejeita letras, símbolos e datas inexistentes
        // ----------------------------------------------------------
        If !Empty(cDataIni)
            If !fValidaData(cDataIni)
                Self:SetStatus(400)
                Self:SetContentType("application/json")
                Self:SetResponse('{"code": 400, "message": "A dataini informada  invalida, verifique . Use o formato YYYYMMDD. Exemplo: 20260101"}')
                RestArea(aArea)
                Return .T.
            EndIf
        EndIf

        If !Empty(cDataFim)
            If !fValidaData(cDataFim)
                Self:SetStatus(400)
                Self:SetContentType("application/json")
                Self:SetResponse('{"code": 400, "message": "A datafim informada  invalida, verifique. Use o formato YYYYMMDD. Exemplo: 20261231"}')
                RestArea(aArea)
                Return .T.
            EndIf
        EndIf

        // Valida se dataini não é maior que datafim (só se as duas foram informadas)
        // Como o formato é YYYYMMDD, a comparação de string funciona corretamente
        If !Empty(cDataIni) .And. !Empty(cDataFim) .And. cDataIni > cDataFim
            Self:SetStatus(400)
            Self:SetContentType("application/json")
            Self:SetResponse('{"code": 400, "message": "A dataini nao pode ser posterior a datafim"}')
            RestArea(aArea)
            Return .T.
        EndIf

        // ----------------------------------------------------------
        // Monta a query SQL
        // ----------------------------------------------------------
        cQuery := "SELECT LTRIM(RTRIM(E2_XIDLCX)) AS XIDLCX, " + CRLF
        cQuery +=        "E2_NUM,      " + CRLF
        cQuery +=        "E2_VENCTO,   " + CRLF
        cQuery +=        "E2_EMISSAO,  " + CRLF
        cQuery +=        "E2_BAIXA,    " + CRLF
        cQuery +=        "E2_VALOR,    " + CRLF
        cQuery +=        "E2_SALDO,    " + CRLF
        cQuery +=        "E2_STATUS,   " + CRLF
        cQuery +=        "E2_PREFIXO   " + CRLF
        cQuery += "  FROM " + RetSqlName("SE2") + " " + CRLF
        cQuery += " WHERE D_E_L_E_T_ = ' '  " + CRLF
        //cQuery += "   AND E2_FILIAL  = '" + xFilial("SE2") + "' " + CRLF
        cQuery += "   AND E2_PREFIXO = 'LCX' " + CRLF                 
        

        // Filtro de datas
        If !Empty(cDataIni) .And. !Empty(cDataFim)
            cQuery += " AND E2_EMISSAO >= '" + cDataIni + "' "
            cQuery += " AND E2_EMISSAO <= '" + cDataFim + "' "
        ElseIf !Empty(cDataIni) .And. Empty(cDataFim)
            cQuery += " AND E2_EMISSAO >= '" + cDataIni + "' "
        ElseIf Empty(cDataIni) .And. !Empty(cDataFim)
            cQuery += " AND E2_EMISSAO <= '" + cDataFim + "' "
        EndIf

        // Filtro de status        

        If cFiltro == "pago"
            cQuery += "   AND E2_SALDO = 0 " + CRLF
        ElseIf cFiltro == "aberto"
            cQuery += "   AND E2_SALDO <> 0 " + CRLF
        EndIf

        cQuery += " ORDER BY E2_EMISSAO, E2_NUM "

        //Executa a query SQL e abre o resultado como uma "tabela temporária". O DbGoTop() posiciona no primeiro registro.
        dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T.)
        (cAlias)->(DbGoTop())

        While (cAlias)->(!Eof())

            //Validação extra: se o XIDLCX estiver vazio ou for "0", pula esse registro e vai para o próximo.
            If Empty(AllTrim((cAlias)->XIDLCX)) .Or. AllTrim((cAlias)->XIDLCX) == "0"
                (cAlias)->(DbSkip())
                Loop
            EndIf

            //Monta o json da resposta
            oTitulo := JsonObject():New()
            oTitulo["prefixo"]        := AllTrim((cAlias)->E2_PREFIXO)
            oTitulo["idLocX"]         := AllTrim((cAlias)->XIDLCX)
            oTitulo["numero"]         := AllTrim((cAlias)->E2_NUM)
            oTitulo["dataEmissao"]    := AllTrim((cAlias)->E2_EMISSAO)   
            oTitulo["dataVencimento"] := AllTrim((cAlias)->E2_VENCTO)
            oTitulo["dataBaixa"]      := AllTrim((cAlias)->E2_BAIXA)
            oTitulo["valor"]          := (cAlias)->E2_VALOR
            oTitulo["saldo"]          := (cAlias)->E2_SALDO

            cSt := AllTrim((cAlias)->E2_STATUS)

            //Usa E2_BAIXA E E2_SALDO OU E2_STATUS PARA DEFINIR SE O TITULO VAI RECEBER O STATUS DE PAGO OU ABERTO
            If (!Empty(AllTrim((cAlias)->E2_BAIXA)) .And. (cAlias)->E2_SALDO == 0) .Or. cSt == "B"
                oTitulo["status"] := "pago"
            ElseIf (!Empty(AllTrim((cAlias)->E2_BAIXA)) .And. (cAlias)->E2_SALDO > 0) .Or. cSt == "R"
                oTitulo["status"] := "reliquidado"
            ElseIf (Empty(AllTrim((cAlias)->E2_BAIXA)) .And. (cAlias)->E2_SALDO > 0) .Or. cSt == "A"
                oTitulo["status"] := "aberto"
            Else
                oTitulo["status"] := "indefinido"
            EndIf

            AAdd(aRetorno, oTitulo)
            (cAlias)->(DbSkip())

        EndDo

        (cAlias)->(DbCloseArea())

        oResposta := JsonObject():New()
        oResposta["total"]   := Len(aRetorno)
        oResposta["titulos"] := aRetorno

        Self:SetStatus(200)
        Self:SetContentType("application/json")
        Self:SetResponse(oResposta:ToJson())

    RECOVER

        If Select(cAlias) > 0
            (cAlias)->(DbCloseArea())
        EndIf

        Self:SetStatus(500)
        Self:SetContentType("application/json")
        Self:SetResponse('{"code": 500, "message": "Erro interno no servidor. Contate o administrador."}')

    END SEQUENCE

    RestArea(aArea)

Return .T.


/*/-----------------------------------------------------------------------------------
- Método    : GET BYTID
- Descrição : Retorna um título específico pelo E2_XIDLCX (id do LocX)
- Como usar : GET /GetTit2/titulo/4
- Retorno   : 200 + dados do título   = título encontrado
              404                     = título não encontrado
              400                     = id não informado ou inválido
-----------------------------------------------------------------------------------/*/
WSMETHOD GET BYTID WSSERVICE GetTit2

    Local aArea     := FWGetArea()
    Local cId       := ""
    Local oTitulo   := Nil
    Local cQuery    := ""
    Local cAlias    := "QRY_BYTID"
    Local cSt       := ""

    BEGIN SEQUENCE

        // lê o path param usando ::id 
        cId := AllTrim(::id)

        If Empty(cId) .Or. cId == "0"
            Self:SetStatus(400)
            Self:SetContentType("application/json")
            Self:SetResponse('{"code": 400, "message": "id invalido. Informe o idLocX do titulo na URL. Exemplo: /GetTit2/titulo/4"}')
            RestArea(aArea)
            Return .T.
        EndIf

        cQuery := "SELECT LTRIM(RTRIM(E2_XIDLCX)) AS XIDLCX, " + CRLF
        cQuery +=        "E2_NUM,      " + CRLF
        cQuery +=        "E2_VENCTO,   " + CRLF
        cQuery +=        "E2_EMISSAO,  " + CRLF
        cQuery +=        "E2_BAIXA,    " + CRLF
        cQuery +=        "E2_VALOR,    " + CRLF
        cQuery +=        "E2_SALDO,    " + CRLF
        cQuery +=        "E2_STATUS,   " + CRLF
        cQuery +=        "E2_PREFIXO   " + CRLF
        cQuery += "  FROM " + RetSqlName("SE2") + " " + CRLF
        cQuery += " WHERE D_E_L_E_T_ = ' '  " + CRLF
        cQuery += "   AND E2_FILIAL  = '" + xFilial("SE2") + "' " + CRLF
        cQuery += "   AND E2_PREFIXO = 'LCX' " + CRLF
        cQuery += "   AND LTRIM(RTRIM(E2_XIDLCX)) = '" + cId + "' " + CRLF

        dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T.)
        (cAlias)->(DbGoTop())

        If (cAlias)->(Eof())
            (cAlias)->(DbCloseArea())
            Self:SetStatus(404)
            Self:SetContentType("application/json")
            Self:SetResponse('{"code": 404, "message": "Titulo nao encontrado para o id informado verifique o id"}')
            RestArea(aArea)
            Return .T.
        EndIf

        oTitulo := JsonObject():New()
        oTitulo["prefixo"]        := AllTrim((cAlias)->E2_PREFIXO)
        oTitulo["idLocX"]         := AllTrim((cAlias)->XIDLCX)
        oTitulo["numero"]         := AllTrim((cAlias)->E2_NUM)
        oTitulo["dataEmissao"]    := AllTrim((cAlias)->E2_EMISSAO)
        oTitulo["dataVencimento"] := AllTrim((cAlias)->E2_VENCTO)
        oTitulo["dataBaixa"]      := AllTrim((cAlias)->E2_BAIXA)
        oTitulo["valor"]          := (cAlias)->E2_VALOR
        oTitulo["saldo"]          := (cAlias)->E2_SALDO

        cSt := AllTrim((cAlias)->E2_STATUS)

        If (!Empty(AllTrim((cAlias)->E2_BAIXA)) .And. (cAlias)->E2_SALDO == 0) .Or. cSt == "B"
            oTitulo["status"] := "pago"
        ElseIf (!Empty(AllTrim((cAlias)->E2_BAIXA)) .And. (cAlias)->E2_SALDO > 0) .Or. cSt == "R"
            oTitulo["status"] := "reliquidado"
        ElseIf (Empty(AllTrim((cAlias)->E2_BAIXA)) .And. (cAlias)->E2_SALDO > 0) .Or. cSt == "A"
            oTitulo["status"] := "aberto"
        Else
            oTitulo["status"] := "indefinido"
        EndIf

        (cAlias)->(DbCloseArea())

        Self:SetStatus(200)
        Self:SetContentType("application/json")
        Self:SetResponse(oTitulo:ToJson())

    RECOVER

        If Select(cAlias) > 0
            (cAlias)->(DbCloseArea())
        EndIf

        Self:SetStatus(500)
        Self:SetContentType("application/json")
        Self:SetResponse('{"code": 500, "message": "Erro interno no servidor. Contate o administrador."}')

    END SEQUENCE

    RestArea(aArea)

Return .T.
