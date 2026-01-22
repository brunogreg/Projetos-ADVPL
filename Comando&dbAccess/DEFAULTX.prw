#INCLUDE "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DEFAULTX  ºAdaptacao³Carlos Testa        º Data ³  09/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ferramenta para eliminacao de NULOS em banco de Dados        º±±
±±º          ³ Homologados para Protheus.                                   º±±
±±º          ³ Este programa foi adaptado para trabalhar via RDMAKE.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP 5.07, 5.08, 6.09 e 7.10                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DefaultX()
Local _oDlg,_lFimProc := .F.
Local _cMens01	:= OemToAnsi("Antes de Executar esta Rotina, efetue uma CÓPIA DE SEGURANÇA DO BANCO DE DADOS")
Local _cMens02	:= OemToAnsi("Deseja continuar com o Processo ?")
Local _cTitOdlg	:= OemToAnsi("DefaultX - Limpeza de NULOS em Banco de Dados")

Private cEmpAnt,cTabela := space(3)
Private cBanco			:= Space(10)
Private cServer			:= Space(20)
Private cDataBase		:= Space(20)
Private cDetab 			:= Space(3)  
PRIVATE cAteTab 		:= "ZZZ"
Private cDeEmp			:= "01"  
PRIVATE	cAteEmp			:= "99"
PRIVATE  ncont, ntotreg

SET(11,.T.)	// Habilita os deletados das tabelas

If MsgYesNo(_cMens01,_cMens02)
	
	@ 0,0 TO 160,400 DIALOG _oDlg TITLE _cTitOdlg
	@ 05,05 Say "Banco de Dados:"
	@ 05,50 Get cBanco
	@ 15,05 Say "Alias:"
	@ 15,50 Get cDataBase
	@ 25,05 Say "I.P. do Servidor:"
	@ 25,50 Get cServer
	@ 35,05 Say "Tabela De:"
	@ 35,50 Get cDeTab    Picture "@!"
	@ 45,05 Say "Tabela Ate:"
	@ 45,50 Get cAteTab Picture "@!"
	@ 55,05 Say "Empresa De:"
	@ 55,50 Get cDeEmp Picture "99"
	@ 65,05 Say "Empresa Ate:"
	@ 65,50 Get cAteEmp Picture "99"

	@ 20,168 BMPBUTTON TYPE 1 ACTION _lFimProc := Defa01()
	@ 40,168 BMPBUTTON TYPE 2 ACTION Close(_oDlg)
	ACTIVATE DIALOG _oDlg CENTERED
	
	// Fecha a oDlg apos encerramento da Rotina e 
	// reabre a tabela SX5 analisada e fechada durante o processamento
	If _lFimProc
		dbUseArea(.T.,"TOPCONN",RetSQLName("SX5"),"SX5",.T.,.F.)
		dbSetOrder(1)
		Close(_oDlg)
	EndIf
	
EndIf
Return Nil

// Executa a malha de processamento para analise dos dados
Static Function Defa01()
Local _cIndEmp
Private _oObjRegua2,_lRetRegua2 := .F.

Connect(nil,cBanco,cDataBase,cServer)

Alert("Certifique-se que não existe ninguem trabalhando no PROTHEUS")

dbseek(cDeEmp,.t.)
cEmpAnt := "@@"

_oObjRegua2:= MsNewProcess():New({|_lRetRegua2| RodaEmp(cEmpAnt)},"","",.F.)
_oObjRegua2:Activate()

Return Nil

Static Function RodaEmp(cEmpAnt)
Local _nValInit := 0
While SM0->(!Eof()) .and. SM0->M0_CODIGO <= cAteEmp
	IF SM0->M0_CODIGO == cEmpAnt
		SM0->( dbSkip() )
		LOOP
	Endif
	cEmpAnt := SM0->M0_CODIGO
	
	dbSelectArea("SX2")
	dbClearFilter()
	IndRegua("SX2","SX2TRB","X2_CHAVE",,,"REINDEXANDO SX2010 ...")
	If Empty(cDeTab)
		dbGoTop()
	Else
		dbSeek(cDeTab)
	EndIf
	
	If Empty(cDeTab) .AND. cAteTab == "ZZZ"
		_nValInit := SX2->(RecCount())
	Else
		// Contagem das tabelas para inicializacao da Primeira linha da Regua.
	    While SX2->X2_CHAVE <= cAteTab
	    	_nValInit++
	    	dbSkip()
	    EndDo
	    dbSeek(cDeTab)
	EndIf
	
	_oObjRegua2:SetRegua1(_nValInit)	 // TIRADO PARA TESTES
	
	While SX2->(!Eof()) .and. SX2->X2_CHAVE <= cAteTab
		_oObjRegua2:IncRegua1("Analisando Tabela "+SX2->X2_ARQUIVO+" | Empresa:"+SM0->M0_FILIAL)

		RebuildFile(SX2->X2_ARQUIVO,cBanco) //ORIGINAL
		
		dbSelectArea("SX2")
		dbSkip()
		
	EndDo

	SM0->( dbSkip() )
