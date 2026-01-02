/*

ESSAS FUNÇOES SAO IDEIAS PARA SETAR OS TIPOS DOS CAMPOS

ExistCpo() Verifica se um campo existe em uma determinada tabela aberta no Protheus

If ExistCpo("SA1", "A1_NOME")
    MsgInfo("O campo A1_NOME existe na tabela SA1")
EndIf

---------------------------------------------------------------------------------
ExistChv() Verifica se um registro existe, normalmente com base na chave primária da tabela.

If ExistChv("SA1", xFilial("SA1") + "00000101")
    MsgInfo("Cliente já cadastrado")
EndIf

------------------------------------------------------------------------------------

NaoVazio() Retorna .T. se o valor não estiver vazio, considerando o tipo da variável
O que é considerado vazio
String: ""
Número: 0
Data: Ctod("")
Lógico: .F.

If NaoVazio(cNome)
    MsgInfo("Nome preenchido")
EndIf

----------------------------------------------------------------------------------------

Vazio() Retorna .T. se o valor estiver vazio, conforme o tipo

If Vazio(dData)
    MsgAlert("Data não informada")
EndIf

---------------------------------------------------------------------------------------

Negativo() Verifica se um valor numérico é negativo (menor que zero).
Positivo() Verifica se um valor numérico é positivo (maior que zero).
Uso comum
Financeiro
Validações de estoque
Regras de negócio

If Negativo(nSaldo)
    MsgAlert("Saldo negativo")
EndIf

-----------------------------------------------------------------------------------------

Texto() Finalidade Converte qualquer valor para texto (string).
Quando usar
Exibição em mensagens
Concatenação de valores
Logs
Exemplo

MsgInfo("Valor: " + Texto(nValor))

*/
