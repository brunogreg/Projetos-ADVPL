#INCLUDE "Protheus.ch"
#INCLUDE "TOTVS.CH" 

User Function operadoresLogicos()
    
    // Operadores logicos 

    if nResult >0 .And. "teste" $ cBranco
        ALERT("teste e ok")
    elseif nResult >0 .Or. "teste" $ cBranco
        ALERT("TESTE OU OK") 
    Elseif Not(nResult >0) .Or. !("teste" $ cBranco)
        ALERT("teste ou ok")
    Elseif !(nResult >0) .And. "teste" $ cBranco
        ALERT("nao aconteceu")
    EndIf   
    
Return 
