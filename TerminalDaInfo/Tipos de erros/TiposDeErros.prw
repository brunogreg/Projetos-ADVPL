//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"

// Simulando o erro Alias already in use / TABELA JA ESTA EM USO

User Function zErro01()
	Local aArea := GetArea()
	Local cQry  := ""
	Local cQry2 := ""

	//Selecionando todos os fornecedores
	cQry := " SELECT " + CRLF
	cQry += "     A2_COD, " + CRLF
	cQry += "     A2_NOME " + CRLF
	cQry += " FROM " + CRLF
	cQry += "     " + RetSQLName('SA2') + " SA2 " + CRLF
	cQry += " WHERE " + CRLF
	cQry += "     A2_FILIAL = '" + FWxFilial('SA2') + "' " + CRLF
	cQry += "     AND SA2.D_E_L_E_T_ = ' ' " + CRLF
	TCQuery cQry New Alias "QRY_SA2"

	//Selecionando dados de fornecedores de SP
	cQry2 := " SELECT " + CRLF
	cQry2 += "     A2_COD, " + CRLF
	cQry2 += "     A2_NOME " + CRLF
	cQry2 += " FROM " + CRLF
	cQry2 += "     " + RetSQLName('SA2') + " SA2 " + CRLF
	cQry2 += " WHERE " + CRLF
	cQry2 += "     A2_FILIAL = '" + FWxFilial('SA2') + "' " + CRLF
	cQry2 += "     AND A2_EST = 'SP' " + CRLF
	cQry2 += "     AND SA2.D_E_L_E_T_ = ' ' " + CRLF
	TCQuery cQry2 New Alias "QRY_SA2" //Aqui ocorre o erro, pois o alias QRY_SA2 já foi utilizado na consulta anterior NA LINHA 21

	QRY_SA2->(DbCloseArea())
	//QRY_SA2B->(DbCloseArea())
	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro Alias does not exist / ALIAS NAO EXISTE

User Function zErro02()
	Local aArea := GetArea()
	Local cQry  := ""

	//Selecionando todos os fornecedores
	cQry := " SELECT " + CRLF
	cQry += "     A2_COD, " + CRLF
	cQry += "     A2_NOME " + CRLF
	cQry += " FROM " + CRLF
	cQry += "     " + RetSQLName('SA2') + " SA2 " + CRLF
	cQry += " WHERE " + CRLF
	cQry += "     A2_FILIAL = '" + FWxFilial('SA2') + "' " + CRLF
	cQry += "     AND SA2.D_E_L_E_T_ = ' ' " + CRLF
	TCQuery cQry New Alias "QRY_SA2"

	//Mostrando o primeiro fornecedor encontrado
	Alert(QRY_SA->A2_NOME) //Aqui ocorre o erro, pois o alias utilizado na consulta foi QRY_SA2 e não QRY_SA LINE 57, SOLUÇAO SERIA ALTERAR PARA QRY_SA2
	QRY_SA2->(DbCloseArea())

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

// Simulando o erro Argument Error / ERRO DE ARGUMENTO 

User Function zErro03()
	Local aArea := GetArea()
	Local dData := Date() // UMA POSSIVEL SOLUÇÃO SERIA PASSAR A DATA COMO CARACTER, EX cData := "09/03/2026"

	//Mostrando a data
	Alert( sToD(dData) )// o erro ocorre pq a função sToD espera um argumento do tipo caracter e foi passado uma data, para corrigir o erro seria necessário passar a data como caracter ou utilizar a função dToS para converter a data em caracter

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro Array out of bounds / ERRO DE ARRAY FORA DOS LIMITES

User Function zErro04()
	Local aArea := GetArea()
	Local aDados := {}
	Local nPosicao := 4 //o erro inica aqui pois ele definiu a posiçao como 4 sendo que aDados so tem 3 posições, para corrigir o erro seria necessário definir nPosicao como 3 ou adicionar mais um elemento no array aDados para que ele tenha 4 posições ou mais

	//Adicionando elementos no array
	aAdd(aDados, "Daniel")
	aAdd(aDados, "Atilio")
	aAdd(aDados, "Terminal de Informacao")

	//Mostrando o quarto elemento
	Alert(aDados[nPosicao])

	// if nPosicao <= Len(aDados) uma possivel correção para esse erro
	//    Alert(aDados[nPosicao])
	// EndIf

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro Index not found / ERRO DE INDICE NAO ENCONTRADO

User Function zErro05()
	Local aArea := GetArea()

	DbSelectArea('SA2')
	SA2->(DbSetOrder(37))// O erro esta aqui posi chamou o indice 37 que nao existe na tabela
	SA2->(DbGoTop())

	//Mostrando o nome do fornecedor
	Alert(SA2->A2_NOME)

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro Duplicated Function / ERRO DE FUNÇÃO DUPLICADA

