#Include "protheus.ch"

User Function TESTEVAR()

    // Variáveis numéricas
    Local nNumero  := 10.5
    Local cNumero  := ""

    // Variáveis de data
    Local dData    := Ctod("01/12/21")
    Local cData    := ""
    Local sData    := ""

    // Variáveis de texto
    Local cTexto   := "AULA PRATICA"
    Local cTexto2  := ""

    // Converter data para caractere (DD/MM/YY)
    cData := Dtoc(dData)

    // Converter data para string (AAAA-MM-DD ou outro formato configurado)
    sData := Dtos(dData)

    // Converter número em caractere
    cNumero := Str(nNumero)

    // Pegar apenas os 5 primeiros caracteres do texto
    cTexto2 := SubStr(cTexto, 1, 5)

    // Deixar apenas a primeira letra maiúscula
    cTexto2 := Upper(SubStr(cTexto2, 1, 1)) + Lower(SubStr(cTexto2, 2))

    // Deixar tudo em minúsculo
    cTexto2 := Lower(cTexto2)

    // Trocar letra A por O
    cTexto2 := StrTran(cTexto2, "a", "o")

    // Exibir resultados no console do Protheus
    ConOut("Número (caractere): " + cNumero)
    ConOut("Data caractere: " + cData)
    ConOut("Data string: " + sData)
    ConOut("Texto final: " + cTexto2)

Return
