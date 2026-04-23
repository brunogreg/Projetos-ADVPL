//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function zOO03
Função de exemplo, demonstrando 3 classes (MsDialog, TDialog e FWDialogModal)
@type  Function
@author Atilio
@since 26/04/2022
/*/

User Function zOO03()
    Local aArea := FWGetArea()

    fDialogMS() // as classes começadas com ms fazer referencia a microsiga, sao mais antigas e menos usadas
    fDialogT() //as classes começadas com T sao mais modernas e sao referencia a TOTVS, tem mais recursos e mais usadas atualmente
    fDialogFW() // as classes começadas com fw sao as mais modernas e fazem parte do framework de desenvolvimento da TOTVS, tem muitos recursos e sao as mais usadas atualmente

    FWRestArea(aArea)
Return

// Função para criar telas usando as classes MsDialog
Static Function fDialogMS()
    Local oDlgAux
    Local nJanAltu   := 200
    Local nJanLarg   := 400
    Local cJanTitulo := "Tela usando MsDialog"

    //Criando a janela
    DEFINE MSDIALOG oDlgAux TITLE cJanTitulo FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
         
    //Ativando a janela
    ACTIVATE MSDIALOG oDlgAux CENTERED
Return

// Função para criar telas usando as classes TDialog
Static Function fDialogT()
    Local oDlgAux
    Local nJanAltu   := 200
    Local nJanLarg   := 400
    Local lDimPixels := .T.
    Local lCentraliz := .T.
    Local bBlocoIni  := {||}
    Local cJanTitulo := "Tela usando TDialog"

    //Cria a dialog
    oDlgAux := TDialog():New(0, 0, nJanAltu, nJanLarg, cJanTitulo, , , , , , /*nCorFundo*/, , , lDimPixels)

    //Ativa e exibe a janela
    oDlgAux:Activate(, , , lCentraliz, , , bBlocoIni)
Return

// Função para criar telas usando as classes FWDialogModal
Static Function fDialogFW()
    Local oDlgAux
    Local nJanAltu   := 100
    Local nJanLarg   := 200
    Local bBlocoTst  := {|| FWAlertInfo("Clicou no botão escrito 'Teste'", "Botão Teste")}
    Local cJanTitulo := "Tela usando FWDialogModal"

    //Instancia a classe, criando uma janela
    oDlgAux := FWDialogModal():New()
    oDlgAux:SetTitle(cJanTitulo)
    oDlgAux:SetSize(nJanAltu, nJanLarg)
    oDlgAux:EnableFormBar(.T.) // para abilitar a barra de ferramentas da janela, onde ficam os botoes
    oDlgAux:CreateDialog() // para criar a janela, obrigatorio para as classes FWDialogModal
    oDlgAux:CreateFormBar() // para criar a barra de ferramentas da janela, obrigatorio para as classes FWDialogModal
    oDlgAux:AddButton("Teste", bBlocoTst, "Teste", , .T., .F., .T., ) // para adicionar um botão na barra de ferramentas da janela, obrigatorio para as classes FWDialogModal, o segundo parametro é o bloco de código que será executado quando clicar no botão, o terceiro parametro é o texto do botão, os outros parametros são para configurar o comportamento do botão, como habilitado ou desabilitado, se é um botão de confirmação, etc.

    //Aqui antes de abrir a tela, caso você queira usar essa classe, pode usar o método oDlgAux:GetPanelMain()
    //   e instanciar os objetos apontando para esse painel
    oDlgAux:Activate()
Return
