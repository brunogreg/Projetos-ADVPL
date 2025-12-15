#INCLUDE "Protheus.ch"
#INCLUDE "TOTVS.CH" 


User Function manipulacaoString()

    cNum2 := AllTrim("   B R U N O   ") // Remove todos os espaços no inicio e no final da variavel apaneas
    cNum2 := AllTrim(cNum2)  
    cAsc := ASC("A")             //Essa funcao ela pega um caracter e te da o valor asc dela, serve tambem pra fazer calculos numericos pois cada tecla do teclado tem um valor especifico seguindo uma tabela por exemplo o A = 65 pois se vc digitar alt+ um atalho vai dar o valor equivalente
    cChr := CHR(cAsc)            //e faz o inverso da funcao asc
    cTexto := At("U", "BRUNO")  // Ela serve para identificar a primeira caracter informada nesse caso onde esta a letra u a resposta sera 3
    cTexto := RAt("U", "BRUNO") // ela pega a ultima posicao do caracter informado quando nao tem nada ele informa zero
    cTexto2 := "BRUNO"
    nNumCar := Len("BRUNO")     // len é usado para informar quantos caracters tem na palavra ou frase informada ou caso linha, ou array
    nNomeCli := "Bruno Couto Gregorio"
    cTexto2 := LOWER("BRUNO")   // Deixa tudo minusculo
    cTexto2 := UPPER("BRUNO")   // Deixa tudo MAIUSCULO
    cTexto2 := CAPITAL("BRUNO") // Deixa apenas a primeira letra em maiusculo
    STUFF("PPQQQPP",3,1,"SSS")  // Permite substituir caracteres apartir da 3 posiçao pegando 1 dos "Q" e trocando por sss 
    nNomeCli := SubStr("Bruno Couto Gregorio",1,5) // Usado para pegar informaçoes em linhas ou informaçoes muito compridas por exemplo ele vai pegar a primeira pavara com 5 caracteres nesse caso ira retornar bruno
    CNomeCli := PadR("bruno Couto",15,"*") // completa com casas a direita apos a casa 15 que foi indicada
    CNomeCli := PadC("bruno Couto",15,"*") // ele completa com casas dos dois lados de acordo com o tanto que voce indicar
    CNomeCli := PadL("bruno Couto",15,"*") // completa com casas a esquerda 
    CNomeCli := Replicate("*",100) // transforma linhas em strings pode ser mais encontrado em relatorios
    CNomeCli := StrTran("bruno Couto","o","z") //usado para transforma caracteres nesse caso em exemplo trocas as letras o por letras z
    
        
return
