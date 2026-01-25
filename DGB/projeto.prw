//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSTitSe2
Recebe dados para geração de Titulos a Pagar
@author Pedro Henrique Pestana de Souza
@since 22/01/2026
@version 1.0
@type wsrestful

/*/

WSRESTFUL WSTitSe2 DESCRIPTION 'Recebe dados para geracao de Titulos a Pagar'
    //Métodos
    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSTitSe2/receivetit'                               PATH 'receivetit'           PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD POST NEW
Cria um novo registro na tabela
@author Pedro Henrique Pestana de Souza
@since 22/01/2026
@version 1.0
@type method
/*/

// WSMETHOD é utilizado para definir um método dentro de uma classe WSRESTFUL
WSMETHOD POST NEW WSRECEIVE WSSERVICE WSTitSe2 //Método para receber os dados e criar o registro
    Local lRet              := .T.
    Local aDados            := {}
    Local jJson             := Nil
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local nLinha            := 0
    Local cDirLog           := '\x_logs\'
    Local cArqLog           := ''
    Local cErrorLog         := ''
    Local aLogAuto          := {}
    Local nCampo            := 0
    Local jResponse         := JsonObject():New()
    Local cAliasWS          := 'SE2'
    Private lMsErroAuto     := .F.
    Private lMsHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.
 
    //Se não existir a pasta de logs, cria
    IF ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

    //Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
    Self:SetContentType('application/json')
    jJson  := JsonObject():New() //Cria o objeto JSON
    cError := jJson:FromJson(cJson) //Faz o Parse do JSON recebido
 
    //Se tiver algum erro no Parse, encerra a execução
    IF ! Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') 
        Self:setStatus(500) 
        jResponse['errorId']  := 'BFREST-004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

    Else
		DbSelectArea(cAliasWS)
       
		//Adiciona os dados do ExecAuto
		aAdd(aDados, {'E2_FILIAL',   xFilial("SE2"),         Nil})
		aAdd(aDados, {'E2_PREFIXO',   jJson:GetJsonObject('prefixo'),   Nil})
		aAdd(aDados, {'E2_NUM',   jJson:GetJsonObject('num'),   Nil})
		aAdd(aDados, {'E2_TIPO',   jJson:GetJsonObject('tipo'),   Nil})
		aAdd(aDados, {'E2_NATUREZ',   jJson:GetJsonObject('naturez'),   Nil})
		aAdd(aDados, {'E2_FORNECE',   Posicione('SA2',1,xFilial("SA2") + jJson:GetJsonObject('fornece'),"A2_COD") ,   Nil})
		aAdd(aDados, {'E2_LOJA',     Posicione('SA2',1,xFilial("SA2") + jJson:GetJsonObject('fornece'),"A2_LOJA") ,   Nil})
		aAdd(aDados, {'E2_NOMFOR',   Posicione('SA2',1,xFilial("SA2")+jJson:GetJsonObject('fornece')+jJson:GetJsonObject('loja'), "A2_NOME" ),   Nil})
		aAdd(aDados, {'E2_VENCTO',   jJson:GetJsonObject('vencto'),   Nil})
		aAdd(aDados, {'E2_VALOR',   jJson:GetJsonObject('valor'),   Nil})
		aAdd(aDados, {'E2_XVLBR',   jJson:GetJsonObject('xvlbr'),   Nil})
		aAdd(aDados, {'E2_HIST',   jJson:GetJsonObject('hist'),   Nil})
		aAdd(aDados, {'E2_IRRF',   jJson:GetJsonObject('irrf'),   Nil})
		aAdd(aDados, {'E2_FORBCO',   jJson:GetJsonObject('forbco'),   Nil})
		aAdd(aDados, {'E2_FORAGE',   jJson:GetJsonObject('forage'),   Nil})
		aAdd(aDados, {'E2_FORCTA',   jJson:GetJsonObject('forcta'),   Nil})
		aAdd(aDados, {'E2_FCTADV',   jJson:GetJsonObject('fctadv'),   Nil})
		aAdd(aDados, {'E2_FORMPAG',   jJson:GetJsonObject('formpag'),   Nil})
		aAdd(aDados, {'E2_CONTAD',   jJson:GetJsonObject('contad'),   Nil})
		aAdd(aDados, {'E2_CCD',   jJson:GetJsonObject('ccd'),   Nil})
		aAdd(aDados, {'E2_LINDIG',   jJson:GetJsonObject('lindig'),   Nil})
		aAdd(aDados, {'E2_XDESCON',   jJson:GetJsonObject('descont'),   Nil})
		aAdd(aDados, {'E2_XNOMSOL',   jJson:GetJsonObject('xnomsol'),   Nil})
		aAdd(aDados, {'E2_XEMASOL',   jJson:GetJsonObject('xemasol'),   Nil})
		
		//Percorre os dados do execauto
		For nCampo := 1 To Len(aDados)
			//Se o campo for data, retira os hifens e faz a conversão
			If GetSX3Cache(aDados[nCampo][1], 'X3_TIPO') == 'D' // GetSX3Cache verifica o tipo do campo na tabela
				aDados[nCampo][2] := StrTran(aDados[nCampo][2], '-', '')
				aDados[nCampo][2] := sToD(aDados[nCampo][2])
			EndIf
		Next

		//Chama a inclusão automática
		MsExecAuto({|x, y| FINA050(x, y)}, aDados, 3) //3 = Modo de inclusão sem confirmação

		//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
		If lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := GetAutoGrLog() // GetAutoGrLo retorna um array com as linhas do log gerado pelo ExecAuto
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSTitSe2_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog) //Grava o log de erro

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'BFREST-005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet



