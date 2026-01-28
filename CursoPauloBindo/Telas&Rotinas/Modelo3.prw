#include "rwmake.ch"
#include "protheus.ch"

User Function xModelo3()

	PRIVATE aRotina := MenuDef()
	PRIVATE cCadastro := OemToAnsi("MODELO 3") // Nome do Cadastro


// Endereca a funcao de BROWSE                                  

	mBrowse( 6, 1,22,75,"SC5")

Return

USER Function RMOD3(cAlias,nReg,nOpc)

	Local bCampo   := { |nCPO| Field(nCPO) } // Cria um array com os nomes dos campos, field é uma funcao que retorna o nome do campo na posiçao nCPO
	Local nCntFor:=0 , _ni:=0, ni:=0
	Local lRet 		:= .F.
	Local nB		:= 0
	LOcal nY		:= 0
	Local nA		:= 0

// Opcoes de acesso para a Modelo 3                             

	Do Case
	Case nOpc == 3 // Incluir
		nOpcE:=3 // cada opçao permite um tipo de ediçao diferente ao usuario
		nOpcG:=3
	Case nOpc == 4 // Alterar
		nOpcE:=4
		nOpcG:=4
	Case nOpc == 2 // Visualizar
		nOpcE:=2
		nOpcG:=2
	Otherwise
		nOpcE:=5
		nOpcG:=5
	EndCase

// Cria variaveis M->????? da Enchoice                       

	RegToMemory("SC5",(nOpc == 3)) // RegToMemory cria as variaveis M->( armazena os campos do arquivo na memoria )
	aCpoEnchoice  :={}
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("SC5")
	While !Eof().and.(x3_arquivo=="SC5") // Percorre o arquivo de rotina de telas e rotinas
		If X3USO(x3_usado).and.x3_nivel>0 // Verifica se o campo esta marcado como usado e o nivel da rotina
			AADD(aCpoEnchoice,x3_campo) // Adiciona o nome do campo ao array aCpoEnchoice
		Endif
		wVar := "M->"+x3_campo // Cria a variavel dinamicamente
		&wVar:= CriaVar(x3_campo) // Inicializa a variavel com o valor padrao
		dbSkip()
	End

	If !(Inclui)
		DbSelectArea("SC5")
		For nCntFor := 1 TO FCount()
			M->&(EVAL(bCampo,nCntFor)) := FieldGet(nCntFor) // Atribui o valor do campo para a variavel M-> 
		Next
	Endif

