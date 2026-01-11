#Include "Protheus.ch"
#Include "TOTVS.ch"

User Function TESTFUNC()

	Local aArea := GetArea()
	ConOut("ENTROU NA FUNCAO - TESTFUNC()")	
	MsgInfo("AQUI VOCE VAI PODER TESTAR SUAS FUNÇOES ", "DEBUG")

	If Type("FWIsInGroup") == "F"
		If !FWIsInGroup("000000") // ajuste o grupo se necessário
			MsgStop("Usuário não autorizado, solicite acesso ao Administrador.", "Operação não permitida")
			RestArea(aArea)
			Return
		EndIf
	Else
		// Ambiente não expõe FWIsInGroup no AppMap (comum em alguns cenários WebApp/AppServer)
		// Como é base local de teste, seguimos sem bloquear.
		// Se quiser, pode deixar um aviso:
		// MsgInfo("FWIsInGroup não disponível no AppMap. Rotina liberada (ambiente de teste).", "Aviso")
	EndIf

	//============================================================
	// Variáveis da tela
	//============================================================
	Private oDlgForm
	Private oGrpForm
	Private oGetForm
	Private cGetForm := Space(250)
	Private oGrpAco
	Private oBtnExec

	//Tamanho da Janela
	Private nJanLarg := 500
	Private nJanAltu := 120
	Private nJanMeio := ((nJanLarg) / 2) / 2
	Private nTamBtn  := 048

	//============================================================
	// Criando a janela
	//============================================================
	DEFINE MSDIALOG oDlgForm TITLE "TESTE DE FUNCOES - Execução DE USER FUNCTIONS" ;
		FROM 000,000 TO nJanAltu,nJanLarg COLORS 0, 16777215 PIXEL

	//Grupo Fórmula
	@ 003,003 GROUP oGrpForm TO 30,(nJanLarg/2)-1 ;
		PROMPT "Fórmula:" OF oDlgForm COLOR 0, 16777215 PIXEL

	@ 010,006 MSGET oGetForm VAR cGetForm ;
		SIZE (nJanLarg/2)-9, 013 OF oDlgForm COLORS 0, 16777215 PIXEL

	//Grupo Ações
	@ (nJanAltu/2)-30,003 GROUP oGrpAco TO (nJanAltu/2)-3,(nJanLarg/2)-1 ;
		PROMPT "Ações:" OF oDlgForm COLOR 0, 16777215 PIXEL

	// IMPORTANTE: usar ACTION com bloco evita alguns efeitos colaterais
	@ (nJanAltu/2)-24, nJanMeio-(nTamBtn/2) BUTTON oBtnExec ;
		PROMPT "Executar" SIZE nTamBtn, 018 OF oDlgForm ;
		ACTION {|| fExecuta() } PIXEL
        //ACTION {|| oDlgForm:End(), fExecuta() }
	ACTIVATE MSDIALOG oDlgForm CENTERED

	RestArea(aArea)
Return
/*---------------------------------------*
 | Func.: fExecuta                       |
 | Desc.: Executa chamada digitada       |
 | Obs.: Base de teste (executor livre)  |
 *---------------------------------------*/
static Function fExecuta()

    Local aArea := GetArea()
    Local cIn   := AllTrim(cGetForm)
    Local cCall := ""
    Local oErr

    If Empty(cIn)
        MsgStop("Informe uma função para executar.", "Atenção")
        RestArea(aArea)
        Return
    EndIf

    //============================================================
    // 1) Segurança mínima: só permitir formato de chamada
    //    Ex.: IVisual / IVisual() / U_IVisual / U_IVisual()
    //    (sem ;, sem espaços, sem concatenação, etc.)
    //============================================================
    If (";" $ cIn) .Or. (" " $ cIn) .Or. ("&" $ cIn) .Or. ("+" $ cIn) .Or. ("-" $ cIn) .Or. ;
       ("*" $ cIn) .Or. ("/" $ cIn) .Or. ("{" $ cIn) .Or. ("}" $ cIn)
        MsgStop("Entrada inválida. Informe apenas o nome da função (ex.: IVisual ou U_IVisual()).", "Atenção")
        RestArea(aArea)
        Return
    EndIf

    //============================================================
    // 2) Normalização:
    //    - Se não tem (), adiciona
    //    - Se não começa com U_ (e parece ser uma user function), prefixa
    //============================================================
    cCall := cIn

    // Se não tem parênteses, adiciona "()"
    If !("(" $ cCall)
        cCall += "()"
    EndIf

    // Se usuário digitou IVisual(), converte para U_IVisual()
    // Mantém funções padrão como MsgInfo(), Alert(), etc. sem forçar U_
    If Upper(Left(cCall, 2)) <> "U_"
        If Upper(Left(cCall, 7)) $ "MSGINFO|MSGSTOP|ALERT|CONOUT|FWALERT"
            // deixa como está (funções padrão)
        Else
            cCall := "U_" + cCall
        EndIf
    EndIf

    //============================================================
    // 3) Fecha a tela antes de executar (evita problemas de foco)
    //============================================================
    If ValType(oDlgForm) == "O"
        oDlgForm:End()
    EndIf

    //============================================================
    // 4) Executa com captura de erro
    //============================================================
    Begin Sequence
        &(cCall)
        MsgInfo("Voce executou a funcao: " + cCall, "OK")
    Recover Using oErr
        MsgStop("Falha ao executar: " + cCall + CRLF + ;
                "Erro: " + oErr:Description, "Erro")
    End Sequence

    RestArea(aArea)
Return
