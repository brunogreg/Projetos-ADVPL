#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

//Variveis Estaticas
Static cTitulo := "CADASTRO DE MUSICAS E ARTISTAS"//****
Static cTabPai := "ZD5"//****
Static cTabFilho := "ZD6"//****

User Function zMVC02()

	Local aArea   := GetArea()
	Local oBrowse
	Private aRotina := {}	

	aRotina:= MenuDef()
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabPai)//***
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()//***	
	oBrowse:Activate()

	RestArea(aArea)
Return Nil


Static Function MenuDef()
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.zMVC02" OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.zMVC02" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.zMVC02" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.zMVC02" OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
	Local oStruPai := FWFormStruct(1, cTabPai)///*****
	Local oStruFilho := FWFormStruct(1, cTabFilho)////*****
	Local aRelation := {}///***
	Local oModel
	
	oModel := MPFormModel():New("zMVC02M")
	oModel:AddFields("ZD5MASTER", /*cOwner*/, oStruPai)//*****
	oModel:AddGrid("ZD6DETAIL","ZD5MASTER",oStruFilho)///****
	oModel:SetDescription("Modelo de dados - " + cTitulo)//
	oModel:GetModel("ZD5MASTER"):SetDescription( "Dados de - " + cTitulo)//
	oModel:GetModel("ZD6DETAIL"):SetDescription( "Grid de - " + cTitulo)//
	oModel:SetPrimaryKey({"ZD5_FILIAL", "ZD5_CD"})

	//Fazendo o relacionamento
	aAdd(aRelation, {"ZD6_FILIAL", "FWxFilial('ZD6')"} )//
	aAdd(aRelation, {"ZD6_CD", "ZD5_CD"})//
	oModel:SetRelation("ZD6DETAIL", aRelation, ZD6->(IndexKey(1)))//
	
	//Definindo campos unicos da linha
	oModel:GetModel("ZD6DETAIL"):SetUniqueLine({'ZD6_MUSICA'})//

Return oModel

Static Function ViewDef()
	Local oModel := FWLoadModel("zMVC02")//
	Local oStruPai := FWFormStruct(2, cTabPai)//
	Local oStruFilho := FWFormStruct(2, cTabFilho)//
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZD5", oStruPai, "ZD5MASTER")///
	oView:AddGrid("VIEW_ZD6",  oStruFilho,  "ZD6DETAIL")//

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)//
	oView:CreateHorizontalBox("GRID", 70)//
	oView:SetOwnerView("VIEW_ZD5", "CABEC")//
	oView:SetOwnerView("VIEW_ZD6", "GRID")//

	//Titulos
	oView:EnableTitleView("VIEW_ZD5", "DADOS DA BANDA ZD5")//
	oView:EnableTitleView("VIEW_ZD6", "LISTA DE MUSICAS - ZD6")//

	//Removendo campos
	oStruFilho:RemoveField("ZD6_CD")//

	//Adicionando campo incremental na grid
	oView:AddIncrementField("VIEW_ZD6", "ZD6_ITEM")//

Return oView
