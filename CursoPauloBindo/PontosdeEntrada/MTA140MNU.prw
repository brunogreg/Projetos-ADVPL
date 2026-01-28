#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA140MNU º Autor ³ Paulo Bindo        º Data ³  16/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PONTO DE ENTRADA NA MONTAGEM DO MENU DO DOC.ENTRADA        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MTA140MNU()  // Ponto de Entrada do Menu de Documentos de Entrada

aAdd(aRotina,{"Importar XML","" ,0,3,0,.F.})
aAdd(aRotina,{"Ver Ped.Compra","" ,0,3,0,.F.})
//aAdd(aRotina,{OemToAnsi("Log Wamas - F5"),"U_ESTMI014('1',SF1->F1_CHVNFE)"	,0,6,0 ,NIL})
aAdd(aRotina,{OemToAnsi("Log Wamas - F5"),""	,0,6,0 ,NIL})

//SetKey(VK_F5,{|| U_ESTRD006('1',SF1->F1_CHVNFE)}) //LOG WAMAS
SetKey(VK_F5,{|| }) //LOG WAMAS
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA140MNU ºAutor  ³Microsiga           º Data ³  01/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function INFMT140PC()
Local cPesPC := Space(06)
Private n:= 0
Private l120Auto :=  .F.
PRIVATE nTipoPed := 1
Private n:= 1

@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Consulta Pedido Compra")
@ 9,9 Say OemToAnsi("Pedido") Size 99,8 Of oDlg
@ 28,9 Get cPesPC Picture "@!" F3 "SC7"  Size 59,10

@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
Activate Dialog oDlg Centered

If !Empty(cPesPC)
	dbSelectArea("SC7")
	dbSetOrder(1)
	If dbSeek(xFilial()+cPesPC)     
		If SC7->C7_CONAPRO == "B"
			MsgAlert("Pedido bloqueado em Compras!","INFMT140PC")
		EndIf 

		dbSelectArea("SY1")
		dbSetOrder(3)
		dbSeek(xFilial()+SC7->C7_USER)
		MsgInfo("Comprador: "+AllTrim(SY1->Y1_NOME),"MTA140MNU")

		dbSelectArea("SC7")
		A103VisuPC(Recno())
	Else
		MsgStop("Pedido não encontrado!","INFMT140PC")
	EndIf
EndIf

Return
