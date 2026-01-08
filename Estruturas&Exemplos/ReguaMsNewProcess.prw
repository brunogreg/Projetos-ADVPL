#include "Protheus.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} regua processa
regua para relatorios
@type user function
@author    paulo.bindo
@version   11.3.10.201812061821
@since     21/06/2019
/*/

User Function PBMsN()
	Private oProcess := NIL
	oProcess := MsNewProcess():New({|lEnd| RunProc(lEnd,oProcess)} ,"Processando","Lendo...",.T.)
	oProcess:Activate()
Return 

// Regua de processamento duplo pois gera duas reguas

Static Function RunProc(lEnd,oObj)
	Local i := 0
	Local aTabela := {}
	Local nCnt := 0

	aTabela := {{"00",0},{"01",0},{"12",0}}
	dbSelectArea("SX5")
	cFilialSX5 := xFilial("SX5")

	dbSetOrder(1)
	For i:=1 To Len(aTabela)
		dbSeek(cFilialSX5+aTabela[i,1])
		While !Eof() .And. X5_FILIAL+X5_TABELA == cFilialSX5+aTabela[i,1]
			If lEnd
				Exit
			Endif
			nCnt++
			dbSkip()
		End
		aTabela[i,2] := nCnt
		nCnt := 0
	Next i


	oObj:SetRegua1(Len(aTabela))
	For i:=1 To Len(aTabela)
		If lEnd
			Exit
		Endif
		oObj:IncRegua1("Lendo Tabela: "+aTabela[i,1])
		dbSelectArea("SX5")
		dbSeek(cFilialSX5+aTabela[i,1])
		oObj:SetRegua2(aTabela[i,2])
		While !Eof() .And. X5_FILIAL+X5_TABELA == cFilialSX5+aTabela[i,1]
			oObj:IncRegua2("Lendo chave: "+X5_CHAVE)
			If lEnd
				Exit
			Endif
			dbSkip()
		End
	Next i
Return
