#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#Include "TOTVS.ch"

User Function MOD2(cCodUsu,cRotUsu)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Private cCadastro := "Cadastro de Usuarios x Rotinas"
	Private NOPCX := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta um aRotina proprio                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
		{"Visualizar","U_CFGAT2Vis",0,2} ,;
		{"Incluir","U_CFGAT2Inc",0,3} ,;
		{"Alterar","U_CFGAT2Alt",0,4} ,;
		{"Copiar","U_CFGAT2Cop",0,4} ,;
		{"Excluir","U_CFGAT2Exc",0,5},;
		{"Testar","U_CFGAT2TST",0,6}}//,;

	Private cString := "SZB"

	dbSelectArea("SZB")
	dbSetOrder(1)

	dbSelectArea(cString)
	mBrowse( 6,1,22,75,cString)


Return
User Function CFGAT2Vis(cAlias,nReg,nOpcX)
	Local i := nB := 0
	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2
	Private nTotaNota := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Opcao de acesso para o Modelo 2                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// 3,4 Permitem alterar getdados e incluir linhas
	// 6 So permite alterar getdados e nao incluir linhas
	// Qualquer outro numero so visualiza
	nOpcx:=2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aHeader                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OpenSxs(,,,,,"SX3TRB","SX3",,.F.)
	cTabela := "SZB"
	nUsado:=0
	aHeader:={}
	aGetSD := {}

	If Select("SX3TRB") > 0
		dbSelectArea('SX3TRB')
		SX3TRB->( dbSetOrder( 1 ) ) //ORDENA POR ALIAS
		SX3TRB->( dbGoTop(  ) )
		If SX3TRB->( msSeek( cTabela ) )
			While SX3TRB->(!Eof()) .AND. SX3TRB->&('X3_ARQUIVO')==cTabela

				IF X3USO(SX3TRB->&('x3_usado')) .AND. cNivel >= SX3TRB->&('x3_nivel') .And. Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_CODUSU" .And. ;
						Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_NOMEUSU" .And. Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_MSBLQL"
					nUsado++
					AADD(aHeader,{ TRIM(SX3TRB->&('x3_titulo')), SX3TRB->&('x3_campo'), SX3TRB->&('x3_picture'),;
						SX3TRB->&('x3_tamanho'), SX3TRB->&('x3_decimal'),SX3TRB->&('x3_valid'),;
						SX3TRB->&('x3_usado'), SX3TRB->&('x3_tipo'), SX3TRB->&('x3_arquivo'), SX3TRB->&('X3_CONTEXT') } )
					Aadd( aGetSD, SX3TRB->&('X3_CAMPO'))
				Endif


				SX3TRB->(dbSkip())
			End
		Endif
		SX3TRB->( DbCloseArea() )
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aCols                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCOLS := Array(1,Len(aHeader)+1)

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZB_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Cabecalho do Modelo 2                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cCodigo := SZB->ZB_CODUSU
	cNomeU	:= SZB->ZB_NOMEUSU
	//cBloq   := SZB->ZB_MSBLQL
	nCnt := 0

	dbSelectArea("SZB")
	dbSetOrder(1)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZB_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			dbSkip()
		End
	EndIf
	aCols:=Array(nCnt,Len(aHeader)+1)

	nCnt := 0
	dbSelectArea("SZB")
	dbSetOrder(4)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZB_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			For nB:=1 To Len(aHeader)
				cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
				cCampo := AllTrim(aHeader[nB][2])
				aCols[nCnt, cVar] := &cCampo
			Next
			dbSelectArea("SZB")
			dbSkip()
		End
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Rodape do Modelo 2                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLinGetD:=0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aC:={}
	// aC[n,1] = Nome da Variavel Ex.:"cCliente"
	// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aC[n,3] = Titulo do Campo
	// aC[n,4] = Picture
	// aC[n,5] = Validacao
	// aC[n,6] = F3
	// aC[n,7] = Se campo e' editavel .t. se nao .f.

	AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999"	,".T.","USR"	,.F.})
	AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,""				,".T.", 	,.F.})
	//AADD(aC,{"cBloq"	,{30,010} ,"Bloqueado       :"	,			  ,		,		,.T.})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Rodape do Modelo 2         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aR:={}
	// aR[n,1] = Nome da Variavel Ex.:"cCliente"
	// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aR[n,3] = Titulo do Campo
	// aR[n,4] = Picture
	// aR[n,5] = Validacao
	// aR[n,6] = F3
	// aR[n,7] = Se campo e' editavel .t. se nao .f.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com coordenadas da GetDados no modelo2                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{220}} )
	nGetLin := aPosObj[2,1]


	aCordW :={aSize[7],0,aSize[6],aSize[5]}
	aCGD:={75,5,218,310}
	aGetEdit := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacoes na GetDados da Modelo 2                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLinhaOk:="AlwaysTrue()"
	cTudoOk:="AlwaysTrue()"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da Modelo2                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// lRetMod2 = .t. se confirmou
	// lRetMod2 = .f. se cancelou
	lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,,,aCordW,.F.)
	// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
	// objeto Getdados Corrente

