/*/
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßß   Programa   MBrwSZ1    Autor  BRUNO GREGORIO     Data   09/01/2026   ßßß
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßß      Descricao : cadastro SZ1 COM MBRWOSE  TELA                       ßßß
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#Include "Protheus.ch"
 
User Function MBrwSZ1()
    Local cAlias := "SZ1"
    Local aCores := {} // cores do browse
    Local cFiltra := "" // filtro do browse
 
    Private cCadastro := "Cadastro Cliente via MBrwSZ1"
    Private aRotina := {} // items do menu
    Private aIndexZ1 := {} // indices do browse
    Private bFiltraBrw:={||} // filtro do browse
 
//BOTOES MENU
 
    AADD(aRotina,{"Pesquisar" ,"PesqBrw" ,0,1})     //AADD(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
    AADD(aRotina,{"Visualizar","AxVisual" ,0,2})    //AADD(aRotina,{"Visualizar","AxVisual",0,2})
    AADD(aRotina,{"Incluir" ,"U_BInclui" ,0,3})     //AADD(aRotina,{"Incluir" ,"AxInclui",0,3})
    AADD(aRotina,{"Alterar" ,"U_BAltera" ,0,4})     //AADD(aRotina,{"Alterar" ,"AxAltera" ,0,4})
    AADD(aRotina,{"Excluir" ,"U_BDeleta" ,0,5})     //AADD(aRotina,{"Excluir" ,"AxDeleta",0,5})
    AADD(aRotina,{"Legenda" ,"U_BLegenda" ,0,3})    //AADD(aRotina,{"Legenda" ,"BrwLegenda" ,0,3})
    AADD(aRotina,{"Processa" ,"U_PBMsgRun()" ,0,6}) //AADD(aRotina,{"Processa" ,"AxProcessa" ,0,6})
    AADD(aRotina, {"Filtro", "U_BFiltra", 0, 7})

 
//CORES LEGENDA
 
    AADD(aCores,{"Z1_TIPO == 'M'" ,"BR_VERDE" })
    AADD(aCores,{"Z1_TIPO == 'D'" ,"BR_AMARELO" })
 
    dbSelectArea(cAlias)
    dbSetOrder(1)
 
// Filtro
    cFiltra := ' SZ1->Z1_FATOR > 10 '
    bFiltraBrw := { || FilBrowse(cAlias, @aIndexZ1, @cFiltra) }
    Eval(bFiltraBrw) // Aplica o filtro
    dbSelectArea(cAlias)
    dbGoTop() // Vai para o primeiro registro
    mBrowse(6,1,22,75,cAlias,,,,,,aCores) // Abre o browse com as cores definidas na variavel aCores
 
// Finaliza filtro
    EndFilBrw(cAlias, aIndexZ1)
 
Return Nil
// ROTINA FILTRO PERSONALIZADO
User Function BFiltra()
    Local aPerg := {}
    Local aResp := {}
    Local cCampo     := ""
    Local cOperador  := ""
    Local cExpressao := ""
    Local cFiltro    := ""

    // Define os campos do filtro
    AADD(aPerg, {"Campo (ex: Z1_TIPO)", "", 1, 20, "C"})
    AADD(aPerg, {"Operador (ex: ==, !=, >)", "", 1, 5, "C"})
    AADD(aPerg, {"Expressão (ex: M ou 10)", "", 1, 30, "C"})

    aResp := ParamBox("Informe os dados do filtro:", aPerg, "Filtro")

    // Garante que o retorno está completo
    If Len(aResp) == 3
        // Garante que tudo é string
        cCampo     := IIf(ValType(aResp[1]) == "C", AllTrim(aResp[1]), "")
        cOperador  := IIf(ValType(aResp[2]) == "C", AllTrim(aResp[2]), "")
        cExpressao := IIf(ValType(aResp[3]) == "C", AllTrim(aResp[3]), "")

        // Se algum estiver vazio, aborta
        If Empty(cCampo) .or. Empty(cOperador) .or. Empty(cExpressao)
            MsgStop("Todos os campos devem ser preenchidos!", "Atenção")
            Return
        EndIf

        // Verifica se é campo numérico
        If ValType( &( "SZ1->" + cCampo ) ) == "N"
            cFiltro := cCampo + " " + cOperador + " " + cExpressao
        Else
            cFiltro := cCampo + " " + cOperador + " '" + cExpressao + "'"
        EndIf

        // Aplica o filtro
        cFiltra := cFiltro
        bFiltraBrw := { || FilBrowse("SZ1", @aIndexZ1, @cFiltra) }
        Eval(bFiltraBrw)

        MsgInfo("Filtro aplicado: " + cFiltro)
    Else
        MsgInfo("Filtro cancelado.")
    EndIf

Return

// ROTINA DE ALTERACAO
User Function BAltera(cAlias,nReg,nOpc)
    Local nOpcao := 0
    nOpcao := AxAltera(cAlias,nReg,nOpc)
    If nOpcao == 1
        MsgInfo("Alteração efetuada com sucesso!")
    Else
        MsgInfo("Alteração cancelada!")
    Endif
Return Nil
 
//ROTINA EXCLUSAO
User Function BDeleta(cAlias,nReg,nOpc)
    Local nOpcao := 0
    nOpcao := AxDeleta(cAlias,nReg,nOpc)
    If nOpcao == 1
        MsgInfo("Exclusão efetuada com sucesso!")
    Else
        MsgInfo("Exclusão cancelada!")
    Endif
Return Nil
 
// ROTINA LEGENDA
 
User Function BLegenda()
    Local ALegenda := {}
 
    AADD(aLegenda,{"BR_VERDE" ,"Multiplica" })
    AADD(aLegenda,{"BR_AMARELO" ,"Divide" })
    BrwLegenda(cCadastro, "Legenda", aLegenda)
Return Nil
