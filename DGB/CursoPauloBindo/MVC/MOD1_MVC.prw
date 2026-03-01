#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH' // Inclui as definiçoes do Framework MVC

//-------------------------------------------------------------------
/*/{Protheus.doc} MOD1_MVC
montagem tela para um tabela em MVC

@author Paulo Bindo
@since 01/10/2021
@version P12
/*/
//-------------------------------------------------------------------
User Function MOD1_MVC()
Local oBrowse 

oBrowse := FWMBrowse():New() // Cria o objeto Browse
oBrowse:SetAlias('SZ1') // Define o alias da tabela a ser usada
oBrowse:SetDescription('Cadastro de UM Cliente') // Define a descricao do Browse
oBrowse:AddLegend( "Z1_TIPO=='D'", "YELLOW", "Divide"  ) //legenda para o filtro
oBrowse:AddLegend( "Z1_TIPO=='M'", "GREEN"  , "Multiplica"  )
//oBrowse:SetFilterDefault( "Z1_TIPO=='M'" ) -- exemplo de filtro default

oBrowse:DisableDetails() // Desabilita a exibicao de detalhes na tela do Browse 
oBrowse:Activate() // Ativa o Browse

Return NIL


//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
montagem menu em MVC

@author Paulo Bindo
@since 01/10/2021
@version P12
/*/
//-------------------------------------------------------------------

Static Function MenuDef() // essa funcao encontra se dentro do  fwmbrowse()
Local aRotina := {}

// Adiciona as opcoes ao menu
ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'          OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MOD1_MVC' OPERATION 2 ACCESS 0 
// sempre atento a fazer as amarraçoes das funcoes as actions
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MOD1_MVC' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MOD1_MVC' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MOD1_MVC' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MOD1_MVC' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MOD1_MVC' OPERATION 9 ACCESS 0
Return aRotina



//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
montagem modelo dados em MVC

@author Paulo Bindo
@since 01/10/2021
@version P12
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruSZ1 := FWFormStruct( 1, 'SZ1', /*bAvalCampo*/,/*lViewUsado*/ )
Local oModel
 
// Remove campos da estrutura                        
//oStruSZ1:RemoveField( 'Z1_FATOR' )      
 

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New('MOD1MVCM', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
//oModel := MPFormModel():New('MOD1MVCM', /*bPreValidacao*/, { |oMdl| MOD1CPOS( oMdl ) }, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formul rio de edi  o por campo
oModel:AddFields( 'SZ1MASTER', /*cOwner*/, oStruSZ1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

//Define a chave primaria utilizada pelo modelo
oModel:SetPrimaryKey({'Z1_FILIAL', 'Z1_CLIENT', 'Z1_LOJA' })

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Modelo de Dados de UM Cliente' )

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'SZ1MASTER' ):SetDescription( 'Dados da UM Cliente' )

// Liga a valida  o da ativacao do Modelo de Dados
oModel:SetVldActivate( { |oModel| MOD1ACT( oModel ) } ) // valida se pode excluir

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
montagem view  em MVC

@author Paulo Bindo
@since 01/10/2021
@version P12
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
// FWLoadModel carrega o modelo de dados ja definido
Local oModel   := FWLoadModel( 'MOD1_MVC' ) //ModelDef() //FWLoadModel( 'MOD1_MVC' )
// Cria a estrutura a ser usada na View
Local oStruSZ1 := FWFormStruct( 2, 'SZ1' ) // forma a tela de edicao

Local oView  


// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados ser  utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_SZ1', oStruSZ1, 'SZ1MASTER' )

//remove campo estrutura
//oStruSZ1:RemoveField( 'Z1_FATOR' )


// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'TELA' , 100 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_SZ1', 'TELA' )

//Forca o fechamento da janela na confirma  o
oView:SetCloseOnOk({||.T.})

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} MOD1CPOS
montagem view  em MVC

@author Paulo Bindo
@since 01/10/2021
@version P12
/*/
//-------------------------------------------------------------------

Static Function MOD1CPOS( oModel )
Local nOperation := oModel:GetOperation()
Local lRet       := .T.

If nOperation == 4
	If Empty( oModel:GetValue( 'SZ1MASTER', 'Z1_MVC' ) )
		Help( ,, 'HELP',, 'Informe o campo mvc', 1, 0)
		lRet := .F.
	EndIf
EndIf

Return lRet


//-------------------------------------------------------------------
/*/{Protheus.doc} MOD1ACT
valida se pode excluir

@author Paulo Bindo
@since 01/10/2021
@version P12
/*/
//-------------------------------------------------------------------

Static Function MOD1ACT( oModel )  // Passa o model sem dados
Local aArea      := GetArea()
Local cQuery     := ''
Local cTmp       := ''
Local lRet       := .T.
Local nOperation := oModel:GetOperation()

If nOperation == 5 .AND. lRet // operacao 5 = excluir

	cTmp    := GetNextAlias()

	
	cQuery  := " SELECT Z1_CLIENT FROM " + RetSqlName( 'SZ1' ) + " Z1 "
	cQuery  += " WHERE EXISTS ( "
	cQuery  += "       SELECT 1 FROM " + RetSqlName( 'SA1' ) + " A1 "
	cQuery  += "        WHERE Z1_CLIENT = A1_COD AND Z1_LOJA = A1_LOJA"
	cQuery  += "          AND A1.D_E_L_E_T_ <> '*' ) "
	cQuery  += "   AND Z1_CLIENT = '" + SZ1->Z1_CLIENT  + "' "
	cQuery  += "   AND Z1.D_E_L_E_T_ = ' ' "

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ) , cTmp, .F., .T. )

	lRet := (cTmp)->( EOF() )

	(cTmp)->( dbCloseArea() )

	If !lRet
		Help( ,, 'HELP',, 'Este Cadastro nao pode ser excluido.', 1, 0)
	EndIf

EndIf

RestArea( aArea )

Return lRet