Return

User Function CFGAT2Inc(cAlias,nReg,nOpcX)
	Local i:= nB:= nA:= 0
	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2,cCodigo
	Private nTotaNota := 0
	Private cNomeU

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Opcao de acesso para o Modelo 2                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// 3,4 Permitem alterar getdados e incluir linhas
	// 6 So permite alterar getdados e nao incluir linhas
	// Qualquer outro numero so visualiza
	nOpcx:=3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aHeader                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OpenSxs(,,,,,"SX3TRB","SX3",,.F.) // Abre tabela de rotinas substitui dbselectarea 
	cTabela := "SZB"
	nUsado:=0
	aHeader:={} // cabeçalho do modelo2
	aGetSD := {} // array com os campos que serao usados no getdados

	If Select("SX3TRB") > 0 // verifica se a area esta aberta se a tabela existe
		dbSelectArea('SX3TRB')
		SX3TRB->( dbSetOrder( 1 ) ) //ORDENA POR ALIAS
		SX3TRB->( dbGoTop(  ) )
		If SX3TRB->( msSeek( cTabela ) )
			While SX3TRB->(!Eof()) .AND. SX3TRB->&('X3_ARQUIVO')==cTabela

				IF X3USO(SX3TRB->&('X3_USADO')) .AND. cNivel >= SX3TRB->&('X3_NIVEL') .And. Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_CODUSU" .And. ;
						Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_NOMEUSU" .And. Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_MSBLQL"
					nUsado++
					AADD(aHeader,{ TRIM(SX3TRB->&('X3_TITULO')), SX3TRB->&('X3_CAMPO'), SX3TRB->&('X3_PICTURE'),;
						SX3TRB->&('X3_TAMANHO'), SX3TRB->&('X3_DECIMAL'),SX3TRB->&('X3_VALID'),;
						SX3TRB->&('X3_USADO'), SX3TRB->&('X3_TIPO'), SX3TRB->&('X3_ARQUIVO'), SX3TRB->&('X3_CONTEXT') } )
					Aadd( aGetSD, SX3TRB->&('X3_CAMPO'))
				Endif


				SX3TRB->(dbSkip())
			End
		Endif
		SX3TRB->( DbCloseArea() )
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aCols                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCOLS := Array(1,Len(aHeader)+1) // sao linhas e colunas do getdados ele esta acrescentando uma linhas

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZB_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F. // Em resumo sao as linhas da tela

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Cabecalho do Modelo 2                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cCodigo := Space(06) 
	cNomeU	:= Space(30)
	//cBloq   := Space(01)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Rodape do Modelo 2                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLinGetD:=0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aC:={}
	// aC[n,1] = Nome da Variavel Ex.:"cCliente"
	// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aC[n,3] = Titulo do Campo
	// aC[n,4] = Picture
	// aC[n,5] = Validacao
	// aC[n,6] = F3
	// aC[n,7] = Se campo e' editavel .t. se nao .f.

	AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999"	,"","US1"	,.T.})
	AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,""				,".T.",	  	,.F.})
	//AADD(aC,{"cBloq"	,{30,010} ,"Bloqueado       :"	,			  ,		,		,.T.})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Rodape do Modelo 2         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aR:={}
	// aR[n,1] = Nome da Variavel Ex.:"cCliente"
	// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aR[n,3] = Titulo do Campo
	// aR[n,4] = Picture
	// aR[n,5] = Validacao
	// aR[n,6] = F3
	// aR[n,7] = Se campo e' editavel .t. se nao .f.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com coordenadas da GetDados no modelo2                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{220}} )
	nGetLin := aPosObj[2,1]


	aCordW :={aSize[7],0,aSize[6],aSize[5]} // coordenadas do getdados na tela
	aCGD:={75,5,218,310}
	aGetEdit := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacoes na GetDados da Modelo 2                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLinhaOk:=".T." // valida cada linha
	cTudoOk:=".T." // valida tudo antes de sair
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da Modelo2                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// lRetMod2 = .t. se confirmou
	// lRetMod2 = .f. se cancelou
	// lRetMod2 é a funcao que carrega todas as informacoes na tela
	lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,"+ZB_ITEM",,aCordW,.T.)
	// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
	// objeto Getdados Corrente
	If lRetMod2 // se confirmou ele entra aqui para gravar os dados
		For nA:=1 To Len(aCols)
			If !( aCols[nA][Len(aHeader)+1] ) // se a linha nao estiver marcada como excluida
				nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZB_ITEM" }) // procura a posicao do campo item
				If  !Empty(aCols[nA,nI])
					RecLock("SZB",.T.)
					ZB_CODUSU  	:= cCodigo
					ZB_NOMEUSU 	:=  UsrRetName(cCodigo)
					//				ZB_MSBLQL	:= cBloq
					For nB:=1 To Len(aHeader) // percorre o cabeçalho
						cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
						xConteudo := aCols[ nA, cVar ]
						cCampo := AllTrim(aHeader[nB][2])
						Replace &cCampo With xConteudo
					Next
					SZB->(MsUnlock())
				EndIf
			EndIf
		Next
		Return
	Else
		Return
	EndIf
