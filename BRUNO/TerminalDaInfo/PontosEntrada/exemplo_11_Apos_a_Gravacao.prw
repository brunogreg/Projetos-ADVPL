//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MTA410T
Ponto de entrada disparado após a gravação do pedido de venda
@type  Function
@author Atilio
@since 15/08/2023
@see https://tdn.totvs.com/display/public/PROT/MTA410T
/*/

User Function MTA410T()
    Local aArea    := FWGetArea()
    Local cCorpo   := ""
    Local cAssunto := ""
    Local cPara    := ""
    Local nPosProd := GDFieldPos("C6_PRODUTO")
    Local nPosDesc := GDFieldPos("C6_DESCRI")
    Local nPosQtde := GDFieldPos("C6_QTDVEN")
    Local nPosVlUn := GDFieldPos("C6_PRCVEN")
    Local nPosVTot := GDFieldPos("C6_VALOR")
    Local nAtual   := 0

    //Se for uma inclusão ou cópia e o tipo do pedido for Normal
    If (INCLUI .Or. FWIsInCallStack("a410PCopia")) .And. SC5->C5_TIPO == "N"
        //Dispara uma mensagem de eMail
        cCorpo := '<p>Olá.</p>'
        cCorpo += '<p>Foi incluido um novo pedido de venda no sistema, abaixo as informações:</p>'
        cCorpo += '<p><b>Pedido:</b> '             + SC5->C5_NUM + '</p>'
        cCorpo += '<p><b>Cliente:</b> '            + SC5->C5_CLIENTE + SC5->C5_LOJACLI + ' (' + Alltrim(Posicione('SA1', 1, FWxFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI, 'A1_NOME')) + ')</p>'
        cCorpo += '<p><b>Vendedor:</b> '           + SC5->C5_VEND1 + ' (' + Alltrim(Posicione('SA3', 1, FWxFilial('SA3') + SC5->C5_VEND1, 'A3_NOME')) + ')</p>'
        cCorpo += '<p><b>Condição Pagamento:</b> ' + SC5->C5_CONDPAG + ' (' + Alltrim(Posicione('SE4', 1, FWxFilial('SE4') + SC5->C5_CONDPAG, 'E4_DESCRI')) + ')</p>'
        cCorpo += '<p><b>Itens:</b> </p>'
        cCorpo += '<center>'
        cCorpo += '<table>'
        cCorpo += '<tr>'
        cCorpo += '<td><b>Produto</b></td>'
        cCorpo += '<td><b>Descrição</b></td>'
        cCorpo += '<td><b>Qtde</b></td>'
        cCorpo += '<td><b>Vlr. Unit.</b></td>'
        cCorpo += '<td><b>Vlr. Total</b></td>'
        cCorpo += '</tr>'
        For nAtual := 1 To Len(aCols)
            cCorpo += '<tr>'
            cCorpo += '<td>' + aCols[nAtual][nPosProd] + '</td>'
            cCorpo += '<td>' + aCols[nAtual][nPosDesc] + '</td>'
            cCorpo += '<td>' + Transform(aCols[nAtual][nPosQtde], "@E 999,999.99") + '</td>'
            cCorpo += '<td>' + Transform(aCols[nAtual][nPosVlUn], "@E 999,999.99") + '</td>'
            cCorpo += '<td>' + Transform(aCols[nAtual][nPosVTot], "@E 999,999.99") + '</td>'
            cCorpo += '</tr>'
        Next
        cCorpo += '</table>'
        cCorpo += '</center>'
        cCorpo += '<p>Mensagem disparada na data <em>' + dToC(Date()) + '</em> às <em>' +Time() + '</em>.</p>'

        cAssunto := "Pedido #" + SC5->C5_NUM
        cPara    := "contato@atiliosistemas.com"
        GPEMail(cAssunto, cCorpo, cPara, /*aAnexos*/, /*lExibeHelp*/)
    EndIf

    FWRestArea(aArea)
Return
