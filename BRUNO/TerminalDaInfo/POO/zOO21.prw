//Bibliotecas
#Include "Totvs.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} User Function zOO21
Exemplo de TWebEngine e TWebChannel
@type  Function
@author Atilio
@since 16/06/2022
/*/

User Function zOO21()
    If Select("SX2") == 0
        RPCSetEnv("99", "01", "Administrador", "", "")
    EndIf

    u_zTransp()    
Return

/*/{Protheus.doc} zTransp
Função para consultar pedidos em transportadoras
@type  Function
@author Atilio
@since 25/11/2019
@version 1.0
@see https://terminaldeinformacao.com/2020/03/27/funcao-para-rastrear-informacoes-em-transportadoras-via-advpl/
/*/
  
User Function zTransp()
    Local aArea     := GetArea()
    Local cRastreio := "AA123456785BR"
    Local aPergs    := {}
  
    //Adiciona os parametros para a pergunta
    aAdd(aPergs, {1, "Rastreio",   cRastreio, "", ".T.", "", ".T.", 80, .T.})
  
    //Mostra uma pergunta com parambox para filtrar o subgrupo
    If ParamBox(aPergs, "Informe os parametros", , , , , , , , , .F., .F.)
        fMontaBusca()
    EndIf
  
    RestArea(aArea)
Return
  
Static Function fMontaBusca()
    Local cUrl          := ""
    //Tamanho da janela
    Private nJanLarg    := 800
    Private nJanAltu    := 600
    //Navegador Internet
    Private oWebChannel
    Private nPort
    Private oWebEngine
    Private aComandos   := {}
  
    //Defina a URL e os comandos que vão ser executados
    cUrl := "https://rastreamento.correios.com.br/app/index.php"
    aAdd(aComandos, 'document.getElementById("objeto").value = "' + MV_PAR01 + '"; ')

    //Cria a dialog
    DEFINE DIALOG oDlg TITLE "Pesquisa de Transportadora" FROM 000,000 TO nJanAltu,nJanLarg PIXEL

        // Prepara o conector WebSocket
        oWebChannel := TWebChannel():New() //ABRIR UM CANAL COM INTERNET
        nPort := oWebChannel::connect() //ARMAZENA A PORTA

        // Cria componente
        oWebEngine := TWebEngine():New(oDlg, 0, 0, 100, 100,, nPort) //MOTOR PARA CONSEGUIR SE CONECTAR
        oWebEngine:bLoadFinished := {|self,url| fRodaScript(url) }
        oWebEngine:navigate(cUrl) // ELE ESCOLE PRA QUAL URL ELE VAI ACESSAR
        oWebEngine:Align := CONTROL_ALIGN_ALLCLIENT //PARA QUE O SITE PREENCHA TODO O ESPAÇO NA TELA

    ACTIVATE DIALOG oDlg CENTERED
    
Return
  
Static Function fRodaScript(cUrl)
    Local nAtual := 0
  
    //Percorre os comandos
    For nAtual := 1 To Len(aComandos)
        oWebEngine:runJavaScript(aComandos[nAtual])
    Next
Return
