#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
User Function TMVC02()

    Local oBrowse
    Private aRotina := {}
    Private cCadastro := 'TELA MVC MODELO SIMPLES ZB2'

    DbSelectArea("ZB2")
    oBrowse := FWmBrowse():New()
    oBrowse:SetAlias('ZB2')
    oBrowse:SetDescription(cCadastro)
    oBrowse:Activate()

Return

Static Function MenuDef()

    aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar'      ACTION 'VIEWDEF.TMVC02' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'         ACTION 'VIEWDEF.TMVC02' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'         ACTION 'VIEWDEF.TMVC02' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'         ACTION 'VIEWDEF.TMVC02' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'          ACTION 'VIEWDEF.TMVC02' OPERATION 9 ACCESS 0    

Return aRotina

Static Function ModelDef()

    local oModel
    Local ostruZB2:= FWFormStruct(1, 'ZB2',,)

    oModel := MPFormModel():New('TMVC02a')
    oModel:AddFields('ZB2Master', /*cOwner*/, ostruZB2)
    oModel:SetPrimaryKey({ "ZB2_FILIAL", "ZB2_NOME" })
    oModel:SetDescription('Cadastro de Clientes')

Return oModel

Static Function ViewDef()

    Local oModel := FWLoadModel('TMVC02')
    Local oStruZB2 := FWFormStruct(2,'ZB2')
    Local oView

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField('VIEW_ZB2', oStruZB2, 'ZB2Master')
    oView:CreateHorizontalBox('TOTAL', 100)
    oView:SetOwnerView('VIEW_ZB2', 'TOTAL')

Return oView
 
