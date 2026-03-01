#Include "Protheus.ch"
#Include "ParmType.ch"
#Include "TopConn.ch"

Static cEol := Chr(13)+Chr(10)

User function UCOMR002()

	Local oReport
	Local aArea 	:= GetArea()
	Local aPergunte := {}
	Private cPerg 	:= "UCOMR002"

	if fPergunte(@aPergunte)

		if fGeraQry(aPergunte)

			oReport := ReportDef(aPergunte)
			oReport:PrintDialog()

		else

			MsgAlert("Não foram encontrados dados com base no preenchimento dos parametros!","Atenção!")

		endif

	endif

	RestArea(aArea)

Return(Nil)


Static Function fPergunte(_aPergunte)

	Local aPar 			:= {}
	Local lRet 			:= .F.
	Default _aPergunte 	:= {}

	aAdd(aPar,{1,"ZB2_PRODUT",Space(TamSX3("ZB2_PRODUT")[1]) 	,""	,".T."	,""	    ,""	,60		,.F.})
	//aAdd(aPar,{1,"ZB2_PRODUT",Space(15), "", ".T.", "SB1", "B1_DESC", 60, .F.})


	lRet := ParamBox(aPar,"Parametros",@_aPergunte)

Return(lRet)

//---------------------------------------------------------
// DefiniÃ§ao da estrutura do relatorio
//---------------------------------------------------------
Static Function ReportDef(aPergunte)

	Local oReport
	Local oDet
	Local cTitle   		:= "Relatorio de Requisitantes"
	Default aPergunte 	:= {}

	oReport:= TReport():New("UCOMR002",cTitle,cPerg,{|oReport| PrintReport(oReport,oDet)},"Este relatorio apresenta uma relação das consultas.")

	oReport:SetPortrait()		// orientação paisagem
	//oReport:SetCustomText( {|| Cabec(oReport,aPergunte) })
	//oReport:HideHeader()  		// Nao imprime cabeçalho padrão do Protheus
	//oReport:HideFooter()			// Nao imprime rodapÃ© padrÃ£o do Protheus
	oReport:HideParamPage()			// Inibe impressao da pagina de parametros
	oReport:SetUseGC(.F.) 			// Habilita o botÃ£o <Gestao Corporativa> do relatorio
	//oReport:DisableOrientation()  // Desabilita a seleção da orientação (retrato/paisagem)
	//oReport:cFontBody := "Arial"
	oReport:nFontBody := 7

	Pergunte(oReport:GetParam(),.F.)

	oDet  := TRSection():New(oReport,"Saldos dos produtos",{"ZB2"},,,,)

	TRCell():New(oDet,"ZB2_NOME"	    , "", /*Titulo*/	, /*Picture*/			, 22        	, /*lPixel*/	,/*bConteudo*/)
	TRCell():New(oDet,"ZB2_FILIAL"	, "", /*Titulo*/	, /*Picture*/			, /*Tamanho*/	, /*lPixel*/	,/*bConteudo*/)
	TRCell():New(oDet,"ZB2_EMAIL"	, "", /*Titulo*/	, /*Picture*/			, /*Tamanho*/	, /*lPixel*/	,/*bConteudo*/)
	TRCell():New(oDet,"ZB2_PRODUT"		, "", /*Titulo*/	, /*Picture*/	    	, /*Tamanho*/	, /*lPixel*/	,/*bConteudo*/)
	TRCell():New(oDet,"ZB2_LIMITE"	, "", /*Titulo*/	, /*Picture*/	    	, /*Tamanho*/	, /*lPixel*/	,/*bConteudo*/)
	TRCell():New(oDet,"ZB2_VALOR"	, "", /*Titulo*/	, /*Picture*/	    	, /*Tamanho*/	, /*lPixel*/	,/*bConteudo*/)	
	oReport:SetTotalInLine(.F.)

Return(oReport)

//---------------------------------------------------------
// Faz impressÃ£o do relatorio
//---------------------------------------------------------
Static Function PrintReport(oReport,oDet)

	Local oTmp		:= oDet

	While TMPZB2->(!EOF())

		oTmp:Init()
		oReport:IncMeter()

		oTmp:Cell("ZB2_FILIAL"	    ):SetValue(TMPZB2->ZB2_FILIAL)
		oTmp:Cell("ZB2_NOME"	):SetValue(TMPZB2->ZB2_NOME)
		oTmp:Cell("ZB2_PRODUT"	):SetValue(TMPZB2->ZB2_PRODUT)
		oTmp:Cell("ZB2_LIMITE"		):SetValue(TMPZB2->ZB2_LIMITE)
		oTmp:Cell("ZB2_VALOR"	):SetValue((TMPZB2->ZB2_VALOR))
		oTmp:Cell("ZB2_EMAIL"	):SetValue((TMPZB2->ZB2_EMAIL))		

		oTmp:PrintLine()

		//Se cancelar abandona o laco
		If oReport:Cancel()

			Exit

		ENDIF

		TMPZB2->(DbSkip())

	EndDo

	oTmp:Finish()

Return()

Static Function fGeraQry(aPergunte)

	Local cCodigo        := aPergunte[1]

	Local cQry 			:= ""
	Default aPergunte 	:= {}

	cQry := " SELECT *	                                        " + cEol
	cQry += " FROM " + RetSqlName("ZB2") + " ZB2            	            " + cEol

	cQry += " WHERE ZB2.D_E_L_E_T_ = ' '	                        " + cEol
	if !Empty(cCodigo)
		cQry += " AND ZB2_PRODUT    = '"+cCodigo+"'    " + cEol
	Endif


	if Select("TMPZB2") > 0

		TMPZB2->(DbCloseArea())

	endif

	TcQuery cQry New Alias "TMPZB2"

	MemoWrite( "c:\temp\cQry.sql", cQry )

	TMPZB2->(DbSelectArea("TMPZB2"))
	TMPZB2->(DbGoTop())

Return(!TMPZB2->(Eof()))
