#INCLUDE "Protheus.ch"

User Function estruturaArrays()
	Private aVeiculos := {}

    // 1-NOME, 2-MARCA, 3-COMBUSTIVEL, 4-SOM, 5-ANO, 6-PRECO, 7- PLACA PRETA
	aVeiculos := {}

    AADD(aVeiculos,{"FUSCA","VW","GASOLINA",.F.,1964,30000}) //A funcao AADD é usada para inserir informaçoes em um array
    AADD(aVeiculos,{"CHEVETE","GM","GASOLINA",.T.,1976,10000})

	ALERT("NOME: " + aVeiculos[1,1])

    // como mudar os valores
	aVeiculos[1] := "Fusca 1300" 
    aVeiculos[2] := "Fiat"
    aVeiculos[3] := "Disel"
    aVeiculos[4] := .T.
    aVeiculos[5] += 2
    aVeiculos[6] := 20000
 
    ASIZE(aVeiculos,7) // Esse comando e responsavel por incrementar meu array passando ele para um array de 7 posiçoes
    ADEL(aVeiculos,7)  //Ele apaga o que tem na posição 7
Return
