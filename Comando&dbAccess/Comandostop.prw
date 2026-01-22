#Include "Topconn.ch"
#Include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณtestatop  บAutor  ณMicrosiga           บ Data ณ  07/05/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function testatop()
    
	//TCCanOpen - Cria arquivo CHECKTOP DE LOG DE INFORMACOES ALTERADAS NA TABELA TOP_FIELD
	If TCCanOpen("CHECKTOP")
		TCSQLEXEC("TRUNCATE TABLE CHECKTOP")
	else
		AADD(aCamposCHK,{'CHK_TABLE','C',64,0})
		AADD(aCamposCHK,{'CHK_NAME' ,'C',32,0})
		AADD(aCamposCHK,{'CHK_TYPE' ,'C',2 ,0})
		AADD(aCamposCHK,{'CHK_PREC' ,'C',4 ,0})
		AADD(aCamposCHK,{'CHK_DEC'  ,'C',4 ,0})
		AADD(aCamposCHK,{'CHK_NUM'  ,'N',2 ,0})
		AADD(aCamposCHK,{'CHK_DAT'  ,'D',8 ,0})
		AADD(aCamposCHK,{'CHK_LOG'  ,'L',1 ,0})
		dbCreate("CHECKTOP",aCamposCHK,"TOPCONN")
	Endif

//TCDelfile -exclui tabela no servidor
	if empty(cUserTable)
		TCDelfile("CHECKTOP")
	Endif

	//TCCanOpen - Testa a exist๊ncia do ํndice
	IF !TCCanOpen("CHECKTOP","CHK_TABLE1")
		INDEX ON CHK_TABLE TO CHK_TABLE1
	ELSE
		SET INDEX TO CHK_TABLE1
	ENDIF

//TCCONTYPE - faz conexao banco de dados
	cBanco		:= Upper(Alltrim(cBanco))
	cDataBase	:= Alltrim(cDataBase)
	cServer		:= Upper(Alltrim(cServer))

	TCCONTYPE("TCPIP")	// Estabelece comunicacao com o Top em Padrใo TCPIP
	nConecta := TCLINK(cBanco+"/"+cDataBase,cServer)
	If nConecta < 0
		Alert("Falha na Conexao TOPCONN")
		Quit
	Endif


//TCGetDb -retorna o tipo de banco de dados
	cBanco := Alltrim(Upper(TCGetDb()))

//TCQUIT -encerra todas as conexoes com o dbaccess
	TCQUIT()


//TCLink - seleciona uma conexao ativa no dbaccess
// Abre conexใo com o ambiente de Produ็ใo
	nCon1 := TCLink("MSSQL/PRODUCAO")
	if nCon1 < 0
		Alert("Falha conectando ambiente de Produ็ใo")
		QUIT
	endif

// Abre conexใo com o ambiente de Testes
	nCon2 := TCLink("MSSQL/TESTES")
	if nCon2 < 0 
		Alert("falha conectando ambiente de Testes")
		QUIT
	endif

//TCUnLink - encerra conexao com o dbaccess
	TCUnLink(nCon2)




//TcSqlExec -executa comandos no mssql 
//TCSqlError -exibe erros de uma execucao
	cQuery := " UPDATE "+RetSqlName("SC5")+" SET C5_BLOQC = '', C5_BLOQE = '', C5_BLOQP = '' WHERE C5_FILIAL = '01' AND C5_NOTA = '' AND C5_PLIB4 IN ('','LIB.IMP')"
	If TcSqlExec(cQuery) <0
		UserException( "Erro na atualiza็ใo"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
	EndIf


//TcSrvType - Retorna o Tipo do Servidor onde esta sendo executado o dbAccess
	TcSrvType() != "AS/400"



Return
