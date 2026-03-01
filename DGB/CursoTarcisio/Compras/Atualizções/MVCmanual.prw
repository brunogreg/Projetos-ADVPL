#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' //Inclui definicoes do Framework MVC
#INCLUDE "rwmake.ch"   //Inclui definicoes do RWMAKE
#INCLUDE "topconn.ch"  //Inclui definicoes de conexao TOP

/*/-------------------------------------------------------------------
-Â Programa  : Contabilizacao
-Â Autor     : Bruno Couto Gregorio
-Â Data      : 03/02/2026
-Â DescriÃ§Ã£o : Tela Manual de Mvc.
-------------------------------------------------------------------/*/


User function MVCmanual()

    // Declara variaveis locais
	Local oBrowse
    // Variavel responsavel pelo cadastro da tela
	Private aRotina
    // Variavel com descricao do cadastro
	Private cCadastro := 'Tela MVC Manual'
    //Seleciona a tabela ZB3
	DbSelectArea("ZB3") 
    //Cria o objeto do Browse 
	oBrowse := FWmBrowse():New() 
    //Define o alias da tabela a ser usada no Browse
	oBrowse:SetAlias( 'ZB3' )
    //Define a descricao do cadastro a ser exibida no Browse
	oBrowse:SetDescription( cCadastro )
	//Ativa o Browse para exibir na tela
	oBrowse:Activate() 

Return

// Crie o menu de opcoes

Static Function MenuDef() // Essa static encontra se dentro do include FWMVCDEF.CH

    aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar'      ACTION 'VIEWDEF.MVCmanual' OPERATION 2 ACCESS 0 // operation 2 = view
    ADD OPTION aRotina TITLE 'Incluir'         ACTION 'VIEWDEF.MVCmanual' OPERATION 3 ACCESS 0 // operation 3 = insert
    ADD OPTION aRotina TITLE 'Alterar'         ACTION 'VIEWDEF.MVCmanual' OPERATION 4 ACCESS 0 // operation 4 = edit
    ADD OPTION aRotina TITLE 'Excluir'         ACTION 'VIEWDEF.MVCmanual' OPERATION 5 ACCESS 0 // operation 5 = delete
    ADD OPTION aRotina TITLE 'Copiar'          ACTION 'VIEWDEF.MVCmanual' OPERATION 9 ACCESS 0 // operation 9 = copy

Return aRotina

// Model é o indice que vai abrir ou fazer uniao com outras tabelas
Static Function ModelDef()
	// Crua um objeto FWFormStruct para definir a estrutura dos campos da tabela ZB3
	Local oStruZB3  := FWFormStruct( 1, 'ZB3',, )
	Local oModel	
	// Cria o modelo de dados para o formulario
	oModel := MPFormModel():New('UCOMP007',,,, )
	//AddFields adiciona a estrutura de formulario ao modelo de dados	
	oModel:AddFields( 'ZB3MASTER',, oStruZB3,,, )
	//Define a chave primaria do modelo de dados		
	oModel:SetPrimaryKey({ "ZB3_FILIAL", "ZB3_CODIG" })                                                                                                                                            	
	//Define a descricao do modelo de dados
	oModel:SetDescription( 'Tela MVC Manual' )
	                                       
Return oModel

// Viel é a construção da tela do formulario

Static Function ViewDef()
	// FWLoadModel carrega o modelo de dados definido na funcao  o ModelDef
	Local oModel   := FWLoadModel( 'MVCmanual' ) 
	Local oView	
	// Cria um objeto FWFormStruct para definir a estrutura dos campos da tabela ZB3
	Local oStruZB3 := FWFormStruct( 2, 'ZB3' )	
	// Cria a visão do formulário
	oView := FWFormView():New()	
	// Define o modelo de dados a ser usado na visão
	oView:SetModel( oModel )	
	// AddField adiciona a estrutura de formulario à visão
	oView:AddField( 'VIEW_ZB3', oStruZB3, 'ZB3MASTER' )	
	// Cria um box horizontal para agrupar os campos na visão
	oView:CreateHorizontalBox( 'TOTAL'	, 100 )	  
	// Adiciona os campos ao box horizontal criado
	oView:SetOwnerView( 'VIEW_ZB3', 'TOTAL' )

Return oView
