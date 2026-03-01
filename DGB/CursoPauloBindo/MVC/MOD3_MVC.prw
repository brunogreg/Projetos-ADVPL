#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} MOD3_MVC
Exemplo de montagem da modelo e interface para uma estrutura
pai/filho em MVC

@author Paulo Bindo
@since 05/10/2021
@version P12
/*/
//-------------------------------------------------------------------
User Function MOD3_MVC()
	Local oBrowse

	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias( 'SB1' )
	oBrowse:SetDescription( 'Produto X UM Cliente' )
	oBrowse:Activate()

Return NIL

/*/{Protheus.doc} MenuDef
montagem menu

@author Paulo Bindo
@since 05/10/2021
@version P12
/*/
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina Title 'Pesquisar'   Action 'PesqBrw'             OPERATION 1 ACCESS 0
	ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.MOD3_MVC' OPERATION 2 ACCESS 0
//	ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.MOD3_MVC' OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.MOD3_MVC' OPERATION 4 ACCESS 0
//	ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.MOD3_MVC' OPERATION 5 ACCESS 0
//	ADD OPTION aRotina Title 'Imprimir'    Action 'VIEWDEF.MOD3_MVC' OPERATION 8 ACCESS 0
//	ADD OPTION aRotina Title 'Copiar'      Action 'VIEWDEF.MOD3_MVC' OPERATION 9 ACCESS 0

Return aRotina


/*/{Protheus.doc} ModelDef
modelo de dados

@author Paulo Bindo
@since 05/10/2021
@version P12
/*/
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSB1 := FWFormStruct( 1, 'SB1', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oStruSZ1 := FWFormStruct( 1, 'SZ1', /*bAvalCampo*/, /*lViewUsado*/ )
	Local oModel

	//Remove os campos 
//	oStruSZ1:RemoveField('Z1_MVC')

// Cria o objeto do Modelo de Dados
	//oModel := MPFormModel():New( 'MOD3MVCM', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	oModel := MPFormModel():New('MOD3MVCM', /*bPreValidacao*/, { |oMdl| MOD3CPOS( oMdl ) }, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formul rio de edi  o por campo
	oModel:AddFields( 'PAI', /*cOwner*/, oStruSB1 )

// Adiciona ao modelo uma estrutura de formul rio de edi  o por grid
//oModel:AddGrid( 'FILHO', 'PAI', oStruSZ1, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
oModel:AddGrid(  'FILHO', 'PAI', oStruSZ1, /*bLinePre*/,  { | oMdlG | MOD3LPOS( oMdlG ) } , /*bPreVal*/, /*bPosVal*/ )

// Faz relaciomaneto entre os compomentes do model
	oModel:SetRelation( 'FILHO', { { 'Z1_PRODUT', 'B1_COD' }}, SZ1->( IndexKey( 1 ) ) )

// Liga o controle de nao repeticao de linha
	//oModel:GetModel( 'FILHO' ):SetUniqueLine( { 'C6_PRODUTO' } )

// Indica que   opcional ter dados informados na Grid
	//oModel:GetModel( 'FILHO' ):SetOptional(.T.)
	//oModel:GetModel( 'FILHO' ):SetOnlyView(.T.)
	oModel:SetPrimaryKey({'Z1_FILIAL', 'Z1_CLIENT', 'Z1_LOJA' })

// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Produto' )

// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'PAI' ):SetDescription( 'Produto' )
	oModel:GetModel( 'FILHO' ):SetDescription( 'UM Cliente'  )
	

Return oModel


/*/{Protheus.doc} ViewDef
montagem tela

@author Paulo Bindo
@since 05/10/2021
@version P12
/*/

Static Function ViewDef()
// Cria a estrutura a ser usada na View
	Local oView
	Local oModel   := FWLoadModel( 'MOD3_MVC' )
	
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oStruSB1 := FWFormStruct( 2, 'SB1' )
	Local oStruSZ1 := FWFormStruct( 2, 'SZ1' ,/*bAvalCampo*/ )
 	
	//Remove os campos 
	//oStruSZ1:RemoveField('Z1_MVC')
   
   
   //Define que no cabe alho n o ter  separa  o de abas (SXA)
    oStruSB1:SetNoFolder()

// Cria o objeto de View
	oView := FWFormView():New()

