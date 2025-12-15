#Include "protheus.ch"
#Include "tbiconn.ch"
#Include "tbicode.ch"
#Include "TOTVS.ch"

User Function soft1()
// Pega o valor do parâmetro MV_1DUP (modo clássico)
    Local cValor1 := GetMV("MV_1DUP")

    // Pega parâmetro considerando filial (GetNewPar)
    Local cValor2 := GetNewPar("MV_1DUP", "TESTE", xFilial("SC5"))

    // Pega parâmetro com prioridade para filial (SuperGetMV)
    Local cValor3 := SuperGetMV("MV_1DUP", .T., "TESTE", xFilial("SC5"))
    
    //ATUALIZAÇÃO DE PARÂMETROS
    
    If SELECT("SX6") > 0
        Alert("PROTHEUS ABERTO")
    Else
        RpcSetType(3)
        PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT"
    EndIf     
    
    PutMV("MV_1DUP", "B") // Grava o valor "B" no parâmetro

    Alert("Valor atualizado gravado no parâmetro MV_1DUP!")

    ConOut(cValor1)
    ConOut(cValor2)
    ConOut(cValor3)

    RESET ENVIRONMENT

Return