EndDo
TCQUIT()
Alert("Processo concluido. ; Reinicialize o Servico do TopConnect e do Protheus")
Return(.T.)

Static Function RebuildFile(cArquivo,cBanco)
Local ni,cQuery,lRename,_aRetNulos
Local _lTemNulos := .F.
Local aStru := {}

// Usa recurso de Rename no Banco
lRename  := Iif(UPPER(AllTrim(cBanco)) $ "MSSQL/ORACLE/INFORMIX",.T.,.F.)

cArquivo := Upper(Alltrim(cArquivo))
IF "."$cArquivo
	cArquivo := Subs(cArquivo,1,AT(".",cArquivo)-1)
Endif

//Verifica se a tabela existe e pode ser aberta
IF !TCCanOpen(cArquivo)
	Return Nil
Endif

dbUseArea(.T.,"TOPCONN",cArquivo,"TRBXTRB",.T.,.F.)

dbSelectArea("TRBXTRB")
aStru := dbStruct()
dbCloseArea()

// utiliza a regua2 para incremento das informacoes
_oObjRegua2:SetRegua2(Len(aStru))
If !_lRetRegua2
	_oObjRegua2:IncRegua2("Verificando existencia de NULOS Tabela "+SX2->X2_ARQUIVO)
	
	// Verifica se Existem nulos na Tabela
	_aRetNulos := TemNulos(aStru)
	
	// Caso EXISTA Campos com NULL e a estrutura NAO CONTENHA campo(s) do Tipo MEMO, efetua o acerto AUTOMATICO
	If _aRetNulos[1]
		ReConstr(RetSQLName(SX2->X2_ARQUIVO),aStru)	// Chama a Rotina de Acerto dos Nulos
	EndIf
	
	// Caso exista Campos com NULL alem do campo Tipo MEMO, avisa para acerto manual
	If _aRetNulos[2]
		Alert("A Tabela "+SX2->X2_ARQUIVO+" tem nulos no entanto não podera ser ajustada automaticamente por ter campo(s) do tipo MEMO, faça os ajustes MANUALMENTE")
		Return Nil
	Endif
	
EndIf
Return Nil

Static Function ReConstr(cArquivo,aStruRec)
Local lRename := .T.
Local ni	:= 0

If TCCanOpen("TRBXTRB")
    cQuery := 'SELECT COUNT(*) TOTREG FROM TRBXTRB'
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)
    If CONT->TOTREG > 0
        Alert("Existem dados na Tabela Temporaria <<TRBXTRB>>, verifique se os dados foram devolvidos a tabela de Origem. ;  Caso os dados possam ser descartados, DROPE a tabela e recomece o Procedimento.")
        TCQUIT()
        Return
    Else
        Alert("NAO EXISTEM DADOS na Tabela Temporaria <<TRBXTRB>>, ela sera DROPPADA")
        TCDELFILE("TRBXTRB")
    EndIf
    CONT->( dbCloseArea() )
Endif

If AllTrim(UPPER(cBanco)) == "MSSQL"
    cQuery := "sp_rename "+UPPER(cArquivo)+", TRBXTRB"
    TCSQLEXEC(cQuery)
    cQuery := "drop index "+cArquivo+"."+cArquivo+"_RECNO"
    TCSQLEXEC(cQuery)
ElseIf AllTrim(UPPER(cBanco)) == "ORACLE"
    cQuery := "rename "+cArquivo+" to TRBXTRB"
    TCSQLEXEC(cQuery)
    cQuery := "drop index "+cArquivo+"_RECNO"
    TCSQLEXEC(cQuery)
ElseIf AllTrim(UPPER(cBanco)) == "INFORMIX"
    cQuery := "rename table "+cArquivo+" to TRBXTRB"
    TCSQLEXEC(cQuery)
    cQuery := "drop index "+cArquivo+"_RECNO"
    TCSQLEXEC(cQuery)
Else
	// Qdo nao for usado o comando Rename, verifica se a qtdade de registros foi copiada integralmente
	lRename	:= .F.
    dbCreate("TRBXTRB",aStruRec,"TOPCONN")
    // Para os outros bancos, eh necessario comparar os numero de registros.
    cQuery := 'SELECT MIN(R_E_C_N_O_) MINRECNO, MAX(R_E_C_N_O_) MAXRECNO, COUNT(*) TOTREG FROM ' + cArquivo
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)

    nCont   := CONT->MINRECNO
    nTotreg := CONT->TOTREG
	_oObjRegua2:SetRegua2(nTotReg)
	While nCont <= CONT->MAXRECNO
        _oObjRegua2:IncRegua2("Preparando TRB apartir da Tabela "+SX2->X2_ARQUIVO+". Regua de Processamento 1/2")
        cQuery := "INSERT INTO TRBXTRB SELECT * FROM "+cArquivo
        cQuery := cQuery + " WHERE R_E_C_N_O_ between "+AllTrim(Str(nCont))+" AND "+AllTrim(Str(nCont+1024))
        TCSQLEXEC(cQuery)
        nCont := nCont + 1025
    Enddo
    CONT->( dbCloseArea() )
