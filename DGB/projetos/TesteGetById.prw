#Include "Totvs.ch"
#Include "Protheus.ch"

User Function TesteGetById()
    Local aArea       := FWGetArea()
    Local aHeader     := {}
    Local oRest       := FWRest():New('https://bluefitacademias196921.protheus.cloudtotvs.com.br:4050/rest')
    Local cResultado  := ''
    Local cErro       := ''
    Local cLogin      := 't.pedro'
    Local cPwd        := 'Pedro091@'
    Local cAuth       := ''
    Local cId         := '16085'

    cAuth := encode64(cLogin + ':' + cPwd)

    aAdd(aHeader, 'User-Agent: Mozilla/4.0 (compatible; Protheus 12.1.x)')
    aAdd(aHeader, 'Content-Type: application/json; charset=utf-8')
    aAdd(aHeader, 'Authorization: Basic ' + cAuth)

    oRest:setPath('/GetTit2/titulo/' + cId)

    If oRest:Get(aHeader)
        cResultado := oRest:GetResult()
        ShowLog('Titulo encontrado: ' + CRLF + cResultado)
    Else
        cErro := oRest:GetLastError()
        ShowLog('Erro: ' + CRLF + cErro)
    EndIf

    FWRestArea(aArea)
Return Nil
