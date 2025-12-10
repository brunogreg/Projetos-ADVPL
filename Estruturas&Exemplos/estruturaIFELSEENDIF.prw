#INCLUDE "Protheus.ch"

User Function EstuturaIfElseEnif()
	Private lPagaIpva := .F.
	Private lRevisao := .F.

	While !Eof()

		If cMeuCarro == "NOVO"
			lPagaIpva := .T.
			If Nkm >=1000 .And. nkm <= 1999
				lRevisao := .T.
			EndIf

		ElseIf cMeuCarro == "VELHO" .And. cCarroEsposa == "NOVO"
			lPagaIpva := .T.
		Else
			lPagaIpva := .F.
		EndIf

		If lPagaIpva
			U_GeraTitulo()
		EndIf

		Do CASE
		Case cMeuCarro == "NOVO"
			lPagaIpva := .T.
            If Nkm >=1000 .And. nkm <= 1999
				lRevisao := .T.
			EndIf

		CASE cMeuCarro == "VELHO" .And. cCarroEsposa == "NOVO"
			lPagaIpva := .T.

		OTHERWISE
			lPagaIpva := .F.

		End CASE

		dbSkip()

	End

Return
