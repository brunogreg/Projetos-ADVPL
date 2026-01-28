#include "Protheus.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} regua rptstatus
regua para relatorios

@author    paulo.bindo
@version   11.3.10.201812061821
@since     21/06/2019
/*/

// A regua rptstatus é que mais usadas para relatorios, geralmente e uma regua que deve obter duas funçoes pelo menos para funcionar e encrementar
User Function PBRpt()
	Local aSay := {}
	Local aButton := {}
	Local nOpc := 0
	Local cTitulo := "Exemplo de Funções"
	Local cDesc1 := "Este programa exemplifica a utilização da função Processa() em conjunto"
	Local cDesc2 := "com as funções de incremento ProcRegua() e IncProc()"
	
	
    AADD( aSay, cDesc1 )
	AADD( aSay, cDesc2 )
	AADD( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
	AADD( aButton, { 2, .T., {|| FechaBatch() }} )
	//A funcao FormBatch assim como msdialog abre um telinha 
	FormBatch( cTitulo, aSay, aButton )
	If nOpc <> 1
		Return 
	Endif
	RptStatus({|lEnd|RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )
Return 


//******************************************************************

Static Function RunProc(lEnd)
	Local nCnt := 0
    Local cCancel := "Cancelado pelo usuario"


	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5")+"01",.T.)
	While !Eof() .And. X5_FILIAL == xFilial("SX5") .And. X5_TABELA <= "99"
		nCnt++ //armazenou quantos registros tem na sc5
		dbSkip()
	End

SetRegua(nCnt)//informa quantos registro tem a regua

	dbSeek(xFilial("SX5")+"01",.T.)
	While !Eof() .And. X5_FILIAL == xFilial("SX5") .And. X5_TABELA <= "99"
		IncRegua()//cada vez que passa por essa função ele incrmenta a regua
		If lEnd
			MsgInfo(cCancel,"Fim")
			Exit
		Endif
		dbSkip()
	End
Return
