#INCLUDE "Protheus.ch"

User Function estruturaFOR() // Para realizar uma estrutura por uma quantidade determinada de vezes

    Local nNumero := 0

    For nNumero := 1 To 10 STEP 2 // Indica que meu for sera adicionado de 2 em 2

        Conout( CValToChar(nNumero) )

        If nNumero == 5
            Loop            // Volta para o próximo ciclo do FOR e ignora tudo abaixo dele
        ElseIf nNumero == 9
            Exit            // Sai do FOR imediatamente
        else
            nNumero --  //sempre vai remover 1 do valor de for          
        EndIf

        Conout( "PASSOU " + CValToChar(nNumero) + " VEZES" )

    Next

Return




Return
