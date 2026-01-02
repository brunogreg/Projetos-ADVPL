#include "Protheus.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} regua processa
regua para relatorios

@author    paulo.bindo
@version   11.3.10.201812061821
@since     21/06/2019
/*/

User Function PBProc()
	Local aSay := {}
	Local aButton := {}
	Local nOpc := 0
	Local cTitulo := "Exemplo de Funções"
	Local cDesc1 :="Utilização da função Processa()"
	Local cDesc2 := " em conjunto com as funções de incremento ProcRegua() e"
	Local cDesc3 := " IncProc()"
	

	AADD( aSay, cDesc1 )
	AADD( aSay, cDesc2 )
    AADD( aSay, cDesc3 )	
	AADD( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
	AADD( aButton, { 2, .T., {|| FechaBatch() }} )
	FormBatch( cTitulo, aSay, aButton )
	If nOpc <> 1
		Return 
	Endif
	Processa( {|lEnd|RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )
Return 

//************************************************

Static Function RunProc(lEnd)
	Local nCnt := 0
    Local cCancel := "Cancelado pelo usuario"

	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5")+"01",.T.)
	dbEval( {|x| nCnt++ },,{||X5_FILIAL==xFilial("SX5").And.X5_TABELA<="99"})
    
    ProcRegua(nCnt)

	dbSeek(xFilial("SX5")+"01",.T.)
	While !Eof() .And. X5_FILIAL == xFilial("SX5") .And. X5_TABELA <= "99"
		IncProc("Processando tabela: "+SX5->X5_CHAVE)
		If lEnd
			MsgInfo(cCancel,"Fim")
			Exit
		Endif
		dbSkip()
	End
Return 