EndIf

cQuery := 'SELECT MIN(R_E_C_N_O_) MINRECNO, MAX(R_E_C_N_O_) MAXRECNO, COUNT(*) TOTREG FROM TRBXTRB'
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)

If !lRename
    // Verifica se o Total de registros foi incluso na TRBXTRB
    If nTotReg == CONT->TOTREG
        TCDELFILE(cArquivo)
        dbCreate(cArquivo,aStruRec,"TOPCONN")
    Else
        Alert("Ocorreu falha na inclusao dos dados na tabela temporaria, o processo sera abortado sem causar problemas")
        TCQUIT()
        return
    Endif
Else
    // Inicializa o Total de Registros para a Verificacao do INSERT
    nTotReg := CONT->TOTREG
    dbCreate(cArquivo,aStruRec,"TOPCONN")
EndIf

nCont := CONT->MINRECNO
Do While nCont <= CONT->MAXRECNO
    // Acerta os NULOS na tabela Temporaria
   	_oObjRegua2:SetRegua2(nTotReg)
    For ni:= 1 to Len(aStruRec)
        _oObjRegua2:IncRegua2("Verificando/Ajustando nulos do campo "+aStruRec[ni,1])
        If aStruRec[ni,2] != "M"
            cQuery := "UPDATE TRBXTRB SET "+aStruRec[ni,1]+" = "
            IF aStruRec[ni,2] == "N"
                cQuery += "0"
            Else
                cQuery += "'"+Space(aStruRec[ni,3])+"'"
            Endif
            cQuery += " WHERE "+aStruRec[ni,1]+" IS NULL"
            cQuery += " AND R_E_C_N_O_ BETWEEN "+AllTrim(Str(nCont))+" AND "+AllTrim(Str(nCont+1024))
            TCSQLEXEC(cQuery)
        EndIf
    Next
    // Insere na Nova Tabela, os registros ja SEM OS NULOS
    cQuery := "INSERT INTO "+cArquivo+" SELECT * FROM TRBXTRB"
    cQuery := cQuery + " WHERE R_E_C_N_O_ between "+Str(nCont)+" AND "+Str(nCont+1024)
    TCSQLEXEC(cQuery)
    nCont := nCont + 1025
Enddo
CONT->( dbCloseArea() )

cQuery := 'SELECT COUNT(*) TOTREG FROM '+cArquivo
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'CONT', .F., .T.)

If nTotReg == CONT->TOTREG
   CONT->( dbCloseArea() )
   TCDELFILE("TRBXTRB")
Else
   CONT->( dbCloseArea() )
   Alert("Ocorreu falha na inclusao dos dados na tabela "+cArquivo+". Ajuste de acordo dados da TRBXTRB.")
   TCQUIT()
   Return Nil
Endif

TCQUIT()
Return Nil

Static Function CONNECT(cType,cBanco,cDataBase,cServer)
cBanco		:= Upper(Alltrim(cBanco))
cDataBase	:= Alltrim(cDataBase)
cServer		:= Upper(Alltrim(cServer))

TCCONTYPE("TCPIP")	// Estabelece comunicacao com o Top em Padrão TCPIP
nConecta := TCLINK(cBanco+"/"+cDataBase,cServer)
If nConecta < 0
   Alert("Falha na Conexao TOPCONN")
   Quit
Endif

Return

Static Function TemNulos(aStru)
Local _lRetNul	:= .F.
Local _lTemMemo	:= .F.
Local _aRetFunc
Local _aStruNul	:= aClone(aStru)
AADD(_aStruNul,{"D_E_L_E_T_","C",1,0})	//agrega o campo D_E_L_E_T_ a matriz para buscar nulos tb
// Verifica a existencia de campos tipo MEMO na tabela, caso exista deve ser efetuado acerto manual
_oObjRegua2:SetRegua2(Len(_aStruNul))
For ni:= 1 to Len(_aStruNul)
    _oObjRegua2:IncRegua2("Analisando Estrutura do Campo "+_aStruNul[ni,1])
    If _aStruNul[ni,2] == "M"
       _lTemMemo := .T.
       Exit
    EndIf
Next 
// Verifica a existencia de NULL na tabela
If !_lTemMemo
	_oObjRegua2:SetRegua2(Len(_aStruNul))
	For ni:= 1 to Len(_aStruNul)
	   	_oObjRegua2:IncRegua2("Analisando NULOS no Campo "+_aStruNul[ni,1])
	    If _aStruNul[ni,2] != "M"
	       cQuery := "Select count(*) NULOS from "+SX2->X2_ARQUIVO
	       cQuery += " WHERE "+_aStruNul[ni,1]+" IS NULL "
	       dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBNUL', .F., .T.)
	       dbSelectArea('TRBNUL')
	       If TRBNUL->NULOS > 0
	           _lRetNul := .T.
		       TRBNUL->( dbCloseArea() )
		       Exit
	       EndIf
	       TRBNUL->( dbCloseArea() )
	    EndIf
	Next
EndIf
_aRetFunc := {_lRetNul,_lTemMemo}
Return(_aRetFunc)
