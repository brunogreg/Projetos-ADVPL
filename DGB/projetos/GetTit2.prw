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
    WSMETHOD GET LIST DESCRIPTION 'Retorna titulos' WSSYNTAX '/GetTit2/list' PATH 'list' PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/-----------------------------------------------------------------------------------
- Método    : GET LIST
- Descrição : Retorna títulos vinculados ao LocX 
- Filtros   : filtro  = "pago", "aberto" ou "todos"
              dataini = data início emissão no formato YYYYMMDD (opcional)
              datafim = data fim    emissão no formato YYYYMMDD (opcional)
-----------------------------------------------------------------------------------/*/

WSMETHOD GET LIST WSRECEIVE WSSERVICE GetTit2

    Local aArea     := FWGetArea()  
    Local cBodyJson := ""           
    Local oJson     := Nil          
    Local cFiltro   := "todos"      // (padrão: todos) se nao for informado pelo usuário, traz todos titulos
    Local aRetorno  := {}           
    Local oTitulo   := Nil          
    Local oResposta := Nil          
    Local cErro     := ""           
    Local cQuery    := ""           
    Local cAlias    := "QRY_LOCX"   
    Local cSt       := ""           // Valor do E2_STATUS de cada título
    Local cDataIni  := ""           // Data início emissão (formato YYYYMMDD)
    Local cDataFim  := ""           // Data fim emissão (formato YYYYMMDD)

    BEGIN SEQUENCE // Inicia tratamento de erros

        // Lê o body da requisição enviada pelo LocX
        cBodyJson := Self:GetContent()

        // Processa o JSON recebido 
        If !Empty(cBodyJson)

            oJson := JsonObject():New()
            cErro := oJson:FromJson(cBodyJson)

            // JSON com estrutura inválida retorna HTTP 400
            If !Empty(cErro)
                Self:SetStatus(400)
                Self:SetContentType("application/json")
                Self:SetResponse('{"code": 400, "message": "JSON invalido: ' + cErro + '"}')
                RestArea(aArea)
                Return .T.
            EndIf

            // Recebe o filtro de status enviado pelo LocX
            If !Empty(oJson["filtro"])
                cFiltro := Lower(AllTrim(oJson["filtro"]))
            EndIf

            // Recebe as datas de emissão enviadas pelo LocX 
            If !Empty(oJson["dataini"])
                cDataIni := AllTrim(oJson["dataini"])
            EndIf

            If !Empty(oJson["datafim"])
                cDataFim := AllTrim(oJson["datafim"])
            EndIf

        EndIf

        // Valida se o status recebido é um valor permitido
        // Aceita apenas: "pago", "aberto" ou "todos" 

        If !( cFiltro == "pago" .Or. cFiltro == "aberto" .Or. cFiltro == "todos" )
            Self:SetStatus(400)
            Self:SetContentType("application/json")
            Self:SetResponse('{"code": 400, "message": "filtro invalido. Use: pago, aberto ou todos"}')
            RestArea(aArea)
            Return .T.
        EndIf

        // ----------------------------------------------------------
        // Valida o formato das datas recebidas
        // Formato esperado: YYYYMMDD (ex: 20260101)
        // Verifica se tem exatamente 8 caracteres numéricos
        // ----------------------------------------------------------

        If !Empty(cDataIni) .And. Len(cDataIni) <> 8
            Self:SetStatus(400)
            Self:SetContentType("application/json")
            Self:SetResponse('{"code": 400, "message": "dataini invalida. Use o formato YYYYMMDD. Exemplo: 20260101"}')
            RestArea(aArea)
            Return .T.
        EndIf

        If !Empty(cDataFim) .And. Len(cDataFim) <> 8
            Self:SetStatus(400)
            Self:SetContentType("application/json")
            Self:SetResponse('{"code": 400, "message": "datafim invalida. Use o formato YYYYMMDD. Exemplo: 20261231"}')
            RestArea(aArea)
            Return .T.
        EndIf

        // Valida se dataini não é maior que datafim
        If !Empty(cDataIni) .And. !Empty(cDataFim) .And. cDataIni > cDataFim
            Self:SetStatus(400)
            Self:SetContentType("application/json")
            Self:SetResponse('{"code": 400, "message": "dataini nao pode ser maior que datafim"}')
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
        cQuery += "  FROM " + RetSqlName("SE2") + " " + CRLF //RetSqlName garante o nome correto da tabela considerando possíveis customizações ou versões do Protheus 
        cQuery += " WHERE D_E_L_E_T_ = ' '  " + CRLF
        cQuery += "   AND E2_FILIAL  = '" + xFilial("SE2") + "' " + CRLF
        cQuery += "   AND E2_PREFIXO = 'LCX' " + CRLF                 
        cQuery += "   AND LTRIM(RTRIM(E2_XIDLCX)) <> '' " + CRLF    
        cQuery += "   AND LTRIM(RTRIM(E2_XIDLCX)) <> '0' " + CRLF   

        // ----------------------------------------------------------
        // Filtro de datas de emissão (E2_EMISSAO)
        // Só adiciona se o usuário informou as datas
        // Pode vir só dataini, só datafim, ou as duas
        // ----------------------------------------------------------

        If !Empty(cDataIni) .And. !Empty(cDataFim)
            // Período completo: entre dataini e datafim
            cQuery += " AND E2_EMISSAO >= '" + cDataIni + "' "
            cQuery += " AND E2_EMISSAO <= '" + cDataFim + "' "

        ElseIf !Empty(cDataIni) .And. Empty(cDataFim)
            // Só dataini: busca a partir dessa data
            cQuery += " AND E2_EMISSAO >= '" + cDataIni + "' "

        ElseIf Empty(cDataIni) .And. !Empty(cDataFim)
            // Só datafim: busca até essa data
            cQuery += " AND E2_EMISSAO <= '" + cDataFim + "' "

        EndIf
        // Se ambas vazias: não adiciona filtro de data (busca tudo)

        // ----------------------------------------------------------
        // Filtro de status
        // PAGO   = E2_STATUS = 'B'
        // ABERTO = E2_STATUS = 'A' ou 'R' (aberto e reliquidado)
        // TODOS  = sem filtro de status
        // ----------------------------------------------------------

        If cFiltro == "pago"
            cQuery += " AND (E2_STATUS = 'B' "
            cQuery += " OR E2_BAIXA <> '') "
            cQuery += " AND E2_SALDO = 0 "

        ElseIf cFiltro == "aberto"
            // Aberto inclui reliquidados (R) pois ainda têm saldo em aberto
            cQuery += " AND (E2_STATUS = 'A' OR E2_STATUS = 'R') "
            cQuery += " OR E2_BAIXA = '' AND E2_SALDO > 0 "

        EndIf

        cQuery += " ORDER BY E2_EMISSAO, E2_NUM " // Ordena por data de emissão e número

        // Executa a query e abre o resultado como uma tabela
        dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T.)
        (cAlias)->(DbGoTop())

        While (cAlias)->(!Eof())

            // Validação extra: pula títulos sem idLocX válido
            If Empty(AllTrim((cAlias)->XIDLCX)) .Or. AllTrim((cAlias)->XIDLCX) == "0"
                (cAlias)->(DbSkip())
                Loop
            EndIf

            // Monta objeto JSON com os dados de cada título
            oTitulo := JsonObject():New()

            oTitulo["prefixo"]        := AllTrim((cAlias)->E2_PREFIXO)
            oTitulo["idLocX"]         := AllTrim((cAlias)->XIDLCX)
            oTitulo["numero"]         := AllTrim((cAlias)->E2_NUM)
            oTitulo["dataEmissao"]    := AllTrim((cAlias)->E2_EMISSAO)   
            oTitulo["dataVencimento"] := AllTrim((cAlias)->E2_VENCTO)
            oTitulo["dataBaixa"]      := AllTrim((cAlias)->E2_BAIXA)
            oTitulo["valor"]          := (cAlias)->E2_VALOR
            oTitulo["saldo"]          := (cAlias)->E2_SALDO

            // Lê o status oficial do Protheus
            cSt := AllTrim((cAlias)->E2_STATUS)

            // Status usando E2_BAIXA + E2_SALDO como lógica principal
            // E2_STATUS como validação adicional (.Or.)
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

        // Monta e envia a resposta final para o LocX
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
