//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function M410FSQL
Ponto de Entrada para filtrar o browse da tela de Pedido de Vendas
@type  Function
@author Atilio
@since 20/06/2023
@see https://tdn.totvs.com/display/public/PROT/M410FSQL+-+Filtro+de+pedidos+de+venda
/*/

User Function M410FSQL()
    Local aArea      := FWGetArea()
    Local cFiltro := ""
    Local aPergs     := {}
    Local cClieDe    := Space(TamSX3('A1_COD')[1])
    Local cClieAt    := StrTran(cClieDe, ' ', 'Z')
    Local dDataDe    := FirstDate(Date())
    Local dDataAt    := LastDate(Date())

    //Adiciona os parâmetros que serão exibidos
    aAdd(aPergs, {1, "Cliente De",  cClieDe,  "", "Vazio() .Or. ExistCPO('SA1')", "SA1", ".T.", 70,  .F.}) //MV_PAR01
    aAdd(aPergs, {1, "Cliente Até", cClieAt,  "", "ExistCPO('SA1')",              "SA1", ".T.", 70,  .T.}) //MV_PAR02
    aAdd(aPergs, {1, "Data De",     dDataDe,  "", ".T.",                          "",    ".T.", 80,  .F.}) //MV_PAR03
    aAdd(aPergs, {1, "Data Até",    dDataAt,  "", ".T.",                          "",    ".T.", 80,  .T.}) //MV_PAR04

    //Se a pergunta for confirmada
    If ParamBox(aPergs, "Informe os parâmetros", , , , , , , , , .F., .F.)

        //Monta o filtro que será aplicado no browse
        cFiltro += " SC5->C5_CLIENTE >= '" + MV_PAR01       + "' .AND. "
        cFiltro += " SC5->C5_CLIENTE <= '" + MV_PAR02       + "' .AND. "
        cFiltro += " SC5->C5_EMISSAO >= sToD('" + dToS(MV_PAR03) + "') .AND. "
        cFiltro += " SC5->C5_EMISSAO <= sToD('" + dToS(MV_PAR04) + "') "
    EndIf

    FWRestArea(aArea)
Return cFiltro
