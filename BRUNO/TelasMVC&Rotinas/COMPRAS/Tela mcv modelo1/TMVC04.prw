#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'

User Function TMVC04()

    Local oBrowse
    Private aRotina
    Private cCadastro := ('TELA MVC SIMPLES MODELO 1')

    DbSelectArea('ZB3')
    oBrowse:= FWmBrowse():New()
    oBrowse:SetAlias('ZB3')
    oBrowse:SetDescription(cCadastro)
    oBrowse:Activate()

Return

Static Function MenuDef()

    aRotina := {}

    ADD OPTION aRotina TITLE 'VISUALIZAR' ACTION 'VIEWDEF.TMVC04'OPERATION 2 ACCESS 0

Return aRotina

Static Function ModelDef()

    Local oModel
    Local oStrucZB3:= FWFormStruct(1,'ZB3')

    oModel:= MPFormModel():new('TMVC04A')
    oModel:AddFields('ZB3MASTER',/*cOwner*/,oStrucZB3)
    oModel:SetPrimaryKey({"ZB3_FILIAL", "ZB3_CODIG"})
    oModel:SetDescription('TESTANDO TELA MVC MODELO 1')

Return oModel

Static Function ViewDef()

    Local oView
    Local oModel:= FWLoadModel('TMVC04')
    Local oStrucZB3:= FWFormStruct(2,'ZB3')

    oView:= FWFormView():new()
    oView:SetModel(oModel)
    oView:AddField('VIEW_ZB3',oStrucZB3,'ZB3MASTER')
    oView:CreateHorizontalBox('TOTAL',100)
    oView:SetOwnerView('VIEW_ZB3', 'TOTAL')

Return oView