Return

User Function CFGAT2Alt(cAlias,nReg,nOpcX)
	Local i:= nB:= nA:= 0
	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2
	Private nTotaNota := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Opcao de acesso para o Modelo 2                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// 3,4 Permitem alterar getdados e incluir linhas
	// 6 So permite alterar getdados e nao incluir linhas
	// Qualquer outro numero so visualiza
	nOpcx:=4
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aHeader                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OpenSxs(,,,,,"SX3TRB","SX3",,.F.)
	cTabela := "SZB"
	nUsado:=0
	aHeader:={}
	aGetSD := {}

	If Select("SX3TRB") > 0
		dbSelectArea('SX3TRB')
		SX3TRB->( dbSetOrder( 1 ) ) //ORDENA POR ALIAS
		SX3TRB->( dbGoTop(  ) )
		If SX3TRB->( msSeek( cTabela ) )
			While SX3TRB->(!Eof()) .AND. SX3TRB->&('X3_ARQUIVO')==cTabela

				IF X3USO(SX3TRB->&('X3_USADO')) .AND. cNivel >= SX3TRB->&('X3_NIVEL') .And. Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_CODUSU" .And. ;
						Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_NOMEUSU" .And. Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_MSBLQL"
					nUsado++
					AADD(aHeader,{ TRIM(SX3TRB->&('X3_TITULO')), SX3TRB->&('X3_CAMPO'), SX3TRB->&('X3_PICTURE'),;
						SX3TRB->&('X3_TAMANHO'), SX3TRB->&('X3_DECIMAL'),SX3TRB->&('X3_VALID'),;
						SX3TRB->&('X3_USADO'), SX3TRB->&('X3_TIPO'), SX3TRB->&('X3_ARQUIVO'), SX3TRB->&('X3_CONTEXT') } )
					Aadd( aGetSD, SX3TRB->&('X3_CAMPO'))
				Endif


				SX3TRB->(dbSkip())
			End
		Endif
		SX3TRB->( DbCloseArea() )
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aCols                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCOLS := Array(1,Len(aHeader)+1)// sao linhas e colunas do getdados ele esta acrescentando uma linhas

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZB_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Cabecalho do Modelo 2                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cCodigo := SZB->ZB_CODUSU
	cNomeU	:= SZB->ZB_NOMEUSU
	//cBloq   := SZB->ZB_MSBLQL

	nCnt := 0

	dbSelectArea("SZB")
	dbSetOrder(1)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZB_CODUSU ==  cCodigo // conta os itens
			nCnt:=nCnt+1
			dbSkip()
		End
	EndIf
	If nCnt == 0 // se nao encontrou nenhum item
		Help(" ",1,"NOITENS")
		Return
	EndIf

	aCols		:=	Array(nCnt,Len(aHeader)+1) 
	aRecnos	:=	Array(nCnt)

	nCnt := 0
	dbSelectArea("SZB")
	dbSetOrder(4)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZB_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			For nB:=1 To Len(aHeader)
				cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
				cCampo := AllTrim(aHeader[nB][2])
				aCols[nCnt, cVar] := &cCampo
			Next
			aCOLS[nCnt][Len(aHeader)+1] := .F.
			dbSelectArea("SZB")
			dbSkip()
		End
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Rodape do Modelo 2                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLinGetD:=0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aC:={}
	// aC[n,1] = Nome da Variavel Ex.:"cCliente"
	// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aC[n,3] = Titulo do Campo
	// aC[n,4] = Picture
	// aC[n,5] = Validacao
	// aC[n,6] = F3
	// aC[n,7] = Se campo e' editavel .t. se nao .f.

	AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999"	,".T.","USR"	,.F.})
	AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,""				,".T.",	  	,.F.})
	//AADD(aC,{"cBloq"	,{30,010} ,"Bloqueado       :"	,			  ,		,		,.T.})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Rodape do Modelo 2         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aR:={}
	// aR[n,1] = Nome da Variavel Ex.:"cCliente"
	// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aR[n,3] = Titulo do Campo
	// aR[n,4] = Picture
	// aR[n,5] = Validacao
	// aR[n,6] = F3
	// aR[n,7] = Se campo e' editavel .t. se nao .f.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com coordenadas da GetDados no modelo2                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{220}} )
	nGetLin := aPosObj[2,1]


	aCordW :={aSize[7],0,aSize[6],aSize[5]}
	aCGD:={75,5,218,310}
	aGetEdit := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacoes na GetDados da Modelo 2                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLinhaOk:=".T."
	cTudoOk:=".T."
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da Modelo2                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// lRetMod2 = .t. se confirmou
	// lRetMod2 = .f. se cancelou
	lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,"+ZB_ITEM",,aCordW,)
	// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
	// objeto Getdados Corrente
	If lRetMod2
		nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZB_ITEM" })
		cItem := aCols[1,nI]
		dbSelectArea("SZB")
		dbSetOrder(4)
		dbSeek(xFILIAL()+cCodigo+cItem)
		While !EOF() .And. cCodigo== SZB->ZB_CODUSU
			For nA:=1 To Len(aCols)
				nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZB_FUNCAO" })
				If  !Empty(aCols[nA,nI])
					nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZB_ITEM" })
					If aCols[nA,nI] == SZB->ZB_ITEM
						If !( aCols[nA][Len(aHeader)+1] )	//GRAVA OS CAMPOS DA LINHA
							RecLock("SZB",.F.)
							For nB:=1 To Len(aHeader)
								cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
								xConteudo := aCols[ nA, cVar ]
								cCampo := AllTrim(aHeader[nB][2])
								Replace &cCampo With xConteudo
							Next
							SZB->(MsUnlock())
						Else	//CASO A LINHA ESTEJA DELETADA NO ACOLS APAGA DA BASE
							dbSelectArea("SZB")
							dbSetOrder(4)
							If dbSeek(xFILIAL()+cCodigo+aCols[nA,nI])
								RecLock("SZB",.F.)
								dbDelete()
								dbUnLock()
							EndIf
						EndIf
						dbSkip()
						Loop
					Else	//INCLUI O NOVO REGISTRO
						RecLock("SZB",.T.)
						ZB_CODUSU  	:= cCodigo
						ZB_NOMEUSU 	:= cNomeU
						//					ZB_MSBLQL	:= cBloq
						If !( aCols[nA][Len(aHeader)+1] )
							For nB:=1 To Len(aHeader)
								cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
								xConteudo := aCols[ nA, cVar ]
								cCampo := AllTrim(aHeader[nB][2])
								Replace &cCampo With xConteudo
							Next
						EndIf
						SZB->(MsUnlock())
						dbSkip()
						Loop
					EndIf
				EndIf
			Next
		End
		Return

	Else
		Return
	EndIf

