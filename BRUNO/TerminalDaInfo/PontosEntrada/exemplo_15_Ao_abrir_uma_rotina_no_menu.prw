//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function ChkExec
Ponto de entrada, acionado ao clicar em alguma rotina no menu
@type  Function
@author Atilio
@since 22/08/2023
@see https://tdn.totvs.com/display/public/framework/CHKEXEC+-+Dispara+ponto+de+entrada
/*/

User Function ChkExec()
    Local aArea     := FWGetArea()
    Local lContinua := .T.
    Local cFuncao   := Alltrim(Upper(PARAMIXB))
    Local cHoraAtu  := Time()

    //Se for antes das 10h
    If cHoraAtu < "10:00:00"

        //Se for o cadastro de clientes ou fornecedores
        If cFuncao $ "CRMA980();MATA020()"

            //Mostra uma mensagem, e define para não abrir a rotina
            ExibeHelp(;
                "Help ChkExec",;
                "Não é permitido cadastrar Clientes e Fornecedores antes das 10h",;
                "Tente novamente mais tarde ou contate o Administrador";
            )
            lContinua := .F.

        EndIf

    EndIf

    FWRestArea(aArea)
Return lContinua
