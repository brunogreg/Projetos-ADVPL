#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'//par usar o TCQUERY
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE ENTER Chr(13)+Chr(10)

User Function  AQuery()

	Local cAliasFor
	Local cSql := ""
	Local nRec := 0

	If SELECT("SX6") >0
		ALERT("PROTHEUS ABERTO")
	Else
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"
	EndIf

	cAliasFor := GetNextAlias() //CRIA ALIAS TEMPORARIO

	//TEXTO QUERY
	cSql :=" Select A2_COD,  A2_LOJA, A2_NREDUZ, A2_EST, A2_MSBLQL,A2_ULTCOM "+ENTER //enter para quebra linha
	cSql +=" FROM " + RetSQLName("SA2")+" "+ENTER //usa funcao para retornar nome correto da tabela
	cSql +=" Where A2_FILIAL = '" + xFilial("SA2") + "'"+ENTER //filial atual
	cSql +=" AND D_E_L_E_T_ = ' ' "+ENTER

	//GERA ARQUIVO NA PASTA SYSTEM
	MemoWrite("AULA_QUERY.SQL",cSql)// memowrite gera um arquivo com a query para conferência

	//TRATAMENTO ADEQUACAO QUERY
	cSql := ChangeQuery(cSql) //usa funcao TBI para adequar query ao banco corrigir a falta de , e ;

	//CRIA TABELA TEMPORARIA
	TCQUERY ( cSql ) ALIAS ( cAliasFor ) NEW

	//CONVERSAO TIPO DE DADO
	TCSetField(cAliasFor,"A2_ULTCOM","D" ) //tcsetfield para converter campo para data

	//CONTA QUANTIDADE REGISTROS
	Count To nRec 

	If nRec == 0
		Alert("NAO FORAM ENCONTRADOS DADOS, REFACA OS PARAMETROS","ATENCAO")
		DbSelectArea(cAliasFor)
		dbCloseArea()
		Return
	EndIf


	//ABRE TABELA TEMPORARIA
	DbSelectArea(cAliasFor)
	dbGoTop()

	While !Eof()

		Conout(A2_COD+" - "+A2_NREDUZ)


		DbSelectArea(cAliasFor)
		dbSkip()
	End

	//FECHA A TABELA TEMPORARIA
	DbSelectArea(cAliasFor)
	dbCloseArea()

	RESET ENVIRONMENT
Return
