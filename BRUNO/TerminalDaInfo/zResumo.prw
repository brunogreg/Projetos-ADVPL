#INCLUDE "protheus.ch"
#INCLUDE "totvs.ch"
/*/                                     REGRA DE PROJETO EM ADVPL

    SE TRATANDO DE ADEVPL O PRIMEIRO PASSO DE UM PROJETO BEM ESTUTURADO É INFORMAR AS BIBLIOTECAS QUE ELE IRA USAR 
    PARA ISSO USAMOS O COMANDO #INCLUDE, 

    O SEGUNDO PASSO É A DOCUMENTAÇÃO INFORMANDO O NOME DO PROJETO, O NOME DO AUTOR, A DATA DE CRIAÇÃO E A VERSÃO DO PROJETO,  

    -------------------------------------------------------------------
    -Â Programa  : Contabilizacao
    -Â Autor     : Bruno Couto Gregorio
    -Â Data      : 03/02/2026
    -A Descrição : Tela Manual de Mvc.
    -------------------------------------------------------------------

    DEPOIS VEM A CONSTRUÇÃO DAS FUNCITOINS SEJA USER FUNCION OU STATIC FUNCTION,
/*/
User Function zLogi02()

    Local aArea := GetArea()
    Local dDataAtual := Date()
    Local cHoraAtual := Time()
    Local cNome := "Curso de Logica em Advpl"

//DEPOIS VEM O CORPO DO PROGRAMA ONDE USAMOS AS VARIAVEIS DECLARADAS PARA REALIZAR AS OPERAÇÕES NECESSÁRIAS,
    MsgInfo("Estamos no [" + cNome + "], hoje é " + dToc(dDataAtual) + " e são " + cHoraAtual)  
    MsgInfo("Ontem foi dia " + dToc(dDataAtual - 1) + " e amanhã será dia " + dToc(dDataAtual + 1))
    MsgInfo(" Mes passado foi " + dToc(dDataAtual - 30) + " e mês que vem será " + dToc(dDataAtual + 30))

//DEPOIS VEM O ENCERRAMENTO DO PROGRAMA
    RestArea(aArea)
Return(nil)

