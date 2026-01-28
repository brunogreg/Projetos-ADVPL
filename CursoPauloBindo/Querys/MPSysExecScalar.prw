
#include "protheus.ch"

#define C_GRUPO  "99"
#define C_FILIAL "01"

/*
MPSysExecScalar
Executa uma consulta e retorna a primeira linha no conjunto de resultados retornados 
pela consulta. Colunas ou linhas adicionais são ignoradas.

https://tdn.totvs.com/display/public/framework/MPSysExecScalar

Executa uma consulta e retorna a primeira linha no conjunto 
de resultados retornados pela consulta. Colunas ou linhas adicionais são ignoradas.
*/
User Function TstQuery()
	Local cQuery as character
	Local nCount as numeric
	RpcSetEnv(C_GRUPO, C_FILIAL)

	cQuery := "SELECT COUNT(R_E_C_N_O_) NREC FROM " + RetSqlName("SB1") + " WHERE D_E_L_E_T_ <> '*' AND B1_PESO >= 0"
    // MpSysExecScalar responsavel por executar a query e retornar o valor da coluna NREC
	nCount := MpSysExecScalar(cQuery,"NREC")
	Conout("Tabela possui " + cValToChar(nCount) + " registros")
	RpcClearEnv()
Return


//EXEMPLO COM BIND

user Function mybind()

	Local cQuery        as character
	Local nVal          as numeric
	Local aBindParam    as array
	RpcSetEnv(C_GRUPO, C_FILIAL)
	cQuery := "SELECT COUNT(*) CNT FROM " + RetSqlName("SB1") + "  WHERE   D_E_L_E_T_ <> ? AND B1_PESO >= ? "
	cQuery := ChangeQuery(cQuery)

//os parametros DEVEM ser enviados na mesma ordem em que aparecem na query.
	aBindParam := {'*', '0'}

	nVal := MPSysExecScalar(cQuery,'CNT',aBindParam) // MpSysExecScalar responsavel por executar a query e retornar o valor da coluna CNT
    Conout("Tabela possui " + cValToChar(nVal) + " registros")
	RpcClearEnv()
Return
