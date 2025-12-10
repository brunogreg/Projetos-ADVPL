#INCLUDE "Protheus.ch"
#INCLUDE "TOTVS.CH" 


User Function conversaoVariaveis()

    Private dData := CtoD("10/01/21")
    ALERT(Dtoc(dData))

    cData  := Dtoc(dData) //data para caracter
    sData  := Dtos(dData) //data para string
    dData2 := StoD(sData) //string para data

    cNumero   := CValToChar(nNumero) // converte para string sem nenhum espaço
    cNum2     := Str(nNumero, 5, 2) //converte pra string mas coloca espaços ao lado do valor nesse caso ele esta com 5 casas e 2 espaços decimais
    cNumStrZ  := StrZero(nNumero, 10) //converte pra string mas coloca zeros ao lado do valor vai inserir 10 digitos zeros na frente
    nNum2     := Val(cNum2) // transforma em valores

return
