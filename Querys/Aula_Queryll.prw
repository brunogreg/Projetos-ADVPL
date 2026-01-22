#INCLUDE 'Protheus.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE ENTER Chr(13)+Chr(10)

User Function  AQueryII()


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
	cSql :=" Select A2_COD,  A2_LOJA, A2_NREDUZ, A2_EST, A2_MSBLQL,A2_ULTCOM "+ENTER
	cSql +=" FROM " + RetSQLName("SA2")+" "+ENTER
	cSql +=" Where A2_FILIAL = '" + xFilial("SA2") + "'"+ENTER
	cSql +=" AND D_E_L_E_T_ = ' ' "+ENTER
	cSql +=" AND A2_ULTCOM <= '"+Dtos(Date())+"'"
	
	//GERA ARQUIVO NA PASTA SYSTEM
	MemoWrite("AULA_QUERYII.SQL",cSql)

	//TRATAMENTO ADEQUACAO QUERY
	cSql := ChangeQuery(cSql)

	//CRIA TABELA TEMPORARIA
	dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cSql),(cAliasFor), .F., .T.)


	//CONVERSAO TIPO DE DADO
	TCSetField(cAliasFor,"A2_ULTCOM","D" )

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
