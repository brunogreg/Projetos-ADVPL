//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MBlkColor
Define a cor para registros bloqueados (MSBLQL)
@type  Function
@author Atilio
@since 22/08/2023
@see https://tdn.totvs.com/display/public/framework/MBlkColor+-+Retorna+cores+a+utilizar
/*/

User Function MBlkColor()
    Local aArea  := FWGetArea()
    Local aCores := Array(2)

    //Define as cores com um tom de amarelo
    aCores[1] := RGB(246, 238, 000) //Cor do Texto
    aCores[2] := RGB(164, 159, 015) //Cor do Fundo

    FWRestArea(aArea)
Return aCores
