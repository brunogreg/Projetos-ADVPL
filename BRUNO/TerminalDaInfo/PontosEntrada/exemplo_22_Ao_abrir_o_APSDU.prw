//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function SDULogin
Ponto de entrada na validação do login do APSDU
@type  Function
@author Atilio
@since 25/08/2023
@see https://tdn.totvs.com/display/public/framework/SDULogin+-+Entrada+e+acesso
/*/

User Function SDULogin()
    Local aArea     := FWGetArea()
    Local lContinua := .T.

    //Adiciona um atalho para liberar para abrir o topconn novamente
	SetKey(K_SH_F5, {|| u_zSDUConn() })

    FWRestArea(aArea)
Return lContinua

/*/{Protheus.doc} User Function zSDUConn
Faz com que a conexão com o TopConn seja atualizada
@type  Function
@author Atilio
@since 25/08/2023
/*/

User Function zSDUConn()
    Local aArea := FWGetArea()

    //Se tiver conexão ativa
    If Type("nConnect") != "U"

        //Se tiver tabelas abertas, não permite prosseguir
        If Len(__aFiles) > 0
            FWAlertError("Há tabela(s) aberta(s), feche toda(s) para prosseguir!", "Atenção")
        Else

            //Somente se o usuário confirmar, desconecta e define a variável como nula
            If FWAlertYesNo("Você deseja forçar a reconexão com o TopConn?", "Continua?")
                TCUnlink(nConnect)
                nConnect := Nil
            EndIf
        EndIf

    EndIf

    FWRestArea(aArea)
Return