// Cria aHeader e aCols da GetDados                         

	nUsado:=0
	dbSelectArea("SX3")
	dbSeek("SC6")
	aHeader:={}
	While !Eof().And.(x3_arquivo=="SC6")
		if X3USO(x3_usado).And.cNivel>=x3_nivel.and.!(alltrim(x3_campo) $ "C6_NUM")
			nUsado:=nUsado+1
			Aadd(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			wVar := "M->"+x3_campo
			&wVar := CriaVar(x3_campo)
		Endif
		dbSkip()
	End

	if nOpc == 3
		aCols:={Array(nUsado+1)}
		aCols[1,nUsado+1]:=.F.
		For _ni:=1 to nUsado
			If AllTrim(aHeader[_ni,2]) == "C6_ITEM"
				cItem:= "00"
				cNItem := Soma1(cItem,Len(SC6->C6_ITEM))
				aCols[1,_ni]:= cNItem
			Else
				aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
			EndIf
		Next
	Else
		aCols:={}
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial("SC6")+SC5->C5_NUM)
		While !Eof() .and. SC5->C5_FILIAL == xFilial("SC6") .and. SC6->C6_NUM ==  SC5->C5_NUM
			AADD(aCols,Array(nUsado+1))
			For _ni:=1 to nUsado
				aCols[Len(aCols),_ni]:=If(aHeader[_ni,10] # "V",FieldGet(FieldPos(aHeader[_ni,2])),CriaVar(aHeader[_ni,2]))
			Next
			aCols[Len(aCols),nUsado+1]:=.F.
			dbSkip()
		End
	Endif

	If Len(aCols)>0		
		cTitulo       :="MODELO 3"
		cAliasEnchoice:="SC5"
		cAliasGetD    :="SC6"
		cLinOk        :="U_VALLINHA()" // Valida a linha
		cTudOk        :="AllwaysTrue()" // Valida tudo
		cFieldOk      :="AllwaysTrue()" // Valida campo

		lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,,,,,,)

	EndIf

	If lRet
		BEGIN TRANSACTION
			If nOpc == 3 // INCLUIR
				DbSelectArea("SC5")
				RecLock("SC5",.T.)
				For nY := 1 TO FCount() // Percorre os campos do arquivo
					If ("FILIAL" $ FieldName(nY) ) // Se for o campo FILIAL
						FieldPut(nY,xFilial("SC5")) // Atribui o valor da filial
					Else	// Senao atribui o valor da variavel M->
						FieldPut(nY,M->&(AllTrim(EVAL(bCampo,nY)))) // Atribui o valor do campo
					EndIf
				Next nY
				SC5->(MsUnlock())

				//GRAVA ITENS
				For nA:=1 To Len(aCols)
					If !( aCols[nA][Len(aHeader)+1] )
						nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_ITEM" })
						If  !Empty(aCols[nA,nI])
							RecLock("SC6",.T.)
							C6_FILIAL := xFilial("SC6")
							C6_NUM 	:= M->C5_NUM
							For nB:=1 To Len(aHeader)
								cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
								xConteudo := aCols[ nA, cVar ]
								cCampo := AllTrim(aHeader[nB][2])
								Replace &cCampo With xConteudo
							Next
							SC6->(MsUnlock())
						EndIf
					EndIf
				Next

			ElseIf nOpc == 4 //ALTERAR
				RecLock('SC5',.F.)
				For nCntFor := 1 TO FCount()
					If "FILIAL"$FieldName(nCntFor)
						FieldPut(nCntFor,xFilial("SC5"))
					Else
						FieldPut(nY,M->&(AllTrim(EVAL(bCampo,nY))))
					EndIf
				Next nCntFor
				SC5->(MsUnlock())


				//GRAVA ITENS
				For nA:=1 To Len(aCols)
					nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_ITEM" })
					If !( aCols[nA][Len(aHeader)+1] )	//GRAVA OS CAMPOS DA LINHA

						If  !Empty(aCols[nA,nI])
							nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_ITEM" }) // PEGA O INDICE DO CAMPO ITEM
							dbSelectArea("SC6")
							dbSetOrder(1)
							If dbSeek(xFilial()+ M->C5_NUM+aCols[nA,nI]) //

								RecLock("SC6",.F.)
								For nB:=1 To Len(aHeader)
									cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )// PEGA O INDICE DO CAMPO
									xConteudo := aCols[ nA, cVar ]
									cCampo := AllTrim(aHeader[nB][2])
									Replace &cCampo With xConteudo
								Next
								MsUnlock("SC6")
							Else	//INCLUI O NOVO REGISTRO
								RecLock("SC6",.T.) // Trava o registro para ediçao
								C6_NUM := M->C5_NUM // É importante fazer a amarração correta dos campos chave
								C6_FILIAL := xFilial("SC6")
								For nB:=1 To Len(aHeader)
									cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
									xConteudo := aCols[ nA, cVar ]
									cCampo := AllTrim(aHeader[nB][2])
									Replace &cCampo With xConteudo
								Next
								MsUnlock("SC6")
							EndIf
						EndIf
					Else	//CASO A LINHA ESTEJA DELETADA NO ACOLS APAGA DA BASE
						dbSelectArea("SC6")
						dbSetOrder(1)
						If dbSeek(xFILIAL()+M->C5_NUM+aCols[nA,nI])
							RecLock("SC6",.F.)
							dbDelete()
							dbUnLock()
						EndIf
					EndIf
				Next

			ElseIf nOpc == 5 //EXCLUIR

				//APAGA ITENS
				dbSelectArea("SC6")
				dbSetOrder(1)
				dbSeek(xFilial("SC6")+SC5->C5_NUM)
				While !Eof() .and. SC5->C5_FILIAL == xFilial("SC6") .and. SC6->C6_NUM ==  SC5->C5_NUM // Percorre os itens do cabeçalho 
					RecLock("SC6",.F.)
					dbDelete()
					SC6->(MsUnlock())
					dbSkip()
				End

				//APAGA CABECALHO
				dbSelectArea("SC5")
				RecLock("SC5",.F.)
				dbDelete()
				SC5->(MsUnlock())


			EndIf
		END TRANSACTION
	EndIf

Return

// Define o menu de opcoes da rotina Modelo 3
Static Function MenuDef()
	Local aRotina := {{ "Pesquisar" ,"axPesqui", 0, 1},;
		{ "Visualizar" ,"U_RMOD3"  , 0, 2},;
		{ "Incluir" ,"U_RMOD3"  , 0, 3},;
		{ "Alterar" ,"U_RMOD3"  , 0, 4},;
		{ "Excluir" ,"U_RMOD3"  , 0, 5}}
Return aRotina

// valida linha
User Function VALLINHA()
	Local lRet := .T.
	
	// Valida se o campo ITEM esta vazio, se estiver atribui o proximo numero
	If Empty(aCols[Len(aCols),1])
		cItem:= aCols[Len(aCols)-1,1]
		cNItem := Soma1(cItem,Len(SC6->C6_ITEM)) // Incrementa 1 no ultimo item
		aCols[Len(aCols),1] := cNItem

		GetDRefresh() // Atualiza a GetDados
	EndIf


Return(lRet)