Return

User Function CFGAT2Exc(cAlias,nReg,nOpcX)
	Local i:= nB:= 0
	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2
	Private nTotaNota := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Opcao de acesso para o Modelo 2                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// 3,4 Permitem alterar getdados e incluir linhas
	// 6 So permite alterar getdados e nao incluir linhas
	// Qualquer outro numero so visualiza
	nOpcx:=5
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aHeader                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OpenSxs(,,,,,"SX3TRB","SX3",,.F.)
	cTabela := "SZB"
	nUsado:=0
	aHeader:={}
	aGetSD := {}

	If Select("SX3TRB") > 0
		dbSelectArea('SX3TRB')
		SX3TRB->( dbSetOrder( 1 ) ) //ORDENA POR ALIAS
		SX3TRB->( dbGoTop(  ) )
		If SX3TRB->( msSeek( cTabela ) )
			While SX3TRB->(!Eof()) .AND. SX3TRB->&('X3_ARQUIVO')==cTabela

				IF X3USO(SX3TRB->&('X3_USADO')) .AND. cNivel >= SX3TRB->&('X3_NIVEL') .And. Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_CODUSU" .And. ;
						Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_NOMEUSU" .And. Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_MSBLQL"
					nUsado++
					AADD(aHeader,{ TRIM(SX3TRB->&('X3_TITULO')), SX3TRB->&('X3_CAMPO'), SX3TRB->&('X3_PICTURE'),;
						SX3TRB->&('X3_TAMANHO'), SX3TRB->&('X3_DECIMAL'),SX3TRB->&('X3_VALID'),;
						SX3TRB->&('X3_USADO'), SX3TRB->&('X3_TIPO'), SX3TRB->&('X3_ARQUIVO'), SX3TRB->&('X3_CONTEXT') } )
					Aadd( aGetSD, SX3TRB->&('X3_CAMPO'))
				Endif


				SX3TRB->(dbSkip())
			End
		Endif
		SX3TRB->( DbCloseArea() )
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aCols                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCOLS := Array(1,Len(aHeader)+1)

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZB_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Cabecalho do Modelo 2                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cCodigo := SZB->ZB_CODUSU
	cNomeU	:= SZB->ZB_NOMEUSU
	//cBloq   := SZB->ZB_MSBLQL

	nCnt := 0

	dbSelectArea("SZB")
	dbSetOrder(1)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZB_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			dbSkip()
		End
	EndIf
	aCols:=Array(nCnt,i)

	nCnt := 0
	dbSelectArea("SZB")
	dbSetOrder(4)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZB_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			For nB:=1 To Len(aHeader)
				cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
				cCampo := AllTrim(aHeader[nB][2])
				aCols[nCnt, cVar] := &cCampo
			Next
			dbSelectArea("SZB")
			dbSkip()
		End
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Rodape do Modelo 2                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLinGetD:=0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aC:={}
	// aC[n,1] = Nome da Variavel Ex.:"cCliente"
	// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aC[n,3] = Titulo do Campo
	// aC[n,4] = Picture
	// aC[n,5] = Validacao
	// aC[n,6] = F3
	// aC[n,7] = Se campo e' editavel .t. se nao .f.

	AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999"	,".T.","USR"	,.F.})
	AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,""				,".T.",	  	,.F.})
	//AADD(aC,{"cBloq"	,{30,010} ,"Bloqueado       :"	,			  ,		,		,.F.})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Rodape do Modelo 2         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aR:={}
	// aR[n,1] = Nome da Variavel Ex.:"cCliente"
	// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aR[n,3] = Titulo do Campo
	// aR[n,4] = Picture
	// aR[n,5] = Validacao
	// aR[n,6] = F3
	// aR[n,7] = Se campo e' editavel .t. se nao .f.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com coordenadas da GetDados no modelo2                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{220}} )
	nGetLin := aPosObj[2,1]


	aCordW :={aSize[7],0,aSize[6],aSize[5]}
	aCGD:={75,5,218,310}
	aGetEdit := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacoes na GetDados da Modelo 2                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLinhaOk:="AlwaysTrue()"
	cTudoOk:="AlwaysTrue()"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da Modelo2                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// lRetMod2 = .t. se confirmou
	// lRetMod2 = .f. se cancelou
	lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,,,aCordW,.F.)
	// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
	// objeto Getdados Corrente

	If lRetMod2
		dbSelectArea("SZB")
		dbSetOrder(4)
		IF dbSeek(xFilial()+cCodigo)
			While !Eof() .and. ZB_CODUSU == cCodigo
				RecLock("SZB",.F.)
				dbDelete()
				dbUnLock()
				dbSkip()
			End
		EndIf
	EndIf
