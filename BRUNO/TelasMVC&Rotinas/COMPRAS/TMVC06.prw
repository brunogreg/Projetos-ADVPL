#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'

User Function TMVC06()

    Local oBrowse
    Local cCadastro := 'TELA MVC 6'
    Private aRotina := {}

    DbSelectArea('XXX')
    
    oBrowse:= FWmBrowse():New
    oBrowse:SetAlias('XXX')
    oBrowse:SetDescription(cCadastro)
    oBrowse:Activate()

Return

Static Function MenuDef()

    aRotina := {}

    ADD OPTION aRotina TITLE 'VISUALIZAR' ACTION 'VIEWDEF.TMVC06' OPERATION 2 ACCESS 0

Return

Static Function MoDelDef()

    Local oModel
    Local oStruXXX:=FWFomrStruct(1,'xxx')

    oModel:= MPFormModel():New('TMVC06a')
    oModel:AddFields('XXXMASTER',/*cOwner*/,oStruXXX)
    oModel:SetPrimaryKey()
    oModel:SetDescription()

Return

Static Function ViewDef()

    Local oModel:= FWLoadModel('TMVC06')
    Local oStruXXX:= FWFomrStruct(2,'xxx')
    Local oView

    oView:=FWFormView():new()
    oView:SetModel(oModel)
    oView:AddFields('VIEW_XXX',oStruXXX,'XXXMASTER')
    oView:CreateHotiontalBox('TOTAL',100)
    oView:SetOwnerView('VIEW_XXX','TOTAL')

Return
