#INCLUDE "rwmake.ch"
#DEFINE ENTER Chr(13)+Chr(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บ Autor ณ AP6 IDE            บ Data ณ  14/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RAMATA410()

	cMensagem := " Este programa ira dividir os pedidos em aberto com bloqueio de estoque"+ENTER



	If MsgYesNo(cMensagem,"Divide Pedidos")
		Processa( {|| Execquebra() } )
	EndIf



Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQUEBRAPED บAutor  ณMicrosiga           บ Data ณ  10/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Execquebra()

	cQuery := " SELECT * FROM "+RetSqlName("SC5")
	cQuery += " WHERE C5_FILIAL = '"+xFilial("SC5")+"'  AND D_E_L_E_T_ <> '*' AND C5_NOTA = '' AND D_E_L_E_T_ <> '*'"

	MEMOWRITE("QUEBRAPED.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	TcSetField("TRB",'C5_EMISSAO','D')

	Count To nRec2

	ProcRegua(nRec2)

	dbSelectArea("TRB")
	dbGoTop()
	nConta := 0

	While !Eof()
		nConta++
		IncProc("Dividindo pedidos  "+StrZero(nConta,4)+" de "+StrZero(nRec2,4))
		ProcessMessages()
		aCab 			:= {}
		aItem 			:= {}
		aCabPV			:= {}
		aItemPV			:= {}
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial()+TRB->C5_CLIENTE)

		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial()+TRB->C5_NUM)
		//ITENS DO NOVO PEDIDO
		AAdd(aCabPV,{"C5_FILIAL"  	,xFilial("SC5")	,Nil}) 	// Filial
		AAdd(aCabPV,{"C5_TIPO"    	,SC5->C5_TIPO         	,Nil}) 	// Tipo de pedido
		AAdd(aCabPV,{"C5_CLIENTE" 	,SC5->C5_CLIENTE	   	,Nil}) // Codigo do cliente
		AAdd(aCabPV,{"C5_LOJACLI" 	,SC5->C5_LOJACLI    	,Nil}) // Loja do cliente
		AAdd(aCabPV,{"C5_CLIENT"  	,SC5->C5_CLIENT	   	,Nil}) // Codigo do cliente
		AAdd(aCabPV,{"C5_LOJAENT" 	,SC5->C5_LOJAENT     ,Nil}) // Loja para entrada
		AAdd(aCabPV,{"C5_TRANSP" 	,SC5->C5_TRANSP		,Nil}) // Codigo da TRANSPORTADORA
		AAdd(aCabPV,{"C5_TIPOCLI" 	,SC5->C5_TIPOCLI		,Nil}) // TIPO DO CLIENTE
		AAdd(aCabPV,{"C5_VEND1" 	,SC5->C5_VEND1		,Nil}) // VENDEDOR
		AAdd(aCabPV,{"C5_COMIS1" 	,SC5->C5_COMIS1		,Nil}) // COMISSAO
		AAdd(aCabPV,{"C5_CONDPAG" 	,SC5->C5_CONDPAG		,Nil}) // Codigo da condicao de pagamanto*
		AAdd(aCabPV,{"C5_EMISSAO" 	,SC5->C5_EMISSAO   	,Nil}) // Data de Entrega
		AAdd(aCabPV,{"C5_MENNOTA" 	,SC5->C5_MENNOTA		,Nil}) // Mensagem da nota
		AAdd(aCabPV,{"C5_LIBEROK" 	,SC5->C5_LIBEROK        	,Nil}) // Liberacao Total
		AAdd(aCabPV,{"C5_TIPLIB"  	,SC5->C5_TIPLIB        	,Nil}) // Tipo de Liberacao
		AAdd(aCabPV,{"C5_TPFRETE"  	,SC5->C5_TPFRETE		,Nil}) // tipo frete



		//ITENS DO PEDIDO A SER ALTERADO
		aAdd(aCab ,{"C5_NUM"		,TRB->C5_NUM		,NIL})
		aadd(aCab,{"C5_CLIENTE"     ,TRB->C5_CLIENTE   ,nil})
		aadd(aCab,{"C5_LOJACLI"     ,TRB->C5_LOJACLI	,nil})
		nCont := 0
		dbSelectArea("SC9")
		dbSetOrder(1)
		If dbSeek(xFilial()+TRB->C5_NUM)

			While !Eof() .And. SC9->C9_FILIAL == TRB->C5_FILIAL .And. SC9->C9_PEDIDO == TRB->C5_NUM
				nCont++
				If !Empty(SC9->C9_NFISCAL)
					dbSkip()
					Loop
				EndIf	
				//POSICIONA NO ITEM PARA BUSCAR INFORMACOES JA DIGITADAS
				dbSelectArea("SC6")
				dbSetOrder(1)
				dbSeek(xFilial()+TRB->C5_NUM+SC9->C9_ITEM)
				aAdd(aItem,{{"AUTDELETA",Iif(SC9->C9_BLEST == "02","S","N"),Nil},;
					{"C6_NUM"	,SC6->C6_NUM						,NIL},;
					{"C6_ITEM"				,SC6->C6_ITEM						,NIL},;
					{"C6_PRODUTO"			,SC6->C6_PRODUTO					,NIL},;
					{"C6_QTDVEN"			,SC6->C6_QTDVEN						,NIL},;
					{"C6_PRCVEN"			,SC6->C6_PRCVEN						,NIL},;
					{"C6_VALOR"				,SC6->C6_PRCVEN*SC6->C6_QTDVEN		,NIL},;
					{"C6_ENTREG"			,SC6->C6_ENTREG						,NIL},;
					{"C6_UM"				,SC6->C6_UM							,NIL},;
					{"C6_TES"				,SC6->C6_TES						,NIL},;
					{"C6_LOCAL"				,SC6->C6_LOCAL						,NIL},;
					{"C6_CLI"				,SC6->C6_CLI						,NIL},;
					{"C6_LOJA"				,SC6->C6_LOJA						,NIL},;
					{"C6_VALDESC"			,SC6->C6_VALDESC					,NIL},;
					{"C6_DESCONT"			,SC6->C6_DESCONT					,NIL},;
					{"C6_PRUNIT"			,SC6->C6_PRUNIT	 					,NIL},;
					{"C6_COMIS1"			,SC6->C6_COMIS1						,NIL}})


				If SC9->C9_BLEST == "02"
					aReg := {}
					AAdd(aReg, {"C6_FILIAL"		,SC6->C6_FILIAL		,Nil}) 	//1
					AAdd(aReg, {"C6_ITEM"		,SC6->C6_ITEM		,Nil})	//2
					AAdd(aReg, {"C6_PRODUTO"	,SC6->C6_PRODUTO		,Nil})	//4
					AAdd(aReg, {"C6_UM"     	,SC6->C6_UM	  		,Nil})	//5
					AAdd(aReg, {"C6_QTDVEN" 	,SC6->C6_QTDVEN		,Nil})	//6
					AAdd(aReg, {"C6_PRCVEN" 	,SC6->C6_PRCVEN		,Nil})	//7
					AAdd(aReg, {"C6_VALOR"  	,SC6->C6_VALOR		,Nil})	//8
					AAdd(aReg, {"C6_QTDLIB" 	,SC6->C6_QTDLIB		,Nil})	//9
					AAdd(aReg, {"C6_LOCAL"  	,SC6->C6_LOCAL		,Nil})	//10
					AAdd(aReg, {"C6_CLI"    	,SC6->C6_CLI 		,Nil})	//11
					AAdd(aReg, {"C6_ENTREG" 	,SC6->C6_ENTREG     	,Nil})	//12
					AAdd(aReg, {"C6_LOJA"   	,SC6->C6_LOJA 		,Nil})	//13
					AAdd(aReg, {"C6_PRUNIT" 	,SC6->C6_PRUNIT		,Nil})	//14
					AAdd(aReg, {"C6_COMIS1" 	,SC6->C6_COMIS1		,Nil})	//15
					AAdd(aReg, {"C6_OP"     	,SC6->C6_OP         	,Nil})	//16
					aAdd(aItemPV,aReg)
				EndIf

				Begin Transaction
					a460Estorna(.T.)
				End Transaction

				dbSelectArea("SC9")
				dbSkip()
			End

			If nCont <= Len(aItem) .And. Len(aItem) > 0
				lMsErroAuto := .F.
				If Len(aItemPV) >0
					lMsErroAuto := .F.
					//grava o pedido
					MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItemPV,3)
					If lMsErroAuto
						Conout("erro na inclusao do pedido de vendas: "+TRB->C5_NUM)
						MOSTRAERRO()
					Else
						lMsErroAuto := .F.
						//grava o pedido
						MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItem,4)
						If lMsErroAuto
							Conout("erro na alteracao do pedido de vendas: "+TRB->C5_NUM)
							MOSTRAERRO()
						EndIf

					EndIf
				EndIf
			EndIf
		EndIf

		dbSelectArea("TRB")
		dbSkip()
	End
	TRB->(dbCloseArea())
Return
