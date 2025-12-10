#Include "protheus.ch"

User Function NUMERICAS()
    
    // Declaração das variáveis
    
    Local nNumero    := 0
    Local nResultado := 0
    Local cTexto     := ""
    Local aArray     := {}
    
    // Atribuição dos valores
    
    nNumero    := 13
    nResultado := Round(nNumero / 2, 2)    // Divide por 2 e deixa com 2 casas decimais
    cTexto     := "Bruno"
    aArray     := {1, 2, 3}
    
    // Exibir o tipo de cada variável
    
    Alert("nNumero é do tipo: "    + ValType(nNumero))
    Alert("nResultado é do tipo: " + ValType(nResultado))
    Alert("cTexto é do tipo: "     + ValType(cTexto))
    Alert("aArray é do tipo: "     + ValType(aArray))

Return
