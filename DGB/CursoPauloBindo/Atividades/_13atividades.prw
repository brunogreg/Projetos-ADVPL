#Include "Protheus.ch"

User Function MBrwSA3()
	Local cAlias := "SA3"
	Local aCores := {}
	Local cFiltra := ""

	Private cCadastro := "Cadastro de Vendedor"
	Private aRotina := {}
	Private aIndexA3 := {}
	Private bFiltraBrw:={||}

//BOTOES MENU
	AADD(aRotina,{"Pesquisar" ,"PesqBrw" ,0,1})		//AADD(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	AADD(aRotina,{"Visualizar","AxVisual" ,0,2})
	AADD(aRotina,{"Incluir" ,"U_BInclui" ,0,3})		//AADD(aRotina,{"Incluir" ,"AxInclui",0,3})
	AADD(aRotina,{"Alterar" ,"U_BAltera1" ,0,4})  	//AADD(aRotina,{"Alterar" ,"AxAltera" ,0,4})
	AADD(aRotina,{"Excluir" ,"U_BDeleta1" ,0,5})		//AADD(aRotina,{"Excluir" ,"AxDeleta",0,5})
//	AADD(aRotina,{"Legenda" ,"U_BLegenda1" ,0,3})
	If RetCodUsr() # "000000"
		AADD(aRotina,{"Processa" ,"U_PBMsgRun()" ,0,6})
	EndIf
//CORES LEGENDA
//	AADD(aCores,{"Z1_TIPO == 'M'" ,"BR_VERDE" })
//	AADD(aCores,{"Z1_TIPO == 'D'" ,"BR_AMARELO" })

	dbSelectArea(cAlias)
	dbSetOrder(1)
//+------------------------------------------------------------
//| Cria o filtro na MBrowse utilizando a função FilBrowse
//+------------------------------------------------------------

//	cFiltra	:= ' SZ1->Z1_FATOR > 10 '
	bFiltraBrw 	:={ || FilBrowse(cAlias,@aIndexA3,@cFiltra) }
	Eval(bFiltraBrw)
	dbSelectArea(cAlias)
	dbGoTop()
	mBrowse(6,1,22,75,cAlias,,,,,,aCores)
//+------------------------------------------------
//| Deleta o filtro utilizado na função FilBrowse
//+------------------------------------------------
	EndFilBrw(cAlias,aIndexA3)
Return Nil

User Function BInclui(cAlias,nReg,nOpc)
	Local nOpcao := 0

	//nOpcao := AxInclui(cAlias,nReg,nOpc)  POR ESTAR COMENTADA NO MBRWSZ1 NAO VAI PERMITIR INCLUSAO
	If nOpcao == 1
		MsgInfo("Inclusão efetuada com sucesso!")
	Else
		MsgInfo("Não é permitido a inclusão de um novo vendedor!")
	Endif

Return Nil

User Function BAltera1(cAlias,nReg,nOpc)
	Local nOpcao := 0
	nOpcao := AxAltera(cAlias,nReg,nOpc)
	If nOpcao == 1
		MsgInfo("Alteração efetuada com sucesso!")
	Else
		MsgInfo("Alteração cancelada!")
	Endif
Return Nil

User Function BDeleta1(cAlias,nReg,nOpc)
	Local nOpcao := 0
	nOpcao := AxDeleta(cAlias,nReg,nOpc)
	If nOpcao == 1
		MsgInfo("Exclusão efetuada com sucesso!")
	Else
		MsgInfo("Exclusão cancelada!")
	Endif
Return Nil

/*User Function BLegenda2()
	Local ALegenda := {}

	AADD(aLegenda,{"BR_VERDE" ,"Multiplica" })
	AADD(aLegenda,{"BR_AMARELO" ,"Divide" })
	BrwLegenda(cCadastro, "Legenda", aLegenda)
Return Nil
