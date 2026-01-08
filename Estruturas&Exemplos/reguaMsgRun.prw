#include "Protheus.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} regua processa
regua para relatorios
@type user function
@author    paulo.bindo
@version   11.3.10.201812061821
@since     21/06/2019
/*/

USER FUNCTION PBMsgRun()
	LOCAL nCnt := 0
	dbSelectArea("SX1")
	dbGoTop()
	//Ele exibe uma mensagem mas nao gera regua
	MsgRun("Lendo arquivo, aguarde...","titulo opcional",{||dbEval({|x| nCnt++}) })
	MsgInfo("FIM!!!, Total de "+AllTrim(Str(nCnt))+" registros",FunName())
RETURN()
