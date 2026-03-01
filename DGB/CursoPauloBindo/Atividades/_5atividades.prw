#INCLUDE "Protheus.ch"
//ARRAYS
User Function DECISAO()
	Local nNumero := nCount := 0
	Local lContinua := .T.
	Local aArray1 := {0,0,0}
	Local aArray2 := {}
	//jjjLocal aArray3 := ARRAY(3,3)

	While lContinua
		nCount++ // incrementa

		aArray1[1]:= nCount
		aArray1[2]:= nCount/2
		aArray1[3]:= nCount**2

		If nCount == 10
			lContinua := .F.  // força a saída do WHILE
		EndIf

	End

	For nNumero := 1 To 10

		aAdd(aArray2,{nNumero})

		If nNumero == 7
			Exit    // encerra o FOR imediatamente
		EndIf

	Next

	nTamanho := Len(aArray2)-1
	nPos := ASCAN(aArray2,{ | x | x[1] == 4}) // procura um elemento dentro de um array e retorna a posição onde encontrou.
	ADEL(aArray2, nPos) //remove o elemento da posição informada.
	ASIZE(aArray2, nTamanho) // Ajusta o tamanho do array (corta o “slot” vazio criado pelo ADEL).

Return