User Function zErro05() // O erro esta aqui pois o nome dessa userfuncion foi usado no escopo anterior e nao deve se repetir nome de user functions
	Local aArea := GetArea()

	Alert('Teste')

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

// Simulando o erro Enddo does not match while / EndIf does not match if / ERRO DE END DO NAO CORRESPONDE AO WHILE OU ENDIF NAO CORRESPONDE AO IF

User Function zErro07()
	Local aArea := GetArea()
	Local nValor := 10

	If nValor > 20
		Alert(nValor)
	EndDo // O erro esta aqui pois o correto seria EndIf para fechar a estrutura de decisão iniciada com If

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------  

//Bibliotecas
	#Include "TOTVS-.ch" // Nesse caso o erro encontra-se aqui pois o nome do include esta errado, o correto seria #Include "TOTVS.ch"

//Simulando o erro File not found ch / ERRO DE ARQUIVO CH NAO ENCONTRADO

User Function zErro08()
	Local aArea := GetArea()

	Alert('Tst')

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro Incorret syntax near / ERRO DE SINTAXE INCORRETA PRÓXIMO A

User Function zErro09()
	Local aArea := GetArea()
	Local cQry  := ""

	//Selecionando todos os fornecedores
	cQry := "SELECT"
	cQry += "    A2_COD,"
	cQry += "    A2_NOME"
	cQry += "FROM"
	cQry += "    " + RetSQLName('SA2') + " SA2"
	cQry += "WHERE"
	cQry += "    A2_FILIAL = '" + FWxFilial('SA2') + "'"
	cQry += "    AND SA2.D_E_L_E_T_ = ' '"
	TCQuery cQry New Alias "QRY_SA2"

    /*/  SOLUÇÃO SERIA ORGANIZAR OS ESPAÇOS E QUEBRAS DE LINHAS PARA QUE A QUERY SEJA GERADA CORRETAMENTE, COMO NO EXEMPLO ABAIXO:
	//Selecionando todos os fornecedores
	cQry := "SELECT" + CRLF
	cQry += "    A2_COD," + CRLF
	cQry += "    A2_NOME" + CRLF
	cQry += "FROM" + CRLF
	cQry += "    " + RetSQLName('SA2') + " SA2" + CRLF
	cQry += "WHERE" + CRLF
	cQry += "    A2_FILIAL = '" + FwxFilial('SA2') + "'" + CRLF
	cQry += "    AND SA2.D_E_L_E_T_ = ''" + CRLF

	TCQuery cQry New Alias "QRY_SA2"
    /*/

	//Se houver dados, mostra a mensagem
	If ! QRY_SA2->(EoF())
		Alert(QRY_SA2->A2_NOME)
	EndIf
	QRY_SA2->(DbCloseArea())

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro InterFunctionCall: cannot find function in AppMap / ERRO DE CHAMADA DE FUNÇÃO: NÃO É POSSÍVEL ENCONTRAR A FUNÇÃO NO APPMAP

User Function zErro10()
	Local aArea := GetArea()

	u_zFuncaoXYZ()

    /*/  SOLUÇÃO SERIA VERIFICAR SE O BLOCO EXISTE ANTES DE CHAMÁ-LO:
    If ExistBlock("u_zFuncaoXYZ")
        u_zFuncaoXYZ()
    EndIf
    /*/

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

// Simulando o erro Invalid field name in alias / ERRO DE NOME DE CAMPO INVÁLIDO NO ALIAS

User Function zErro11()
	Local aArea := GetArea()

	DbSelectArea('SB1')
	Alert(SB1->B1_X_DOCF) // O erro ocorre aqui pois o campo B1_X_DOCF não existe na tabela SB1, para corrigir o erro seria necessário verificar se o campo existe na tabela ou utilizar um campo que exista na tabela
    /*/ SOLUÇÃO
    If FieldPos("B1_X_DOCF", "SB1") > 0
        Alert(SB1->B1_X_DOCF)
    Else
        Alert("Campo B1_X_DOCF não existe na tabela SB1")
    EndIf
    /*/

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------


//Simulando o erro Invalid property / ERRO DE PROPRIEDADE INVÁLIDA

User Function zErro12()
	Local aArea := GetArea()
	Private oFont := TFont():New()

	oFont:AtributoAAA := "Teste"// O erro ocorre aqui pois o objeto TFont não possui a propriedade AtributoAAA, para corrigir o erro seria necessário verificar as propriedades disponíveis para o objeto TFont e utilizar uma propriedade válida ou criar uma propriedade personalizada se necessário