/*/
    --------------------------------------------------------------------------------

    Devemos se atentar que a declaração das user functions deve ter apenas 8 caracteres em seu nome.

    Se for rotinas MVC devera ter até 7 caracteres, pois o ultimo é reservado para a letra que indica o tipo de rotina, seja ela M, V ou C.

    As nomenclaturas utilizadas, geralmente são:
    AABBBXNN, onde:
    AA  - Sigla da empresa
    BBB - Módulo da Função
    X   - Tipo (Atualização, Consulta, Relatório, Miscelanea, Job, etc)
    NN  - Sequência, por exemplo:
    ASFATR87 -> Atilio Sistemas, FATuramento, Relatório, sequência 87

    Ou se for um fonte genérico, de uma lib por exemplo, iniciamos a função de usuário com a letra "Z"
    
    User Function zLogi04()

    --------------------------------------------------------------------------------

    FUNCOES ESTATICAS SOMENTE PODEM SER USADAS DENTRO DE ARQUIVO PRW, ELAS NAO PODE SER CHAMADO EM, OUTROS ARQUIVOS

    Já as funções estáticas não tem limitação de tamanho de caracteres (até 10)
    Para seguir um padrão, tentamos começar com elas, utilizando a letra "f"

    Static Function fLogi04()

    E PARA ELAS SEREM CHAMADAS ELAS DEVEM ESTAR DENTRO DE UMA USER FUNCTION

    -------------------------------------------------------------------------------

    VARIAVEIS DEVEM TER ATE 10 CARACTERES, PARA SEGUIR UM PADRÃO DE PROJETO, 
    DEVEM COMEÇAR COM A LETRA 

        "C" PARA VARIÁVEIS DO TIPO CHARACTER,
        "D" PARA VARIÁVEIS DO TIPO DATA, 
        "L" PARA VARIÁVEIS DO TIPO LOGICO,
        "N" PARA VARIÁVEIS DO TIPO NUMÉRICO
        "A" PARA VARIÁVEIS DO TIPO ARRAY.
        "O" PARA VARIÁVEIS DO TIPO OBJECT
        "P" PARA VARIÁVEIS DO TIPO PROCEDURE
        "H" PARA VARIÁVEIS DO TIPO HANDLE
        "T" PARA VARIÁVEIS DO TIPO TEMPORARY
        "E" PARA VARIÁVEIS DO TIPO EXTERNAL
        "B" PARA VARIÁVEIS DO TIPO BUFFER
        "F" PARA VARIÁVEIS DO TIPO FUNCTION
        E ASSIM VAI ISSO SE CHAMA NOTAÇÃO HUNGARA

        VARIAVEL LOCAL := SO FUNCIONAM DENTRO DOS ESCOPOS
        VARIAVEL PRIVATE := FUNCIONAM COMO CASCATA DE ONDE ELA FOI DECLARADA PRA BAIXO, OU SEJA FUNCIONA DENTRO DE OUTRAS FUNCOES E ESCOPOS TBM
        VARIAVEL PUBLIC := FUNCIONA EM QUALQUER LUGAR DO PROJETO, OU SEJA, QUALQUER FUNÇÃO PODE ACESSAR ESSA VARIÁVEL
        VARIAVEL STATIC := FUNCIONA COMO UMA LOCAL POREM SEU VALOR E NO ARQUIVO PRW INTEIRO ELA E DECLARADA NO INICIO DO CODIGO     
        VARIAL PUBLIC := SERVE PARA OUTROS PRW TBM SENDO ASSIM E MENOS USADA PARA EVITAR CONFLITOS DE VARIÁVEIS ENTRE OS ARQUIVOS, POIS SE FOR USADA EM OUTRO ARQUIVO O VALOR DA VARIÁVEL PODE SER ALTERADO E CAUSAR PROBLEMAS NO PROJETO 
    
    
        ------------------------------------------------------------------------------------------------------------------
    
        CONSTANTES SAO BASICAMENTE OS #DEFINE, ONDE SE DECLARA UMA CONSTANTE E SEU VALOR, ESSA CONSTANTE PODE SER USADA EM QUALQUER LUGAR DO PROJETO, POIS SEU VALOR NAO PODE SER ALTERADO, O QUE GARANTE A SEGURANÇA DO PROJETO, POIS SE FOR USADA EM OUTRO ARQUIVO O VALOR DA CONSTANTE NAO PODE SER ALTERADO E CAUSAR PROBLEMAS NO PROJETO
    
        #DEFINE cNomeConstante "Valor da Constante"

        ELAS VEM APOS AS BIBLIOTECAS E OS SEUS 3 PRIMEIRO CARACTERES DEVEM SER PARA DEFINIR A VARIAVEL
        DEVENDO TER APENAS 10 CARACTERES NO TOTAL, PARA SEGUIR O PADRÃO DE PROJETO,

        ---------------------------------------------------------------------------------------------------------------------------------

        UMA VARIAVEL NOMEADA COM UM X ANTES PODE SE TRATAR DE UMA VARIAVEL INDEFINIDA.

        LOCAL xVar := "Valor da Variável Indefinida"

        ----------------------------------------------------------------------------------------------------------------------------------

        ARRAY MULTI DIMENSIONAL.
/*/

