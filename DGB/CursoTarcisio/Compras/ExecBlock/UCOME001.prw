#INCLUDE "PROTHEUS.CH"

User Function UCOME001()
	// Salva a area atual
	Private aArea 	:= FwGetArea()
	Private oButton1
	Private oButton2
	Private oComboBo1
	Private nComboBo1 := 1
	Private oComboBo2
	Private nComboBo2 := 1
	Private oGet1
	Private cGet1 := space(40)
	Private oGet2
	Private cGet2 := space(3)
	Private oSay1
	Private oSay2
	Private oSay3
	Private oSay4
	Static oDlg

    // Cria uma caixinha de diálogo
	DEFINE MSDIALOG oDlg TITLE "Gravação de Turma" FROM 000, 000  TO 250, 300 COLORS 0, 16777215 PIXEL

	@ 031, 033 SAY oSay1 PROMPT "Descrição" SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 030, 065 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 042, 032 SAY oSay2 PROMPT "Codigo" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 045, 063 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 060, 032 SAY oSay3 PROMPT "Periodo" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 074, 033 SAY oSay4 PROMPT "Situação" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 059, 062 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"1=Manha","2=Tarde","3=Noite"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 073, 061 MSCOMBOBOX oComboBo2 VAR nComboBo2 ITEMS {"1=Ativa","2=Suspensa","3=Encerrada"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 092, 028 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()
	@ 091, 086 BUTTON oButton2 PROMPT "Confirmar" SIZE 037, 012 OF oDlg PIXEL ACTION GRAVAR()

	ACTIVATE MSDIALOG oDlg CENTERED


	FwRestArea(aArea)

Return(Nil)


Static Function GRAVAR()

	// Pergunta ao usuario se deseja gravar
	if MsgYesNo("Deseja gravar a Turma? ","Pergunta!")
		// Seleciona a tabela ZB1 para gravar os dados
		RecLock("ZB1",.T.)
		ZB1->ZB1_CODIGO  := cGet2
		ZB1->ZB1_DESCRI := cGet1

        // Define os valores dos comboboxes 1=Manha","2=Tarde","3=Noite
		if nComboBo1 == 1
			ZB1->ZB1_PERIOD := "1"
		elseif nComboBo1 == 2
            ZB1->ZB1_PERIOD := "2"
		elseif nComboBo1 == 3
            ZB1->ZB1_PERIOD := "3"
		Endif

        // Define os valores dos comboboxes 1=Ativa","2=Suspensa","3=Encerrada
		if nComboBo2 == 1
            ZB1->ZB1_SITUAC := "1"
        elseif nComboBo2 == 2
            ZB1->ZB1_SITUAC := "2"
        elseif nComboBo2 == 3
            ZB1->ZB1_SITUAC := "3"
        Endif
		
		MsUnLock()
		ConfirmSx8()

		MsgInfo("Gravado com sucesso!","Atenção!")

	Endif
	// Restaura a area anterior
	oDlg:End()


Return()
