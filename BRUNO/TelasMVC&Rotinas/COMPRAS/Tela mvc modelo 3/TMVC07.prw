#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'FWMVCDEF.ch'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'

Static cTitulo :='TESTE1'
Static cTabPai :='SC5'
Static cTabFilho := 'SC6'

User Function TMVC07()

Local aArea := GetArea()
Local oBrowse
Private aRotina :={}

aRotina:= MenuDef()

oBrowse:= FWMBrowse():New()
oBrowse:SetAlias(cTabPai)
oBrowse:SetDescription(cTitulo)
oBrowse:DisableDetails()
oBrowse:Activate()

RestArea(aArea)
Return NIL

Static Function MenuDef()

    aRotina :={}

    ADD OPTION aRotina TITLE 'Visualizar'      ACTION 'VIEWDEF.TMVC07' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'         ACTION 'VIEWDEF.TMVC07' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'         ACTION 'VIEWDEF.TMVC07' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'         ACTION 'VIEWDEF.TMVC07' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'          ACTION 'VIEWDEF.TMVC07' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()

    Local oModel
    Local aRelation := {}
    Local oStrucPai   := FWFormStruct(1, cTabPai)
    Local oStrucFilho := FWFormStruct(1, cTabFilho)

    oModel := MPFormModel():New('TMVC07a')

    oModel:AddFields('SC5MASTER', /*cOwner*/, oStrucPai)
    oModel:AddGrid('SC6DETAIL', 'SC5MASTER', oStrucFilho)

    oModel:SetDescription('teste ' + cTitulo)
    oModel:GetModel('SC5MASTER'):SetDescription('Dados de - ' + cTitulo)
    oModel:GetModel('SC6DETAIL'):SetDescription('Grid de - ' + cTitulo)

    // Primary Key do cabeçalho (SC5)
    oModel:SetPrimaryKey({'C5_FILIAL', 'C5_NUM'})

    // Relação entre SC5 (pai) e SC6 (filho)
    aAdd(aRelation, {'C6_FILIAL', 'xFilial("SC6")'})
    aAdd(aRelation, {'C6_NUM'   , 'SC5->C5_NUM'  })

    oModel:SetRelation('SC6DETAIL', aRelation, SC6->(IndexKey(1)))

Return oModel

Static Function ViewDef()

    Local oView
    Local oModel := FWLoadModel('TMVC07')
    Local oStrucPai:= FWFormStruct(2,cTabPai)
    Local oStrucFilho:= FWFormStruct(2,cTabFilho)

    oView:= FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_SC5", oStrucPai, "SC5MASTER")///
	oView:AddGrid("VIEW_SC6",  oStrucFilho,  "SC6DETAIL")//

    //TELA
    oView:CreateHorizontalBox("CABEC", 30)//
	oView:CreateHorizontalBox("GRID", 70)//
	oView:SetOwnerView("VIEW_SC5", "CABEC")//
	oView:SetOwnerView("VIEW_SC6", "GRID")//

	//Titulos
	oView:EnableTitleView("VIEW_SC5", "TESTE2")
	oView:EnableTitleView("VIEW_SC6", "TESTE3")


Return oView
