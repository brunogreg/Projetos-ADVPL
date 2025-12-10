#INCLUDE "Protheus.ch"
#INCLUDE "TOTVS.CH" 

User Function operadoresString()
    
    cBranco := "teste"+space(10)  // Operadores de string
    cBranco2 := cBranco - " teste2" // o sinal de (-) serve para tirar os espaços

    if "teste" $ cBranco 
        ALERT("OK")
    Else 
        ALERT("NAO ENCONTROU")
    EndIf

return
