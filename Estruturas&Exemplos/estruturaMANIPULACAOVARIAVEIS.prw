#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"

User Function manipulacaoVariaveis()

    nTotal := ABS(100-1000) // Ela retorna um valor absoluto
    nNumero := Int(10.398)  // Ele pega somente o valor inteiro do numero informado nesse caso ele ira considerar apenas o 10
    nNumero2 := NoRound(10.398,1) // ELe pega o numero inteiro e mais quantas casas decimais forem informadas nesse caso vai pegar 1 só
    // Obs essa estrutura de No Round é  muito usada em relatorios e pode gerar calculos errados se nao for tratado desde o inicio com a mesca quantidade de casas

    if VALTYPE(cUsuario) == "c"  // Ela informa qual o tipo da sua variavel no caso seria c de caracter
        alert("A variavel é do tipo c")
    Endif

    if Type("nNumero") == "N" // E pareceido com a estrutura VALTYPE mas deve se colocar a variavel entre ""
        alert("ok")
    Endif

Return
