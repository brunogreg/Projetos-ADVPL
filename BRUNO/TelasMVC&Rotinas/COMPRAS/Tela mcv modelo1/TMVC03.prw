#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function TMVC03()

    Local oBrowse
    Private cCabeçalho := ('teste')
    Private aRotina

    DbSelectArea('ZB3')

    oBrowse := FWmBrowse():New()
    oBrowse:SetAlias('ZB3')
    oBrowse:SetDescription(cCabeçalho)
    oBrowse:Activate()

Return

Static Function MenuDef()

    aRotina := {}

    ADD OPTION aRotina TITLE 'VISUALIZAR'ACTION 'VIEWDEF.TMVC03' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'INCLUIR'ACTION 'VIEWDEF.TMVC03' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'ALTERAR'ACTION 'VIEWDEF.TMVC03' OPERATION 4 ACCESS 0

Return aRotina

Static Function ModelDef()

    LOCAL oModel
    Local oStucZB3:=FWFormStruct(1,'ZB3',,)

    oModel:= MPFormModel():New('TMVC03a')
    oModel:AddFields('ZB3MASTER', /*cOwner*/, oStucZB3)
    oModel:SetPrimaryKey({ "ZB3_FILIAL", "ZB3_CODIG" })
    oModel:SetDescription('TESTE')

Return oModel

Static Function ViewDef()

    Local oView
    Local oModel := FWLoadModel('TMVC03')
    Local oStruZB3 := FWFormStruct(2,'ZB3')

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField('VIEW_ZB3', oStruZB3, 'ZB3MASTER')
    oView:CreateHorizontalBox('TOTAL', 100)
    oView:SetOwnerView('VIEW_ZB3', 'TOTAL')

Return oView


