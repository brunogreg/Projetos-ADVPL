#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/-------------------------------------------------------------------
- Programa  : Contabilizacao
- Autor     : Bruno Couto Gregório
- Data      : 02/022026
- Descrição : Rotina de Cadastro de requisitantes.
-------------------------------------------------------------------/*/

User Function UCOMA006()

	Local oBrowse

	Private aRotina
	Private cCadastro := 'Cadastro de Requisitantes'

	DbSelectArea("ZB2") //Seleciona a tabela ZB2

	oBrowse := FWmBrowse():New() //Cria o objeto do Browse
	oBrowse:SetAlias( 'ZB2' )
	oBrowse:SetDescription( cCadastro )
	
	oBrowse:Activate()

Return

//-------------------------------------------------------------------
// Definicao do Menu
//-------------------------------------------------------------------
Static Function MenuDef()

	aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar'      ACTION 'VIEWDEF.UCOMA006' OPERATION 2 ACCESS 0 // operation 2 = view
	ADD OPTION aRotina TITLE 'Incluir'         ACTION 'VIEWDEF.UCOMA006' OPERATION 3 ACCESS 0 // operation 3 = insert
	ADD OPTION aRotina TITLE 'Alterar'         ACTION 'VIEWDEF.UCOMA006' OPERATION 4 ACCESS 0 // operation 4 = edit
	ADD OPTION aRotina TITLE 'Excluir'         ACTION 'VIEWDEF.UCOMA006' OPERATION 5 ACCESS 0 // operation 5 = delete
	ADD OPTION aRotina TITLE 'Copiar'          ACTION 'VIEWDEF.UCOMA006' OPERATION 9 ACCESS 0 // operation 9 = copy
	
Return aRotina

//-------------------------------------------------------------------
// Define Modelo de Dados
//-------------------------------------------------------------------
Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	// FWFormStruct( nTipoEstrutura, cAlias, bAvalCampo, lViewUsado )
	Local oStruZB2  := FWFormStruct( 1, 'ZB2', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel
	
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('UCOMP006', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	
	// Adiciona ao modelo uma estrutura de formulario de edicao por campo
	oModel:AddFields( 'ZB2MASTER', /*cOwner*/, oStruZB2, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	
	// Adiciona a chave primaria da tabela principal
	oModel:SetPrimaryKey({ "Z2_FILIAL", "Z2_NOME" })
	
	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Cadastro de Requisitantes' )
	                                       
Return oModel
 

//-------------------------------------------------------------------
// Define camada de Visão
//-------------------------------------------------------------------
Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'UCOMA006' ) // FWLoadModel carrega o modelo de dados definido na funcao  o ModelDef
	Local oView
	
	// Cria a estrutura a ser usada na View
	Local oStruZB2 := FWFormStruct( 2, 'ZB2' )
	
	// Cria o objeto de View
	oView := FWFormView():New()
	
	// Define qual o Modelo de dados ser· utilizado
	oView:SetModel( oModel )
	
	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZB2', oStruZB2, 'ZB2MASTER' )
	
	// Cria um "box" horizontal para receber cada elemento da view
	oView:CreateHorizontalBox( 'TOTAL'	, 100 )
	  
	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView( 'VIEW_ZB2', 'TOTAL' )

Return oView
