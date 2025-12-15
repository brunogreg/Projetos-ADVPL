#INCLUDE "Protheus.ch"
#INCLUDE "msmgadd.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"

User Function estruturaBlocos()
	Local nItem  := 100
	Local bBloco := {|x| Y := 5, Z := x * y } //x = ao nItem que equivale a 100

	// Executa o bloco passando nItem como parâmetro
	Local nValor := Eval(bBloco, nItem) //eval e quem executa o bloco de codigo

	ConOut(nValor)

Return
static Function Blocos2dbval()

	Local cTab := "12" //tabela 12 de estados
	Local nCnt := 0
	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" //simula a abertura do proteus abre tabelas e variaveis

	dbSelectArea("SX5") //comando para abrir uma tabela no banco ou no dicionario de dados
	dbSetOrder(1) // ele vai abrir o indice que eu quero, vai por na tabela sx5 e vai colocar no primeiro registro
	dbGoTop() //vai para o começo de todos os arquivos da tabela

	While !Eof() .And. X5_FILIAL == xFilial("SX5") .And. X5_TABELA <= cTab //While !Eof() significa que enquanto nao for o fim do arquivo
		nCnt++
		dbSkip()
	EndDo

	RESET ENVIRONMENT //PRA FECHAR O PROTHEUS
	//dbEval( {|x| nCnt++ }, , , {|| X5_FILIAL == xFilial("SX5") .And. X5_TABELA <= cTab })
	//dbval e pra trabalhar com tabelas executar açoes dentro de tabelas

Return

User Function aEval()

    Local aCampos := 0
    Local nX := 0

	AADD(aCampos, "C5_FILIAL") //os campos que preciso
	AADD(aCampos, "C5_NUM") // os campos que preciso

	SX3->(dbSetOrder(2)) //vai abrir na tabela sx3 ordem 2
	For nX := 1 To Len(aCampos)
		SX3->(dbSeek(aCampos[nX]))
		aAdd(aTitulos, AllTrim(SX3->X3_TITULO))
	Next nX


// O mesmo pode ser re-escrito com o uso da função AEVAL():
	aTitulos := {}
	SX3->(dbGoTop())
	aEval(aCampos, {|x| SX3->(dbSeek(x)), AAdd(aTitulos, AllTrim(SX3->X3_TITULO))})
//aeval vai pegar os dois valores dentro de aacampos, e vai colocar como x, vai na x3 e posiciona no x e depois adiciona dentro de atitulus o titulo
	RESET ENVIRONMENT

Return
