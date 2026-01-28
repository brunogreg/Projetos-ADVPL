#Include "Protheus.ch"
#Include "RWMake.ch"

User Function UCOMA001()

	Local lValidaTes := .F.
	Local dData 	 := cTod("")

    // formas de converter dados
	cTod("") //"31/12/2026" - 31/12/2026 	-> Converto caracter para Data.
	sTod("") //20261231     - 31/12/2026 	-> Converto string para Data.
	dTos("") //31/12/2026 	- 20261231 		-> Converto data para string.
	dToc("") //31/12/2026 	- "31/12/2026" 	-> Converto data para caracter.

	if VldDados()
		lValida := GravaDds()
	endif

Return(lValida)

Static Function VldDados()

	Local lTeste := .F.

	lTeste := MsgYesNo("Vamos continuar ?","Atenção!")

Return(lTeste)

Static Function GravaDds()

	Local lValida := .T.

	MsgInfo("Teste realizado com sucesso!","Teste")

Return(lTeste)


User Function UCOMA002()

	Local nVal1 	:= 0
	Local nVal2 	:= 0
	Local nResult 	:= 0

	nVal1 := fRetVlr1()
	nVal2 := fRetVlr2()
	nResult := nVal1+nVal2

	MsgInfo("O resultado é : " + cValToChar(nResult),"Atenção!")

Return(Nil)

Static Function fRetVlr1()

	Local nValor := 2

Return(nValor)

Static Function fRetVlr2()

	Local nValor := 3

Return(nValor)

User Function UCOMA003()

	Local nVal1 	:= 0
	Local nVal2 	:= 0
	Local nResult 	:= 0

	nVal1 := fRetVlr3()
	nVal2 := fRetVlr4()
	fCalcula(nVal1,nVal2,@nResult)

	MsgInfo("O resultado é : " + cValToChar(nResult),"Atenção!")

Return(Nil)

Static Function fRetVlr3()

	Local nValor := 2

Return(nValor)

Static Function fRetVlr4()

	Local nValor := 3

Return(nValor)

Static Function fCalcula(nVal1,nVal2,nResult)

	Default nVal1
	Default nVal2
	Default nResult

	nResult := nVal1+nVal2

Return(Nil)
	
User Function UFATA001()

	Local nNumer1 := 10
	Local nNumer2 := 5

	if nNumer1 > nNumer2
		MsgInfo("Numero1 é maior")
	elseif nNumer1 < nNumer2
		MsgInfo("Numero2 é maior")
	else
		MsgInfo("São iguais")
	endif

Return(Nil)


User Function TstCase()

	Local nOpc := 2

	Do Case
	Case nOpc == 1
		MsgAlert("Opção 1 selecionada")
	Case nOpc == 2
		MsgAlert("Opção 2 selecionada")
	Case nOpc == 3
		MsgAlert("Opção 3 selecionada")
	Otherwise
		// Otherwise é opcional.
		MsgAlert("Nenhuma opção selecionada")
	EndCase
Return()

	 
User Function UFATA003()

	Local nCont := 0

	While nCont <= 10
		MsgInfo("SEquencia : " + cValToChar(nCont),"Atenção!")
		nCont++
	enddo

Return(Nil)

User Function UFATA002()

	Local aDados := {"Janeiro","Fevereiro","Março","Abril"}
	Local nCont  := 0

	While nCont <= len(aDados)
		MsgInfo("Mês : " + aDados[nCont],"Atenção!")
		nCont++
	enddo

Return(Nil)

User Function UFATA004()

	Local aDados := {"Janeiro","Fevereiro","Março","Abril"}
	Local nX 	 := 1

	for nX := 1 to len(aDados)
		MsgInfo("Mês : " + aDados[nX],"Atenção!")
	next nX

Return(Nil)
	 
/*/
	SA1
	1 - A1_FILIAL+A1_COD+A1_LOJA
	2 - A1_FILIAL+A1_NOME
	3 - A1_FILIAL+A1_CGC
/*/

User Function UCOMA005()

	Local aArea 	:= FwGetArea()
	Local aAreaSA1 	:= SA1->(FwGetArea())
	Local cCnpj  	:= "70031035167"

	//Utilizar em logicas mais complexas.
	DbSelectArea("SA1")
	DbSetOrder(3)
	DbSeek(FWxFilial("SA1")+cCnpj)
	While !SA1->(Eof()) .AND. SA1->A1_CGC == cCnpj

		SA1->(DbSkip())
	enddo

	//Utilizar em logicas mais simples.
	Posicione("SA1",3,FWxFilial("SA1")+cCnpj,"A1_NOME")

	FwRestArea(aArea)
	FwRestArea(aAreaSA1)

Return(Nil)
