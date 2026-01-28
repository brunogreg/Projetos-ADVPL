#include "protheus.ch"

//FUNCAO PRINCIPAL
User Function PEntrada()
	Local cNota  := "XXX"
	Local cSerie := "01"
	Local cFornece := "000001"
	Local cLoja := "02"
    Local lGravou := .F.
	Local aParam := {cNota, cSerie, cFornece, cLoja}


	IF EXISTBLOCK("PEcexb")// verifica se a funcao existe
		lGravou := EXECBLOCK("PEcexb",.F.,.F.,aParam) // executa a funcao de ponto de entrada
	ENDIF
RETURN




//PONTO DE ENTRADA
USER FUNCTION PEcexb()

	LOCAL cNota := PARAMIXB[1]
	LOCAL cSerie:= PARAMIXB[2]
	LOCAL cFornece:= PARAMIXB[3]
	LOCAL cLoja:= PARAMIXB[4]

	ApMsgAlert('Nota: '+cNota)
	ApMsgAlert('Serie: '+cSerie)
	ApMsgAlert('Fornece: '+cFornece)
	ApMsgAlert('Loja: '+cLoja)
RETURN .T.