Return

User Function CFGAT2Cop(cAlias,nReg,nOpcX)
	Local i:= nB:= nA:= 0
	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2,cCodigo
	Private nTotaNota := 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Opcao de acesso para o Modelo 2                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// 3,4 Permitem alterar getdados e incluir linhas
	// 6 So permite alterar getdados e nao incluir linhas
	// Qualquer outro numero so visualiza
	nOpcx:=3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aHeader                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OpenSxs(,,,,,"SX3TRB","SX3",,.F.)
	cTabela := "SZB"
	nUsado:=0
	aHeader:={}
	aGetSD := {}

	If Select("SX3TRB") > 0
		dbSelectArea('SX3TRB')
		SX3TRB->( dbSetOrder( 1 ) ) //ORDENA POR ALIAS
		SX3TRB->( dbGoTop(  ) )
		If SX3TRB->( msSeek( cTabela ) )
			While SX3TRB->(!Eof()) .AND. SX3TRB->&('X3_ARQUIVO')==cTabela

				IF X3USO(SX3TRB->&('X3_USADO')) .AND. cNivel >= SX3TRB->&('X3_NIVEL') .And. Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_CODUSU" .And. ;
						Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_NOMEUSU" .And. Trim(SX3TRB->&('X3_CAMPO')) <> "ZB_MSBLQL"
					nUsado++
					AADD(aHeader,{ TRIM(SX3TRB->&('X3_TITULO')), SX3TRB->&('X3_CAMPO'), SX3TRB->&('X3_PICTURE'),;
						SX3TRB->&('X3_TAMANHO'), SX3TRB->&('X3_DECIMAL'),SX3TRB->&('X3_VALID'),;
						SX3TRB->&('X3_USADO'), SX3TRB->&('X3_TIPO'), SX3TRB->&('X3_ARQUIVO'), SX3TRB->&('X3_CONTEXT') } )
					Aadd( aGetSD, SX3TRB->&('X3_CAMPO'))
				Endif


				SX3TRB->(dbSkip())
			End
		Endif
		SX3TRB->( DbCloseArea() )
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando aCols                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCOLS := Array(1,Len(aHeader)+1)

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZB_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Cabecalho do Modelo 2                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodigo := Space(06)
	cNomeU	:= Space(30)
	cCodCop := SZB->ZB_CODUSU

	nCnt := 0

	dbSelectArea("SZB")
	dbSetOrder(1)
	If dbSeek(xFilial()+cCodCop)
		While !EOF() .And. ZB_CODUSU ==  cCodCop
			nCnt:=nCnt+1
			dbSkip()
		End
	EndIf
	If nCnt == 0
		MsgInfo("Nenhum item foi selecionado!","SEM REGISTROS!")
		Return
	EndIf

	aCols		:=	Array(nCnt,Len(aHeader)+1)
	aRecnos	:=	Array(nCnt)

	nCnt := 0
	dbSelectArea("SZB")
	dbSetOrder(4)
	If dbSeek(xFilial()+cCodCop)
		While !EOF() .And. ZB_CODUSU ==  cCodCop
			nCnt:=nCnt+1
			For nB:=1 To Len(aHeader)
				cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
				cCampo := AllTrim(aHeader[nB][2])
				aCols[nCnt, cVar] := &cCampo
			Next
			aCOLS[nCnt][Len(aHeader)+1] := .F.
			dbSelectArea("SZB")
			dbSkip()
		End
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis do Rodape do Modelo 2                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLinGetD:=0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aC:={}
	// aC[n,1] = Nome da Variavel Ex.:"cCliente"
	// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aC[n,3] = Titulo do Campo
	// aC[n,4] = Picture
	// aC[n,5] = Validacao
	// aC[n,6] = F3
	// aC[n,7] = Se campo e' editavel .t. se nao .f.

	AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999",".T.","USR"	,.T.})
	//AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,"@R 99999999",".T.",	  	,.T.})

	///ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com descricao dos campos do Rodape do Modelo 2         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aR:={}
	// aR[n,1] = Nome da Variavel Ex.:"cCliente"
	// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
	// aR[n,3] = Titulo do Campo
	// aR[n,4] = Picture
	// aR[n,5] = Validacao
	// aR[n,6] = F3
	// aR[n,7] = Se campo e' editavel .t. se nao .f.

	//AADD(aR,{"nTotaNota"  ,{220,010},"Total Nota","@E 999",,,.F.})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Array com coordenadas da GetDados no modelo2                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{220}} )
	nGetLin := aPosObj[2,1]


	aCordW :={aSize[7],0,aSize[6],aSize[5]}
	aCGD:={75,5,218,310}
	aGetEdit := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacoes na GetDados da Modelo 2                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLinhaOk:=".T."
	cTudoOk:=".T."
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da Modelo2                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// lRetMod2 = .t. se confirmou
	// lRetMod2 = .f. se cancelou
	lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,"+ZB_ITEM",,aCordW,.T.)
	// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
	// objeto Getdados Corrente

	If lRetMod2
		For nA:=1 To Len(aCols)
			If !( aCols[nA][Len(aHeader)+1] )
				nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZB_ITEM" })
				If  !Empty(aCols[nA,nI])
					RecLock("SZB",.T.)
					ZB_CODUSU  	:= cCodigo
					ZB_NOMEUSU 	:=  UsrRetName(cCodigo)
					//				ZB_MSBLQL	:= cBloq
					For nB:=1 To Len(aHeader)
						cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
						xConteudo := aCols[ nA, cVar ]
						cCampo := AllTrim(aHeader[nB][2])
						Replace &cCampo With xConteudo
					Next
					SZB->(MsUnlock())
				EndIf
			EndIf
		Next
	EndIf
