create or replace force view u1.v_rej_score_knp_bw_22_1 as
select contract_number,
       SCR_AGE_FULL_YEARS_GENDER + SCR_AMOUNT_RISE_PERC + SCR_CHILDREN + SCR_CLIENT_PATRONYMIC_TYPE + SCR_CLI_AGE_BA_ON_FLD_MON_FL + SCR_CLI_AGE_BASING_ON_CON + SCR_CONTRACT_AMOUNT + SCR_CONTRACT_TERM_MONTHS +
       SCR_DEPENDANTS_COUNT + SCR_EDUCATION + SCR_FACT_ADDRESS_REGION + SCR_IS_AUTO_EXISTS + SCR_KDN_PMT_NOM__TO_GCVP_SAL + SCR_MARITAL_STATUS + SCR_ORG_SECTOR + SCR_PAID_SAL_COUNT + SCR_PKB_CLOSED_CONTRACTS +
       SCR_PMT_NOM_RATE + SCR_PMT_RISE_PERC + SCR_REAL_ESTATE_RELATION + SCR_START_NUM_OF_CON_BY_CLI + SCR_WORK_EXPR_LAST_PLACE_MON_F + SCR_X_DNP_NAME
       as SCORE_POINTS
from (select t.contract_number,

   case
      when AGE_FULL_YEARS_GENDER< -31  then 9
      when (AGE_FULL_YEARS_GENDER>=-31 and AGE_FULL_YEARS_GENDER< 26) or AGE_FULL_YEARS_GENDER is null then -2
      when AGE_FULL_YEARS_GENDER>=26 and AGE_FULL_YEARS_GENDER< 33  then 5
      when AGE_FULL_YEARS_GENDER>=33 and AGE_FULL_YEARS_GENDER< 46  then 12
      when AGE_FULL_YEARS_GENDER>=46  then 16 end SCR_AGE_FULL_YEARS_GENDER,

   case
      when AMOUNT_RISE_PERC< 147  then 5
      when 147<= AMOUNT_RISE_PERC and AMOUNT_RISE_PERC< 210  then 6
      when 210<= AMOUNT_RISE_PERC and AMOUNT_RISE_PERC< 366  then 6
      when 366<= AMOUNT_RISE_PERC  then 6
      when AMOUNT_RISE_PERC is null then 6 end SCR_AMOUNT_RISE_PERC,

   case
      when CHILDREN = 'НЕТ'or CHILDREN is null then 5
      when CHILDREN = '1' then 6
      when CHILDREN in ('4', '5 И БОЛЕЕ' ) then 7
      when CHILDREN = '2' then 7
      when CHILDREN = '3' then 7
      else 5 end SCR_CHILDREN,

   case
      when CLIENT_PATRONYMIC_TYPE in ('ЗЫ', 'ИЧ', 'ЛЫ' ) then 4
      when CLIENT_PATRONYMIC_TYPE = 'НА' then 7
      when CLIENT_PATRONYMIC_TYPE in ('ВА', 'ЕД', 'ИН', 'ИР', 'КИ', 'ЛИ') or CLIENT_PATRONYMIC_TYPE is null then 6
      else 6 end SCR_CLIENT_PATRONYMIC_TYPE,

   case
      when CLI_AGE_BASED_ON_FLD_MON_FL< 5  then 10
      when 5<= CLI_AGE_BASED_ON_FLD_MON_FL and CLI_AGE_BASED_ON_FLD_MON_FL< 12  then 7
      when 12<= CLI_AGE_BASED_ON_FLD_MON_FL and CLI_AGE_BASED_ON_FLD_MON_FL< 23  then 6
      when (23<= CLI_AGE_BASED_ON_FLD_MON_FL and CLI_AGE_BASED_ON_FLD_MON_FL< 50) or CLI_AGE_BASED_ON_FLD_MON_FL is null then 4
      when 50<= CLI_AGE_BASED_ON_FLD_MON_FL  then 3 end SCR_CLI_AGE_BA_ON_FLD_MON_FL,

   case
      when CLI_AGE_BASING_ON_CON< 184  then -8
      when 184<= CLI_AGE_BASING_ON_CON and CLI_AGE_BASING_ON_CON< 364  then 1
      when (364<= CLI_AGE_BASING_ON_CON and CLI_AGE_BASING_ON_CON< 760) or CLI_AGE_BASING_ON_CON is null then 8
      when 760<= CLI_AGE_BASING_ON_CON and CLI_AGE_BASING_ON_CON< 1414  then 15
      when 1414<= CLI_AGE_BASING_ON_CON  then 22 end SCR_CLI_AGE_BASING_ON_CON,

   case
      when CONTRACT_AMOUNT< 220000  then 7
      when 220000<= CONTRACT_AMOUNT and CONTRACT_AMOUNT< 296875  then 6
      when 296875<= CONTRACT_AMOUNT and CONTRACT_AMOUNT< 330000  then 7
      when 330000<= CONTRACT_AMOUNT and CONTRACT_AMOUNT< 556250  then 6
      when 556250<= CONTRACT_AMOUNT or CONTRACT_AMOUNT is null then 5 end SCR_CONTRACT_AMOUNT,

   case
      when CONTRACT_TERM_MONTHS< 18  then 33
      when 18<= CONTRACT_TERM_MONTHS and CONTRACT_TERM_MONTHS< 24  then 18
      when 24<= CONTRACT_TERM_MONTHS and CONTRACT_TERM_MONTHS< 36 or CONTRACT_TERM_MONTHS is null then 5
      when 36<= CONTRACT_TERM_MONTHS and CONTRACT_TERM_MONTHS< 48  then -4
      when 48<= CONTRACT_TERM_MONTHS  then -14 end SCR_CONTRACT_TERM_MONTHS,

   case
      when DEPENDANTS_COUNT = 'НЕТ' or DEPENDANTS_COUNT is null then 5
      when DEPENDANTS_COUNT = '1' then 6
      when DEPENDANTS_COUNT in ('2', '3', '4', '5 И БОЛЕЕ' ) then 7
      else 5 end SCR_DEPENDANTS_COUNT,

   case
      when EDUCATION in ('НЕПОЛНОЕ ВЫСШЕЕ', 'НЕПОЛНОЕ СРЕДНЕЕ', 'СРЕДНЕЕ' ) then 0
      when EDUCATION in ('СРЕДНЕЕ-СПЕЦИАЛЬНОЕ' ) then 5
      when EDUCATION in ('ВЫСШЕЕ', 'НЕСКОЛЬКО ВЫСШИХ', 'УЧЕНАЯ СТЕПЕНЬ') or EDUCATION is null then 14
      else 14 end SCR_EDUCATION,

   case
      when FACT_ADDRESS_REGION in ('АКТЮБИНСКАЯ', 'АСТАНА', 'КЫЗЫЛОРДИНСКАЯ' ) then 5
      when FACT_ADDRESS_REGION in ('АЛМАТИНСКАЯ', 'АЛМАТЫ', 'ВОСТОЧНО-КАЗАХСТАНСКАЯ' ) then 5
      when FACT_ADDRESS_REGION in ('АКМОЛИНСКАЯ', 'ЖАМБЫЛСКАЯ', 'КАРАГАНДИНСКАЯ', 'КОСТАНАЙСКАЯ', 'ПАВЛОДАРСКАЯ') or FACT_ADDRESS_REGION is null then 6
      when FACT_ADDRESS_REGION in ('АТЫРАУСКАЯ', 'ЗАПАДНО-КАЗАХСТАНСКАЯ', 'СЕВЕРО-КАЗАХСТАНСКАЯ', 'ЮЖНО-КАЗАХСТАНСКАЯ' ) then 7
      when FACT_ADDRESS_REGION in ('МАНГИСТАУСКАЯ' ) then 9
      else 6 end SCR_FACT_ADDRESS_REGION,

   case
      when IS_AUTO_EXISTS in ('ВЗЯТЫЙ В АРЕНДУ', 'ЕСТЬ (В КРЕДИТ)', 'НЕТ', 'СЛУЖЕБНЫЙ') or IS_AUTO_EXISTS is null then 4
      when IS_AUTO_EXISTS in ('ЕСТЬ (СОБСТВЕННЫЙ)' ) then 14
      when IS_AUTO_EXISTS in ('ЕСТЬ У СУПРУГИ(-А)' ) then 20
      else 4 end SCR_IS_AUTO_EXISTS,

   case
      when KDN_PMT_NOM_RATE_TO_GCVP_SAL is null then -4
      when KDN_PMT_NOM_RATE_TO_GCVP_SAL< 17  then 13
      when 17<= KDN_PMT_NOM_RATE_TO_GCVP_SAL and KDN_PMT_NOM_RATE_TO_GCVP_SAL< 27  then 8
      when 27<= KDN_PMT_NOM_RATE_TO_GCVP_SAL and KDN_PMT_NOM_RATE_TO_GCVP_SAL< 38  then 6
      when 38<= KDN_PMT_NOM_RATE_TO_GCVP_SAL  then 3 end SCR_KDN_PMT_NOM__TO_GCVP_SAL,

   case
      when MARITAL_STATUS in ('НИКОГДА В БРАКЕ НЕ СОСТОЯЛ(А)' ) then 3
      when MARITAL_STATUS in ('ГРАЖДАНСКИЙ БРАК/СОВМЕСТНОЕ ПРОЖИВАНИЕ', 'РАЗВЕДЕН/РАЗВЕДЕНА' ) then 6
      when MARITAL_STATUS in ('ВДОВЕЦ/ВДОВА', 'ЖЕНАТ/ЗАМУЖЕМ' ) or MARITAL_STATUS is null then 7
      else 7 end SCR_MARITAL_STATUS,

   case
      when ORG_SECTOR in ('СЕРВИС/РЕСТОРАНЫ/ГОСТИНИЦЫ/РАЗВЛЕЧЕНИЯ', 'СТРОИТЕЛЬСТВО/СТРОЙМАТЕРИАЛЫ', 'ТОРГОВЛЯ ОПТОВАЯ' ) then 3
      when ORG_SECTOR in ('НОТАРИАТ/ЮРИДИЧЕСКИЕ УСЛУГИ/ОХРАНА', 'ПРОЧЕЕ', 'РИЭЛТОР', 'СЕЛЬСКОЕ ХОЗЯЙСТВО', 'СМИ/ПИАР/РЕКЛАМА/ИЗДАТЕЛЬСТВО' ) then 5
      when ORG_SECTOR in ('ЛЕГКАЯ И ПИЩЕВАЯ ПРОМЫШЛЕННОСТЬ', 'ТОРГОВЛЯ РОЗНИЧНАЯ', 'ЭНЕРГЕТИКА' ) then 5
      when ORG_SECTOR in ('АРМИЯ/МИЛИЦИЯ/БЕЗОПАСНОСТЬ/ТАМОЖНЯ', 'КОММУНАЛЬНОЕ ХОЗЯЙСТВО/ДОРОЖНЫЕ СЛУЖБЫ', 'ПРОЧАЯ ПРОМЫШЛЕННОСТЬ' ) then 6
      when ORG_SECTOR in ('БАНКИ/СТРАХОВАНИЕ', 'ГОСУДАРСТВЕННОЕ/МУНИЦИПАЛЬНОЕ УПРАВЛЕНИЕ', 'ДОБЫВАЮЩАЯ ПРОМЫШЛЕННОСТЬ', 'ИНФОРМАТИКА/ТЕЛЕКОММУНИКАЦИИ', 'МЕДИЦИНА', 'НАУКА/КУЛЬТУРА/ИССКУСТВО', 'ОБРАЗОВАНИЕ', 'ТРАНСПОРТ И СВЯЗЬ' ) or ORG_SECTOR is null then 7
      else 7 end SCR_ORG_SECTOR,

   case
      when PAID_SAL_COUNT is null  then -1
      when PAID_SAL_COUNT< 3  then 3
      when 3<= PAID_SAL_COUNT and PAID_SAL_COUNT< 5  then 5
      when 5<= PAID_SAL_COUNT and PAID_SAL_COUNT< 8  then 7
      when 8<= PAID_SAL_COUNT  then 10 end SCR_PAID_SAL_COUNT,

   case
      when PKB_CLOSED_CONTRACTS is null  then 6
      when PKB_CLOSED_CONTRACTS< 1  then 8
      when 1<= PKB_CLOSED_CONTRACTS and PKB_CLOSED_CONTRACTS< 3  then 6
      when 3<= PKB_CLOSED_CONTRACTS and PKB_CLOSED_CONTRACTS< 6  then 5
      when 6<= PKB_CLOSED_CONTRACTS  then 4 end SCR_PKB_CLOSED_CONTRACTS,

   case
      when PMT_NOM_RATE is null  then 16
      when PMT_NOM_RATE< 19052  then 4
      when 19052<= PMT_NOM_RATE and PMT_NOM_RATE< 19593  then 14
      when 19593<= PMT_NOM_RATE and PMT_NOM_RATE< 22634.5  then 4
      when 22634.5<= PMT_NOM_RATE  then 7 end SCR_PMT_NOM_RATE,

   case
      when PMT_RISE_PERC is null  then 14
      when PMT_RISE_PERC< 121  then 6
      when 121<= PMT_RISE_PERC and PMT_RISE_PERC< 179  then 5
      when 179<= PMT_RISE_PERC and PMT_RISE_PERC< 248.5  then 3
      when 248.5<= PMT_RISE_PERC  then 0 end SCR_PMT_RISE_PERC,

   case
      when REAL_ESTATE_RELATION in ('АРЕНДОВАННОЕ', 'ЖИЛИЩЕ РОДИТЕЛЕЙ' ) then 3
      when REAL_ESTATE_RELATION in ('ВЕДОМСТВЕННОЕ', 'ДРУГОЕ' ) then 4
      when REAL_ESTATE_RELATION in ('КУПЛЕННОЕ В КРЕДИТ', 'НЕПРИВАТИЗИРОВАННОЕ', 'СОБСТВЕННОЕ') or REAL_ESTATE_RELATION is null then 9
      else 9 end SCR_REAL_ESTATE_RELATION,

   case
      when START_NUM_OF_CON_BY_CLI< 2  then 1
      when (2<= START_NUM_OF_CON_BY_CLI and START_NUM_OF_CON_BY_CLI< 3) or START_NUM_OF_CON_BY_CLI is null  then 5
      when 3<= START_NUM_OF_CON_BY_CLI and START_NUM_OF_CON_BY_CLI< 4  then 8
      when 4<= START_NUM_OF_CON_BY_CLI and START_NUM_OF_CON_BY_CLI< 5  then 10
      when 5<= START_NUM_OF_CON_BY_CLI  then 12 end SCR_START_NUM_OF_CON_BY_CLI,

   case
      when WORK_EXPR_LAST_PLACE_MON_FLOOR< 22  then -1
      when (22<= WORK_EXPR_LAST_PLACE_MON_FLOOR and WORK_EXPR_LAST_PLACE_MON_FLOOR< 49) or WORK_EXPR_LAST_PLACE_MON_FLOOR is null then 4
      when 49<= WORK_EXPR_LAST_PLACE_MON_FLOOR and WORK_EXPR_LAST_PLACE_MON_FLOOR< 83  then 8
      when 83<= WORK_EXPR_LAST_PLACE_MON_FLOOR and WORK_EXPR_LAST_PLACE_MON_FLOOR< 142  then 13
      when 142<= WORK_EXPR_LAST_PLACE_MON_FLOOR  then 17 end SCR_WORK_EXPR_LAST_PLACE_MON_F,

   case
      when X_DNP_NAME in ('АКТАУ', 'КУЛЬСАРЫ' ) then 17
      when X_DNP_NAME in ('АТЫРАУ', 'ЖЕЗКАЗГАН', 'ПЕТРОПАВЛОВСК', 'САТПАЕВ', 'СЕМЕЙ', 'ТЕМИРТАУ', 'УРАЛЬСК', 'ШЫМКЕНТ' ) then 10
      when X_DNP_NAME in ('КОКШЕТАУ', 'КОРДАЙ', 'КОСТАНАЙ', 'ТАРАЗ', 'ЭКИБАСТУЗ' ) then 7
      when X_DNP_NAME in ('КАРАГАНДА', 'ПАВЛОДАР', 'РУДНЫЙ', 'ТАЛГАР' ) then 5
      when X_DNP_NAME in ('АКТОБЕ', 'АЛМАТЫ', 'АСТАНА', 'КАСКЕЛЕН', 'КЫЗЫЛОРДА', 'ТАЛДЫКОРГАН', 'УСТЬ-КАМЕНОГОРСК') or X_DNP_NAME is null then 2
      else 2 end SCR_X_DNP_NAME

from (select a.*, case when a.SEX = 'М' then a.AGE_FULL_YEARS*(-1) else a.AGE_FULL_YEARS end AGE_FULL_YEARS_GENDER from m_folder_con_miner a
     where a.cr_program_name = 'КРЕДИТ НАЛИЧНЫМИ ПОВТОРНИКУ') t);
grant select on U1.V_REJ_SCORE_KNP_BW_22_1 to LOADDB;
grant select on U1.V_REJ_SCORE_KNP_BW_22_1 to LOADER;


