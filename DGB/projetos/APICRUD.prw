#include 'totvs.ch'
#include 'tlpp-core.th'
#include "tlpp-rest.th"

namespace projeto.api.clientes

Class Clientes from fwAdapterBaseV2

	public method new() constructor

	@get(endpoint='/clientes',description='Retorna a lista de clientes')
	public method listar_clientes() as logical

	@post(endpoint='/cliente',description='Cria um novo cliente')
	public method novo_cliente() as logical

	@get(endpoint='/cliente',description='Retorna os detalhes de um cliente')
	public method detalhe_cliente() as logical

	@put(endpoint='/cliente',description='Atualiza os dados de um cliente')
	public method atualiza_cliente() as logical

	@get(endpoint='/estados',description='Retorna a lista de estados')
	public method listar_estados() as logical

	@get(endpoint='estados/:estado',description='Retorna o estado do cliente')
	public method detalhes_estado() as logical

	@get(endpoint='/cidades/:estado',description='Retorna a lista de cidades de um estado')
	public method listar_cidades() as logical

	@get(endpoint='/cidades/:estado/:cidade',description='Retorna a lista de cidades de um estado')
	public method detalhes_cidade() as logical

	@delete(endpoint='/cliente',description='Exclui um cliente')
	public method excluir_cliente() as logical

End Class
method new() class Clientes
Return self

