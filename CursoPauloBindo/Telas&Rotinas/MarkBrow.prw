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

// TELA DE BROWSE COM MARCADORES E VISUALIZADOR DE LOTES
USER FUNCTION MkBrwSz1()
	Local aCpos := {}
	Local aCampos := {}
	Local nI := 0
	Local cAlias := "SZ1"
	Private aRotina := {}
	Private cCadastro := "Cadastro de UM por Clientes"
	Private aRecSel := {}

    //BOTOES
	AADD(aRotina,{"Visualizar Lote","U_VisLote",0,5})

    //CAMPOS DO BROWSE
	AADD(aCpos, "Z1_OK" )
	AADD(aCpos, "Z1_FILIAL" )
	AADD(aCpos, "Z1_CLIENT" )
	AADD(aCpos, "Z1_LOJA" )
	AADD(aCpos, "Z1_PRODUT" )
	AADD(aCpos, "Z1_FATOR" )
	dbSelectArea("SX3")
	dbSetOrder(2)
	// Monta array com os campos do browse 
	For nI := 1 To Len(aCpos)
		IF dbSeek(aCpos[nI])
			AADD(aCampos,{X3_CAMPO,"",IIF(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
		ENDIF
	Next

	DbSelectArea(cAlias)
	DbSetOrder(1)
	// Abre o MarkBrowse
	MarkBrow(cAlias,aCpos[1],"Z1_TIPO == ' '",aCampos,.F.,		GetMark(,"SZ1","Z1_OK"))
Return Nil

// ROTINA VISUALIZAR LOTE
USER FUNCTION VisLote()
	Local cMarca := ThisMark() // Marca selecionada no browse
	Local nX := 0
	Local lInvert := ThisInv() // Inverte a selecao do browse
	Local cTexto := ""
	Local cEOL := CHR(10)+CHR(13) // Quebra de linha
	Local oDlg // Objeto dialogo
	Local oMemo // Objeto memo para exibir os dados
	DbSelectArea("SZ1")
	dbSetOrder(1)
	DbGoTop()

	// Percorre os registros da tabela selecionando os marcados
	While !EOF()

		IF SZ1->Z1_OK == cMarca .AND. !lInvert
			AADD(aRecSel,{SZ1->(Recno()),SZ1->Z1_CLIENT, SZ1->Z1_LOJA, SZ1->Z1_PRODUT})
		ELSEIF SZ1->Z1_OK != cMarca .AND. lInvert
			AADD(aRecSel,{SZ1->(Recno()),SZ1->Z1_CLIENT,SZ1->Z1_LOJA, SZ1->Z1_PRODUT})
		ENDIF
		dbSkip()
	Enddo

	// Exibe os registros selecionados
	IF Len(aRecSel) > 0
		cTexto := "Cliente | Loja | Cod.Produto "+cEol
		// "1234567890123456789012345678901234567890
		// "CCCCCC | LL | NNNNNNNNNNNNNNNNNNNN +cEol

		// Monta o texto com os registros selecionados
		For nX := 1 to Len(aRecSel)
			cTexto+=aRecSel[nX][2]+Space(1)+"|"+Space(2)+aRecSel[nX][3] + Space(3)+"|"
			cTexto += Space(1)+SUBSTRING(aRecSel[nX][4],1,20)+Space(1)
			cTexto += cEOL
		Next nX
		// Cria o dialogo para exibir os dados
		DEFINE MSDIALOG oDlg TITLE "Clientes Selecionados" From 000,000 TO 350,400 PIXEL
		@ 005,005 GET oMemo VAR cTexto MEMO SIZE 150,150 OF oDlg PIXEL
		oMemo:bRClicked := {||AllwaysTrue()}
		DEFINE SBUTTON FROM 005,165 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTER
		LimpaMarca()
	ENDIF
RETURN

// ROTINA LIMPA MARCAÇÃO
STATIC FUNCTION LimpaMarca()
	Local nX := 0
	// Limpa a marcação dos registros
	For nX := 1 to Len(aRecSel)
		SZ1->(DbGoto(aRecSel[nX][1]))
		RecLock("SZ1",.F.)
		SZ1->Z1_OK := SPACE(2)
		MsUnLock()
	Next nX
Return()
