#Include 'TOTVS.ch'
#Include 'FWMVCDef.ch'
 
User Function zMVC05()
    Private oMark
     
    //Criando o MarkBrow
    oMark := FWMarkBrowse():New()
    oMark:SetAlias('ZB4')
     
    //Setando semáforo, descrição e campo de mark
    oMark:SetSemaphore(.T.)
    oMark:SetDescription('Seleção do Cadastro de Artistas')
    oMark:SetFieldMark('ZB4_OK')
     
    //Ativando a janela
    oMark:Activate()
Return NIL
  
Static Function MenuDef()
    Local aRotina := {}
     
    //Criação das opções
    ADD OPTION aRotina TITLE 'Processar'  ACTION 'u_zMarkProc'    OPERATION 2 ACCESS 0
Return aRotina 

 
User Function zMarkProc()
    Local aArea    := GetArea()
    Local cMarca   := oMark:Mark()
    Local nTotal   := 0
     
    //Percorrendo os registros da ZB4
    ZB4->(DbGoTop())
    While ! ZB4->(EoF())
        //Caso esteja marcado, aumenta o contador
        If oMark:IsMark(cMarca)
            nTotal++
             
            //Limpando a marca
            RecLock('ZB4', .F.)
                ZB4_OK := ''
            ZB4->(MsUnlock())
        EndIf
         
        //Pulando registro
        ZB4->(DbSkip())
    EndDo
     
    //Mostrando a mensagem de registros marcados
    MsgInfo('Foram marcados <b>' + cValToChar( nTotal ) + ' artistas</b>.', "Atenção")
     
    //Restaurando área armazenada
    RestArea(aArea)
Return
