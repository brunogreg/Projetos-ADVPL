//Bibliotecas
#Include 'TOTVS.ch'

/*/{Protheus.doc} User Function zOO16
Funcao com tela customizada usando a classe TDialog que foi gerado pelo PDialogMaker
@type  Function
@author Atilio
@since 16/06/2022 
@see https://atiliosistemas.com/portfolio/pdialogmaker/
@obs Obrigado por usar um aplicativo da Atilio Sistemas
/*/

User Function zOO16()
    Local aArea         := FWGetArea()
    Local nCorFundo     := RGB(238, 238, 238)
    Local nJanAltura    := 129
    Local nJanLargur    := 242 
    Local cJanTitulo    := 'Exemplo TButton'
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
    Private oBtnObj0 
    Private cBtnObj0    := 'Botão Normal'  
    Private bBtnObj0    := {|| MsgInfo('Coloque sua funcao aqui', 'Atencao objeto0')}  
    //objeto1 
    Private oBtnObj1 
    Private cBtnObj1    := 'Botão com CSS'  
    Private bBtnObj1    := {|| MsgInfo('Coloque sua funcao aqui', 'Atencao objeto1')}  
    
    //Cria a dialog
    oDialogPvt := TDialog():New(0, 0, nJanAltura, nJanLargur, cJanTitulo, , , , , , nCorFundo, , , lDimPixels)
    
        //objeto0 - usando a classe TButton
        nObjLinha := 10
        nObjColun := 10
        nObjLargu := 100
        nObjAltur := 15
        oBtnObj0  := TButton():New(nObjLinha, nObjColun, cBtnObj0, oDialogPvt, bBtnObj0, nObjLargu, nObjAltur, , oFontPadrao, , lDimPixels)

        //objeto1 - usando a classe TButton
        nObjLinha := 35
        nObjColun := 10
        nObjLargu := 100
        nObjAltur := 15
        oBtnObj1  := TButton():New(nObjLinha, nObjColun, cBtnObj1, oDialogPvt, bBtnObj1, nObjLargu, nObjAltur, , oFontPadrao, , lDimPixels)
        oBtnObj1:SetCSS("TButton { font: bold;     background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #3DAFCC, stop: 1 #0D9CBF);    color: #FFFFFF;     border-width: 1px;     border-style: solid;     border-radius: 3px;     border-color: #369CB5; }TButton:focus {    padding:0px; outline-width:1px; outline-style:solid; outline-color: #51DAFC; outline-radius:3px; border-color:#369CB5;}TButton:hover {    color: #FFFFFF;     background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #3DAFCC, stop: 1 #1188A6);    border-width: 1px;     border-style: solid;     border-radius: 3px;     border-color: #369CB5; }TButton:pressed {    color: #FFF;     background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #1188A6, stop: 1 #3DAFCC);    border-width: 1px;     border-style: solid;     border-radius: 3px;     border-color: #369CB5; }TButton:disabled {    color: #FFFFFF;     background-color: #4CA0B5; }")

    
    //Ativa e exibe a janela
    oDialogPvt:Activate(, , , lCentraliz, , , bBlocoIni)
    
    FWRestArea(aArea)
Return