Return
User Function CFGAT2FIL(l1Elem,lTipoRet)

	Local cTitulo := ""
	Local MvPar
	Local MvParDef:= ""

	Private aSit:={}
	l1Elem := If (l1Elem = Nil , .F. , .T.)

	DEFAULT lTipoRet := .T.

	cAlias := Alias() 					 // Salva Alias Anterior

	IF lTipoRet
		MvPar:=&(Alltrim(ReadVar()))	 // Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim(ReadVar())		 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	aSit := {;
		"0101 - " + "Sem Uso",;
		"9901 - " + "Teste";
		}

	MvParDef:= "123456789A"

	/*               
	f_Opcoes(Variavel de Retorno,;
	Titulo da Coluna com as opcoes,;
	Opcoes de Escolha (Array de Opcoes),;
	String de Opcoes para Retorno,;
	Nao Utilizado,;
	Nao Utilizado,;
	Se a Selecao sera de apenas 1 Elemento por vez,;
	Tamanho da Chave,;
	No maximo de elementos na variavel de retorno,;
	Inclui Botoes para Selecao de Multiplos Itens,;
	Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX ),;
	Qual o Campo para a Montagem do aOpcoes,;
	Nao Permite a Ordenacao,;
	Nao Permite a Pesquisa	 )
	*/					

	IF lTipoRet
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
			&MvRet := mvpar // Devolve Resultado
		EndIF
	EndIF

	dbSelectArea(cAlias) // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )
