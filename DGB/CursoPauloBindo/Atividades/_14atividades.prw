#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MkBrwSz1   Autor ³ BRUNO GREGORIO     º Data ³  12/01/25   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ MARKBROWSE SZ1         E                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION MkBrwSA3()
	Local aCpos := {}
	Local aCampos := {}
	Local nI := 0
	Local cAlias := "SA3"
	Private aRotina := {}
	Private cCadastro := "Cadastro de Vendedor"
	Private aRecSel := {}

    //BOTOES
	AADD(aRotina,{"Visualizar Lote","U_VisLote2",0,5})

    //CAMPOS DO BROWSE
	AADD(aCpos, "A3_OK" )
	AADD(aCpos, "A3_FILIAL" )
	AADD(aCpos, "A3_COD" )
	AADD(aCpos, "A3_NOME" )
	AADD(aCpos, "A3_TIPVEND" )
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nI := 1 To Len(aCpos)
		IF dbSeek(aCpos[nI])
			AADD(aCampos,{X3_CAMPO,"",IIF(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
		ENDIF
	Next

	DbSelectArea(cAlias)
	DbSetOrder(1)
	MarkBrow(cAlias,aCpos[1],"A3_TIPVEND == '2'",aCampos,.F.,		GetMark(,"SA3","A3_OK"))
Return Nil

USER FUNCTION VisLote2()
	Local cMarca := ThisMark()
	Local nX := 0
	Local lInvert := ThisInv()
	Local cTexto := ""
	Local cEOL := CHR(10)+CHR(13)
	Local oDlg
	Local oMemo
	DbSelectArea("SA3")
	dbSetOrder(1)
	DbGoTop()

	While !EOF()

		IF SA3->A3_OK == cMarca .AND. !lInvert
			AADD(aRecSel,{SA3->(Recno()),SA3->A3_COD, Left(SA3->A3_NOME,20), SA3->A3_EST})
		ELSEIF SA3->A3_OK != cMarca .AND. lInvert
			AADD(aRecSel,{SA3->(Recno()),SA3->A3_COD, Left(SA3->A3_NOME,20), SA3->A3_EST})
		ENDIF
		dbSkip()
	Enddo

	IF Len(aRecSel) > 0
		cTexto := "Codigo | Nome                 | UF "+cEol
		       // "1234567890123456789012345678901234567890
		       // "CCCCCC | LLLLLLLLLLLLLLLLLLLL | NN +cEol

		For nX := 1 to Len(aRecSel)
			cTexto+=aRecSel[nX][2]+Space(1)+"|"+Space(1)+aRecSel[nX][3] + Space(1)+"|"
			cTexto += Space(1)+aRecSel[nX][4]+Space(1)
			cTexto += cEOL
		Next nX

		DEFINE MSDIALOG oDlg TITLE "Vendedores Selecionados" From 000,000 TO 350,400 PIXEL
		@ 005,005 GET oMemo VAR cTexto MEMO SIZE 150,150 OF oDlg PIXEL
		oMemo:bRClicked := {||AllwaysTrue()}
		DEFINE SBUTTON FROM 005,165 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTER
		LimpaMarca()
	ENDIF
RETURN

STATIC FUNCTION LimpaMarca()
	Local nX := 0
	For nX := 1 to Len(aRecSel)
		SA3->(DbGoto(aRecSel[nX][1]))
		RecLock("SA3",.F.)
		SA3->A3_OK := SPACE(2)
		MsUnLock()
	Next nX
Return()
