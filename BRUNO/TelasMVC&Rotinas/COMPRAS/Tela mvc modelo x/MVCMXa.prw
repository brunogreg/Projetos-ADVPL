#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

STATIC cAliasPAI   := 'SC2'
STATIC cAliasFILHO := 'SD4'
STATIC cAliasNETO  := 'SH1'
STATIC cTitulo     := 'TELA MVC MODELO X TESTE'

User Function MVCMXa()

    Local aArea   := GetArea()
    Local oBrowse
    Private aRotina := {}

    aRotina := MenuDef()

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAliasPAI)
    oBrowse:SetDescription(cTitulo)
    oBrowse:DisableDetails()
    oBrowse:Activate()

    RestArea(aArea)
Return Nil

STATIC FUNCTION MenuDef()

    aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVCMXa' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVCMXa' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVCMXa' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVCMXa' OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVCMXa' OPERATION 9 ACCESS 0

RETURN aRotina

STATIC FUNCTION MODELDEF()

    LOCAL oModel
    LOCAL oStrucPAI   := FWFormStruct(1, cAliasPAI)
    LOCAL oStrucFILHO := FWFormStruct(1, cAliasFILHO)
    LOCAL oStrucNETO  := FWFormStruct(1, cAliasNETO)
    LOCAL aRelFilho   := {}
    LOCAL aRelNeto    := {}

    // Garante campos chave que podem nao estar no dicionario
    IF SC2->(FieldPos("C2_NUM"))  > 0 .AND. !oStrucPAI:HasField("C2_NUM")
        oStrucPAI:AddField("", "", "C2_NUM", "C", Len(SC2->C2_NUM))
    ENDIF

    IF SD4->(FieldPos("D4_OP"))   > 0 .AND. !oStrucFILHO:HasField("D4_OP")
        oStrucFILHO:AddField("", "", "D4_OP", "C", Len(SD4->D4_OP))
    ENDIF
    IF SD4->(FieldPos("D4_ITEM")) > 0 .AND. !oStrucFILHO:HasField("D4_ITEM")
        oStrucFILHO:AddField("", "", "D4_ITEM", "C", Len(SD4->D4_ITEM))
    ENDIF

    IF SH1->(FieldPos("H1_OP"))   > 0 .AND. !oStrucNETO:HasField("H1_OP")
        oStrucNETO:AddField("", "", "H1_OP", "C", Len(SH1->H1_OP))
    ENDIF
    IF SH1->(FieldPos("H1_ITEM")) > 0 .AND. !oStrucNETO:HasField("H1_ITEM")
        oStrucNETO:AddField("", "", "H1_ITEM", "C", Len(SH1->H1_ITEM))
    ENDIF

    oModel := MPFormModel():NEW('MVCMXaM')
    oModel:AddFields('SC2MASTER', /*cOwner*/, oStrucPAI)
    oModel:AddGrid('SD4DETAIL', 'SC2MASTER', oStrucFILHO)  // filho do PAI
    oModel:AddGrid('SH1DETAIL', 'SD4DETAIL', oStrucNETO)   // filho do FILHO (bug corrigido)

    oModel:SetPrimaryKey({'C2_FILIAL', 'C2_NUM', 'C2_ITEM', 'C2_SEQUEN'})

    aAdd(aRelFilho, {'D4_FILIAL', 'xFilial("SD4")'})
    aAdd(aRelFilho, {'D4_OP',     'C2_NUM'})
    oModel:SetRelation('SD4DETAIL', aRelFilho, SD4->(IndexKey(1)))

    aAdd(aRelNeto, {'H1_FILIAL', 'xFilial("SH1")'})
    aAdd(aRelNeto, {'H1_OP',     'D4_OP'})
    oModel:SetRelation('SH1DETAIL', aRelNeto, SH1->(IndexKey(1)))

    oModel:GetModel('SD4DETAIL'):SetUniqueLine({'D4_FILIAL', 'D4_OP', 'D4_ITEM'})
    oModel:GetModel('SH1DETAIL'):SetUniqueLine({'H1_FILIAL', 'H1_OP', 'H1_ITEM'})

RETURN oModel

STATIC FUNCTION VIEWDEF()

    LOCAL oView
    LOCAL oModel    := FWLoadModel('MVCMXaM')
    LOCAL oStrucPAI := FWFormStruct(2, cAliasPAI)
    LOCAL oStrucFIL := FWFormStruct(2, cAliasFILHO)
    LOCAL oStrucNET := FWFormStruct(2, cAliasNETO)

    oView := FWFormView():NEW()
    oView:SetModel(oModel)

    oView:AddFields('VIEW_SC2', oStrucPAI, 'SC2MASTER')
    oView:AddGrid('VIEW_SD4',   oStrucFIL, 'SD4DETAIL')
    oView:AddGrid('VIEW_SH1',   oStrucNET, 'SH1DETAIL')

    oView:CreateHorizontalBox('CABEC_SC2', 30)
    oView:CreateHorizontalBox('GRID_SD4',  30)
    oView:CreateHorizontalBox('GRID_SH1',  40)

    oView:SetOwnerView('VIEW_SC2', 'CABEC_SC2')
    oView:SetOwnerView('VIEW_SD4', 'GRID_SD4')
    oView:SetOwnerView('VIEW_SH1', 'GRID_SH1')   // bug corrigido: era 'VIEW_SH14'

    oView:EnableTitleView('VIEW_SC2', 'Ordem de Producao - SC2 (Cabecalho)')
    oView:EnableTitleView('VIEW_SD4', 'Requisicoes - SD4 (Filho)')
    oView:EnableTitleView('VIEW_SH1', 'Apontamentos - SH1 (Neto)')  // bug corrigido: era 'VIEW_S'

RETURN oView
