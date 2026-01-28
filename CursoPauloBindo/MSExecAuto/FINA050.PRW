#INCLUDE "Protheus.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

// Rotina para gerar pre-pagamentos automaticamente
User Function RAFINA050()
	Local aArea     := GetArea()
	
	Private cCadastro := "Cadastro de Pré-Pagamentos"
	Private oDlg
	Private oTempTable
	Private cAlias := "TIT"	
	
	// Monta um aRotina proprio                                          

	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
	{"Visualizar","AxVisual",0,2} ,;
	{"Gerar","U_FINAT3Func",0,7} }

	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

	Private cString := "SE2"

	dbSelectArea("SE2")
	dbSetOrder(1)


	dbSelectArea(cString)
	mBrowse( 6, 1,22,75,cString,,,,,, Fa040Legenda("SE2"))
	RestArea(aArea)
Return

// 	Rotina para gerar os pre-pagamentos
User Function FINAT3Func()
	Local cPerg := "FIAT03"
	Local nOpca := 0
	Local aAlter    :={} // Campos que podem ser alterados na GETDB
	Local oDlg
	Local aFields := {} // Campos do TempTable
	Local oTempTable

	Private aRotina := {{"","",0,4}} //0,4 = Rotina de Alteracao
	Private aHeader := {}
	Private cTipo  := SPACE(03)
	Private cPrefix:= SPACE(03)
	Private dDataP := dDataBase
	Private dDataE := dDataBase
	Private nUsado := 2
	Private lClose := .T.

	validperg(cPerg)

	If Pergunte(cPerg,.T.)
		//FAZ A SELECAO DE DADOS NO SE2 CONFORME PARAMETROS

		cQuery := " SELECT  E2_HIST, E2_PREFIXO, E2_NUM, E2_NATUREZ, E2_FORNECE,E2_NOMFOR, E2_VALOR, E2_EMISSAO, E2_TIPO, E2_CCUSTO,  E2_LOJA 
		cQuery += " FROM "+RetSqlName("SE2")+" "
		cQuery += " WHERE E2_PREFIXO BETWEEN '"+mv_par01+ "' AND '"+mv_par02+"'"
		cQuery += " AND E2_NATUREZ BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
		cQuery += " AND E2_FORNECE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
		cQuery += " AND E2_EMISSAO BETWEEN '"+Dtos(mv_par07)+"' AND '"+Dtos(mv_par08)+"'"
		cQuery += " AND D_E_L_E_T_ <> '*' AND E2__NUMTIT = '' AND E2_FORNECE <= '999999' "

		//FILTRA TITULOS QUE REPETEM TODO MES
		If mv_par09 == 1
			cQuery += " AND E2__REPETE = '1'"
		EndIf
		//FILTRA TIPO TITULO
		If !Empty(mv_par11)
			cQuery += " AND E2_TIPO = '"+mv_par11+"'"
		EndIf


		//cQuery := ChangeQuery(cQuery)
		MemoWrit("FINAT2Func.sql",cQuery)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
		TCSETFIELD("TRB","E2_EMISSAO","D") // TCSETFIELD PARA TIPOS DATA
		COUNT TO nRecCount
		//CASO TENHA DADOS ADICIONA NA MATRIZ
		If nRecCount > 0
			//CRIA ARQUIVO TEMPORARIO
			
			
			AADD(aFields,{"MARC","C",1,0})       //PREFIXO
			AADD(aFields,{"PREF","C",3,0})       //PREFIXO
			AADD(aFields,{"NUM" ,"C",9,0})       //NUMERO
			AADD(aFields,{"NAT" ,"C",10,0})      //NATUREZA
			AADD(aFields,{"FORN","C",6,0})       //CODIGO DO FORNECEDOR
			AADD(aFields,{"NFOR","C",20,0})      //NOME DO FORNECEDOR
			AADD(aFields,{"VALO" ,"N",14,2})      //VALOR
			AADD(aFields,{"EMIS","D",8,0})       //DATA DA EMISSAO
			AADD(aFields,{"TIPO","C",3,0})       //TIPO DO TITULO
			AADD(aFields,{"CCUS","C",6,0})       //CENTRO DE CUSTO
			AADD(aFields,{"NCCU","C",40,0})      //NOME DO CENTRO DE CUSTO
			AADD(aFields,{"LOJA","C",02,0})      //LOJA DO FORNECEDOR
			AADD(aFields,{"HIST","C",80,0})      //HISTORICO
			AADD(aFields,{"PYNO","C",60,0})      //NOME FORNECEDOR

			// Arquivo Auxiliar para Consultas
			//-------------------
			//Criação do objeto
			//-------------------
			oTempTable := FWTemporaryTable():New( cAlias ) // cria uma tabela temporaria

			//--------------------------
			//Monta os campos da tabela
			//--------------------------
			aadd(aFields,{"CAMPO","C",200,0})

			oTemptable:SetFields( aFields )

			oTempTable:AddIndex("01", {"PREF","NUM"} ) // cria um indice na tabela temporaria

			//------------------
			//Criação da tabela
			//------------------
			oTempTable:Create() // cria a tabela fisica
			

			dbSelectArea("TRB")
			dbGoTop()
			While !EOF()
				RecLock("TIT",.T.)
				If mv_par10 == 1
					MARC := "X"
				EndIf
				PREF := TRB->E2_PREFIXO
				NUM  := TRB->E2_NUM
				NAT  := TRB->E2_NATUREZ
				FORN := TRB->E2_FORNECE
				NFOR := TRB->E2_NOMFOR				
				VALO := TRB->E2_VALOR
				EMIS := TRB->E2_EMISSAO
				TIPO := TRB->E2_TIPO
				CCUS := TRB->E2_CCUSTO
				LOJA := TRB->E2_LOJA
				HIST := TRB->E2_HIST

				MsUnlock()
				dbSelectArea("TRB")
				dbSkip()
			End
			//MARCACAO
			AADD(aAlter,"MARC") // Campo que pode ser alterado na GETDB
			AADD(aHeader,{"Sel.","MARC","",1,0,"Pertence('X| ')",USADO,"C",""," "})
			//PREFIXO
			AADD(aHeader,{"Prefixo","PREF","",3,0,,USADO,"C",""," "})
			//NUMERO
			AADD(aHeader,{"Numero","NUM","",9,0,,USADO,"C",""," "})
			//NATUREZA
			AADD(aHeader,{"Natureza","NAT","",10,0,,USADO,"C","",""})
			//CODIDO DO FORNECEDOR
			AADD(aHeader,{"Fornecedor","FORN","",6,0,,USADO,"C",""," "})
			//LOJA DO FORNECEDOR
			AADD(aHeader,{"Loja","LOJA","",2,0,,USADO,"C",""," "})
			//NOME DO FORNECEDOR
			AADD(aHeader,{"N.Reduz","NFOR","",20,0,,USADO,"C",""," "})
			//NOME DO FORNECEDOR
			AADD(aHeader,{"Razao","PYNO","",60,0,,USADO,"C",""," "})
			//VALOR
			AADD(aAlter,"VALO") // Campo que pode ser alterado na GETDB
			AADD(aHeader,{"Valor","VALO","@E 999,999,999.99",14,2,,USADO,"N",""," "})
			//DATA DA EMISSAO
			AADD(aHeader,{"Emisao","EMIS","",8,0,,USADO,"D",""," "})
			//TIPO DO TITULO
			AADD(aHeader,{"Tipo","TIPO","",3,0,,USADO,"C",""," "})

			//HISTORICO
			AADD(aAlter,"HIST") // Campo que pode ser alterado na GETDB
			AADD(aHeader,{"Historico","HIST","",80,0,,USADO,"C",""," "})

			//CENTRO DE CUSTO
			AADD(aHeader,{"C Custo","CCUS","",6,0,,USADO,"C",""," "})
			//NOME DO CENTRO DE CUSTO
			//AADD(aHeader,{"Nome Custo","NCCU","",40,0,,USADO,"C",""," "})

			TRB->(dbCloseArea())
		Else
			MsgStop("Não foram encontrados dados!")
			TRB->(dbCloseArea())
			Return
		EndIf
		dbSelectArea("TIT")
		dbGotop()

		//TELA DO PRE PAGAMENTO
		DEFINE MSDIALOG oDlg TITLE "Pré-Pagamento" From 100,0 To 445,878 OF oMainWnd PIXEL
		@ 10,15 TO 129,135 LABEL OemToAnsi("Repetição") OF oDlg  PIXEL
		@ 25,20 RADIO oUsado VAR nUsado 3D SIZE 70,10 PROMPT  OemToAnsi("Continuar"),;
		OemToAnsi("Desmarcar") OF oDlg PIXEL
		@ 045,020 Say OemToAnsi("Tipo") SIZE 60,10 OF oDlg PIXEL
		@ 045,055 MSGET cTipo F3 "05" SIZE 15,10 OF oDlg PIXEL
		@ 065,020 Say OemToAnsi("Prefixo") SIZE 60,10 OF oDlg PIXEL
		@ 065,055 MSGET cPrefix  SIZE 15,10 OF oDlg PIXEL
		@ 090,020 Say OemToAnsi("Data Emissão") SIZE 60,10 OF oDlg PIXEL
		@ 090,085 MSGET dDataE SIZE 45,10 OF oDlg PIXEL Valid VerData(1)
		@ 102,020 Say OemToAnsi("Data Pagamento") SIZE 60,10 OF oDlg PIXEL
		@ 102,085 MSGET dDataP SIZE 45,10 OF oDlg PIXEL Valid VerData(2)
		oGetDb := MsGetDB():New(10,140,130,420,1,"Allwaystrue","Allwaystrue","",.F.,aAlter,,,,"TIT",,,,,,.T.)

		DEFINE SBUTTON FROM 137,323 TYPE 1 ACTION (Iif(!Empty(cPrefix).And.!Empty(cTipo),(nOpca:=1,oDlg:End()),MsgStop("O campo Pefixo e Tipo devem estar preenchidos"))) Of oDlg PIXEL ENABLE
		DEFINE SBUTTON FROM 137,350 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg CENTERED Valid lClose
		If nOpca == 1		
			MsgRun("Efetuando a cópia dos registros selecionados, Aguarde...","",{|| CursorWait(), U_FIAT3Grava() ,CursorArrow()})
		EndIf
		dbSelectArea("TIT")
		TIT->(dbCloseArea())
		oTempTable:Delete()

	EndIf