// Define qual o Modelo de dados ser  utilizado
	oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SB1', oStruSB1, 'PAI' )

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	oView:AddGrid(  'VIEW_SZ1', oStruSZ1, 'FILHO' )

// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR', 20 )
	oView:CreateHorizontalBox( 'INFERIOR', 80 )

// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SB1', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_SZ1', 'INFERIOR' )

// Define campos que terao Auto Incremento
	//oView:AddIncrementField( 'VIEW_SZ1', 'Z1_ITEM' )

// Criar novo botao na barra de botoes
	oView:AddUserButton( 'Teste', 'CLIPS', { |oView| MOD3BUT() } )

// Liga a identificacao do componente
	oView:EnableTitleView('VIEW_SZ1','UM Cliente')


Return oView



/*/{Protheus.doc} MOD3LPOS
valida campo

@author Paulo Bindo
@since 05/10/2021
@version P12
/*/
Static Function MOD3LPOS( oModelGrid )
	Local lRet       := .T.
	Local oModel     := oModelGrid:GetModel( 'FILHO' )
	Local nOperation := oModel:GetOperation()

	If nOperation == 3 .OR. nOperation == 4

		If FwFldGet( 'Z1_MVC' ) # "0"
			//Help( ,, 'Help',, 'Somente o valor ZERO e pemitido', 1, 0 )
			//lRet := .F.
		EndIf

	EndIf

Return lRet

/*/{Protheus.doc} MOD3CPOS
valida linha

@author Paulo Bindo
@since 05/10/2021
@version P12
/*/
//-------------------------------------------------------------------
Static Function MOD3CPOS( oModel )
	Local lRet       := .T.
	Local nOperation := oModel:GetOperation()
	Local oModelSZ1  := oModel:GetModel( 'FILHO' )
	Local nI         := 0
	Local nCt        := 0
	Local lAchou     := .F.
	Local aSaveLines := FWSaveRows()


	If nOperation == 3 .OR. nOperation == 4

		For nI := 1 To  oModelSZ1:Length()

			oModelSZ1:GoLine( nI )

			If !oModelSZ1:IsDeleted()
				If  oModelSZ1:GetValue( 'Z1_FATOR' ) == 1
				//	lAchou := .T.
					Exit
				EndIf
			EndIf

		Next nI

		If lAchou
			Help( ,, 'Help',, 'n o   permitido Fator 1 na segunda UM', 1, 0 )
			lRet := .F.
		EndIf

		If lRet

			For nI := 1 To oModelSZ1:Length()

				oModelSZ1:GoLine( nI )

				If oModelSZ1:IsInserted() .AND. !oModelSZ1:IsDeleted() // Verifica se   uma linha nova
					nCt++
				EndIf

			Next nI

			If nCt == 0
				Help( ,, 'Help',, 'N o foram inseridas novas linhas', 1, 0 )
				//lRet := .F.
			EndIf

		EndIf

	EndIf

	FWRestRows( aSaveLines )

Return lRet

/*/{Protheus.doc} MOD3BUT
insere botao

@author Paulo Bindo
@since 05/10/2021
@version P12
/*/
//-------------------------------------------------------------------
Static Function MOD3BUT()
	Local oModel     := FWModelActive()
	Local nOperation := oModel:GetOperation()
	Local aArea      := GetArea()
	Local aAreaSZ1   := SZ1->( GetArea() )
	Local lOk        := .F.

//FWExecView( /*cTitulo*/, /*cFonteModel*/, /*nAcao*/, /*bOk*/ )

	If     nOperation == 3 // Inclusao
		lOk := ( FWExecView('Inclusao por FWExecView','MOD1_MVC', nOperation, , { || .T. } ) == 0 )

	ElseIf nOperation == 4

		SZ1->( dbSetOrder( 2 ) )
		If SZ1->( dbSeek( xFilial( 'SZ1' ) + FwFldGet( 'Z1_PRODUT' ) ) )
			lOk := ( FWExecView('Alteracao por FWExecView','MOD1_MVC', nOperation, , { || .T. } ) == 0 )
		EndIf

	EndIf

	If lOk
		Help( ,, 'Help',, 'Foi alterada a segunda UM', 1, 0 )
	Else
		Help( ,, 'Help',, 'Foi cancelada a alteracao da segunda UM', 1, 0 )
	EndIf

	RestArea( aAreasZ1 )
	RestArea( aArea )

Return lOk
