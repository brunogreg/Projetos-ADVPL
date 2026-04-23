//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function GEMXGRCVND
P.E. acionado durante a gravação dos dados no pedido de venda
@type  Function
@author Atilio
@since 15/08/2023
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784609
/*/

User Function GEMXGRCVND()
    Local aArea   := FWGetArea()
    Local cEstado := ""
    Local cObsAux := "CLIENTE DE SP ! "
    
    //Se for um pedido normal, busca o estado do cliente
    If SC5->C5_TIPO == "N"
        cEstado := Posicione('SA1', 1, FWxFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI, "A1_EST")

        //Se for o estado de São Paulo, incrementa a observação caso não exista ainda
        If cEstado == "SP" .And. ! cObsAux $ Upper(SC5->C5_MENNOTA)
            SC5->C5_MENNOTA := cObsAux + SC5->C5_MENNOTA
        EndIf
    EndIf

    FWRestArea(aArea)
Return