Return
  
// verifica se a data digitada e maior ou igual a database 
Static Function VerData(n)

	If n == 1
		If dDataE < dDataBase
			MsgStop("A data digitada é menor que a database!")
			lClose := .F.
		ElseIf dDataE <= dDataP
			lClose := .T.
		EndIf
	ElseIf n == 2
		If dDataE > dDataP 
			MsgStop("A data de Emissão é maior que a Data de Vencimento!")
			lClose := .F.
		ElseIf dDataE >= dDataBase
			lClose := .T.
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIAT2Grava  ºAutor  ³Paulo Bindo       º Data ³  09/15/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Insere os titulos no SE2                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIAT3Grava()
	Local nContErro := 0
	Local aTitulo 	:= {}
	Local nOpc    	:= 3


	dbSelectArea("TIT")
	dbGoTop()
	While !EOF()
		//CASO NAO TENHA SIDO SELECIONADO
		If !MARC $ "X"
			dbSkip()
			Loop
		EndIf

		cPrefixo := TIT->PREF
		cNumSE2  := GetSX8Num("SE2","E2_NUM")//BUSCA NUMERACAO DO SE2

		aTitulo := { {"E2_PREFIXO"	, cPrefix	,Nil},;
		{"E2_NUM"		,cNumSE2				,Nil},;
		{"E2_PARCELA"	,Space(01)				,Nil},;
		{"E2_TIPO"		,cTipo					,Nil},;
		{"E2_NATUREZ"	,TIT->NAT				,Nil},;
		{"E2_FORNECE"	,TIT->FORN				,Nil},;
		{"E2_LOJA"		,TIT->LOJA				,Nil},;
		{"E2_EMISSAO"	,dDataE					,Nil},;
		{"E2_VENCTO"	,dDataP					,Nil},;
		{"E2_VENCREA"	,DataValida(dDataP)		,Nil},;
		{"E2_VALOR"		,TIT->VALO		 		,Nil},;
		{"E2__REPETE"	,AllTrim(Str(nUsado))	,Nil},;
		{"E2_HIST"  	,TIT->HIST     			,Nil},;
		{"E2_CCUSTO"  	,TIT->CCUS	  			,Nil},;
		{"E2__NUMTIT"	,TIT->NUM				,Nil}}

		lMsErroAuto := .F.
		//GERA O TITULO NO SE2
		MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,nOpc) // 
		If lMsErroAuto
			nContErro ++
			RollBackSX8()
		Else                               
			ConfirmSX8()
		EndIf
		dbSelectArea("TIT")
		dbSkip()
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se gerou novo arquivo de erro, apaga o anterior e gera novo  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nContErro > 0
		cNomArqErro := NomeAutoLog() // NomeAutoLog() funçao da totvs que gera um arquivo
		cNomNovArq  := __RELDIR+"TITULOG.##R"
		If MsErase(cNomNovArq)
			__CopyFile(cNomArqErro,cNomNovArq)
		EndIf
		MsErase(cNomArqErro)
		If MsgYesNo(OemToAnsi("Ocorreram problemas com" + "  ( " + Ltrim(Str(nContErro,5)) + " )  " + "titulos durante o processo de integracao. Deseja visualiza-los agora?"),;
		OemToAnsi("Aten‡„o"))
			fVerLog() // Chama a rotina que visualiza o arquivo de log
		EndIf
	EndIf

