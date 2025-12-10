#INCLUDE "Protheus.ch"  // Diretivas de compilação onde é avaliado o que esta dentro do include pra avaliar se o codigo esta nos conformes

User Function funcoes()

// funtion mata010()
// function mata410()
// function mata030() 
// Esses são modelos de funçoes criadas pela Totvs, porem nao conseguimos compilar desta forma
//Template Function Mata010()
//mata030()
//u_funcoes
//SIGAADV
//SIGACFG
//MAIN FUNCTION SIGACFG()

//ESSES SAO VARIOS MODELOS DE FUNCOES QUE TEMOS QUANDO TRABALHAMOS COM ADVPL TOTVS PROTHEUS

//STATICS FUNCTIONS SO FUNCIONAM DENTRO DO MESMO ARQUIVO RDMAKE
    Local nValor := 10
    Local nQuantidade := 5
    Local nConta

    nConta := U_Calcula(@nValor,nQuantidade) //o @ significa que ele ira trabalhar com o nomvo valor que vai receber
    nConta := U_Calcula(@nValor) //te a possibilidade tbm de a função nao vir com os parametros
    //pra se chamar uma user function deve se usar o u_
Return

User Function Calcula(nValor,nQuantidade)

Local nTotal := nValor * nQuantidade
DEFAULT nQuantidade := 20 // UMA DAS ALTERNATIVAS DE QUANDO NAO SE VEM UM PARAMETRO E TRABALHAR COM PADRAO

If ValType(nQuantidade) # "n" //Para certificar se que o nQuantidade tera um valor pois o valltype vai ver o tipo de variavel que ela é
    nQuantidade := 0
Endif

conOut(nTotal)

Return(nTotal)
