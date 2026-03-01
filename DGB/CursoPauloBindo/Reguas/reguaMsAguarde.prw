#include "Protheus.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} regua processa
regua para relatorios
@type user function
@author    paulo.bindo
@version   11.3.10.201812061821
@since     21/06/2019
/*/


USER FUNCTION PBMsA()
	PRIVATE lEnd := .F.
	MsAguarde({|lEnd| RunProc(@lEnd)},"Aguarde...","Processando SX5",.T.)
RETURN

//****************************
STATIC FUNCTION RunProc(lEnd)
	dbSelectArea("SX5")
	dbSetOrder(1)
	dbGoTop()
	While !Eof()
		If lEnd
			MsgInfo(cCancel,"Fim")
			Exit
		Endif
		// ProcessMessage() força a regua atualizar
        ProcessMessage() 
		MsProcTxt("Tabela: "+SX5->X5_TABELA+" Chave: "+SX5->X5_CHAVE)
		dbSkip()
	End
RETURN
