//Bibliotecas
#Include 'TOTVS.ch'

/*/{Protheus.doc} User Function zOO20
Funcao com tela customizada usando a classe TDialog que foi gerado pelo PDialogMaker
@type  Function
@author Atilio
@since 16/06/2022 
@see https://atiliosistemas.com/portfolio/pdialogmaker/
@obs Obrigado por usar um aplicativo da Atilio Sistemas
/*/

User Function zOO20()
    Local aArea         := FWGetArea()
    Local nCorFundo     := RGB(238, 238, 238)
    Local nJanAltura    := 220
    Local nJanLargur    := 500
    Local cJanTitulo    := 'Exemplo TToolBox'
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
    //objeto0 
    Private oGetObj0 
    Private xGetObj0    := Space(20) //Se o get for data para inicilizar use dToS(''), se for numerico inicie com 0  
    //objeto1 
    Private oBtnObj1 
    Private cBtnObj1    := 'Confirmar'  
    Private bBtnObj1    := {|| MsgInfo('Nome: ' + xGetObj0 + CRLF + 'Apelido: ' + xGetObj2 + CRLF + 'Frase: ' + xGetObj3, 'Atenção')} 
    //objeto2 
    Private oGetObj2 
    Private xGetObj2    := Space(20) //Se o get for data para inicilizar use dToS(''), se for numerico inicie com 0  
    //objeto3 
    Private oGetObj3 
    Private xGetObj3    := Space(100) //Se o get for data para inicilizar use dToS(''), se for numerico inicie com 0  
    
    //Cria a dialog
    oDialogPvt := TDialog():New(0, 0, nJanAltura, nJanLargur, cJanTitulo, , , , , , nCorFundo, , , lDimPixels)
        //Cria os paineis que estarão no ToolBox
        oPan1Red := TPanel():New(0, 0, "", oDialogPvt, , , , , RGB(255, 230, 230), 0, 0)
        oPan2Gre := TPanel():New(0, 0, "", oDialogPvt, , , , , RGB(230, 255, 230), 0, 0)
        oPan3Blu := TPanel():New(0, 0, "", oDialogPvt, , , , , RGB(230, 230, 255), 0, 0)
    
        //Cria o ToolBox com os paineis
        oToolBox := TToolBox():New(1, 1, oDialogPvt, nJanLargur/2 - 1, nJanAltura/2 - 20)
        oToolBox:AddGroup( oPan1Red, 'Cadastro (Vermelho)', Nil )
        oToolBox:AddGroup( oPan2Gre, 'Cadastro (Verde)',    Nil )
        oToolBox:AddGroup( oPan3Blu, 'Cadastro (Azul)',     Nil )

        //Criando os objetos do painel vermelho
        nObjLinha := 5
        nObjColun := 3
        nObjLargu := 100
        nObjAltur := 10
        oGetObj0  := TGet():New(nObjLinha, nObjColun, {|u| Iif(PCount() > 0 , xGetObj0 := u, xGetObj0)}, oPan1Red, nObjLargu, nObjAltur, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels)
        oGetObj0:cPlaceHold := "Digite um nome"

        //Criando os objetos do painel verde
        nObjLinha := 5
        nObjColun := 3
        nObjLargu := 100
        nObjAltur := 10
        oGetObj2  := TGet():New(nObjLinha, nObjColun, {|u| Iif(PCount() > 0 , xGetObj2 := u, xGetObj2)}, oPan2Gre, nObjLargu, nObjAltur, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels)
        oGetObj2:cPlaceHold := "Digite um apelido"

        //Criando os objetos do painel azul
        nObjLinha := 5
        nObjColun := 3
        nObjLargu := 100
        nObjAltur := 10
        oGetObj3  := TGet():New(nObjLinha, nObjColun, {|u| Iif(PCount() > 0 , xGetObj3 := u, xGetObj3)}, oPan3Blu, nObjLargu, nObjAltur, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels)
        oGetObj3:cPlaceHold := "Digite uma frase"

        //objeto1 - usando a classe TButton
        nObjLinha := nJanAltura/2 - 17
        nObjColun := 10
        nObjLargu := 100
        nObjAltur := 15
        oBtnObj1  := TButton():New(nObjLinha, nObjColun, cBtnObj1, oDialogPvt, bBtnObj1, nObjLargu, nObjAltur, , oFontPadrao, , lDimPixels)
        oBtnObj1:SetCSS("TButton { font: bold;     background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #3DAFCC, stop: 1 #0D9CBF);    color: #FFFFFF;     border-width: 1px;     border-style: solid;     border-radius: 3px;     border-color: #369CB5; }TButton:focus {    padding:0px; outline-width:1px; outline-style:solid; outline-color: #51DAFC; outline-radius:3px; border-color:#369CB5;}TButton:hover {    color: #FFFFFF;     background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #3DAFCC, stop: 1 #1188A6);    border-width: 1px;     border-style: solid;     border-radius: 3px;     border-color: #369CB5; }TButton:pressed {    color: #FFF;     background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #1188A6, stop: 1 #3DAFCC);    border-width: 1px;     border-style: solid;     border-radius: 3px;     border-color: #369CB5; }TButton:disabled {    color: #FFFFFF;     background-color: #4CA0B5; }")
    
    //Ativa e exibe a janela
    oDialogPvt:Activate(, , , lCentraliz, , , bBlocoIni)
    
    FWRestArea(aArea)
Return
