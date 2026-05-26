//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo := "Artistas x CDs x Músicas"
Static cTabPai := "ZB4"
Static cTabFilho := "ZD5"
Static cTabNeto := "ZD6"


User Function TMVCMX()
	Local aArea   := GetArea()
	Local oBrowse
	Private aRotina := {}

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabPai)
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()

	//Ativa a Browse
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

/*/{Protheus.doc} MenuDef
Menu de opcoes na funcao TMVCMX
@author Daniel Atilio
@since 04/02/2022
@version 1.0
@type function
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.TMVCMX" OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.TMVCMX" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.TMVCMX" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.TMVCMX" OPERATION 5 ACCESS 0

Return aRotina


Static Function ModelDef()
	Local oStruPai := FWFormStruct(1, cTabPai)
	Local oStruFilho := FWFormStruct(1, cTabFilho, { |x| ! Alltrim(x) $ 'ZD5_NOME' })
    Local oStruNeto := FWFormStruct(1, cTabNeto)
	Local aRelFilho := {}
    Local aRelNeto := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCommit := Nil
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("TMVCMXM", bPre, bPos, bCommit, bCancel)
	oModel:AddFields("ZB4MASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZD5DETAIL","ZB4MASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
    oModel:AddGrid("ZD6DETAIL","ZD5DETAIL",oStruNeto,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetPrimaryKey({})

    //Fazendo o relacionamento (pai e filho)
    oStruFilho:SetProperty("ZD5_ARTIST", MODEL_FIELD_OBRIGAT, .F.)
	aAdd(aRelFilho, {"ZD5_FILIAL", "FWxFilial('ZD5')"} )
	aAdd(aRelFilho, {"ZD5_ARTIST", "ZB4_CODIGO"})
	oModel:SetRelation("ZD5DETAIL", aRelFilho, ZD5->(IndexKey(1)))

	//Fazendo o relacionamento (filho e neto)
	aAdd(aRelNeto, {"ZD6_FILIAL", "FWxFilial('ZD6')"} )
	aAdd(aRelNeto, {"ZD6_CD", "ZD5_CD"})
	oModel:SetRelation("ZD6DETAIL", aRelNeto, ZD6->(IndexKey(1)))

	//Definindo campos unicos da linha
    oModel:GetModel("ZD5DETAIL"):SetUniqueLine({'ZD5_CD'})
	oModel:GetModel("ZD6DETAIL"):SetUniqueLine({'ZD6_MUSICA'})

Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao TMVCMX
@author Daniel Atilio
@since 04/02/2022
@version 1.0
@type function
/*/

Static Function ViewDef()
	Local oModel := FWLoadModel("TMVCMX")
	Local oStruPai := FWFormStruct(2, cTabPai)
	Local oStruFilho := FWFormStruct(2, cTabFilho, { |x| ! Alltrim(x) $ 'ZD5_NOME' })
    Local oStruNeto := FWFormStruct(2, cTabNeto)
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZB4", oStruPai, "ZB4MASTER")
	oView:AddGrid("VIEW_ZD5",  oStruFilho,  "ZD5DETAIL")
    oView:AddGrid("VIEW_ZD6",  oStruNeto,  "ZD6DETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC_PAI", 30)
	oView:CreateHorizontalBox("GRID_FILHO", 30)
    oView:CreateHorizontalBox("GRID_NETO", 40)
	oView:SetOwnerView("VIEW_ZB4", "CABEC_PAI")
	oView:SetOwnerView("VIEW_ZD5", "GRID_FILHO")
    oView:SetOwnerView("VIEW_ZD6", "GRID_NETO")

	//Titulos
    oView:EnableTitleView("VIEW_ZB4", "Pai - ZB4 (Artistas)")
	oView:EnableTitleView("VIEW_ZD5", "Filho - ZD5 (CDs)")
	oView:EnableTitleView("VIEW_ZD6", "Neto - ZD6 (Musicas dos CDs)")

	//Removendo campos
    oStruFilho:RemoveField("ZD5_ARTIST")
    oStruFilho:RemoveField("ZD5_NOME")
	oStruNeto:RemoveField("ZD6_CD")

	//Adicionando campo incremental na grid
	oView:AddIncrementField("VIEW_ZD6", "ZD6_ITEM")

Return oView
