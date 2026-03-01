#include 'PROTHEUS.CH'


/*/{Protheus.doc} PLOJA001
@author pablocavalcante
@since 10/04/2014
@version 1.0
@description
Ponto de Entrada da Rotina de Cadastro de Carta Frete (ULOJA020)
/*/
User Function UCOMP001()

Local aParam     := PARAMIXB
Local oObj       := aParam[1]
Local cIdPonto   := aParam[2]
Local cIdModel   := IIf( oObj<> NIL, oObj:GetId(), aParam[3] ) //cIdModel   := aParam[3]
Local cClasse    := IIf( oObj<> NIL, oObj:ClassName(), '' )
Local nOperation := IIf( oObj<> NIL, oObj:GetOperation(), 0)
Local xRet       := .T.
Local lIsGrid    := .F.
Local nLinha     := 0
Local nQtdLinhas := 0
Local cMsg       := ''
Local cOperad := ""

If aParam <> NIL

	oObj       := aParam[1]
	cIdPonto   := aParam[2]
	cIdModel   := IIf( oObj<> NIL, oObj:GetId(), aParam[3] ) //cIdModel   := aParam[3]
	cClasse    := IIf( oObj<> NIL, oObj:ClassName(), '' )
	nOperation := IIf( oObj<> NIL, oObj:GetOperation(), 0)

	lIsGrid    := ( Len( aParam ) > 3 ) .and. cClasse == 'FWFORMGRID'

	If lIsGrid
		nQtdLinhas := oObj:GetQtdLine()
		nLinha     := oObj:nLine
	EndIf

	If cIdPonto == 'MODELVLDACTIVE'		
	
	Alert("Entrou no ponto de entrada MODELVLDACTIVE")
		
		if ZB1->ZB1_SITUAC$"2"
			Help( ,, 'Help',, 'Essa Matricula encontrase bloqueada. A  o n o permitida.', 1, 0 )
			xRet := .T.
		endif
	
  	ElseIf cIdPonto == 'BUTTONBAR'
	//Para a inclus o de bot es na ControlBar.
	Alert("Entrou no ponto de entrada BUTTONBAR")

	ElseIf cIdPonto == 'FORMLINEPRE'
	//Antes da altera  o da linha do formul rio FWFORMGRID. 
	Alert("Entrou no ponto de entrada FORMLINEPRE")

	ElseIf cIdPonto ==  'FORMPRE'
	//Antes da altera  o de qualquer campo do formul rio. 
	Alert("Entrou no ponto de entrada FORMPRE")
	
	ElseIf cIdPonto == 'FORMPOS'
	//Na valida  o total do formul rio. 
	Alert("Entrou no ponto de entrada FORMPOS")	
	
	ElseIf cIdPonto == 'FORMLINEPOS'
	//Na valida  o total da linha do formul rio FWFORMGRID. formul rio
	Alert("Entrou no ponto de entrada FORMLINEPOS")	

  	ElseIf cIdPonto ==  'MODELPRE'
	//Antes da altera  o de qualquer campo do modelo. 
	Alert("Entrou no ponto de entrada MODELPRE")
	
	ElseIf cIdPonto == 'MODELPOS'
	//Na valida  o total do modelo. 
	Alert("Entrou no ponto de entrada MODELPOS")	
	
	ElseIf cIdPonto == 'FORMCANCEL'
	//No cancelamento do bot o.
	Alert("Entrou no ponto de entrada FORMCANCEL")

	ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
	//Antes da grava  o da tabela do formul rio.
	Alert("Entrou no ponto de entrada FORMCOMMITTTSPRE")

	ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
	//Ap s a grava  o da tabela do formul rio.
	Alert("Entrou no ponto de entrada FORMCOMMITTTSPOS")

	ElseIf cIdPonto == 'MODELCOMMITTTS'
	//Ap s a grava  o total do modelo e dentro da transa  o.
	Alert("Entrou no ponto de entrada MODELCOMMITTTS")
	
 	ElseIf cIdPonto == 'MODELCOMMITNTTS'
	//Ap s a grava  o total do modelo e fora da transa  o.
	Alert("Entrou no ponto de entrada MODELCOMMITNTTS")

	
 	ElseIf cIdPonto == 'MODELCANCEL'
	Alert("Entrou no ponto de entrada MODELCANCEL")
	//cMsg := 'Chamada no Bot o Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente Sair ?'
           
	endif

endif

Return xRet
