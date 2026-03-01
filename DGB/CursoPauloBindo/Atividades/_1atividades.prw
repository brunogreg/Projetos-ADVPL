#Include "Protheus.ch"

/*/-------------------------------------------------------------------
- Programa  : Contabilizacao
- Autor     : Tarcisio Silva Miranda
- Data      : 28/01/2026
- Descrição : Rotina que faz o calculo do ato cooperado.
-------------------------------------------------------------------/*/

Static cTexto := "Estatica"
User Function Principal()

    Local nNumero := 10   // Variável LOCAL (escopo restrito à função)
    Private dData := Date() // Variável PRIVATE (visível nas funções chamadas)

    if nNumero >= 10.5
        ALERT("OK")
    EndIf

    ConOut("Valor: " + cValToChar(nNumero))
    
    Filha()

Return
Static Function Filha()

    Local nNumero := 20    // Local apenas da Filha
    Private lContinua := .T. // Private visível para funções chamadas
    Public aDados := {1,3,7}

    cTexto := " NOVAMENTE"+SPACE(10)
    dData := dData + nNumero
    dData += nNumero 

    if lContinua == .F.
        ALERT("FALSO")
    else
        ALERT("VERDADEIRO")
    EndIf

    if ! lContinua
        ALERT("FALSO")
    Endif

    ConOut("Valor: " + cValToChar(nNumero))
    ConOut("Valor: " + cValToChar(cTexto))
   
    U_Secundaria()

Return

User Function Secundaria()

    Local nNumero := 30 // Local apenas da Secundaria

    aDados := {,0,0,0}
    nResto := nNumero % 4
    cTexto := cTexto - "sem espaço"

    if "ATEU" $ cTexto // $ = significa que esta contido
        ALERT("contido")
    Endif

    ConOut("Valor: " + cValToChar(nNumero))

Return