/*/ sOLUÇÃO
    if Type("oFont:AtributoAAA") != "U"
        oFont:AtributoAAA := "Teste"
    Else
        Alert("A propriedade AtributoAAA não existe para o objeto TFont")
    EndIf
    
/*/

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------


//Simulando o erro Invalid typecast / ERRO DE CONVERSÃO DE TIPO INVÁLIDA

User Function zErro13()
	Local aArea := GetArea()
	Local lOk

	For lOk := .T. To 10 //o erro esta aqui pois, nao e possivel eu ir de uma variavel logica ate o numero 10 a soluçao e definir a varialve
    // como nok := 1 e depois rodar o for

	Next

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro Local variable never used / VARIÁVEL LOCAL NUNCA USADA

User Function zErro14()
	Local aArea := GetArea()
	Local cNome := "Daniel"// o erro esta aqui pois a variavel cNome foi declarada e atribuida mas nunca foi utilizada em nenhum lugar do código, para corrigir o erro seria necessário utilizar a variavel cNome em algum lugar do código, como por exemplo mostrar um alerta com o valor da variavel ou concatenar ela com outra string e mostrar o resultado

    // a solução para esse caso seria remover a varial ou usar ela em algum lugar do código, como por exemplo:
    //Alert(cNome)

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------


//Simulando o erro Local declaration follows executable statement / DECLARAÇÃO LOCAL SEGUINDO UMA INSTRUÇÃO EXECUTÁVEL

User Function zErro15()
	Local aArea        := GetArea()
	Local cNome        := "Daniel"
	Private cSobreNome := "Atilio"
	Local cNomeInt     := cNome + " " + cSobreNome // o erro esta aqui pois a variavel cNomeInt foi declarada depois de uma instrução executável (a atribuição do valor), para corrigir o erro seria necessário declarar a variavel cNomeInt antes de qualquer instrução executável, como por exemplo:

    //a solução nesse caso seria subir a linha do local para ele vir antes dos private

	Alert(cNomeInt)

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------

//Simulando o erro More parameters used in function call than expected / MAIS PARÂMETROS USADOS NA CHAMADA DE FUNÇÃO DO QUE O ESPERADO

User Function zErro16()
	Local aArea        := GetArea()
	Local cNome        := "Daniel"

	fMostrar(cNome, "Atencao", "a")//o erro se encontra aqui pois esta sendo chamado 3 paramentros sendo que eu passei so dois na linha 327

	RestArea(aArea)
Return

Static Function fMostrar(cMensagem, cTitulo)
	MsgInfo(cMensagem, cTitulo)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro stack depth overflow in function / ESTOURO DE PROFUNDIDADE DE PILHA NA FUNÇÃO LOOPING INFINITO

User Function zErro17()
	Local aArea        := GetArea()
	Local cNome        := "Daniel"
	Private nVez       := 0

	fLooping(cNome)

	RestArea(aArea)
Return

Static Function fLooping(cNome)// o erro esta aqui pois ela incrementa nVez e continua chamando a função sem parar
	nVez++
	fLooping(cNome)

    /*/ SOLUÇÃO
     if nVez < 3
        nVez++
        fLooping(cNome)
     EndIf
    /*/

Return

//----------------------------------------------------------------------------------------------------------------------------------------------------


//Simulando o erro Statement unbalanced function in / ERRO DE DECLARAÇÃO DE FUNÇÃO DESEQUILIBRADA EM

User Function zErro18()
	Local aArea        := GetArea()
	Local cNome        := "Daniel"

	fMostrar(cNome)
	RestArea(aArea)
// O ERRO NESSE CASO ESTAO POIS FOI INICIADO UMA USER FUNCTION MAS NAO FOI FINALIZDA POR UM RETURN
Static Function fMostrar(cNome)
	Alert(cNome)
Return

//----------------------------------------------------------------------------------------------------

//Simulando o erro Statement unterminate at end of line/unbalanced parentesis/brackets / ERRO DE DECLARAÇÃO DE FUNÇÃO DESEQUILIBRADA NO FINAL DA LINHA/ PARENTESIS/ COLCHETES DESEQUILIBRADOS

