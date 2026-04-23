//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function M410AGRV
Ponto de Entrada antes de realizar as gravações no banco de dados
@type  Function
@author Atilio
@since 03/08/2023
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6784142
@obs É necessário baixar o zLogGeneric disponível em https://terminaldeinformacao.com/2022/03/07/criar-um-log-em-txt-de-forma-generica-ti-responde-003/
/*/

User Function M410AGRV()
    Local aArea      := FWGetArea()
    Local nOpcao     := ParamIXB[1]
    Local cPasta     := "\x_logs\"
    Local cArquivo   := ""
    Local cMensagem  := ""
    Local dData      := Date()
    Local cHora      := Time()
    Local aCampos    := {"C5_VEND1", "C5_TRANSP", "C5_MENNOTA"}
    Local nAtual     := 0
    Local cCampoAtu  := ""
    Local cAntes     := ""
    Local cDepois    := ""
    Local oLogGen

    //Se for uma alteração, verifica se algum campo foi alterado para gravar no log
    If nOpcao == 2

        //Se a pasta de logs não existir, cria ela
        If ! ExistDir(cPasta)
            MakeDir(cPasta)
        EndIf

        //Define o nome do arquivo como: filial + pedido + data + hora
        cArquivo := SC5->C5_FILIAL + SC5->C5_NUM + "_" + dToS(dData) + "_" + StrTran(cHora, ":", "-") + ".log"

        //Percorre os campos que serão validados
        For nAtual := 1 To Len(aCampos)
            cCampoAtu := aCampos[nAtual]
            cAntes    := &("SC5->" + cCampoAtu)
            cDepois   := &("M->" + cCampoAtu)

            //Se o campo estiver diferente, incrementa o log
            If cAntes != cDepois
                cMensagem += "Campo [" + cCampoAtu + "]" + CRLF
                cMensagem += "+ Antes:  '" + cAntes  + "'" + CRLF
                cMensagem += "+ Depois: '" + cDepois + "'" + CRLF
                cMensagem += CRLF
            EndIf
        Next

        //Se houver mensagem
        If ! Empty(cMensagem)
            //Cria o log
            oLogGen := zLogGeneric():New(cPasta, cArquivo, .F., .F.)
            oLogGen:AddText(cMensagem)
            oLogGen:Finish()
        EndIf
    EndIf

    FWRestArea(aArea)
Return
