//Bibliotecas
#Include 'TOTVS.ch'

/*/{Protheus.doc} User Function zOO15
Funcao com tela customizada usando a classe TDialog que foi gerado pelo PDialogMaker
@type  Function
@author Atilio
@since 16/06/2022 
@see https://atiliosistemas.com/portfolio/pdialogmaker/
@obs Obrigado por usar um aplicativo da Atilio Sistemas
/*/

User Function zOO15()
    Local aArea         := FWGetArea()
    Local nCorFundo     := RGB(238, 238, 238)
    Local nJanAltura    := 154
    Local nJanLargur    := 318 
    Local cJanTitulo    := 'Exemplo TMultiGet'
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
    Private oMulObj0 
    Private cMulObj0    := ''  
    //objeto1 
    Private oBtnObj1 
    Private cBtnObj1    := 'Confirmar'  
    Private bBtnObj1    := {|| MsgInfo('O texto digitado foi:' + CRLF + CRLF + cMulObj0, 'Atenção')}  
    
    //Cria a dialog
    oDialogPvt := TDialog():New(0, 0, nJanAltura, nJanLargur, cJanTitulo, , , , , , nCorFundo, , , lDimPixels)
    
        //objeto0 - usando a classe TMultiGet
        nObjLinha := 7
        nObjColun := 6
        nObjLargu := 145
        nObjAltur := 40
        oMulObj0  := TMultiGet():New(nObjLinha, nObjColun, {|u| Iif(PCount() > 0 , cMulObj0 := u, cMulObj0)}, oDialogPvt, nObjLargu, nObjAltur, oFontPadrao, , , , , lDimPixels, , , /*bWhen*/, , , /*lReadOnly*/, /*bValid*/, , , /*lNoBorder*/, .T.)

        //objeto1 - usando a classe TButton
        nObjLinha := 54
        nObjColun := 6
        nObjLargu := 75
        nObjAltur := 15
        oBtnObj1  := TButton():New(nObjLinha, nObjColun, cBtnObj1, oDialogPvt, bBtnObj1, nObjLargu, nObjAltur, , oFontPadrao, , lDimPixels)

    
    //Ativa e exibe a janela
    oDialogPvt:Activate(, , , lCentraliz, , , bBlocoIni)
    
    FWRestArea(aArea)
Return