Static Function zLogi08()

    Local aArea      := GetArea()
    Local aNomes     := {}
    Local aSobreNome := Array(3)
    Local aPessoa    := {}  

    aAdd(aNomes, "Daniel")
    aAdd(aNomes, "Terminal")
    aSobreNome[1] := "Atilio"
    aSobreNome[2] := "de Informação

    //Array Multidimensional
    aAdd(aPessoa, {"Daniel", sToD("19930712"), "Bauru"})
    aAdd(aPessoa, {"João",   sToD("19910131"), "Agudos"})
    aAdd(aPessoa, {"Maria",  sToD("19921231"), "Piratinga"})

    Local nAtual := 0
    For nAtual := 1 To Len(aPessoa)
        Alert(aPessoa[nAtual][1] + " nasceu no dia " + dToS(aPessoa[nAtual][2]) + " em " + aPessoa[nAtual][3])
    Next

    //Inserindo elemento no Array
    aSize(aPessoa, Len(aPessoa) + 1) //aumentando o tamanho do Array em 1 para inserir um novo elemento
    aIns(aPessoa, 1) // ains e usado pra inserir um elemento na posição 1
    aPessoa[1] := {"Bruno", sToD("19900228", "Bauru")}
    Alert("Linha 2,Coluna1:" + aPessoa[2][1]) //Acessando o elemento da linha 2, coluna 1 do Array

    //Procurando um elemento no array
    //ascan é usado para procurar um elemento no array, ele retorna a posição do elemento encontrado ou 0 se não encontrar
    nPos := aScan(aPessoa, { |x| AllTrim(Upper(x[1])) == "JOÃO" }) 
    
    If nPos > 0
        MsgInfo("O nome " + aPessoa[nPos][1] + " foi encontrado na posição " + LTrim(Str(nPos)))
    Else
        Alert("O nome não foi encontrado no Array")
    Endif

    //Excluindo o elemento de um array
    aDel(aPessoa, nPos) 
    aSize(aPessoa, Len(aPessoa) - 1) //Diminuindo o tamanho do Array em 1 para excluir o elemento
    Alert("Array aPessoa com " + cValToChar(Len(aPessoa)) + " elementos após exclusão")

    RestArea(aArea)
Return(nil) 
    
          
        
    
/*/

Static Function fFormaNov()

    Local cNome      AS Character

    cNome := "Daniel"
    cNome := Date()

    Alert(cNome)

    
    Local cNome      AS Character
    Local nIdade     AS Numeric
    Local dDataNasc  AS Date
    Local lCurso     AS Logical
    Local oFont      AS Object
    Local bBloco     AS CodeBlock
    Local aDados     AS Array
    
    Return(nil)

    O AS é usado para declarar o tipo da variável, ele é opcional, mas é recomendado para seguir um padrão de projeto, pois facilita a leitura do código e a identificação do tipo da variável, além de evitar erros de tipo em tempo de execução.

    -----------------------------------------------------------------------------------------------------------
    
/*/

// COMO MONTAR QUERYS DENTRO DO ADVPL
User Function zLogi15()

    Local aArea   := GetArea()
    Local cQrySA2 := ""
    Local nAtual  := 0

    //Selecionando os fornecedores via query diretamente no banco de dados
    cQrySA2 := " SELECT TOP 100 " + CRLF
    cQrySA2 += "     A2_COD, " + CRLF
    cQrySA2 += "     A2_NOME " + CRLF
    cQrySA2 += " FROM " + CRLF
    cQrySA2 += "     " + RetSQLName('SA2') + " SA2 " + CRLF
    cQrySA2 += " WHERE " + CRLF
    cQrySA2 += "     A2_FILIAL = '" + FWxFilial('SA2') + "' " + CRLF
    cQrySA2 += " AND A2_MSBLQL != '1' " + CRLF
    cQrySA2 += " AND SA2.D_E_L_E_T_ = '' " + CRLF
    cQrySA2 += " ORDER BY " + CRLF
    cQrySA2 += "     A2_COD " + CRLF

    //Executando a query
    PLSQuery(cQrySA2, "QRY_SA2")

    //ENQUANTO HOUVER DADOS DA QUERY.
    While ! QRY_SA2->(Eof())
       nAtual ++

       QRY_SA2->(DbSkip()) 
    Enddo
    QRY_SA2->(DbCloseArea()) 

    MsgInfo(cValToChar(nAtual) + " fornecedores encontrados na query")

    RestArea(aArea)
Return

//---------------------------------------------------------------------------------------------------------------------------------

User Function zLogi16()

    Local aArea  := GetArea()
    Local nAtual := 0

    //Construindo a consulta
    BeginSql Alias "QRY_SA2"
        SELECT
            A2_COD,
            A2_NOME
        FROM
            %table:SA2% SA2
        WHERE
            A2_FILIAL = %xFilial:SA2%
            AND A2_MSBLQL != '1'
            AND SA2.%notDel%
    EndSql

    //Enquanto houver dados da query
    While ! QRY_SA2->(EoF())

        nAtual++

        QRY_SA2->(DbSkip())

    EndDo

    QRY_SA2->(DbCloseArea())

    MsgInfo(cValToChar(nAtual) + " fornecedor(es) encontrado(s)!", "Atenção")
    RestArea(aArea)
Return  