User Function CFGAT2TST()


	dbSelectArea("SM0")
	cCodUsr := RetCodUsr()

	If !U_CHECAFUNC(cCodUsr,"MOD2")
		MsgStop("Usuário sem premissão para utilizar esta rotina","CHECAFUNC")
		Return(lRet)
	EndIf

Return

User Function ChecaFunc(cUsuCod,cFuncaoU)
	Local lRet := .F.
	Local aArea := GetArea()
	Local cQuery
	Local cParFil := "1"

	If ValType(cUsuCod) == "U"
		MsgStop("Usuário sem premissão para utilizar esta rotina","CHECAFUNC")
		RestArea(aArea)
		Return(lRet)
	ElseIf	ValType(cFuncaoU) == "U"
		RestArea(aArea)
		MsgStop("Usuário sem premissão para utilizar esta rotina","CHECAFUNC")
		Return(lRet)
	EndIf

	//COMENTEI PARA A AULA
	//quando for adminitrador  libera
	/*
	If cUsuCod $ "000000"
		Return(.T.)
	EndIf
	*/
	If cFilAnt == "01" .And. cEmpAnt == "01"
		cParFil := "1"
	ElseIf xFilial("SF2") == "01" .And. cEmpAnt == "99"
		cParFil := "2"
	EndIf


	cQuery := " SELECT COUNT(ZB_CODUSU) NCOUNT FROM "+RetSqlName("SZB")+" WITH(NOLOCK)"
	cQuery += " WHERE ZB_CODUSU = '"+cUsuCod+"' AND ZB_FUNCAO = '"+cFuncaoU+"'"
	cQuery += " AND ZB_MSBLQL <> '1' AND D_E_L_E_T_ <> '*' AND ZB_ATIVO = 'S'"
	cQuery += " AND ZB_FILUSO LIKE '%"+cParFil+"%'"

	MemoWrite("CHECAFUNC.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBCH", .F., .T.)

	dbSelectArea("TRBCH")
	If TRBCH->NCOUNT > 0
		lRet := .T.
	EndIf
	TRBCH->(dbCloseArea())
	RestArea(aArea)
Return(lRet)
