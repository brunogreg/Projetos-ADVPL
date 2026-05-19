#Include "Protheus.ch"
#Include "ParmType.ch"
#Include "TopConn.ch"

Static cEol := Chr(13)+Chr(10)

User function UCOMR001()

	Local oReport
	Local aArea 	:= GetArea()
	Local aPergunte := {}
	Private cPerg 	:= "UCOMR001"

	if fPergunte(@aPergunte)

		if fGeraQry(aPergunte)

			oReport := ReportDef(aPergunte)
			oReport:PrintDialog()

		else

			MsgAlert("Não foram encontrados dados com base no preenchimento dos parâmetros!","Atenção!")

		endif

	endif

	RestArea(aArea)

Return(Nil)


Static Function fPergunte(_aPergunte)

	Local aPar 			:= {}
	Local lRet 			:= .F.
	Default _aPergunte 	:= {}

	aAdd(aPar,{1,"CODIGO",Space(TamSX3("ZB1_CODIGO")[1]) 	,""	,".T."	,""	    ,""	,60		,.F.})

	lRet := ParamBox(aPar,"Parâmetros",@_aPergunte)

Return(lRet)

//---------------------------------------------------------
// Definiçao da estrutura do relatorio
//---------------------------------------------------------
Static Function ReportDef(aPergunte)

	Local oReport
	Local oDet
	Local cTitle   		:= "Consultas SPC"
	Default aPergunte 	:= {}

	oReport:= TReport():New("UCOMR001",cTitle,cPerg,{|oReport| PrintReport(oReport,oDet)},"Este relatório apresenta uma relação das consultas SPC.")

	oReport:SetPortrait()		// Orientação paisagem
	//oReport:SetCustomText( {|| Cabec(oReport,aPergunte) })
	//oReport:HideHeader()  		// Nao imprime cabeçalho padrão do Protheus
	//oReport:HideFooter()			// Nao imprime rodapé padrão do Protheus
	oReport:HideParamPage()			// Inibe impressão da pagina de parametros
	oReport:SetUseGC(.F.) 			// Habilita o botão <Gestao Corporativa> do relatório
	//oReport:DisableOrientation()  // Desabilita a seleção da orientação (retrato/paisagem)
	//oReport:cFontBody := "Arial"
	oReport:nFontBody := 7

	Pergunte(oReport:GetParam(),.F.)

	oDet  := TRSection():New(oReport,"Saldos dos produtos",{"ZB1"},,,,)

	TRCell():New(oDet,"ZB1_CODIGO"	    , "", /*Titulo*/	, /*Picture*/			, 22        	, /*lPixel*/	,/*bConteudo*/)
	TRCell():New(oDet,"ZB1_FILIAL"	, "", /*Titulo*/	, /*Picture*/			, /*Tamanho*/	, /*lPixel*/	,/*bConteudo*/)
	TRCell():New(oDet,"ZB1_DESCRI"	, "", /*Titulo*/	, /*Picture*/			, /*Tamanho*/	, /*lPixel*/	,/*bConteudo*/)
	TRCell():New(oDet,"ZB1_PERIOD"		, "", /*Titulo*/	, /*Picture*/	    	, /*Tamanho*/	, /*lPixel*/	,/*bConteudo*/)
	TRCell():New(oDet,"ZB1_SITUAC"	, "", /*Titulo*/	, /*Picture*/	    	, /*Tamanho*/	, /*lPixel*/	,/*bConteudo*/)	
	oReport:SetTotalInLine(.F.)

Return(oReport)

//---------------------------------------------------------
// Faz impressão do relatório
//---------------------------------------------------------
Static Function PrintReport(oReport,oDet)

	Local oTmp		:= oDet

	While TMPZB1->(!EOF())

		oTmp:Init()
		oReport:IncMeter()

		oTmp:Cell("ZB1_FILIAL"	    ):SetValue(TMPZB1->ZB1_FILIAL)
		oTmp:Cell("ZB1_CODIGO"	):SetValue(TMPZB1->ZB1_CODIGO)
		oTmp:Cell("ZB1_DESCRI"	):SetValue(TMPZB1->ZB1_DESCRI)
		oTmp:Cell("ZB1_PERIOD"		):SetValue(TMPZB1->ZB1_PERIOD)
		oTmp:Cell("ZB1_SITUAC"	):SetValue((TMPZB1->ZB1_SITUAC))		

		oTmp:PrintLine()

		//Se cancelar abandona o laco
		If oReport:Cancel()

			Exit

		ENDIF

		TMPZB1->(DbSkip())

	EndDo

	oTmp:Finish()

Return()

Static Function fGeraQry(aPergunte)

	Local cCodigo        := aPergunte[1]

	Local cQry 			:= ""
	Default aPergunte 	:= {}

	cQry := " SELECT *	                                        " + cEol
	cQry += " FROM " + RetSqlName("ZB1") + " ZB1            	            " + cEol

	cQry += " WHERE ZB1.D_E_L_E_T_ = ' '	                        " + cEol
	if !Empty(cCodigo)
		cQry += " AND ZB1_CODIGO    = '"+cCodigo+"'    " + cEol
	Endif


	if Select("TMPZB1") > 0

		TMPZB1->(DbCloseArea())

	endif

	TcQuery cQry New Alias "TMPZB1"

	MemoWrite( "c:\temp\cQry.sql", cQry )

	TMPZB1->(DbSelectArea("TMPZB1"))
	TMPZB1->(DbGoTop())

Return(!TMPZB1->(Eof()))
