#Include "Protheus.ch"
#Include "FWBrowse.ch"
#Include "FWMVCDEF.ch"
#Include "tbiconn.ch"
#Include "tbicode.ch"

#define MVC_ID     "SZ1990MVC"
#define ALIAS_Z    "SZ1990"

/*/{Protheus.doc} ZSZ1990
Manutenção da tabela SZ1990 (Browse padrão + MVC)
@type user function
@author Bruno
@since 27/12/2025
/*/
User Function ZSZ1990()
    Local oBrw := Nil

    // Defensivo: garante contexto caso execute "no seco"
    RpcSetType(3)
    PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "SIGACFG"

    BEGIN SEQUENCE

        // Garante que o alias existe/abre
        dbSelectArea(ALIAS_Z)
        dbSetOrder(1)

        // Browse padrão (lista)
        oBrw := FWMBrowse():New()
        oBrw:SetAlias(ALIAS_Z)
        oBrw:SetTitle("Manutenção - SZ1990 (Conversão de UM)")

        // Colunas (igual estilo do print)
        oBrw:AddFields({;
            {"Z1_CLIENT", "Cliente"},;
            {"Z1_LOJA",   "Loja"},;
            {"Z1_PRODUT", "Produto"},;
            {"Z1_UM",     "UM"},;
            {"Z1_FATOR",  "Fator"},;
            {"Z1_TIPO",   "Tipo"},;
            {"Z1_UMCLI",  "UM Cliente"} })

        // Botões padrão
        oBrw:AddButton("Visualizar",{|| Sz1_OpenView("VIEW")})
        oBrw:AddButton("Incluir",{|| Sz1_OpenView("INCLUIR"),oBrw:Refresh()})
        oBrw:AddButton("Alterar",{|| Sz1_OpenView("ALTERAR"),oBrw:Refresh()})
        oBrw:AddButton("Excluir",{|| Sz1_DeleteCurrent(),oBrw:Refresh()})

        oBrw:Activate()

    END SEQUENCE

    RESET ENVIRONMENT
Return


// ======================================================
// Abre o MVC no modo desejado (VIEW / INCLUIR / ALTERAR)
// ======================================================
Static Function Sz1_OpenView(cModo)
    Local cOperation := ""
    Local aArea      := GetArea()

    Do Case
    Case Upper(cModo) == "VIEW"
        cOperation := "VIEW"
    Case Upper(cModo) == "INCLUIR"
        cOperation := "INSERT"
    Otherwise // ALTERAR
        cOperation := "UPDATE"
    EndCase

    // Abre a tela MVC
    FWExecView( ;
        "SZ1990 - Conversão de UM", ; // Título
        MVC_ID, ;                    // ID do MVC
        cOperation, ;                // Operação
        , ;                          // aParam (vazio)
        .T. )                        // lModal

    RestArea(aArea)
Return


// =====================================
// Exclui o registro corrente da SZ1990
// =====================================
Static Function Sz1_DeleteCurrent()
    Local aArea := GetArea()
    Local lOk   := .F.

    dbSelectArea(ALIAS_Z)
    dbSetOrder(1)

    If (ALIAS_Z)->(Eof())
        FWAlertInfo("Não há registro selecionado.")
        RestArea(aArea)
        Return .F.
    EndIf

    If ! FWAlertYesNo("Confirma a exclusão do registro selecionado?")
        RestArea(aArea)
        Return .F.
    EndIf

    // Exclusão padrão
    If RecLock(ALIAS_Z, .F.)
        (ALIAS_Z)->(dbDelete())
        (ALIAS_Z)->(MsUnlock())
        lOk := .T.
    Else
        FWAlertError("Não foi possível bloquear o registro para exclusão.")
    EndIf

    RestArea(aArea)
Return lOk


// =======================
// MVC - MODEL (obrigatório)
// =======================
Static Function ModelDef()
    Local oModel := FWFormModel():New(MVC_ID)
    Local oStru  := FWFormStruct(1, ALIAS_Z)

    oModel:AddFields("MASTER", , oStru)

    // -----------------------
    // Validações de negócio
    // -----------------------

    // Cliente + Loja (SA1)
    oModel:AddValidation( ;
        "Z1_CLIENT", ;
        {|| ValidCliente((ALIAS_Z)->Z1_CLIENT, (ALIAS_Z)->Z1_LOJA)}, ;
        "Cliente/Loja não encontrados na SA1!" )

    // Produto (SB1)
    oModel:AddValidation( ;
        "Z1_PRODUT", ;
        {|| ValidProduto((ALIAS_Z)->Z1_PRODUT)}, ;
        "Produto não encontrado na SB1!" )

    // Fator > 0
    oModel:AddValidation( ;
        "Z1_FATOR", ;
        {|| Val(AllTrim((ALIAS_Z)->Z1_FATOR)) > 0}, ;
        "O fator deve ser maior que zero!" )

Return oModel


// ======================
// MVC - VIEW (obrigatório)
// ======================
Static Function ViewDef()
    Local oView  := FWFormView():New()
    Local oModel := FWLoadModel(MVC_ID)
    Local oStruV := FWFormStruct(2, ALIAS_Z)

    oView:SetModel(oModel)

    oView:CreateHorizontalBox("BOX", 100)
    oView:AddFields("VIEW_MASTER", oStruV, "MASTER")
    oView:SetOwnerView("VIEW_MASTER", "BOX")

Return oView


// ==========================================
// Validação Cliente+Loja (SA1) - por índice
// ==========================================
Static Function ValidCliente(cCliente, cLoja)
    Local aArea := GetArea()
    Local lOk   := .F.

    cCliente := PadR(AllTrim(cCliente), TamSX3("A1_COD")[1])
    cLoja    := PadR(AllTrim(cLoja),    TamSX3("A1_LOJA")[1])

    dbSelectArea("SA1")
    dbSetOrder(1) // normalmente: xFilial("SA1")+A1_COD+A1_LOJA

    lOk := SA1->( DbSeek( xFilial("SA1") + cCliente + cLoja ) )

    RestArea(aArea)
Return lOk


// ===================================
// Validação Produto (SB1) - por índice
// ===================================
Static Function ValidProduto(cProd)
    Local aArea := GetArea()
    Local lOk   := .F.

    cProd := PadR(AllTrim(cProd), TamSX3("B1_COD")[1])

    dbSelectArea("SB1")
    dbSetOrder(1) // normalmente: xFilial("SB1")+B1_COD

    lOk := SB1->( DbSeek( xFilial("SB1") + cProd ) )

    RestArea(aArea)
Return lOk
