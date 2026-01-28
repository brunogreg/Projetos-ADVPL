#include "Protheus.ch"    

User Function DECLVAR()
    
    Local nNumero := 42
    
    Local cTexto := "Uniformizar em modo turbo"
    
    Local lAtivo := .T.
    
    Local aLista := { "Camisa", "cal�a", "Jaleco" }
    
    Local dHoje := Date()
    
    Local bCalculo := { |x, y| x * y + 10 }
    
    Alert("Número: " + AllTrim(Str(nNumero)))
    Alert("Texto: " + cTexto)
    Alert("Lógico: " + iif(lAtivo, "Verdadeiro", "Falso"))
    Alert("Primeiro item do array: " + aLista[1])
    Alert("Data de hoje: " + DtoC(dHoje))
    Alert("Resultado do bloco: " + AllTrim(Str( Eval(bCalculo, 5, 3) )) )

Return
