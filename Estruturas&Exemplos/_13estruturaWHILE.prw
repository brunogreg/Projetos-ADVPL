#INCLUDE "Protheus.ch"
#INCLUDE "TOTVS.CH" 

User Function estruturaWhile()
    Local nNumero := 0

    While nNumero <= 10

        If nNumero == 5
            nNumero ++
            Loop              // Volta para o começo do WHILE sem executar o incremento
        ElseIf nNumero == 9
            Exit              // Sai completamente do WHILE
        EndIf

        nNumero++             // Incrementa a variável

    End    
Return 
