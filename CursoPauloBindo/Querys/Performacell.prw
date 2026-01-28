#include 'protheus.ch'
#define C_GRUPO  "99"
#define C_FILIAL "01"

//-------------------------------------------------------------------
/*/{Protheus.doc} cache_ex
Este exemplo mostra o uso do cache de queries. 
Este cache faz com que a query seja buscada na dbapi, se for o mesmo resultset.
muito útil quando executamos a mesma query em diversos lugares do sistema
Documentação disponível em https://tdn.totvs.com/display/PROT/FWExecCachedQuery
@author  framework
@since   08/10/2021
@version 1.0
/*/
//-------------------------------------------------------------------
user function cache_ex()
	Local cQuery    as character
	Local cAlias    as character
	Local nTime     as numeric
	Local nX        as numeric
	Local oExec     as object

	RpcSetEnv(C_GRUPO, C_FILIAL)


//----------------------------------
//para o exemplo vamos conectar no banco de dados.
//mas para uso, basta estar conectado
//----------------------------------


	cQuery := "SELECT * FROM " + RetSqlName("SB1") + " WHERE D_E_L_E_T_ <> '*' AND B1_COD = '000001' AND B1_PESO >= 0"

	cAlias := GetNextAlias()

	Conout('******************************dbuseArea***************')

	For nX := 1 to 10
		nTime := Seconds()

		DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)

		Conout('Tempo decorrido - '+ cValToChar(Seconds() - ntime ))

		(cAlias)->(DbCloseArea())
	Next

//executando com cache

	Conout('******************************Cache***************')

	For nX := 1 to 10
		nTime := Seconds()

		cAlias := FwExecCachedQuery():OpenQuery(cQuery,,,,'300','120')
		aStruQry	:= &(cAlias)->(dbStruct())
		Conout('Tempo decorrido - '+ cValToChar(Seconds() - ntime ))

		(cAlias)->(DbCloseArea())
	Next


//executando com cache

	Conout('******************************Cache e bind***************')
	cQuery := "SELECT ? FROM " + RetSqlName("SB1") + " WHERE D_E_L_E_T_ <> ? AND B1_COD = ? "
	cQuery += " AND B1_PESO >= ? AND B1_TIPO IN (?)"
	oExec := FWExecStatement():New(cQuery)
	oExec:SetUnsafe(1,'B1_DESC')
	oExec:SetString(2,'*')
	oExec:SetString(3,'000001')
	oExec:SetNumeric(4,0)
	oExec:SetIn(5,{'PA','PI'})
	
	cQryNFS := oExec:GetFixQuery()
	
	For nX := 1 to 10
		nTime := Seconds()

		oExec:OpenAlias(@cAlias,'300','120')
		aStruQry	:= &(cAlias)->(dbStruct())
		Conout('Tempo decorrido - '+ cValToChar(Seconds() - ntime ))

		(cAlias)->(DbCloseArea())
	Next

	RpcClearEnv()
Return


