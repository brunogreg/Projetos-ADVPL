#INCLUDE "Protheus.ch"
#INCLUDE "TOTVS.CH" 

User Function operadoresRelacionais()

// Operadores relacionais comparações

    if nResult > 0
        ALERT("maior que zero")
    elseif nResult < 0
    ALERT("menor que zero")
    elseif nResult == 0
    ALERT("igual a zero")
    elseif nResult <= 0
    ALERT("menor igual zero")
    elseif nResult >= 0
    ALERT("maior igual zero")
    elseif nResult <> 0
    ALERT("diferenteque zero")
    elseif nResult # 0
    ALERT("diferente de zero")
    elseif nResult != 0
    ALERT("nao igual a zero")
    Endif

return
