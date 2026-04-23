//Bibliotecas
#Include 'TOTVS.ch'

/*/{Protheus.doc} User Function zOO12
Funcao com tela customizada usando a classe TDialog que foi gerado pelo PDialogMaker
@type  Function
@author Atilio
@since 10/06/2022 
@see https://atiliosistemas.com/portfolio/pdialogmaker/
@obs Obrigado por usar um aplicativo da Atilio Sistemas
/*/

User Function zOO12()
    Local aArea         := FWGetArea()
    Local nCorFundo     := RGB(238, 238, 238)
    Local nJanAltura    := 190
    Local nJanLargur    := 220
    Local cJanTitulo    := 'Exemplo TRadMenu'
    Local lDimPixels    := .T. 
    Local lCentraliz    := .T. 
    Local nObjLinha     := 0
    Local nObjColun     := 0
    Local nObjLargu     := 0
    Local nObjAltur     := 0
    Private cFontNome   := 'Tahoma'
    Private oFontPadrao := TFont():New(cFontNome, , -12)
    Private oDialogPvt 
    Private bBlocoIni   := {|| /*fSuaFuncao()*/ } //Aqui voce pode acionar funcoes customizadas que irao ser acionadas ao abrir a dialog 
    //Radio
    Private nRadOpc     := 1
    Private aRadItens   := {"Azul", "Branco", "Laranja", "Preto", "Verde", "Vermelho"}
    Private oRadCores
    //objeto0 
    Private oBtnObj0 
    Private cBtnObj0    := 'Confirmar'  
    Private bBtnObj0    := {|| MsgInfo('Opção escolhida: ' + cValToChar(nRadOpc) + " - " + aRadItens[nRadOpc], 'Atencao')}  
    
    //Cria a dialog
    oDialogPvt := TDialog():New(0, 0, nJanAltura, nJanLargur, cJanTitulo, , , , , , nCorFundo, , , lDimPixels)
    
        //Menu com opções do Radio
        nObjLinha := 10
        nObjColun := 14
        nObjLargu := 80
        nObjAltur := 0 //irá usar o lAutoHeight
        oRadCores := TRadMenu():New (nObjLinha, nObjColun, aRadItens, {|u|Iif (PCount()==0,nRadOpc,nRadOpc:=u)}, oDialogPvt, /*uParam6*/, /*bChange*/, /*nClrText*/, /*nClrPane*/, /*cMsg*/, /*uParam11*/, /*bWhen*/, nObjLargu, nObjAltur, /*bValid*/, /*uParam16*/, lDimPixels, .T.)
        oRadCores:oFont := oFontPadrao

        //objeto0 - usando a classe TButton
        nObjLinha := 70
        nObjColun := 14
        nObjLargu := 50
        nObjAltur := 15
        oBtnObj0  := TButton():New(nObjLinha, nObjColun, cBtnObj0, oDialogPvt, bBtnObj0, nObjLargu, nObjAltur, , oFontPadrao, , lDimPixels)

    
    //Ativa e exibe a janela
    oDialogPvt:Activate(, , , lCentraliz, , , bBlocoIni)
    
    FWRestArea(aArea)
Return
