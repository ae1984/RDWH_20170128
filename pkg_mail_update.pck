create or replace package u1.PKG_MAIL_UPDATE is

  -- Author  : NAZIROV_19076
  -- Created : 19.05.2015 15:12:10
  -- Purpose : 

  -- Отправка письма по завершению обновления MV                     
  procedure add_mail_aft_upd;
  
  /*Отправка данных по M_PKB_SEND_MON*/
  procedure pkb_mon_send;

  /*Отправка данных по V_OUT_ZALOG_ESTIMATE  - Передача залога на оценку*/
  procedure p_zalog_estim_send;
  
  /*Отправка данных по V_OUT_CONTRACT_AUTO  - Выданные кредита АВТО*/
  procedure p_contract_auto;
  
  /*Отправка ежемесячного отчета по мошенническим операциям */
  procedure p_out_report_fraud;
   
  /*Отправка отчета по ЛСБОО */
  procedure p_black_lisk;
  
   /*Отправка письма с результатами проверки инкрементальной загрузки */  
  procedure p_inc_chk;
  
end PKG_MAIL_UPDATE;
/

create or replace package body u1.PKG_MAIL_UPDATE is

  EMAIL_CODE_BL constant varchar2(32) := 'RFO_BLACK_LIST_APP';
  EMAIL_CODE_PKB_MON constant varchar2(32) := 'RDWH_PKB_MON';  
  EMAIL_CODE_INC_CHK constant varchar2(32) := 'RDWH_INC_TABLE_CHK';  
  
  
 -- Отправка письма по завершению обновления MV
  procedure add_mail_aft_upd is
    V_MV_READY      number;
    V_EMAIL_BODY    varchar2(2560);
    --V_EMAIL_CODE    varchar2(256);
    V_EMAIL_SUBJECT varchar2(256);
    V_EMAIL_SEND    number;
    ------------------------------
    v_rfo_bl_app_lsboo     number;
    v_rfo_bl_app_lsboo_all number;
    v_rfo_lsboo_contr_new  number;
    v_rfo_bl_app_lsboo_new number;
    --
    v_rfo_bl_app_terror    number;
    v_rfo_bl_app_terror_all number;
    v_rfo_terr_contr_new    number;
    v_rfo_bl_app_terror_new number;
    v_offer_a7_all          number;
    v_offer_a7              number;
    --
    v_rfo_overdraft          number;
    v_rfo_overdraft_all      number; -- кол-во клиентов-ЛСБОО выщедщих в овердрафт
    v_ovrd_lsboo_new         number;
    v_ovrd_over_new          number;
    v_offer_lsboo_all        number;
    v_offer_lsboo            number;
    --
    --
    v_rfo_a7          number;
    v_rfo_a7_all      number; -- кол-во клиентов-a7 выщедщих в овердрафт
    v_a7_lsboo_new    number;
    v_a7_over_new     number;
    --V_LSBOO_EARL_CRED   number; -- кол-во клиентов с просроченными кредитами, которые после выдачи стали ЛСБОО
  begin
    --------------------------------------------------------------- 
    /*----M_RFO_BLACK_LIST_APPROV  Количество выданных кредитов ЛСБОО
    select count(*)
      into V_EMAIL_SEND
      from email_log l
     where l.email_code = EMAIL_CODE_BL
       and trunc(date_start) = trunc(sysdate);
  
    if V_EMAIL_SEND = 0 then 
   
       selecT count(1)
       into V_MV_READY
       from v_mviews_ready
       where MVIEW_NAME in ( 'M_RFO_BLACK_LIST_APPROV', 'M_OVERDRAFT_ANALYSIS')
         and update_status = 'OK';    
    
      if V_MV_READY = 2 then
        --
        --select count(1) into V_RFO_BL_APP_LSBOO from M_RFO_BLACK_LIST_APPROV where type_list = 'LSBOO';
        select count(distinct contract_number),
               count(distinct case when trunc(folder_date_create_mi) = trunc(sysdate) - 1 then contract_number end),
               count(distinct case when trunc(date_add) = trunc(sysdate) - 1    then rfo_client_id end),
               count(distinct case when folder_date_create_mi >= date_add then contract_number end),
               count(distinct case when cnt_spec_offer > 0 then contract_number end),
               count(distinct case when is_spec_offer_last = 1 then contract_number end)
          into v_rfo_bl_app_lsboo_all, v_rfo_lsboo_contr_new, v_rfo_bl_app_lsboo_new, v_rfo_bl_app_lsboo,
               v_offer_lsboo_all, v_offer_lsboo      
          from M_RFO_BLACK_LIST_APPROV
         where is_credit_active = 1 
           and type_list = 'LSBOO';
        --select count(1) into V_RFO_BL_APP_TERROR from M_RFO_BLACK_LIST_APPROV where type_list = 'TERRORIST';
        select count(distinct contract_number),
               count(distinct case when trunc(folder_date_create_mi) = trunc(sysdate) - 1 then contract_number end),
               count(distinct case when trunc(date_add) = trunc(sysdate) - 1    then rfo_client_id end),
               count(distinct case when folder_date_create_mi >= date_add then contract_number end),
               count(distinct case when cnt_spec_offer > 0 then contract_number end),
               count(distinct case when is_spec_offer_last = 1 then contract_number end)
          into v_rfo_bl_app_terror_all, v_rfo_terr_contr_new, v_rfo_bl_app_terror_new, v_rfo_bl_app_terror,
               v_offer_a7_all, v_offer_a7
          from M_RFO_BLACK_LIST_APPROV
         where is_credit_active = 1 
           and type_list = 'TERRORIST';
        --
        select count(distinct contract_number) as  v_rfo_overdraft,
               count(distinct case when trunc(date_add_bl) = trunc(sysdate) - 1 then contract_number end) as v_ovrd_lsboo_new,
               count(distinct case when rep_date_over = trunc(sysdate) - 1 then rfo_client_id end) as v_ovrd_over_new,
               count(distinct case when rep_date_over >= date_add_bl - 1 then contract_number end)
          into v_rfo_overdraft_all, v_ovrd_lsboo_new,  v_ovrd_over_new, v_rfo_overdraft
          from M_OVERDRAFT_ANALYSIS 
         where in_lsboo = 1 
           and rep_date = trunc(sysdate)-1;
        --
        select count(distinct contract_number),
               count(distinct case when trunc(date_add_bl) = trunc(sysdate) - 1 then contract_number end),
               count(distinct case when rep_date_over = trunc(sysdate) - 1 then rfo_client_id end),
               count(distinct case when rep_date_over >= date_add_bl - 1 then contract_number end)
          into v_rfo_a7_all, v_a7_lsboo_new,  v_a7_over_new, v_rfo_a7
          from M_OVERDRAFT_ANALYSIS 
         where in_terror = 1 
           and rep_date = trunc(sysdate)-1;   
        --   
              
        --
        V_EMAIL_BODY    := --'ТЕСТИРОВАНИЕ' || chr(10) || chr(10) ||
                           'Добрый день!' || chr(10) || chr(10) ||
                           'Отчет за: ' || to_char(sysdate-1,'dd.mm.yyyy') || chr(10) || chr(10) ||
                           --
                           'Действующие кредитные договора по клиентам "ЛСБОО":' || chr(10) || chr(13) ||                           
                           chr (9) || '1. Выданные кредиты в отчетную дату - '|| v_rfo_lsboo_contr_new || chr(10) || chr(13) ||
                           chr (9) || '2. Клиенты, добавленные в категорию - '|| v_rfo_bl_app_lsboo_new || chr(10) || chr(13) ||
                           chr (9) || '3. Всего кредитов - '|| v_rfo_bl_app_lsboo_all || chr(10) || chr(13) ||
                           chr (9) || chr (9) || 'в том числе выданные кредиты после занесения клиента в категорию - '|| v_rfo_bl_app_lsboo || chr(10) || chr(13) ||
                           chr (9) || '4. Всего кредитов, по которым исполнены спец.предложения - '|| v_offer_lsboo_all || chr(10) || chr(13) ||
                           chr (9) || '5. Кредиты, по которым исполнены спец.предложения в отчетную дату - '|| v_offer_lsboo || chr(10) || chr(10) ||
                           --
                           'Действующие кредитные договора по клиентам "A7":' || chr(10) || chr(13) ||                           
                           chr (9) || '1. Выданные кредиты в отчетную дату - '|| v_rfo_terr_contr_new || chr(10) || chr(13) ||
                           chr (9) || '2. Клиенты, добавленные в категорию - '|| v_rfo_bl_app_terror_new || chr(10) || chr(13) ||
                           chr (9) || '3. Всего кредитов - '|| v_rfo_bl_app_terror_all || chr(10) || chr(13) ||
                           chr (9) || chr (9) || 'в том числе выданные кредиты после занесения клиента в категорию - '|| v_rfo_bl_app_terror || chr(10) || chr(13) ||
                           chr (9) || '4. Всего кредитов, по которым исполнены спец.предложения - '|| v_offer_a7_all || chr(10) || chr(13) ||
                           chr (9) || '5. Кредиты, по которым исполнены спец.предложения в отчетную дату - '|| v_offer_a7 || chr(10) || chr(10) ||
                           --
                           'Клиенты "ЛСБОО",имеющие задолженность по овердрафту :' || chr(10) || chr(13) ||                           
                           chr (9) || '1. Возникновение овердрафта в отчетную дату - '|| v_ovrd_over_new || chr(10) || chr(13) ||
                           chr (9) || '2. Клиенты, добавленные в категорию - '|| v_ovrd_lsboo_new || chr(10) || chr(13) ||
                           chr (9) || '3. Всего договоров - '|| v_rfo_overdraft_all || chr(10) || chr(13) ||
                           chr (9) || chr (9) || 'в том числе возникновение овердрафта после занесения клиента в категорию - '|| v_rfo_overdraft||chr(10) || chr(10) || 
                           --
                           'Клиенты "A7",имеющие задолженность по овердрафту :' || chr(10) || chr(13) ||                           
                           chr (9) || '1. Возникновение овердрафта в отчетную дату - '|| v_a7_over_new || chr(10) || chr(13) ||
                           chr (9) || '2. Клиенты, добавленные в категорию - '|| v_a7_lsboo_new || chr(10) || chr(13) ||
                           chr (9) || '3. Всего договоров - '|| v_rfo_a7_all || chr(10) || chr(13) ||
                           chr (9) || chr (9) || 'в том числе возникновение овердрафта после занесения клиента в категорию - '|| v_rfo_a7;
                           
        --V_EMAIL_CODE    := 'RFO_BLACK_LIST_APP';
        V_EMAIL_SUBJECT := 'Выданных кредитов ЛСБОО- ' || v_rfo_lsboo_contr_new || ',' || 
                           ' A7- ' || v_rfo_terr_contr_new || ','||
                           ' Вышедших в овердрафт ЛСБОО- '||v_a7_over_new || ' за: ' || to_char(sysdate-1,'dd.mm.yyyy');
        ----------------------------------------------------------------
      
        pkg_mail.add_email(in_email_code    => EMAIL_CODE_BL,
                           in_email_body    => V_EMAIL_BODY,
                           in_email_subject => V_EMAIL_SUBJECT);
      end if;
     
    end if;*/
      --отправка по ЧС
      p_black_lisk;
      ----M_PKB_SEND_MON
      pkb_mon_send;
      --отправка данные об оценке залога
      p_zalog_estim_send;
      --Отправка данных по выданным кредитам АВТО
      p_contract_auto;
      --Отправка отчета по мошенническим операциям
      p_out_report_fraud;
      --Отправка письма с результатами проверки инкрементальной загрузки      
      p_inc_chk;
  end add_mail_aft_upd;
  
  /*Отправка данных по M_PKB_SEND_MON*/
  procedure pkb_mon_send
  as
    v_mv_ready      number;
    v_email_send    number;
    
    v_file_name varchar2(200);
  begin
    --------------------------------------------------------------- 
    ----M_PKB_SEND_MON
    select count(*)
      into v_email_send
      from email_log l
     where l.email_code = EMAIL_CODE_PKB_MON
       and trunc(date_start) = trunc(sysdate);
  
    if v_email_send = 0 then
      selecT count(*)
        into v_mv_ready
        from v_mviews_ready
       where MVIEW_NAME = 'M_PKB_SEND_MON' and 
             update_status = 'OK';
    
      if v_mv_ready > 0 then
        v_file_name := 'pkb_result_exp_' || to_char(sysdate, 'ddmmyyyy_hh24miss') || '.tsv';
        
        u1.dump_table_to_tsv(p_tname => 'U1.M_PKB_SEND_MON', 
                             p_dir => 'EXPORT_DIR', 
                             p_filename => v_file_name);
      
        pkg_mail.add_email(in_email_code    => EMAIL_CODE_PKB_MON,
                           in_email_body    => '',
                           in_email_subject => 'PKB report monitoring', 
                           in_attach_dir => 'EXPORT_DIR', 
                           in_attach_file => v_file_name, 
                           in_with_attach => 1);
      end if;
    end if;
  end;
  --------------
    /*Отправка данных по V_OUT_ZALOG_ESTIMATE - Передача залога на оценку*/
  procedure p_zalog_estim_send
    as
    v_mv_ready      number;
    v_email_send    number;
    
    v_file_name varchar2(200);
  begin
    --------------------------------------------------------------- 
    ----M_PKB_SEND_MON
    select count(1)
      into v_email_send
      from EMAIL_LOG l
     where l.email_code = 'RDWH_ZALOG_ESTIM'
       and trunc(date_start) = trunc(sysdate);
  
    if v_email_send = 0 then
      select count(1)
        into v_mv_ready
        from V_MVIEWS_READY
       where mview_name = 'M_RFO_ZALOG_ESTIMATE' and 
             update_status = 'OK';
    
      if v_mv_ready > 0 then
        v_file_name := 'zalog_result_exp_' || to_char(sysdate, 'ddmmyyyy_hh24miss') || '.tsv';
        
        u1.dump_table_to_tsv(p_tname => 'U1.V_OUT_ZALOG_ESTIMATE', 
                             p_dir => 'EXPORT_DIR', 
                             p_filename => v_file_name);
      
        pkg_mail.add_email(in_email_code    => 'RDWH_ZALOG_ESTIM',
                           in_email_body    => '',
                           in_email_subject => '', 
                           in_attach_dir => 'EXPORT_DIR', 
                           in_attach_file => v_file_name, 
                           in_with_attach => 1);
      end if;
    end if;
  end;
  --
   /*Отправка данных по V_OUT_CONTRACT_AUTO  - Выданные кредита АВТО*/
  procedure p_contract_auto
    as
    v_mv_ready      number;
    v_email_send    number;
    --n_tmp           number;
    
    v_file_name varchar2(200);
  begin
    --------------------------------------------------------------- 
    ----M_PKB_SEND_MON
    select count(1)
      into v_email_send
      from EMAIL_LOG l
     where l.email_code = 'RDWH_CONTRACT_AUTO'
       and trunc(date_start) = trunc(sysdate);
  
    if v_email_send = 0 then
      select count(1)
        into v_mv_ready
        from V_MVIEWS_READY
       where mview_name in ('V_CONTRACT_ALL_RFO_AUTO',
                            'V_DWH_PORTFOLIO_CURRENT',
                            'V_CLIENT_RFO_BY_ID') and 
             update_status = 'OK';
    
      --если пересчет не готов, а время уже более 9-00, то данные отправлять по необновленным объектам
      --добавить проверку, что на данный момент объект не обновляется
      --пока закомментировала, так как данные выгружаются на вчера
      --и если объект не обновлен, то данные пустые
      /*if v_mv_ready < 3 then
         if to_number(to_char(sysdate, 'HH24MI')) >= 0900 then
            --проверяем, что объект не обновляется на данный момент
            select count(1)
              into n_tmp
              from v$locked_object l
              join user_objects    o on o.object_id = l.object_id      
             where o.OBJECT_NAME in ('V_CONTRACT_ALL_RFO_AUTO',
                                     'V_DWH_PORTFOLIO_CURRENT',
                                     'V_CLIENT_RFO_BY_ID');  
            if n_tmp = 0 then
               v_mv_ready := 3;
            end if;                                  
         end if;  
      end if;*/  
      if v_mv_ready >= 3 then
        v_file_name := 'contract_auto_result_exp_' || to_char(sysdate, 'ddmmyyyy_hh24miss') || '.tsv';
        
        u1.dump_table_to_tsv(p_tname => 'U1.V_OUT_CONTRACT_AUTO', 
                             p_dir => 'EXPORT_DIR', 
                             p_filename => v_file_name);
      
        pkg_mail.add_email(in_email_code    => 'RDWH_CONTRACT_AUTO',
                           in_email_body    => '',
                           in_email_subject => '', 
                           in_attach_dir => 'EXPORT_DIR', 
                           in_attach_file => v_file_name, 
                           in_with_attach => 1);
      end if;
    end if;
  end;
  --
 /*Отправка данных по V_OUT_CONTRACT_AUTO  - Выданные кредита АВТО*/
  procedure p_out_report_fraud
    as
    v_mv_ready      number;
    v_email_send    number;
    --n_tmp           number;
    
    v_file_name varchar2(200);
  begin
    --------------------------------------------------------------- 
    --ежемесячный отчет
    select count(1)
      into v_email_send
      from EMAIL_LOG l
     where l.email_code = 'RDWH_REPORT_FRAUD'
       and trunc(date_start,'mm') = trunc(sysdate,'mm');
  
    if v_email_send = 0 then
      select count(1)
        into v_mv_ready
        from V_MVIEWS_READY
       where mview_name in ('M_OUT_REPORT_FRAUD') 
         and update_status = 'OK';
    
      if v_mv_ready >= 1 then
        v_file_name := 'report_fraud_result_exp_' || to_char(sysdate, 'ddmmyyyy_hh24miss') || '.tsv';
        
        u1.dump_table_to_tsv(p_tname => 'U1.M_OUT_REPORT_FRAUD', 
                             p_dir => 'EXPORT_DIR', 
                             p_filename => v_file_name);
      
        pkg_mail.add_email(in_email_code    => 'RDWH_REPORT_FRAUD',
                           in_email_body    => '',
                           in_email_subject => '', 
                           in_attach_dir => 'EXPORT_DIR', 
                           in_attach_file => v_file_name, 
                           in_with_attach => 1);
      end if;
    end if;
    --ежеквартальный отчет
    select count(1)
      into v_email_send
      from EMAIL_LOG l
     where l.email_code = 'RDWH_QUART_REPORT_FRAUD'
       and trunc(date_start,'mm') = trunc(sysdate,'mm');
  
    if v_email_send = 0 and to_char(sysdate,'mm') in ('01','04','07','10') then
      select count(1)
        into v_mv_ready
        from V_MVIEWS_READY
       where mview_name in ('M_OUT_QUART_REPORT_FRAUD') 
         and update_status = 'OK';
    
      if v_mv_ready >= 1 then
        v_file_name := 'quart_report_fraud_result_exp_' || to_char(sysdate, 'ddmmyyyy_hh24miss') || '.tsv';
        
        u1.dump_table_to_tsv(p_tname => 'U1.M_OUT_QUART_REPORT_FRAUD', 
                             p_dir => 'EXPORT_DIR', 
                             p_filename => v_file_name);
      
        pkg_mail.add_email(in_email_code    => 'RDWH_QUART_REPORT_FRAUD',
                           in_email_body    => '',
                           in_email_subject => '', 
                           in_attach_dir => 'EXPORT_DIR', 
                           in_attach_file => v_file_name, 
                           in_with_attach => 1);
      end if;
    end if;
  end;
