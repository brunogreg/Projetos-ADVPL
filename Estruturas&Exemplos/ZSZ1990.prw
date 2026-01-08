#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
 
#Define cTitulo "Cadastro de Cliente (ZZ1)"
 
User Function ZSZ1990()
 
    Local oBrowse := FWMBrowse():New()
 
    oBrowse:SetAlias("ZZ1")
    oBrowse:SetDescription(cTitulo)
    oBrowse:SetMenuDef("ZSZ1990")
    oBrowse:DisableDetails()
 
    oBrowse:Activate()
 
Return NIL
 
Static Function MenuDef()
 
    Local aRotina := {}
 
    // IMPORTANTE: aqui TEM que ser string, não pode ser bloco {|| }
    aAdd(aRotina, {"Visualizar", "VIEWDEF.ZSZ1990", 0, OP_VISUALIZAR, 0, NIL})
    //aAdd(aRotina, {"Incluir"   , "VIEWDEF.ZSZ1990", 0, OP_INCLUIR   , 0, NIL})
    aAdd(aRotina, {"Incluir",    "U_ZZ1_INSERT", 0, OP_INCLUIR,   0, NIL})
    aAdd(aRotina, {"Alterar"   , "VIEWDEF.ZSZ1990", 0, OP_ALTERAR   , 0, NIL})
    aAdd(aRotina, {"Excluir"   , "VIEWDEF.ZSZ1990", 0, OP_EXCLUIR   , 0, NIL})
 
Return aRotina

User Function ZZ1_INSERT()
    ConOut(">>> BOTÃO INCLUIR CLICADO")
    FWExecView("ZSZ1990", OP_INCLUIR)
Return NIL
 
//==============================================================
// MODEL
//==============================================================
Static Function ModelDef()
 
    Local oModel   := MPFormModel():New("ZSZ1990", ;
                        , ;                  // bPreVld
                        , ;                  // bPosVld
                        {|oM| oM:Save() }, ; // bCommit (grava)
                        {|oM| .T. } )        // bCancel
 
    Local oStruZZ1 := FWFormStruct(1, "ZZ1") // 1 = MODEL
    Local aKeep    := {"ZZ1_FILIAL","ZZ1_CLIENT","ZZ1_NOME","ZZ1_FONE","ZZ1_EMAIL","ZZ1_CPF"}
    Local aFields  := oStruZZ1:GetFields()
    Local n, cFld
 
    // Mantém só os campos desejados (SEM usar aFields[n]:Name)
    For n := Len(aFields) To 1 Step -1
        cFld := _FldName(aFields[n])
        If !Empty(cFld) .And. Ascan(aKeep, cFld) == 0
            oStruZZ1:RemoveField(cFld)
        EndIf
    Next
 
    oModel:AddFields("MODEL_ZZ1", , oStruZZ1)
    oModel:GetModel("MODEL_ZZ1"):SetPrimaryKey({"ZZ1_FILIAL","ZZ1_CLIENT"})
 
    oModel:SetDescription(cTitulo)
    oModel:GetModel("MODEL_ZZ1"):SetDescription(cTitulo)
 
Return oModel
 
//==============================================================
// VIEW
//==============================================================
Static Function ViewDef()
 
    Local oView   := FWFormView():New()
    Local oModel  := FWLoadModel("ZSZ1990")
 
    // Na sua versão, evitar FWFormStruct(2,...) (já vimos dar erro nType)
    Local oStruV  := FWFormStruct(1, "ZZ1")
    Local aKeep   := {"ZZ1_FILIAL","ZZ1_CLIENT","ZZ1_NOME","ZZ1_FONE","ZZ1_EMAIL","ZZ1_CPF"}
    Local aFields := oStruV:GetFields()
    Local n, cFld
 
    For n := Len(aFields) To 1 Step -1
        cFld := _FldName(aFields[n])
        If !Empty(cFld) .And. Ascan(aKeep, cFld) == 0
            oStruV:RemoveField(cFld)
        EndIf
    Next
 
    oView:SetModel(oModel)
 
    oView:CreateVerticalBox("PAINEL_PRINCIPAL", 100)
    oView:CreateHorizontalBox("BOX_FORM", 100, "PAINEL_PRINCIPAL")
 
    oView:AddField("VIEW_ZZ1", oStruV, "MODEL_ZZ1")
    oView:SetOwnerView("VIEW_ZZ1", "BOX_FORM")
 
Return oView
 
//==============================================================
// Helper: pega nome do campo independente do formato do GetFields()
//==============================================================
Static Function _FldName(uField)
 
    Local cName := ""
 
    Do Case
    Case ValType(uField) == "C"
        cName := uField
 
    Case ValType(uField) == "A" .And. Len(uField) > 0 .And. ValType(uField[1]) == "C"
        cName := uField[1]
 
    Case ValType(uField) == "O"
        Begin Sequence
            cName := uField:Name
        Recover
            Begin Sequence
                cName := uField:cName
            Recover
                cName := ""
            End Sequence
        End Sequence
    EndCase
 
Return Upper(AllTrim(cName))