User Function zErro19()
	Local aArea        := GetArea()
	Local cNome        := "Daniel"

	fMostrar(cNome//ERRO ESTA AQUI POIS O PARENTESIS DE FECHAMENTO ESTA FALTANDO

	RestArea(aArea)
Return

Static Function fMostrar(cNome)
	Alert(cNome)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------  

//Simulando o erro Static Function never called / FUNÇÃO ESTÁTICA NUNCA CHAMADA

User Function zErro20()
	Local aArea        := GetArea()
	Local cNome        := "Daniel"

	Alert(cNome)
    //SOLUÇÃO SERIA CHAMAR A FUNÇÃO ESTÁTICA EM ALGUM LUGAR DO CÓDIGO, COMO POR EXEMPLO:
    //fMostrar(cNome)
	RestArea(aArea)
Return

Static Function fMostrar(cNome)
	Alert(cNome)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------


//Simulando o erro String size overflow/ ESTOURO DE TAMANHO DE STRING

User Function zErro21() 
	Local aArea        := GetArea()
	Private cMsg       := Space(500000000)// ERRO ESTA AQUI POIS ESTA ACIMA DO PERMETIDO PARA O TAMANHO DE STRING, PARA CORRIGIR O ERRO SERIA NECESSÁRIO REDUZIR O TAMANHO DA STRING PARA UM VALOR PERMITIDO, COMO POR EXEMPLO
	//SOLUÇÃO SERIA REDUZIR O TAMANHO DA STRING PARA UM VALOR PERMITIDO, COMO POR EXEMPLO
    //Private cMsg       := Space(1000)
    Private nVez       := 0

	Alert(cMsg)

	RestArea(aArea)
Return


//  ----------------------------------------------------------------------------------------------------------------------------------------------------


//Simulando o erro Syntax Error / ERRO DE SINTAXE

User Function zErro22()
	Local aArea        := GetArea()

	STR_NOME := "Daniel Atilio"// O ERRO ESTA AQUI POIS NO MOMENTO ESTA COMO CONSTANTE, PARA CORRIGIR O ERRO SERIA NECESSÁRIO DECLARAR A VARIÁVEL ANTES DE ATRIBUIR O VALOR, COMO POR EXEMPLO:
    //Local STR_NOME := ""
    //STR_NOME := "Daniel Atilio"

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro Too few parameters calling / ERRO DE PARÂMETROS INSUFICIENTES NA CHAMADA DE FUNÇÃO

User Function zErro23()
	Local aArea  := GetArea()
	Local cNome  := ""

	cNome := "Daniel Atilio"

	MsgInfo()//O ERRO ESTA AQUI POIS A FUNÇÃO MsgInfo ESPERA PELO MENOS UM PARÂMETRO, PARA CORRIGIR O ERRO SERIA NECESSÁRIO PASSAR PELO MENOS UM PARÂMETRO PARA A FUNÇÃO MsgInfo, COMO POR EXEMPLO:
    //MsgInfo(cNome)

	RestArea(aArea)
Return


//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro Type mismatch on/ ERRO DE INCOMPATIBILIDADE DE TIPO EM

User Function zErro24()
	Local aArea  := GetArea()
	Local cNome  := "0"

	If cNome == 3 //ERRO ACUSOU POIS ESTOU TENTNADO ATRIBUIR UM VALOR NUMERICO A UMA VARIAVEL QUE ESPERA CARACTER
        //Val(cNome) == 3 // SOLUÇÃO SERIA UTILIZAR A FUNÇÃO VAL PARA CONVERTER O VALOR DE CARACTER PARA NUMÉRICO ANTES DE REALIZAR A COMPARAÇÃO
		Alert("igual a 3")
	EndIf

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro Unsupported assign to function call / ERRO DE ATRIBUIÇÃO NÃO SUPORTADA PARA CHAMADA DE FUNÇÃO

User Function zErro25()
	Local aArea  := GetArea()
	Local cNome  := ""

	Alert("Daniel") := cNome // toda vez que tem parentese quer dizer que e uma função e nao podemos atribuir valores a funçoes
    // SOLUÇÃO SERIA ATRIBUIR O VALOR A VARIÁVEL E DEPOIS CHAMAR A FUNÇÃO COM A VARIÁVEL COMO PARÂMETRO, COMO POR EXEMPLO:
    //cNome := "Daniel"
    //Alert(cNome)

	RestArea(aArea)
Return

//----------------------------------------------------------------------------------------------------------------------------------------------------

//Simulando o erro Variable does not exist / ERRO DE VARIÁVEL INEXISTENTE

User Function zErro26()
	Local aArea  := GetArea()
    //local nVar := 0 seria a solução para esse caso

	nVar++// erro aqui pois a variavel nao foi declarada antes 
	Alert(nVar)

	RestArea(aArea)
Return


//----------------------------------------------------------------------------------------------------------------------------------------------------


//Simulando o erro Variable redefined / ERRO DE VARIÁVEL REDEFINIDA

User Function zErro27()
	Local aArea  := GetArea()
	Local cNome  := "Daniel"
	Local nVar   := 0
	Local cNome  := ""// erro aqui pois esta em duplicidade de cariavel cNome, para corrigir o erro seria necessário remover a segunda declaração da variável cNome ou utilizar um nome diferente para a segunda variável, como por exemplo:
    //Local cNome2 := ""

	nVar++
	Alert(nVar)

	RestArea(aArea)
Return
