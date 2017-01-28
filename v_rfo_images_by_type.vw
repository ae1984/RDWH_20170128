create or replace force view u1.v_rfo_images_by_type as
select
   t.id
   ,t.c_uid as photo_guid
   ,trunc(t.c_date) as  photo_date
   ,t.c_date as  photo_datetime
   ,case
      when upper(t.c_name) like '%DOC_UD_LICH%'               then 'УДОС.ЛИЧНОСТИ'
      when  upper(t.c_name) like '%УДЛ%'                      then 'УДОС.ЛИЧНОСТИ'
      when  upper(t.c_name) like '%УД Л%'                     then 'УДОС.ЛИЧНОСТИ'
      when  upper(t.c_name) like '%DEP_ATTY_DOC%'             then 'УДОС.ЛИЧНОСТИ'
      when  upper(t.c_name) like '%UDL_PRODAVCA%'             then 'УДОС.ЛИЧНОСТИ'
      when  upper(t.c_name) like '%UDL_LIC%'                  then 'УДОС.ЛИЧНОСТИ'
      when  upper(t.c_name) like '%У/Л%'                      then 'УДОС.ЛИЧНОСТИ'
      when upper(t.c_name)  like '%DEP_CL_NEW%'               then 'ФОТО КЛИЕНТА'
      when upper(t.c_name)  like upper('%Изображение фото%')  then 'ФОТО КЛИЕНТА'
      when upper(t.c_name) like '%DEP_ATTY_CL%'               then 'ФОТО КЛИЕНТА'
      when upper(t.c_name) like '%FOTO_FL%'                   then 'ФОТО КЛИЕНТА'
      when upper(t.c_name) like '%КЛИЕНТ%'                    then 'ФОТО КЛИЕНТА'
      when upper(t.c_name) like '%КДИЕНТ%'                    then 'ФОТО КЛИЕНТА'
      when t.c_name like '%ФОТО%'                             then 'ФОТО КЛИЕНТА'
      when upper(t.c_name) like '%999_DEP_CL%'                then 'ФОТО КЛИЕНТА'
      when upper(t.c_name) like '%\_КЛ%'                      then 'ФОТО КЛИЕНТА 2'
      when upper(t.c_name) like '%ПАСПОРТ%'                   then 'ПАСПОРТ'
      when upper(t.c_name) like '%ПАСП%'                      then 'ПАСПОРТ'
      when upper(t.c_name) like '%ПАС1%'                      then 'ПАСПОРТ'
      when upper(t.c_name) like '%ПАС2%'                      then 'ПАСПОРТ'
      when upper(t.c_name) like '%П1%'                        then 'ПАСПОРТ'
      when upper(t.c_name) like '%П2%'                        then 'ПАСПОРТ'
      when upper(t.c_name) like '%ВИД%ЖИТ%'                   then 'ВИД НА ЖИТЕЛЬСТВО'
      when upper(t.c_name) like '%DEP_CL_NEREZ%'              then 'МИГРАЦИОНКА' --миграционка
      when upper(t.c_name) like '%VODIT_UDOST%'               then 'ВОДИТ.УДОСТ.' --сводит. удостоверение
      when upper(t.c_name) like '%PASP_AVTO%'                 then 'ТЕХПАСПОРТ' --тех.паспорт
      when upper(t.c_name) like '%РНН%'                       then 'РНН'
      when upper(t.c_name) like '%СВ%РОЖД%'                   then 'СВИД.РОЖДЕНИЯ'  --свидетельство рождения
      when upper(t.c_name)  like '%БРАК%'                     then 'СВИД. О БРАКЕ' --св-во о браке
      when upper(t.c_name) like '%КП%'                        then 'ПОДПИСИ'
      when upper(t.c_name) like '%DEP_TRUSTEE_OP%'            then 'ПОДПИСИ'
      when upper(t.c_name) like '%ОП%'                        then 'ПОДПИСИ'
      when upper(t.c_name) like '%ДБЗ%'                       then 'ПОДПИСИ'
      when upper(t.c_name) like '%FORM_CLIENT%'               then 'ПОДПИСИ'
      when upper(t.c_name) like '%ANKETA%'                    then 'ПОДПИСИ'
      when upper(t.c_name) like '%ПК%'                        then 'ПОДПИСИ'
      when upper(t.c_name) like '%EDIT_CL_PRIV%'              then 'ПОДПИСИ'
      when upper(t.c_name) like '%ОБР_ПОД%'                   then 'ПОДПИСИ'
      when upper(t.c_name) like upper('%подпис%')             then 'ПОДПИСИ'
      when upper(t.c_name) like upper('%док с обр. подп.%')   then 'ПОДПИСИ'
      when upper(t.c_name) like '%999_DEP_CL_OP%'             then 'ПОДПИСИ'
      when upper(t.c_name) like '%RE_ISSUE_PC%'               then 'ПОДПИСИ'
      when upper(t.c_name) like '%О П%'                       then 'ПОДПИСИ'
      when upper(t.c_name) like '%01_SVED%'                   then 'ПОДПИСИ'
      when upper(t.c_name) like '%PERSONAL_USLOVIYA%'         then 'ПОДПИСИ'
      when upper(t.c_name) like '%SOGLASIE_FOTO%'             then 'ПОДПИСИ'
      when upper(t.c_name) like '%PERSON_USLOVIYA%'           then 'ПОДПИСИ'
      when upper(t.c_name) like upper('%Образец%')            then 'ПОДПИСИ'
      when upper(t.c_name) like '%RASHODNIK_CREDIT%'          then 'ПОДПИСИ'
      when upper(t.c_name) like '%МИГР%'                      then 'СВИД.РЕГИСТРАЦИИ'
      when upper(t.c_name) like '%СПРАВКА%'                   then 'СПРАВКА'
      when upper(t.c_name) like '%СПР%'                       then 'СПРАВКА'
      when upper(t.c_name) like '%СП С ОК%'                   then 'СПРАВКА'
      when upper(t.c_name) like '%САБ%'                       then 'СПРАВКА'
      when upper(t.c_name) like '%ESTIMATE%'                  then 'ОЦЕНКА НЕДВИЖИМОСТИ' --оценка недвижимости
      when upper(t.c_name) like '%СОГЛАСИЕ НА КБ%'            then 'СОГЛАСИЕ НА ЗАПРОС В ПКБ'  --согласие на ПКБ
      when upper(t.c_name) like '%КБ%'                        then 'ОТЧЕТ ПКБ'  --отчет ПКБ
      when upper(t.c_name) like '%ГЦВП%'                      then 'ОТЧЕТ ГЦВП'  --отчет ГЦВП
      when upper(t.c_name) like '%ДК%'                        then 'ДОМОВАЯ КНИГА'  --домовая книга
      when upper(t.c_name) like '%DOM_KNIGA%'                 then 'ДОМОВАЯ КНИГА'  --домовая книга
      when upper(t.c_name) like '%ДОМОВАЯ%'                   then 'ДОМОВАЯ КНИГА'  --домовая книга
      when upper(t.c_name) like upper('%дом%')                then 'ДОМОВАЯ КНИГА'  --домовая книга
      when upper(t.c_name) like '%DOV%'                       then 'ДОВЕРЕННОСТЬ'  --доверенность
      when upper(t.c_name) like '%ДОВ%'                       then 'ДОВЕРЕННОСТЬ'  --доверенность
      when upper(t.c_name) like '%SVEDENIYA_KLIENT%'          then 'СВЕДЕНЬЯ О КЛИЕНТЕ'  --сведенья о клиенте
      when upper(t.c_name) like '%АНКЕТ%'                     then 'АНКЕТА'  --анкета
      when upper(t.c_name) like '%ЗАЯВЛ%'                     then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%ПФ%'                        then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like upper('%отказ%')              then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%FOTO_AUTO%'                 then 'ФОТО АВТОМОБИЛЯ'
      when upper(t.c_name) like '%SVID_ZALOG%'                then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%NO_JUDJE_SALE%'             then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%DOG_DEPOZIT%'               then 'ДЕПОЗИТНЫЙ ДОГОВОР'
      when upper(t.c_name) like '%СИК%'                       then 'СИК'
      when upper(t.c_name) like '%КЛ%'                        then 'ФОТО КЛИЕНТА'
      when upper(t.c_name) like '%DOC_UD_INVALID%'            then 'ИНВАЛИДНОСТЬ'
      when upper(t.c_name) like '%UDL%'                       then 'УДОС.ЛИЧНОСТИ'
      when upper(t.c_name) like '%UD_L%'                      then 'УДОС.ЛИЧНОСТИ'
      when upper(t.c_name) like '%TRUD_DOG%'                  then 'ТРУД.ДОГОВОР'
      when upper(t.c_name) like '%VIPISKA_PF%'                then 'ВЫПИСКИ'
      when upper(t.c_name) like '%МОШЕННИ%'                   then 'ФОТО МОШЕННИКА'
      when upper(t.c_name) like '%МОШЕНИ%'                    then 'ФОТО МОШЕННИКА'
      when upper(t.c_name) like '%SVID_IP%'                   then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%SPRAVKA_OK%'                then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%CANCEL_PC%'                 then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%RAPAYMENT%'                 then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like upper('%согласие%')           then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%DBU_TEMP_CARD%'             then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%DRUGOE%'                    then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%ZAYAVKA_NEW%'               then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%DOGOVOR%'                   then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%ZAYVLENIE%'                 then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%DBZ_COM_CREDIT%'            then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%DOP_SOGL_DEP%'              then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%SPRAVKA_OTSUTST_ZADOLZH%'   then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%SVIDVO_TC%'                 then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%ZAYAVL%'                    then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%RESH_KE%'                   then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%FOTO_ADD_ZAL%'              then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%UVEDOMLENIE_ACCEPT_GU%'     then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%CREDIT_DOC%'                then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%DOG_ZALOG_AUTO%'            then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%BC1_CHANGE_COND_ZAYAV%'     then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%SOGLASIE_PKB%'              then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%DEP_ATTY_NEREZ_IIN%'        then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%AUTO_TRINITY_DOG%'          then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%ZAVERENIYA_GARANTIYA%'      then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%TEX_RASSP%'                 then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%POYASNENIYA_USLOVIYA%'      then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%SPRAVKA_ZP%'                then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%DOG_ARENDA%'                then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%DEFECT_ACT%'                then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%ACCEPT2_CRD%'               then 'ДРУГИЕ ДОКУМЕНТЫ'
      when upper(t.c_name) like '%ОБ%ПОД%'                    then 'ПОДПИСИ'
      when
        upper(substr(trim(c_name),length(trim(c_name))-5,length(trim(c_name)))) in
        (
          'АНОВНА','АНОВИЧ','ЛЬЕВНА','ИРОВНА','ЛАЕВНА','БАЕВНА','ЕКОВНА','ДРОВНА','ОРОВНА','РЬЕВНА','ЕКОВИЧ','БАЕВИЧ','АТОВНА','ИРОВИЧ','ЛЬЕВИЧ','АТОВИЧ','ДРОВИЧ','ЛАЕВИЧ','ГЕЕВНА'
          ,'ЕНОВНА','ЙЛОВНА','ЛИЕВНА','ИНОВНА','ОРОВИЧ','ТРОВНА','РЬЕВИЧ','АРОВНА','СЕЕВНА','ЛИЕВИЧ','ЕНОВИЧ','ИМОВНА','ИНОВИЧ','ГЕЕВИЧ','ЕТОВНА','АРОВИЧ','ИСОВНА','ИКОВНА','ЙЛОВИЧ'
          ,'ТАЕВНА','ВЛОВНА','ДЬЕВНА','РЕЕВНА','РИЕВНА','ИМОВИЧ','ЕТОВИЧ','ТРОВИЧ','ИКОВИЧ','СЕЕВИЧ','НЬЕВНА','ТАЕВИЧ','АВОВНА','ИТОВНА','ИСОВИЧ','ДЬЕВИЧ','ЫКОВНА','ДИЕВНА','РЕЕВИЧ'
          ,'ИЛОВНА','ВЛОВИЧ','ИТОВИЧ','ГИЕВНА','АСОВНА','РИЕВИЧ','АЙ?ЫЗЫ','АН?ЫЗЫ','ВЛЕВНА','НЬЕВИЧ','АВОВИЧ','ОНОВНА','ЕГОВНА','ИНИЧНА','ЕК?ЫЗЫ','ЫКОВИЧ','АКОВНА','ИЛОВИЧ','ДИЕВИЧ'
          ,'БЕКОВА','ОРЕВНА','АШЕВНА','АМОВНА','АСОВИЧ','ЫНОВНА','ЯНОВНА','БЕК?ЛЫ','ОНОВИЧ','БАЙ?ЛЫ','ЕГОВИЧ','АЛИЕВА','ТЬЕВНА','ЫМОВНА','АЛОВНА','АКОВИЧ','ГИЕВИЧ','АТ?ЫЗЫ','ОЛОВНА'
          ,'ОРЕВИЧ','АТЬЯНА','ЕСОВНА','ЫРОВНА','ЫНОВИЧ','РЕННЫЙ','АНКЫЗЫ','ЕТЛАНА','АШЕВИЧ','АМОВИЧ','АЙКЫЗЫ','ИПОВНА','ИФОВНА','УРОВНА','УТОВНА','ЕККЫЗЫ','ВЛЕВИЧ','АТАЛЬЯ','ЖАНОВА'
          ,' ЕЛЕНА','ЗИЕВНА','ОЛОВИЧ','ЗЫЕВНА','ФЕЕВНА','РТОЧКА','АЛОВИЧ','НБАЕВА','УНОВНА','ХАНОВА','РТОВНА','ЫМОВИЧ','САЕВНА','МБАЕВА','ЕРОВНА','ДЫЕВНА','ИПОВИЧ','ЛЬСТВО','ЕСОВИЧ'
          ,'УТОВИЧ','ЯРОВНА','ЫЛОВНА','ЫРОВИЧ','ЫШЕВНА','АЗОВНА','ЕШОВНА','МАНОВА','ИЗОВНА','АПОВИЧ',' ОЛЬГА','ЮДМИЛА','АПОВНА','АШОВНА','ГАЛИНА','ЕН?ЫЗЫ','УРОВИЧ','ЗАЕВНА','ЯРОВИЧ'
          ,'КСАНДР','ЯНОВИЧ','СЬЕВНА','АШОВИЧ','ЛИ?ЫЗЫ','БЕТОВА','ТЬЕВИЧ','ЕЛОВНА','ЫТОВНА','МЕТОВА','АТКЫЗЫ','АР?ЫЗЫ','ЕРОВИЧ','ПАЕВНА','СЕРГЕЙ','ЛТАНАТ',' ЖАНАР','ХАН?ЛЫ','РТОВИЧ'
          ,'ЛЬМИРА','ЯТОВНА','ЛЛОВНА',' ИЛЬИЧ','САЕВИЧ'
        )
      then 'ФОТО КЛИЕНТА 2'
      when  upper(t.c_name) like '%УД%'                       then 'УДОС.ЛИЧНОСТИ'
      when  upper(t.c_name) like '%УЛ%'                       then 'УДОС.ЛИЧНОСТИ'

      when upper(t.c_name) like '%СМЕРТ%'                     then 'СВ-ВО О СМЕРТИ'
      when upper(t.c_name)=lower(t.c_name) or t.c_name is null then 'ИДЕНТИФИЦИРОВАТЬ ГРУППУ НЕТ ВОЗМОЖНОСТИ'
      --when upper(substr(c_name,1,9))=lower(substr(c_name,1,9)) then 'ИДЕНТИФИЦИРОВАТЬ ГРУППУ НЕТ ВОЗМОЖНОСТИ'

      else upper('нужен доп.анализ изображений')
    end as photo_type
    ,t.c_name
from U1.V_RFO_Z#IMAGES t
;
grant select on U1.V_RFO_IMAGES_BY_TYPE to LOADDB;
grant select on U1.V_RFO_IMAGES_BY_TYPE to RISK_ALEXEY;
grant select on U1.V_RFO_IMAGES_BY_TYPE to RISK_ALEXEY2;


