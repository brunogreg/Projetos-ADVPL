#include "protheus.ch"
#include "totvs.ch"

User Function zLogi17()

    Local aArea  := GetArea()
    Local aDados := {}
    Private lMsErroAuto := .F.

    //Adiciona os dados do cadastro de bancos
    aAdd(aDados, {"A6_COD",     "000",        Nil})
    aAdd(aDados, {"A6_AGENCIA", "00000",      Nil})
    aAdd(aDados, {"A6_NUMCON",  "0000000000", Nil})
    aAdd(aDados, {"A6_NOME",    "BANCO DE TESTE", Nil})

    //Iniciando transação
    Begin Transaction

        //x e y sao parametros, mata070 e a minha rotina, meu x e o aDados, e o y é o numero de parametros que estou passando
        MSExecAuto({|x, y| Mata070(x, y)}, aDados, 3) //

        //Se houve erro, mostra mensagem
        If lMsErroAuto
            MostraErro()
            DisarmTransaction()
        Else
            MsgInfo("Banco 000 cadastrado com sucesso!", "Atenção")
        EndIf

    End Transaction

    RestArea(aArea)

Return