method excluir_cliente() class Clientes
	Local jQueryParams  as json
	Local jHeaderReq    as json
	Local jHeaderRes    as json
	Local cMsgLog       as character
	Local cCodigo       as character
	Local cLoja         as character
	Local aDados         as array
	Local lRet           as logical
	Local lMsErroAuto    as logical


	jHeaderRes := jsonObject():new()
	jHeaderRes['Content-Type'] := 'application/json'

	jQueryParams  := oRest:getQueryRequest()
	jHeaderReq    := oRest:getHeaderRequest()

	cCodigo     := jQueryParams['codigo']
	cLoja       := jQueryParams['loja']

	SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCodigo+cLoja))
	aDados  := array(0)
	aadd(aDados,{'A1_COD'   ,SA1->A1_COD    ,})
	aadd(aDados,{'A1_LOJA'  ,SA1->A1_LOJA   ,})

	lMsErroAuto := .F.
	lRet        := .T.

	msExecAuto({|x,y| mata030(x,y)},aDados,5)

	If lMsErroAuto
		mostraerro('\data\','mata030_erro.txt')
		cMsgLog := memoread('\data\mata030_erro.txt')
		lRet := .F.
	EndIf

	jResponse := jsonObject():new()

	If lRet
		jResponse['retorno'] := 'Cliente excluído com sucesso.'
		oRest:setResponse(jResponse:toJson())
	Else
		oRest:setStatusCode(500)
		oRest:setFault(cMsgLog)
	EndIf

return .T.

method listar_clientes() class Clientes
	Local cQuery     as character
	Local cWhere     as character
	Local cResult    as character
	Local cCodigo    as character
	Local cLoja      as character
	Local nPage      as numeric
	Local nPageSize  as numeric
	Local jResult    as json
	Local jQueryPar  as json
	Local jHeaderReq as json
	Local jHeaderRes as json
	//Local oQuery     as object

	jHeaderReq       := oRest:getHeaderRequest()
	jQueryPar        := oRest:getQueryRequest()

	cCodigo          := jQueryPar['codigo'  ]
	cLoja            := jQueryPar['loja'    ]
	cSearch          := jQueryPar['search'  ]
	cOrder           := jQueryPar['order'   ]
	nPage            := jQueryPar['page'    ]; nPage     := val(nPage     )
	nPageSize        := jQueryPar['pageSize']; nPageSize := val(nPageSize )

	IF .not. valtype(cOrder) == 'C'
		cOrder := 'A1_COD, A1_LOJA'
	Else
		DO CASE
		CASE cOrder == 'codigo' .or. cOrder == 'loja'
			cOrder := 'A1_COD,A1_LOJA'
		CASE cOrder == 'nome'
			cOrder := 'A1_NOME'
		CASE cOrder == 'endereco'
			cOrder := 'A1_END'
		OTHERWISE
			cOrder := 'A1_COD,A1_LOJA'
		END CASE
	EndIF

	jHeaderRes       := jsonObject():new()
	jHeaderRes['Content-Type'] := 'application/json'

	cQuery := "SELECT #QueryFields# FROM ("
	cQuery += CRLF + "SELECT * FROM " + RETSQLNAME("SA1") + " SA1 ) SA1"
	cQuery += CRLF + "WHERE #QueryWhere#"

	cWhere := "D_E_L_E_T_ = ' ' "

	IF .not. empty(cSearch)

		IF empty(jQueryPar['order']) .or. jQueryPar['order'] == 'nome'
			cWhere += CRLF + "AND A1_NOME LIKE '%" + Upper(alltrim(cSearch)) + "%' "
		ElseIF jQueryPar['order'] == 'endereco'
			cWhere += CRLF + "AND A1_END LIKE '%" + Upper(alltrim(cSearch)) + "%' "
		ElseIF jQueryPar['order'] == 'codigo'
			cWhere += CRLF + "AND A1_COD LIKE '%" + Upper(alltrim(cSearch)) + "%' "
		ElseIF jQueryPar['order'] == 'cidade'
			cWhere += CRLF + "AND A1_MUN LIKE '%" + Upper(alltrim(cSearch)) + "%' "
		ElseIF jQueryPar['order'] == 'estado'
			cWhere += CRLF + "AND A1_EST LIKE '%" + Upper(alltrim(cSearch)) + "%' "
		Else
			cWhere += CRLF + "AND A1_NOME LIKE '%" + Upper(alltrim(cSearch)) + "%' "
		EndIF

	EndIF

	_Super:new('GET',.T.)
	::addMapFields('codigo'    ,'A1_COD'   ,.T.,.T.)
	::addMapFields('loja'      ,'A1_LOJA'  ,.T.,.T.)
	::addMapFields('nome'      ,'A1_NOME'  ,.T.,.T.)
	::addMapFields('tipo'      ,'A1_PESSOA',.T.,.T.)
	::addMapFields('endereco'  ,'A1_END'   ,.T.,.T.)
	::addMapFields('bairro'    ,'A1_BAIRRO',.T.,.T.)
	::addMapFields('cidade'    ,'A1_MUN'   ,.T.,.T.)
	::addMapFields('estado'    ,'A1_EST'   ,.T.,.T.)
	::addMapFields('cep'       ,'A1_CEP'   ,.T.,.T.)

	::setQuery(cQuery)
	::setWhere(cWhere)
	::setOrder(cOrder)
	::setPageSize(nPageSize)
	::setPage(nPage)

	IF ::execute()
		::fillGetResponse()
		cResult := ::getJsonResponse()
	EndIF

	jResult := jsonObject():new()
	jResult:fromJson(cResult)

	oRest:setResponse(cResult)

Return .T.
method novo_cliente() class Clientes
	Local jQueryParams  as json
	Local jHeaderReq    as json
	Local jHeaderRes    as json
	Local jBodyReq      as json
	Local cMegLog       as character
	Local lRet           as logical


	jHeaderRes := jsonObject():new()
	jHeaderRes['Content-Type'] := 'application/json'

	jQueryParams  := oRest:getQueryRequest()
	jHeaderReq    := oRest:getHeaderRequest()

	jBodyReq      := jsonObject():new()
	jBodyReq:fromJson(oRest:getBodyRequest())

	lRet  := grava_cliente(@jBodyReq,@cMegLog)

	If lRet
		oRest:setResponse(jBodyReq:toJson())
	else
		oRest:setStatusCode(500)
		oRest:setFault(cMegLog)
	EndIf


return .T.

method atualiza_cliente() class Clientes
	Local jQueryParams  as json
	Local jHeaderReq    as json
	Local jHeaderRes    as json
	Local jBodyReq      as json
	Local cMegLog       as character
	Local lRet           as logical


	jHeaderRes := jsonObject():new()
	jHeaderRes['Content-Type'] := 'application/json'

	jQueryParams  := oRest:getQueryRequest()
	jHeaderReq    := oRest:getHeaderRequest()

	jBodyReq      := jsonObject():new()
	jBodyReq:fromJson(oRest:getBodyRequest())

	lRet  := grava_cliente(@jBodyReq,@cMegLog)

	If lRet
		oRest:setResponse(jBodyReq:toJson())
	else
		oRest:setStatusCode(500)
		oRest:setFault(cMegLog)
	EndIf

return .T.

method detalhes_estado() class Clientes
	Local jResponse     as json
	Local jPathPar      as json
	Local cEstado       as character

	jPathPar            := oRest:getPathParamsRequest()
	cEstado             := jPathPar['estado']

	dbSelectArea('SX5')
	dbSetOrder(1)
	dbSeek(xFilial(alias())+'12'+cEstado)

	jResponse           := jsonObject():new()
	jResponse['value']  := alltrim(SX5->X5_CHAVE)
	jResponse['label']  := alltrim(SX5->X5_DESCRI)

	oRest:setResponse(jResponse:toJson())

return .T.

method listar_estados() class Clientes
	Local cQuery     	as character
	Local cWhere     	as character
	Local cResult    	as character
	Local cOrder			as character
	Local nPage				as numeric
	Local nPageSize		as numeric
	Local jResult			as json
	Local jHeaderRes	as json

	jHeaderRes	:= jsonObject():new()
	jHeaderRes['Content-Type']	:= 'application/json'

	cQuery := "SELECT #QueryFields# FROM ("
	cQuery += CRLF + "SELECT * FROM " + retSqlName("SX5") + " SX5 ) SX5"
	cQuery += CRLF + "WHERE #QueryWhere#"

	cWhere := "D_E_L_E_T_ = ' ' "
	cWhere += CRLF + "AND X5_TABELA = '12' "

	If .not. empty(oRest:getQueryRequest()['filter'])
		cWhere += CRLF + "AND X5_DESCRI LIKE '%" + Upper(alltrim(oRest:getQueryRequest()['filter'])) + "%' "
	EndIf

	cOrder := "X5_DESCRI"
	nPageSize := 30
	nPage := 1

	_Super:new('GET',.T.)
	::addMapFields('value'    ,'X5_CHAVE'   ,.T.,.T.,)
	::addMapFields('label'    ,'X5_DESCRI'	,.T.,.T.,)
	::setQuery(cQuery)
	::setWhere(cWhere)
	::setOrder(cOrder)
	::setPageSize(nPageSize)
	::setPage(nPage)

	If ::execute()
		::fillGetResponse()
		cResult := ::getJsonResponse()
	EndIf
	jResult := jsonObject():new()
	jResult:fromJson(cResult)

	oRest:setResponse(cResult)

return .T.

method listar_cidades() class Clientes
	Local cQuery     	as character
	Local cWhere     	as character
	Local cResult    	as character
	Local cOrder			as character
	Local nPage				as numeric
	Local nPageSize		as numeric
	Local jResult			as json
	Local jHeaderReq	as json
	Local jHeaderRes	as json
	Local jPathParams as json

	jHeaderReq	:= oRest:getHeaderRequest()
	jPathParams := oRest:getPathParamsRequest()

	jHeaderRes	:= jsonObject():new()
	jHeaderRes['Content-Type']	:= 'application/json'

	cQuery := "SELECT #QueryFields# FROM ("
	cQuery += CRLF + "SELECT * FROM " + retSqlName("CC2") + " CC2 ) CC2"
	cQuery += CRLF + "WHERE #QueryWhere#"

	cWhere := "D_E_L_E_T_ = ' ' "
	cWhere += CRLF + "AND CC2_EST = '" + Upper(alltrim(jPathParams['estado'])) + "' "

	If .not. empty(oRest:getQueryRequest()['filter'])
		cWhere += CRLF + "AND CC2_MUN LIKE '%" + Upper(alltrim(oRest:getQueryRequest()['filter'])) + "%' "
	EndIf

	cOrder := "CC2_EST, CC2_MUN"
	nPageSize := 200
	nPage := 1

	_Super:new('GET',.T.)
	::addMapFields('estado'   ,'CC2_EST' ,.T.,.T.,)
	::addMapFields('cidade'   ,'CC2_MUN' ,.T.,.T.,)
	::addMapFields('codibge'  ,'CC2_CODMUN' ,.T.,.T.,)
	::addMapFields('value'    ,'CC2_MUN' ,.T.,.T.,{'CC2_MUN','C',TamSX3('CC2_MUN')[1],0},'CC2_VALUE')
	::addMapFields('label'    ,'CC2_MUN' ,.T.,.T.,{'CC2_MUN','C',TamSX3('CC2_MUN')[1],0},'CC2_LABEL')

	::setQuery(cQuery)
	::setWhere(cWhere)
	::setOrder(cOrder)
	::setPageSize(nPageSize)
	::setPage(nPage)

	If ::execute()
		::fillGetResponse()
		cResult := ::getJsonResponse()
	EndIf
	jResult := jsonObject():new()
	jResult:fromJson(cResult)

	oRest:setResponse(cResult)

return .T.

method detalhes_cidade() class Clientes
	Local jPathPar      as json
	Local jResponse     as json
	Local jHeaderReq    as json
	Local cEstado       as character
	Local cCidade       as character
	Local cCodigo       as character
	Local cLoja         as character

	jPathPar    := oRest:getPathParamsRequest()
	jHeaderReq  := oRest:getHeaderRequest()

	cCodigo     := jHeaderReq['codigoclient']
	cLoja       := jHeaderReq['lojaclient']

	jResponse   := jsonObject():new()

	cEstado     := jPathPar['estado']
	cCidade     := jPathPar['cidade']

	dbSelectArea("CC2")
	dbSetOrder(4)
	dbSeek(xFilial(alias())+cEstado+cCidade)

	If .not. empty(cCodigo)
		SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCodigo+cLoja))
		CC2->(dbSetOrder(4),dbSeek(xFilial(alias())+SA1->A1_EST+SA1->A1_MUN))
	EndIf

	jResponse['value'] := alltrim(CC2->CC2_MUN)
	jResponse['label'] := alltrim(CC2->CC2_MUN)

	oRest:setResponse(jResponse:toJson())

