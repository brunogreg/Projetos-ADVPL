#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


Static cTabPai := 'xxx'
Static cTabFilho := 'yyy'
Static cTitulo := 'Testes de tela modelo 3 feita a mao'

User Function TMVC08()

    Local aArea := GetAtea()
    Local oBrowse
    Private aArray :={}
    

    oBrowse := FWMBrowse():New()
    oBrowse: SetAlias(cTabPai)
    oBrowse: SetDescription(cTitulo)
    oBrowse: Activate()

    RestArea(aArea)

Return

Static Function MenuDef()

    aArray:={}

    ADD OPTION aArray TITLE 'VISUALIZAR' ACTION 'VIEWDEF.TMVC08' OPERATION 2 ACCESS 0

Return aArray

Static Function ModelDef()

    Local oModel
    Local aRelation := {}
    Local oStrucFilho := FWFormStruct(1,cTabPai)
    Local oStrucPai := FWFormStruct(1,cTabFilho)

    oModel:= MPFormModel():NEW('TMVC08A')
    oModel:Addfilds('XXXMASTER',/*cOwner*/,oStrucPai)
    oModel:AddGrid('yyyDetail','XXXMASTER', oStrucFilho)

    oModel:SetDescription()
    oModel:GetModel():SetDescription()
    oModel:GetModel():SetDescription()

    oModel:SetPrimarykey()  

    aAdd(aRelation,{})
    aAdd(aRelation,{})

    oModel:SetRelation('xxxDetail', aRelation, cTitulo->(IndexKey(1)))

Return oModel

Static Function VIEWDEF()
    Local oView
    Local oModel:= FWLoadModel('TMVC08')
    Local oStrucPai:= FWFormStruct(2,cTabPai)
    Local oStrucFilho:= FWFormStruct(2,cTabFilho)

    oView:= FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_xxx", oStrucPai, "XXXMASTER")
	oView:AddGrid("VIEW_yyy",  oStrucFilho,  "yyyDetail")
    oView:CreateHorizontalBox('TOTAL',100)
    oView:SetOwnerV('viewxxx','TOTAL')

    oView:CreateHorizontalBox("CABEC", 30)//
	oView:CreateHorizontalBox("GRID", 70)//
	oView:SetOwnerView("VIEW_SC5", "CABEC")//
	oView:SetOwnerView("VIEW_SC6", "GRID")//

	//Titulos
	oView:EnableTitleView("VIEW_SC5", "TESTE2")
	oView:EnableTitleView("VIEW_SC6", "TESTE3")

Return oView
