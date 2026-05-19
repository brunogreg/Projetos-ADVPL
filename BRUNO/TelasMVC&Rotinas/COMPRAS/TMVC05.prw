#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'

User Function TMVC05()

    Local oBrowse
    Private cHeader := 'TELA TESTE MVC NUMERO 5'
    Private aRotina :={}

    DbSelectArea('ZZ1')

    oBrowse:= FWmBrowse():new()
    oBrowse:SetAlias('ZZ1')
    oBrowse:SetDescription(cHeader)
    oBrowse:Activate()

Return

Static Function MenuDef()

    aRotina := {}

    ADD OPTION aRotina TITLE 'VISUALIZAR'  ACTION 'VIEWDEF.TMVC04'OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'INCLUIR'     ACTION 'VIEWDEF.TMVC04'OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'ALTERAR'     ACTION 'VIEWDEF.TMVC04'OPERATION 4 ACCESS 0

Return aRotina

Static Function ModelDef()

    Local oStucZZ1 := FWFormStruct(1,'ZZ1')
    Local oModel 

    oModel:= MPFormModel():NEW('TMVC05A',)
    oModel:AddFields('ZZ1MASTER',/*cOwner*/,oStucZZ1)
    oModel:SetPrimaryKey({"ZZ1_FILIAL", "ZZ1_CLIENT"})
    oModel:SetDescription('TELA TESTE NUMERO 5')

Return oModel

Static Function ViewDef()

    local oModel := FWLoadModel('TMVC05')
    lOCAL oStruZZ1 := FWFormStruct(2,'ZZ1')
    LOCAL oView

    oView:= FWFormView():new()
    oView:SetModel(oModel)
    oView:AddField('VIEW_ZZ1',oStruZZ1,'ZZ1MASTER')
    oView:CreateHorizontalBox('TOTAL',100)
    oView:SetOwnerView('VIEW_ZZ1','TOTAL')

Return oView