return.T.

method detalhe_cliente() class Clientes
	Local jQueryParams  as json
	Local jHeaderReq    as json
	Local jHeaderRes    as json
	Local jResponse     as json
	Local cCodigo    as character
	Local cLoja      as character

	jQueryParams := oRest:getQueryRequest()
	jHeaderReq   := oRest:getHeaderRequest()

	jHeaderRes  := jsonObject():new()
	jResponse   := jsonObject():new()

	cCodigo     := jQueryParams['codigo']
	cLoja       := jQueryParams['loja']
	cLoja       := Left(cLoja,2)

	dbSelectArea('SA1')
	dbSetOrder(1)
	dbSeek(xFilial(alias())+cCodigo+cLoja)

	jResponse['codigo'    ] := SA1->A1_COD
	jResponse['loja'      ] := SA1->A1_LOJA
	jResponse['nome'      ] := alltrim(SA1->A1_NOME)
	jResponse['pessoa'    ] := SA1->A1_PESSOA
	jResponse['endereco'  ] := alltrim(SA1->A1_END)
	jResponse['cep'       ] := SA1->A1_CEP
	jResponse['bairro'    ] := SA1->A1_BAIRRO
	jResponse['cidade'    ] := SA1->A1_MUN
	jResponse['estado'    ] := SA1->A1_EST

	oRest:setResponse(jResponse:toJson())

