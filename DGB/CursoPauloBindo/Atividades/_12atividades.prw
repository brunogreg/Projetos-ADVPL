#include "Protheus.ch"

//aulas leitura de erro


User Function VerErros()
Local nNumero := ""// erro pois esta declarado como texto
Local aArray  := {{0,0,0}}//linhas 17 erro pois esta declarado com 3 colunas {{0,0,0}, {0,0,3}} seria o correto
Local cNumero := 0
//Local lTeste  := "TRUE" // erro pois esta declarado como texto
Local lTeste  := .T.


If nNumero >= 0 
    MsgAlert("NUMERO")
ENDIF


If aArray[2,2] == 3
    MsgAlert("ARRAY")
ENDIF

If cNumero > 0 
    MsgAlert("TEXTO")
ENDIF

If lTeste 
    MsgAlert("BOLEANO")
ENDIF





RETURN
