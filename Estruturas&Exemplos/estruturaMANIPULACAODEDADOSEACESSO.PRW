#INCLUDE "Protheus.ch"
#INCLUDE "msmgadd.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"

User Function FUNCOES2()
    Local cCliente := "000001"
    Local cLoja := "01"
    // Local cProd := "000001"

    IF SELECT("SX6") > 0 //pode ser usado pra informar que uma tabelas esta aberta ou nao
        ALERT("PROTHEUS ABERTO")
    ELSE
    RcpSetType(3)
    PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" //simula a abertura do proteus abre tabelas e variaveis
    ENDIF
    dbSelectArea("SZ1")  //comando para abrir uma tabela no banco ou no dicionario de dados
    //dbCloseArea() serve para fechar a tabela
    dbSetOrder(1) // E o indice que ele vai me retornar
    //DBORDERNICKNAME("NOME DO CLIENTE")
    //dbGoTop() vai para o inicio dos registros
    //dbGoBotton vai para o final dos registros
    //dbGoTo(2) ele vai direto onde voce precisa
    if dbSeek(xFilial()+cCliente+cLoja) //faz uma busca binária no índice corrente da tabela. Ele procura pela chave exata ou pela primeira chave maior/igual à informada.//Essa expressão está montando a chave que o índice espera. 'xFilial()+cCliente+01'
        ALERT("ACHOU")

        WHILE !Eof()
        RecLock("SZ1", .F.)        
        Z1_FATOR  := 100
        MsUnlock()

        dbSkip() // pula para o proximo registro
        //dbSkip(-1) e quando voce nao que pular para  o proximo registro
        // SZ1 ->(dbSkip()) essa é uma forma de amarar o dbskip a uma tabelamiguel
        
        End

    else
        RecLock("SZ1", .T.) // ele trava a tabela para eu fazer algum ajuste e inclusao de algum item
        Z1_FILIAL := xFilial()
        Z1_CLIENT := "000001"
        Z1_LOJA   := "01"
        Z1_PRODUT := "000001"
        Z1_UM     := "PC"
        Z1_UMCLI  := "CX"
        Z1_TIPO   := "M"
        Z1_FATOR  := 10

        MsUnlock() // destrava a tabela apos eu ter ajustado
    Endif

    //APAGAR O REGISTRO
    dbSelectArea("SZ1")  //comando para abrir uma tabela no banco ou no dicionario de dados
    dbSetOrder(1)        // E o indice que ele vai me retornar
    //DBORDERNICKNAME("NOME DO CLIENTE")
    if dbSeek(xFilial()+cCliente+cLoja) //faz uma busca binária no índice corrente da tabela. Ele procura pela chave exata ou pela primeira chave maior/igual à informada.//Essa expressão está montando a chave que o índice espera. 'xFilial()+cCliente+01'
        RecLock("SZ1", .T.)// ele trava a tabela para eu fazer algum ajuste ou inclusao de algum item
        DBDELETE()
        MsUnlock()// destrava a tabela apos eu ter ajustado
    else
        ALERT("SEM REGISTRO PARA INCLUIR")
    Endif
    
       
Return

//SOFTLOCK("SZ1") // TRAVA UMA TABELA PARA QUE POSSA FAZER ALTERAÇOES SEM SER ATRAPALHADO
//DBUNLOCK() DESTRADA A TABELA QUE FOI TRAVADA
