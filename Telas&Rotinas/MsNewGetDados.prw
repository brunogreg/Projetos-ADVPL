#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³CTPCD100  ºAutor  ³Microsiga           º Data ³  02/24/17   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³CADASTRO DE MOTIVO DE DESCONTO EM TITULOS A RECEBER         º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTPCD100()
	Local aAreaAtu:=GetArea()
	Local cFiltTop:=""
	Private cCadastro:= "Cadastro de motivos de desconto em títulos a receber"
	Private aRotina:=MenuDef()


	cFiltTop:=" X5_TABELA='00' AND SUBSTRING(X5_CHAVE,1,2)='P0' "

	mBrowse(6,1,22,75,"SX5",,,,,,,,,,,,,,cFiltTop)
	RestArea(aAreaAtu)
Return()

User Function CD100MAN(cAlias,nReg,nOpc)
	Local cAliasQry:=GetNextAlias()
	Local aAreaAtu:=GetArea()
	Local aSize
	Local aObjects
	Local aInfo
	Local aSize := {}
	Local aPosObj,aPosGet
	Local aAltEnchoice:={}
	Local aMyEncho:={"X5_TABELA","X5_CHAVE","X5_DESCRI"}
	Local aCposGet :={"X5_CHAVE","X5_DESCRI"}
	Local aButtons:={}
	Local lContinua:=.F.
	Local cDescTab:=""
	Local oFonte01 := Nil
	Local oMenTabe :=Nil

	Private aHeadSX5:={}
	Private aColsSX5:={}

	cTabela:=SX5->X5_CHAVE
	cDescTab:=SX5->X5_DESCRI

	SX3->(DbSetOrder(2))
	For nInd:=1 To Len(aCposGet)
		If SX3->(DbSeek(aCposGet[nInd]))
			Aadd(aHeadSX5,{TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				"",;
				"" })
		EndIf
	Next
	ADHeadRec(cAlias,aHeadSX5)
	cQuery:=" Select X5_CHAVE,X5_DESCRI,'SX5' X5_ALI_WT ,R_E_C_N_O_ X5_REC_WT From "+RetSqlName("SX5")+" SX5 "
	cQuery+=" Where SX5.D_E_L_E_T_=' ' "
	cQuery+=" And SX5.X5_FILIAL='"+xFilial("SX5")+"'"
	cQuery+=" And SX5.X5_TABELA='"+cTabela+"'"
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAliasQry, .F., .F. )
	aColsSX5:={}

	Do While (cAliasQry)->(!Eof())
		AADD(aColsSX5,Array(Len(aHeadSX5)+1))
		nLinha:=Len(aColsSX5)

		For nInd:=1 To (cAliasQry)->(FCount())
			aColsSX5[nLinha,GDFieldPos( FieldName(nInd),aHeadSX5 )]:= (cAliasQry)->(FieldGet(nInd))
		Next
		aColsSX5[nLinha,Len(aHeadSX5)+1]:=.F.
		(cAliasQry)->(DbSkip())
	EndDo

	(cAliasQry)->(DbCloseArea())
	DbSelectArea(cAlias)

	aSize := MsAdvSize()
	aObjects := {}
	aAdd( aObjects, { 000, 030, .t., .f. } )
	aAdd( aObjects, { 100, 150, .t., .t. } )

	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

	oFonte01 := TFont():New("Courier New",009,040,,.T.)
	oMenTabe	:= TSay():New(aPosObj[1][1]+05,05,{||"Tabela: "+cTabela+"-"+cDescTab },oDlg,,oFonte01,,,,.T.)
	oMenTabe:nClrText := CLR_HBLUE

	oGetDados := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],Iif(nOpc<>2,GD_INSERT+GD_DELETE+GD_UPDATE,0),"u_CD100LOK()","u_CD100TOK()",/*'*/,/*aAlterGDa*/,/*nFreeze*/,/*nMax*/,/*cFieldOk*/,/*cSuperDel*/,/*cDelOk*/ ,oDlg,aHeadSX5,aColsSX5)

	Activate MsDialog oDlg On Init EnchoiceBar(oDlg,{|| IIf(oGetDados:TudoOk(),(lContinua:=.T.,oDlg:End()),)  },{|| oDlg:End() },,aButtons)

	If nOpc<>2 .And. lContinua
		CD100GRV()
	EndIf

	RestArea(aAreaAtu)
Return


User Function CD100LOK(nLinha)
	Local lRetorno:=.T.
	Local aCpos:={"X5_CHAVE","X5_DESCRI"}
	Local cChave:=""

	Default nLinha:=oGetDados:nAt

	lRetorno:=GdNoEmpty( aCpos , nLinha , aHeadSX5 , oGetDados:aCols , , , .T. )

	If lRetorno
		cChave:=GdFieldGet( "X5_CHAVE",nLinha,,aHeadSX5 , oGetDados:aCols )

		For nInd:=1 To Len(oGetDados:aCols)

			If nLinha==nInd .Or. GdDeleted( nInd , aHeadSX5 , oGetDados:aCols )
				Loop
			EndIf

			If cChave==GdFieldGet( "X5_CHAVE",nInd,,aHeadSX5 , oGetDados:aCols )
				Aviso(	"CD100LOK",;
					"Chave já "+cChave+" cadastrada nas linha "+AllTrim(Str(Min(nLinha,nInd))) +" e " +AllTrim(Str(Max(nInd,nLinha))),;
					{ "&Retorna" },,;
					"Chave Duplicada " )
				lRetorno	:=  .F.
				Exit
			EndIf
		Next

	EndIf

Return lRetorno

User Function CD100TOK()
	Local nInd

	For nInd:=1 To Len(oGetDados:aCols)
		If !U_CD100LOK(nInd)
			Return .F.
		EndIf
	Next

Return .T.

Static Function CD100GRV()
	Local nInd
	SX5->(DbSetOrder(0))
	For nInd:=1 To Len(oGetDados:aCols)

		nRecSX5:=GdFieldGet( "X5_REC_WT" , nInd ,  , aHeadSX5 , oGetDados:aCols )
		If nRecSX5>0
			SX5->(DbGoTo(nRecSX5))
			SX5->(RecLock("SX5",.F.))
		EndIf

		If GdDeleted( nInd , aHeadSX5 , oGetDados:aCols )
			If nRecSX5>0
				SX5->(DbDelete())
				SX5->(MsUnLock())
			EndIf
			Loop
		EndIf
		If nRecSX5==0
			SX5->(RecLock("SX5",.T.))
			SX5->X5_FILIAL:=xFilial("SX5")
			SX5->X5_TABELA:=cTabela
		EndIf
		SX5->X5_CHAVE  :=GdFieldGet( "X5_CHAVE"  , nInd ,  , aHeadSX5 , oGetDados:aCols )
		SX5->X5_DESCRI :=GdFieldGet( "X5_DESCRI" , nInd ,  , aHeadSX5 , oGetDados:aCols )
		SX5->X5_DESCSPA:=SX5->X5_DESCRI
		SX5->X5_DESCENG:=SX5->X5_DESCRI
		SX5->(MsUnLock())
	Next
Return

Static Function MenuDef()
	Local aRotina := { { "Pesquisar" ,  "AxPesqui"  , 0 , 1},;
		{ "Visualizar",   "U_CD100MAN", 0 , 2},;
		{ "Alterar",   "U_CD100MAN", 0 , 4}}
Return(aRotina)