return .T.



static function grava_cliente(jCliente as json, cMsgLog as character) as logical
	Local cCodigo as character
	Local cLoja as character
	Local cNome as character
	Local cNReduz as character
	Local cPessoa as character
	Local cTipo as character
	Local cEnd as character
	Local cCep as character
	Local cBairro as character
	Local cCidade as character
	Local cCodMun as character
	Local cEstado as character
	Local cCampo as character
	Local lStatus as logical
	Local nOpc as numeric
	Local nPos as numeric
	Local aDados as array
	Local aCampos as array

	Local x as variant
	Local xValue as variant

	Private lMsErroAuto as logical

	cCodigo := jCliente['codigo']
	cLoja   := jCliente['loja']
	cNome   := Upper(fwNoAccent(decodeUTF8(jCliente['nome'],'cp1252')))
	cPessoa := jCliente['pessoa']
	cEnd    := Upper(fwNoAccent(decodeUTF8(jCliente['endereco'],'cp1252')))
	cCep    := jCliente['cep']
	cCep    := if(valtype(cCep) <> 'C','',cCep)
	cBairro := Upper(fwNoAccent(decodeUTF8(jCliente['bairro'],'cp1252')))
	cCidade := jCliente['cidade']
	cEstado := jCliente['estado']
	lStatus := jCliente['status']
	cNReduz := LEFT(cNome,tamSX3('A1_NREDUZ')[1])
	cTipo   := 'F'

	cBloquei:= if(lStatus,'1','2')

	aDados  := array(0)

	IF isInCallStack('novo_cliente')
		nOpc := 3
	ElseIF isInCallStack('atualiza_cliente')
		nOpc := 4
	EndIF

	IF cEstado == 'EX'

		cTipo := 'X'
		cCep  := ''

	Else

		CC2->(dbSetOrder(4),dbSeek(xFilial(alias())+cEstado+cCidade))
		cCodMun := CC2->CC2_CODMUN
		cCidade := CC2->CC2_MUN

	EndIF

	IF nOpc == 3
		aadd(aDados,{'A1_LOJA'  ,'01'           ,})
	Else
		SA1->(dbSetOrder(1),dbSeek(xFilial(alias())+cCodigo+cLoja))

		aadd(aDados,{'A1_COD'   ,SA1->A1_COD    ,})
		aadd(aDados,{'A1_LOJA'  ,SA1->A1_LOJA   ,})

		cNReduz := SA1->A1_NREDUZ
	EndIF

	aadd(aDados,{'A1_NOME'      ,cNome          ,})
	aadd(aDados,{'A1_NREDUZ'    ,cNReduz        ,})
	aadd(aDados,{'A1_PESSOA'    ,cPessoa        ,})
	aadd(aDados,{'A1_TIPO'      ,cTipo          ,})
	aadd(aDados,{'A1_END'       ,cEnd           ,})
	aadd(aDados,{'A1_CEP'       ,cCep           ,})
	aadd(aDados,{'A1_BAIRRO'    ,cBairro        ,})
	aadd(aDados,{'A1_EST'       ,cEstado        ,})

	IF cEstado <> 'EX'
		aadd(aDados,{'A1_COD_MUN'   ,cCodMun        ,})
	EndIF

	aadd(aDados,{'A1_MUN'       ,cCidade        ,})
	aadd(aDados,{'A1_MSBLQL'    ,cBloquei       ,})

	IF nOpc == 4
		aCampos := fwSx3Util():getAllFields('SA1',.F.)

		For x := 1 To Len(aCampos)
			IF alltrim(aCampos[x]) == 'A1_COD_MUN'
				Loop
			EndIF

			cCampo     := alltrim(aCampos[x])
			xValue     := &('SA1->' + cCampo)
			nPos       := aScan(aDados,{|xCampo| alltrim(xCampo[1]) == cCampo})

			IF nPos == 0
				aadd(aDados,{cCampo,xValue,})
			EndIF

		Next

	EndIF

	lMsErroAuto := .F.

	msExecAuto({|x,y| mata030(x,y)},aDados,nOpc)

	IF lMsErroAuto
		mostraerro('\data\','mata030_erro.txt')
		cMsgLog := memoread('\data\mata030_erro.txt')
		return .F.
	EndIF

	jCliente['codigo'] := SA1->A1_COD
	jCliente['loja'  ] := SA1->A1_LOJA

return .T.
