//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MT410ACE
Ponto de entrada que valida o acesso do usuário a uma rotina
@type  Function
@author Atilio
@since 03/08/2023
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784346
/*/

User Function MT410ACE()
    Local aArea     := FWGetArea()
    Local lContinua := .T.
    Local nOpcao    := PARAMIXB[1]

    //Se for antes das 8h da manhã, não permite prosseguir
    If Time() <= "08:30:00"
        lContinua := .F.

        //Mas se for um usuário administrador, mostra a pergunta se deseja abrir mesmo assim
        If ! IsBlind() .And. FWIsAdmin()
            lContinua := FWAlertYesNo("Pedidos não podem ser manipulados antes das 8h30, mas você como Administrador, deseja continuar?", "Continua (Opção " + cValToChar(nOpcao) + ")?")
        EndIf
    EndIf

    FWRestArea(aArea)
Return lContinua
