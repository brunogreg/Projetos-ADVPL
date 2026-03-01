#INCLUDE "protheus.ch"
#DEFINE ENTER Chr(13)+Chr(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RAMATA240 º Autor ³ AP6 IDE            º Data ³  15/02/22   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ROTINA AUTOMATICA MOVIMENTACAO INTERNA                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RAMATA240()


If RetCodUsr() # "000000"
	MsgStop("Usuario sem premissao","RAMATA240")
	Return
EndIf


cMensagem := " Este programa ira executar comando"+ENTER
cMensagem += " para Expemplo rotina automatica movimentacao interna"


If MsgYesNo(cMensagem,"RAMATA240")
	Processa( {|| ra240() } )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RAMATA240ºAutor  ³Microsiga           º Data ³  12/28/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ra240()

	
	//TRANSFERIR DO NL PARA 01 TODOS OS SALDOS DE MAIS DE 1 LOCALIZACAO
	cQuery := " SELECT * FROM "+RetSqlName("SB2")+" WHERE B2_FILIAL = '"+cFilAnt+"' AND B2_QATU > 0 AND D_E_L_E_T_ <> '*'"
	
	MemoWrite("RAMATA240.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
	
	Count To nRec
	
	If nRec > 0
		
		ProcRegua(nRec)
		dbSelectArea("TRB")
		dbGoTop()
		
		While !Eof()
			IncProc("REQUISITANDO ITENS ESTOQUE ")
			
			
			cNumseq := ProxNum()
			cNumDoc  := NextNumero("SD3",2,"D3_DOC",.T.)//BUSCA NUMERACAO DO SD3
			nQuant := 1

			aReg := { {"D3_COD"	,TRB->B2_COD	,Nil},;
			{"D3_LOCAL"		,TRB->B2_LOCAL		,Nil},;
			{"D3_NUMSEQ"	,cNumSeq 			,Nil},;
			{"D3_DOC"		,cNumDoc 			,Nil},;
			{"D3_LOCALIZ"	,""					,Nil},;
			{"D3_QUANT"		,nQuant				,Nil},;
			{"D3_TM"		,"501" 				,Nil},;
			{"D3_OBS"		,"CONSUMO INTERNO RAMATA240"	,Nil}}
			
			
			lMsErroAuto := .F.
			//GERA O TITULO NO SD3
			MSExecAuto({|x,y,z| MATA240(x,y,z)},aReg,,3)
			Conout("Requisicao interna efetuada "+cNumDoc)
			If lMsErroAuto
				Mostraerro()
			EndIf
			
			
			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())
	



Return