Return

// Valida as perguntas da rotina
Static Function validperg(cPerg)

	//U_PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01 ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       	,cDefSpa3,cDefEng3,cDef04			,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	U_PutSx1(cPerg,"01"   ,"Do Prefixo         ?",""                    ,""                    ,"mv_ch1","C"   ,03      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""  	 ,""      ,""      ,""    ,""		,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"02"   ,"Ate o Prefixo      ?",""                    ,""                    ,"mv_ch2","C"   ,03      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par02",""  	 ,""      ,""      ,""    ,""		,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"03"   ,"Da Natureza        ?",""                    ,""                    ,"mv_ch3","C"   ,10      ,0       ,0      , "G",""    			,"SED" 	,""         ,""   ,"mv_par03",""  	 ,""      ,""      ,""    ,""		,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"04"   ,"Ate a Natureza     ?",""                    ,""                    ,"mv_ch4","C"   ,10      ,0       ,0      , "G",""    			,"SED" 	,""         ,""   ,"mv_par04",""  	 ,""      ,""      ,""    ,""		,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"05"   ,"Do Fornecedor      ?",""                    ,""                    ,"mv_ch5","C"   ,06      ,0       ,0      , "G",""    			,"SA2" 	,""         ,""   ,"mv_par05",""  	 ,""      ,""      ,""    ,""		,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"06"   ,"Ate o Fornecedor   ?",""                    ,""                    ,"mv_ch6","C"   ,06      ,0       ,0      , "G",""    			,"SA2" 	,""         ,""   ,"mv_par06",""  	 ,""      ,""      ,""    ,""		,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"07"   ,"Da Data            ?",""                    ,""                    ,"mv_ch7","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par07",""  	 ,""      ,""      ,""    ,""		,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"08"   ,"Ate a Data         ?",""                    ,""                    ,"mv_ch8","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par08",""  	 ,""      ,""      ,""    ,""		,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"09"   ,"Repete Mês         ?",""                    ,""                    ,"mv_ch9","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par09","Sim"  ,""      ,""      ,""    ,"Não"	,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"10"   ,"Traz Marcado       ?",""                    ,""                    ,"mv_chA","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par10","Sim"  ,""      ,""      ,""    ,"Não"	,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	U_PutSx1(cPerg,"11"   ,"Tipo		       ?",""                    ,""                    ,"mv_chB","C"   ,03      ,0       ,0      , "G",""    			,"05" 	,""         ,""   ,"mv_par11",""  	 ,""      ,""      ,""    ,""		,""     ,""      ,""	,""      ,""      ,""  	,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")


Return