--    
  /*Отправка отчета по ЛСБОО */
  procedure p_black_lisk
  is
  v_email_send number;
  v_mv_ready   number;
  v_email_body clob;
  v_email_subject varchar2(128);
  --
  v_all_13     number;
  v_all_a7     number;
  v_rfo_bl_app_lsboo_all number;
  v_rfo_lsboo_contr_new  number;
  v_rfo_bl_app_lsboo     number;
  v_offer_lsboo_all      number;
  v_offer_lsboo_new      number;
  v_offer_lsboo          number;
  v_rfo_bl_app_terror_all number;
  v_rfo_terr_contr_new    number;
  v_rfo_bl_app_terror     number;
  v_offer_a7_all          number;
  v_offer_a7_new          number;
  v_offer_a7              number;
  v_rfo_overdraft_all     number;
  v_ovrd_over_new         number;
  v_rfo_overdraft         number;
  v_rfo_a7_all            number;
  v_a7_over_new           number;
  v_rfo_a7                number;
  begin
    select count(1)
      into v_email_send
      from EMAIL_LOG l
     where l.email_code = email_code_bl
       and trunc(date_start) = trunc(sysdate);
    --если пиьсмо еще не отправляли
    if v_email_send = 0 then 
       selecT count(1)
         into v_mv_ready
         from V_MVIEWS_READY
        where mview_name in ( 'M_RFO_BLACK_LIST_APPROV', 'M_OVERDRAFT_ANALYSIS')
          and update_status = 'OK';    
      --если объекты обновлены
      if v_mv_ready = 2 then
         select nvl(sum(case when t.note in ('А0000013','A0000013') then 1 end),0),
                nvl(sum(case when t.note in ('A7','А7') then 1 end),0)
           into v_all_13, v_all_a7
           from V_RFO_BLACK_LIST t
          where t.note in ('А0000013','A0000013','A7','А7')
            and trunc(t.date_add) = trunc(sysdate) - 1;
         --   
         select count(distinct contract_number) as v_rfo_bl_app_lsboo_all,
               count(distinct case when trunc(folder_date_create_mi) = trunc(sysdate) - 1 then contract_number end) as v_rfo_lsboo_contr_new,
               count(distinct case when folder_date_create_mi >= date_add then contract_number end) as v_rfo_bl_app_lsboo,
               count(distinct case when cnt_spec_offer > 0 then contract_number end) as v_offer_lsboo_all,
               count(distinct case when is_spec_offer_last = 1 then contract_number end) as v_offer_lsboo_new,
               count(distinct case when is_spec_offer = 1 then contract_number end) as v_offer_lsboo
          into v_rfo_bl_app_lsboo_all, v_rfo_lsboo_contr_new, v_rfo_bl_app_lsboo,
               v_offer_lsboo_all, v_offer_lsboo_new, v_offer_lsboo      
          from M_RFO_BLACK_LIST_APPROV
         where is_credit_active = 1 
           and type_list = 'LSBOO';
        select count(distinct contract_number), --всего кредитов
               count(distinct case when trunc(folder_date_create_mi) = trunc(sysdate) - 1 then contract_number end), --выданные кредиты в отчетную дату
               count(distinct case when folder_date_create_mi >= date_add then contract_number end), --кредит после занесения
               count(distinct case when cnt_spec_offer > 0 then contract_number end), --всего спец предложений
               count(distinct case when is_spec_offer_last = 1 then contract_number end),  --спец предложение в отчетную дату
               count(distinct case when is_spec_offer = 1 then contract_number end)  --спец предложение после занесения
          into v_rfo_bl_app_terror_all, v_rfo_terr_contr_new, v_rfo_bl_app_terror,
               v_offer_a7_all, v_offer_a7_new, v_offer_a7
          from M_RFO_BLACK_LIST_APPROV
         where is_credit_active = 1 
           and type_list = 'TERRORIST';

        select count(distinct contract_number) as  v_rfo_overdraft, --всего оверов
               count(distinct case when rep_date_over = trunc(sysdate) - 1 then rfo_client_id end) as v_ovrd_over_new, --овер в отчетную
               count(distinct case when rep_date_over >= date_add_bl - 1 then contract_number end) --овер после занесения
          into v_rfo_overdraft_all, v_ovrd_over_new, v_rfo_overdraft
          from M_OVERDRAFT_ANALYSIS 
         where in_lsboo = 1 
           and rep_date = trunc(sysdate)-1;
        --
        select count(distinct contract_number),
               count(distinct case when rep_date_over = trunc(sysdate) - 1 then rfo_client_id end),
               count(distinct case when rep_date_over >= date_add_bl - 1 then contract_number end)
          into v_rfo_a7_all, v_a7_over_new, v_rfo_a7
          from M_OVERDRAFT_ANALYSIS 
         where in_terror = 1 
           and rep_date = trunc(sysdate)-1;    
         --собираем тело письма
         v_email_body := '
         <p>Добрый день</p>
         <p>Отчет за: '||to_char(trunc(sysdate-1),'dd.mm.yyyy')||'</p>
         <table>
         <tr bgcolor="#E0E0E0"> <td ><br>На отчетную дату</br></td><td><br>ЛСБОО</br></td> <td><br>А7</br></td></tr>
         <tr> <td>Клиенты, добавленные в категорию</td> <td>'||v_all_13||'</td><td>'||v_all_a7||'</td></tr>
         <tr> <td>Выданные кредиты</td>                 <td>'||v_rfo_lsboo_contr_new||'</td><td>'||v_rfo_terr_contr_new||'</td></tr>
         <tr> <td>Спец предложения</td>                 <td>'||v_offer_lsboo_new||'</td><td>'||v_offer_a7_new||'</td></tr>
         <tr> <td>Овердрафты</td>                       <td>'||v_ovrd_over_new||'</td><td>'||v_a7_over_new||'</td></tr>
         <tr bgcolor="#E0E0E0"> <td colspan=3><br>Всего договоров по клиентам, включенным в ЧС<br></td></tr>
         <tr><td>Выданные кредиты</td><td>'||v_rfo_bl_app_lsboo_all||'</td><td>'||v_rfo_bl_app_terror_all||'</td></tr>
         <tr><td>Спец предложения</td><td>'||v_offer_lsboo_all||'</td><td>'||v_offer_a7_all||'</td></tr>
         <tr><td>Овердрафты</td><td>'||v_rfo_overdraft_all||'</td><td>'||v_rfo_a7_all||'</td></tr>
         <tr bgcolor="#E0E0E0"> <td colspan=3><br>Всего договоров после включения в ЧС<br></td></tr>
         <tr><td>Выданные кредиты</td><td>'||v_rfo_bl_app_lsboo||'</td><td>'||v_rfo_bl_app_terror||'</td></tr>
         <tr><td>Спец предложения</td><td>'||v_offer_lsboo||'</td><td>'||v_offer_a7||'</td></tr>
         <tr><td>Овердрафты</td><td>'||v_rfo_overdraft||'</td><td>'||v_rfo_a7||'</td></tr>
         </table>';
         --тема письма
         v_email_subject := 'Отчет по ЛСБОО и А7 за '||to_char(trunc(sysdate-1),'dd.mm.yyyy');
         --отправляем писmмо
         pkg_mail.add_email(in_email_code    => email_code_bl,
                            in_email_body    => v_email_body,
                            in_email_subject => v_email_subject,
                            in_with_html     => 1);
     end if;  
     end if;  
  end;  
  
    /*Отправка письма с результатами проверки инкрементальной загрузки */
  procedure p_inc_chk
  is
  n_email_send    number;
  n_cnt           number;
  --
  n_cnt_all       number(10);
  v_email_body    clob;
  v_email_subject varchar2(128);
  begin
    select count(1)
      into n_email_send
      from EMAIL_LOG l
     where l.email_code = EMAIL_CODE_INC_CHK
       and trunc(date_start) = trunc(sysdate);
    --если пиьсмо еще не отправляли
    if n_email_send = 0 then 
       select count(distinct p.table_name)
         into n_cnt
         from T_RDWH_INCREM_CHECK_PARAM p
         where not exists (select 1 
                           from T_RDWH_INCREM_CHECK_LOG l
                           where l.table_name = p.table_name
                           and l.check_date = trunc(sysdate));    
      --если все таблицы проверены
      if n_cnt = 0 then
         select count(1)
         into n_cnt_all
         from T_RDWH_INCREM_CHECK_LOG l
         where l.check_date = trunc(sysdate)
           and l.check_result = 0;
         --   
         if n_cnt_all = 0 then  -- если нет ошибок
             v_email_body := '
           <p>Добрый день</p>
           <p>Отчет за: '||to_char(trunc(sysdate),'dd.mm.yyyy')||'</p>
           <p>Отсутствуют расхождения в инкрементально загружаемых таблицах</p>';
         else
            --собираем тело письма
             v_email_body := '
                 <p>Добрый день</p>
                 <p>Отчет за: '||to_char(trunc(sysdate),'dd.mm.yyyy')||'</p>
                 <table>
                 <tr bgcolor="#E0E0E0"> <td ><br>Таблица</br></td><td><br>Количество записей в источнике</br></td> <td><br>Количество записей в RDWH</br></td><td><br>Разница</br></td></tr>';
                 
                 for rec in (select l.table_name,l.source_cnt,l.table_cnt, l.source_cnt-l.table_cnt as diff
                             from T_RDWH_INCREM_CHECK_LOG l
                 where l.check_date = trunc(sysdate)
                   and l.check_result = 0)
                   loop
                     v_email_body := v_email_body||'<tr> <td>'||rec.table_name||'</td> <td>'||rec.source_cnt||'</td><td>'||rec.table_cnt||'</td><td>'||rec.diff||'</td></tr>';             
                   end loop;
                   v_email_body := v_email_body||'</table>';
                 end if;
                       
                
                 --тема письма
                 v_email_subject := 'Проверка инкрементальной загрузки за '||to_char(trunc(sysdate),'dd.mm.yyyy');
                 --отправляем писmмо
                 pkg_mail.add_email(in_email_code    => EMAIL_CODE_INC_CHK,
                                    in_email_body    => v_email_body,
                                    in_email_subject => v_email_subject,
                                    in_with_html     => 1);
     end if;  
   end if;  
  end p_inc_chk;  
  
  
end PKG_MAIL_UPDATE;
/

