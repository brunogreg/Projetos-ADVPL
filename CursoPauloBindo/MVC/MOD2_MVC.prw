//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
  
//Variáveis Estáticas
Static cTitulo := "Cadastro de Usuarios x Rotinas"
  
/*/{Protheus.doc} MOD2_MVC
Função para cadastros de Usuarios x Rotinas
@author Paulo Bindo
@since 13/09/2021
@version 1.0
/*/
 
User Function MOD2_MVC()
    Local aArea   := GetArea()
    Local oBrowse
      
    //Cria um browse para a SZB
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("SZB")
    oBrowse:SetDescription(cTitulo)
    oBrowse:Activate()
      
    RestArea(aArea)
Return Nil
 


/*/{Protheus.doc} MenuDef
menu
@author Paulo Bindo
@since 13/09/2021
@version 1.0
/*/
Static Function MenuDef()
    Local aRotina := {}
      
    //Adicionando opções
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MOD2_MVC' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MOD2_MVC' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MOD2_MVC' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MOD2_MVC' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MOD2_MVC' OPERATION 9 ACCESS 0
Return aRotina
 
/*/{Protheus.doc} model

@author Paulo Bindo
@since 13/09/2021
@version 1.0
/*/

Static Function ModelDef()
    //Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 2 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
    Local oModel      := NIL
    Local oStruCab     := FWFormStruct(1, 'SZB', {|cCampo| AllTRim(cCampo) $ "ZB_CODUSU;ZB_NOMEUSU;"})
    Local oStruGrid := fModStruct()
 
    //Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
    oModel := MPFormModel():New('MOD2MVCM', /*bPreValidacao*/, {|oModel| fValidGrid(oModel)}, /*bCommit*/, /*bCancel*/ )
 
    //Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
    oModel:AddFields('MdFieldSZB', NIL, oStruCab)
    oModel:AddGrid('MdGridSZB', 'MdFieldSZB', oStruGrid, , )
 
    //Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
    oModel:SetRelation('MdGridSZB', {;
            {'ZB_FILIAL', 'xFilial("SZB")'},;
            {"ZB_CODUSU",  "ZB_CODUSU"};
            }, SZB->(IndexKey(1)))
     
    //Definindo outras informações do Modelo e da Grid
    oModel:GetModel("MdGridSZB"):SetMaxLine(9999)
    oModel:SetDescription(cTitulo)
    oModel:SetPrimaryKey({"ZB_FILIAL", "ZB_CODUSU", "ZB_FUNCAO"})
 
Return oModel
 

/*/{Protheus.doc} viewdef
menu
@author Paulo Bindo
@since 13/09/2021
@version 1.0
/*/
Static Function ViewDef()
    //Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 2 campos, e na grid vamos carregar conforme a função fViewStruct
    Local oView        := NIL
    Local oModel    := FWLoadModel('MOD2_MVC')
    Local oStruCab  := FWFormStruct(2, "SZB", {|cCampo| AllTRim(cCampo) $ "ZB_CODUSU;ZB_NOMEUSU;"})
    Local oStruGRID := fViewStruct()
 
    //Define que no cabeçalho não terá separação de abas (SXA)
    oStruCab:SetNoFolder()
 
    //Cria o View
    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    //Cria uma área de Field vinculando a estrutura do cabeçalho com MDFieldSZB, e uma Grid vinculando com MdGridSZB
    oView:AddField('VIEW_SZB', oStruCab, 'MdFieldSZB')
    oView:AddGrid ('GRID_SZB', oStruGRID, 'MdGridSZB' )
 
    //O cabeçalho (MAIN) terá 25% de tamanho, e o restante de 75% irá para a GRID
    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 75)
 
    //Vincula o MAIN com a VIEW_SZB e a GRID com a GRID_SZB
    oView:SetOwnerView('VIEW_SZB', 'MAIN')
    oView:SetOwnerView('GRID_SZB', 'GRID')
    oView:EnableControlBar(.T.)
 
    //Define o campo incremental da grid como o SZB_ITEM
    oView:AddIncrementField('GRID_SZB', 'ZB_ITEM')
Return oView
 
 /*/{Protheus.doc} fModStruct
Função chamada para montar o modelo de dados da Grid
@author Paulo Bindo
@since 13/09/2021
@version 1.0
/*/

Static Function fModStruct()
    Local oStruct
    oStruct := FWFormStruct(1, 'SZB', {|cCampo| !AllTRim(cCampo) $ "ZB_CODUSU;ZB_NOMEUSU;"})
Return oStruct
 

  /*/{Protheus.doc} fViewStruct
Função chamada para montar a visualização de dados da Grid
@author Paulo Bindo
@since 13/09/2021
@version 1.0
/*/

Static Function fViewStruct()
    Local cCampoCom := "ZB_CODUSU;ZB_NOMEUSU;"
    Local oStruct
 
    //Irá filtrar, e trazer todos os campos, menos os que tiverem na variável cCampoCom
    oStruct := FWFormStruct(2, "SZB", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct
 

/*/{Protheus.doc} fValidGrid
Função que faz a validação da grid
@author Paulo Bindo
@since 13/09/2021
@version 1.0
/*/

Static Function fValidGrid(oModel)
    Local lRet     := .T.
    Local nDeletados := 0
    Local nLinAtual :=0
    Local oModelGRID := oModel:GetModel('MdGridSZB')
    //Local oModelMain := oModel:GetModel('MdFieldSZB')
    //Local nValorMain := oModelMain:GetValue("ZB_VALOR")
    //Local nValorGrid := 0
    //Local cPictVlr   := PesqPict('SZB', 'ZB_VALOR')
 
    //Percorrendo todos os itens da grid
    For nLinAtual := 1 To oModelGRID:Length() // Length retorna o número total de linhas da Grid 
        //Posiciona na linha
        oModelGRID:GoLine(nLinAtual) 
         
        //Se a linha for excluida, incrementa a variável de deletados, senão irá incrementar o valor digitado em um campo na grid
        If oModelGRID:IsDeleted()
            nDeletados++ // soma o numero de linha deletadas
        Else
//            nValorGrid += NoRound(oModelGRID:GetValue("SZB_TCOMB"), 4)
        EndIf
    Next nLinAtual
 
    //Se o tamanho da Grid for igual ao número de itens deletados, acusa uma falha
    If oModelGRID:Length()==nDeletados
        lRet :=.F.
        Help( , , 'Dados Inválidos' , , 'A grid precisa ter pelo menos 1 linha sem ser excluida!', 1, 0, , , , , , {"Inclua uma linha válida!"})
    EndIf
 /*
    If lRet
        //Se o valor digitado no cabeçalho (valor da NF), não bater com o valor de todos os abastecimentos digitados (valor dos itens da Grid), irá mostrar uma mensagem alertando, porém irá permitir salvar (do contrário, seria necessário alterar lRet para falso)
        If nValorMain != nValorGrid
            //lRet := .F.
            MsgAlert("O valor do cabeçalho (" + Alltrim(Transform(nValorMain, cPictVlr)) + ") tem que ser igual o valor dos itens (" + Alltrim(Transform(nValorGrid, cPictVlr)) + ")!", "Atenção")
        EndIf
    EndIf
 */
Return lRet
