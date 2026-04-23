#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"

// codigo para atualizar o cadastro de bancos, utilizando a função de busca e bloqueio de registro, DbSeek e RecLock
User Function zLogi19()

    Local aArea   := GetArea()
    Local cBanco  := "000"
    Local cAgencia:= "00000"
    Local cConta  := "0000000000"
    Local cNomeBco:= "Banco Teste " + dToS(Date())

    //Selecionando a tabela de bancos
    DbSelectArea('SA6')
    SA6->(DbSetOrder(1)) //A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON

    //Se conseguir posicionar no registro
    If SA6->(DbSeek( FWxFilial('SA6') + cBanco + cAgencia + cConta ))

        //Atualizando o nome do banco
        RecLock('SA6', .F.) //.T. PARA INCLUIR REGISTRO, .F. PARA ATUALIZAR REGISTRO
            SA6->A6_NOME := cNomeBco
        SA6->(MsUnLock())

    EndIf

    RestArea(aArea)

Return

