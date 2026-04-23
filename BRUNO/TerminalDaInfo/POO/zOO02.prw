//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zOO02
Função que testa a classe Pessoa (via Debug para ver os atributos)
@author Atilio
@since 26/04/2022
@version 1.0
    @example
    u_zOO02()
/*/
 
User Function zOO02()
    Local oPessoa
    Local cNome        := "José"
    Local dNascimento  := sToD("19850712")
     
    //Instanciando o objeto através da classe Pessoa
    oPessoa := zPessoa():New(cNome, dNascimento)
     
    //Chamando um método da classe
    oPessoa:MostraIdade()
Return
