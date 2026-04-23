//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MBrwBtn
Valida o clique em alguma opção disponível nos Browses das rotinas
@type  Function
@author Atilio
@since 22/08/2023
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6815197
/*/

User Function MBrwBtn()
    Local aArea     := FWGetArea()
    Local lContinua := .T.
    Local cFuncMenu := Upper(Alltrim(ParamIXB[4]))
    Local nOpcaMenu := ParamIXB[3]

    //Se for a opção de excluir
    If nOpcaMenu == 5

        //Não permite prosseguir e mostra uma mensagem
        ExibeHelp(;
            "Help MBrwBtn",;
            "Não é permitido excluir registros! (Função: " + cFuncMenu + ")",;
            "Contate o líder do departamento";
        )
        lContinua := .F.

    EndIf

    FWRestArea(aArea)
Return lContinua
