#INCLUDE 'PROTHEUS.CH'//Base do sistema tipo funcoes padroes e constantes
#INCLUDE 'FWMVCDEF.CH'//pras funcoes fw fomrmstruct..formview ect
#INCLUDE "rwmake.ch"// recurso de interface menus e acoes
#INCLUDE "topconn.ch"//conectar com o banco sql

User Function TMVC01()//ponto de entrada da rotina

	Local oBrowse //objeto da tela de listagem grid inicial
	Private aRotina
	Private cCadastro := 'TELA MVC MODELO SIMPLES - ZZ1'

	DbSelectArea("ZZ1") //Seleciona a tabela ZZ1
	oBrowse := FWmBrowse():New() //Cria o objeto do Browse
	oBrowse:SetAlias( 'ZZ1' )
	oBrowse:SetDescription( cCadastro )	
	oBrowse:Activate()//renderiza o browse  inicia o flux mvc
	
Return

Static Function MenuDef() //Cria o menu de opçoes para o cadastro

	aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar'      ACTION 'VIEWDEF.TMVC01' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'         ACTION 'VIEWDEF.TMVC01' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'         ACTION 'VIEWDEF.TMVC01' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'         ACTION 'VIEWDEF.TMVC01' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'          ACTION 'VIEWDEF.TMVC01' OPERATION 9 ACCESS 0
	
Return aRotina

Static Function ModelDef() //usado pra definir a modelagem dos dados que vou salvar 

	Local oStruZZ1  := FWFormStruct( 1, 'ZZ1',,) // carrega a estrutura da tabela 1 pois e editavel 
	Local oModel	
	//Local bPre := Nil
	//Local bPos := Nil
	//Local bCommit := Nil
	//Local bCancel := Nil
	
	oModel := MPFormModel():New('TMVC01a', /*bPre, bPos, bCommit, bCancel*/)// Cria o objeto do Modelo de Dados	
	oModel:AddFields('ZZ1MASTER', /*cOwner*/, oStruZZ1) // Define o nome do meu modelo de dados como ZZ1master e passa a estrutura (oStruZZ1) da tabela para o modelo	
	oModel:SetPrimaryKey({ "ZZ1_FILIAL", "ZZ1_CLIENT" })// Adiciona a chave primaria da tabela principal	
	oModel:SetDescription( 'Cadastro de Turmas' )// Adiciona a descricao do Modelo de Dados
	                                       
Return oModel

Static Function ViewDef() //monta a visualização da minha tabela em tela
	
	Local oModel := FWLoadModel( 'TMVC01' ) //carrega o modelo de dados (ModelDef)
	Local oStruZZ1 := FWFormStruct( 2, 'ZZ1' ) // monta o formulario de modo a ser visuzlizado por isso a opçao 2
	Local oView	
	
	oView := FWFormView():New()	// Cria o objeto da View
	oView:SetModel( oModel )	// Seta o Modelo de Dados na View
	oView:AddField( 'VIEW_ZZ1', oStruZZ1, 'ZZ1MASTER' )	//cria uma view chamda viewZZ1 e amarramos ao ZZ1master e passa a estrutura oStuz1 para a view
	oView:CreateHorizontalBox( 'TOTAL'	, 100 )	//cria uma caixa horizontal de 100% chamada tela
	oView:SetOwnerView( 'VIEW_ZZ1', 'TOTAL' ) //amarra o view a nossa tela criada

Return oView
