//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MSFinal
Intercepta quando o usuário clica no botão Fechar para encerrar a rotina
@type  Function
@author Atilio
@since 22/08/2023
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6815199
/*/

User Function MSFinal()
    Local aArea     := FWGetArea()
    Local lContinua := .F.
    Local cCodUsr   := RetCodUsr()
    Local cPastaTmp := "\x_temp\"
    Local cNomeArq  := ""
    Local cMensagem := ""
    Local cHora     := Time()
    Local dHoje     := Date()

    //Se não veio do APSDU
    If ! FWIsInCallStack("APSDU")

        //Se for o usuário Administrador, permite prosseguir
        If cCodUsr == "000000"
            lContinua := .T.

        //Senão, se for antes das 17h, irá solicitar um motivo para gravar o log
        ElseIf cHora <= "17:00:00"

            //Se a pasta não existir, cria
            If ! ExistDir(cPastaTmp)
                MakeDir(cPastaTmp)
            EndIf

            //Busca a mensagem
            cMensagem := FWInputBox("Informe um motivo para estar fechando o sistema:")

            //Se a mensagem tiver vazia
            If Empty(cMensagem)
                ExibeHelp(;
                    "Help MSFinal",;
                    "É obrigatório informar um motivo para encerrar o sistema antes do previsto (17h)",;
                    "Informe um motivo para que o sistema seja encerrado";
                )

            //Senão, permite encerrar e grava um log
            Else
                lContinua := .T.

                //Montando o log e gravando
                cNomeArq := "usr_" + cCodUsr + "_" + dToS(dHoje) + "_" + StrTran(cHora, ":", "-") + ".log"
                cMensagem := "Motivo informado: " + cMensagem
                cMensagem := "------" + CRLF + cMensagem
                cMensagem := "Hora:    " + cHora + CRLF + cMensagem
                cMensagem := "Data:    " + dToC(dHoje) + CRLF + cMensagem
                cMensagem := "Usuário: " + cCodUsr + " (" + UsrRetName(cCodUsr) + ")" + CRLF + cMensagem
                MemoWrite(cPastaTmp + cNomeArq, cMensagem)
            EndIf

        EndIf
    EndIf

    FWRestArea(aArea)
Return lContinua
