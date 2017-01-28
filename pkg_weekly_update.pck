create or replace package u1.PKG_WEEKLY_UPDATE is

  -- Author  : Malayeva_26016
  -- Created : 16.07.2015 14:22:30
  -- Purpose :
--Пакет обновляет все объекты по еженедельному пересчету
  
  -- Инсерт в таблицу событий
  procedure put_event(p_event in varchar2,
                      p_detail in varchar2 default NULL);

  -- Проверить событие - есть/нет
  function check_event(p_event in varchar2)
  return boolean;
  
  -- основная процедура по запуску всех процессов
  procedure weekly_update;
  
  --процедуры по пересчету
  procedure recalc_weekrdwh_p1;
  
  procedure recalc_weekrdwh_p2;
  
  procedure recalc_weekrdwh(p_proc_name in varchar2);
--  
end PKG_WEEKLY_UPDATE;
/

create or replace package body u1.PKG_WEEKLY_UPDATE
is
--обработка ошибок и отправка сообщений
p_email_code_err constant varchar2(32) := 'RDWH_MONTH_ERR';
s_error_message  varchar2(4000);
e_user_exception exception;

  -- Инсерт в таблицу событий
  procedure put_event(p_event in varchar2,
                      p_detail in varchar2 default NULL)
  is
    n_cnt integer;
  begin
    -- Каждое событие может присутствовать только один раз в сутки
    select count(1)
      into n_cnt
      from weekly_update_event
     where event = p_event
       and e_date = trunc(sysdate);
  
    if n_cnt > 0 then
      log_error('pkg_weekly_update.put_event',
                '-1',
                'Event ''' || p_event || ''' already exist',
                null,
                null);
      return;
    end if;
  
    insert into weekly_update_event
      (event, e_detail, e_date)
    values
      (p_event, p_detail, trunc(sysdate));
    commit;
  
  exception
    when others then
      log_error('pkg_weekly_update.put_event', sqlcode, substr(dbms_utility.format_error_backtrace,1,200), null, null);
  end put_event;  

  -- Проверить событие - есть/нет
  function check_event(p_event in varchar2)
  return boolean
  is  
    n_cnt integer;
  begin
  
    select count(1)
      into n_cnt
      from weekly_update_event
     where event = p_event
       and e_date >= trunc(sysdate-1);
  
    if n_cnt > 0 then
      return true;
    end if;
  
    return false;
  exception
    when others then
      log_error('pkg_weekly_update.check_event',
                sqlcode,
                substr(dbms_utility.format_error_backtrace,1,200),
                null,
                null);
      return false;
  end check_event;  
  
  -- основная процедура по запуску всех процессов
  procedure weekly_update
  is
  vJob       integer;
  vStartTime varchar2(22);
  vStopTime  varchar2(22);
    v_cnt_obj number;
    v_cnt_obj_ready number;  
  begin
    -- окно времени, когда идет обновление
    --процедуру запускаем не раньше 11-00(пока rbo все равно раньше не готово)
    --и не позже 20-00 --максимальный процесс не позже 4 часов, чтоб успеть до 24-00
    vStartTime := '10:00:00';
    vStopTime  := '21:00:00';
    vStartTime := to_char(sysdate, 'dd.mm.yyyy') || ' ' || vStartTime;
    vStopTime  := to_char(sysdate, 'dd.mm.yyyy') || ' ' || vStopTime;
    --и должна запускаться только по суббота
    if sysdate < to_date(vStartTime, 'dd.mm.yyyy hh24:mi:ss') or
       sysdate > to_date(vStopTime, 'dd.mm.yyyy hh24:mi:ss') or
       (trim(to_char(sysdate,'DAY')) != 'SATURDAY' and trim(to_char(sysdate,'DAY')) != 'SUNDAY') then
      return;
    end if;
    --проверяем что весь процесс закончен
    if pkg_weekly_update.check_event('PROCESS_WEEKRDWH_COMPLETE') then
       return;
    end if;  
    --проверяем что весь процесс закончен
    if pkg_weekly_update.check_event('RECALC_WEEKRDWH_P1_COMPLETE') and
       pkg_weekly_update.check_event('RECALC_WEEKRDWH_P2_COMPLETE') and
       pkg_weekly_update.check_event('RECALC_WEEKRDWH_P3_COMPLETE') and
       pkg_weekly_update.check_event('RECALC_WEEKRDWH_P4_COMPLETE') and
       not pkg_weekly_update.check_event('PROCESS_WEEKRDWH_COMPLETE') then
       pkg_weekly_update.put_event('PROCESS_WEEKRDWH_COMPLETE');
    end if;  
    --если на сегодня основные процессы не закончены, то return;
    /*if not pkg_daily_update.check_event('PROCESS_COMPLETE') or
       not pkg_daily_update.check_event('PROCESS_ADD_COMPLETE') or
       not pkg_daily_update.check_event('PROCESS_RBO_COMPLETE') 
       then
       return; 
    end if;*/
    select count(b.object_name) , count(l.id) into v_cnt_obj,v_cnt_obj_ready 
    from /*T_RDWH_PROC_OBJECT*/ (select * from NT_RDWH_PROC_OBJECT_HIST where trunc(sdt)=trunc(sysdate)-1) b
    left join update_log l on l.object_name=trim(b.object_name) and l.begin_refresh>=trunc(sysdate) and l.status='OK' --and l.status='OK'
    where b.is_used=1 and b.type_load='DAILY' and b.object_type <> 'VIEW' and b.proc_name<>'JOB' ;--and nvl(b.load_group,'-')<>'ADD';
    if v_cnt_obj <> v_cnt_obj_ready or v_cnt_obj<=0 then
       return;
    end if;      
    --запускаем пересчет 
    if not pkg_weekly_update.check_event('RECALC_WEEKRDWH_PROCESSING') then
       put_event('RECALC_WEEKRDWH_PROCESSING');
       dbms_job.submit(vJob, 'pkg_weekly_update.recalc_weekrdwh_p1;');
       dbms_job.submit(vJob, 'pkg_weekly_update.recalc_weekrdwh_p2;');
       dbms_job.submit(vJob, 'pkg_weekly_update.recalc_weekrdwh(''RECALC_WEEKRDWH_P3'');');
       dbms_job.submit(vJob, 'pkg_weekly_update.recalc_weekrdwh(''RECALC_WEEKRDWH_P4'');');
       commit;
    end if; 
    --  
  exception
  when others then
     log_error(in_operation => 'pkg_weekly_update.weekly_update',
               in_error_code => sqlcode,
               in_error_message => sqlerrm||' '||dbms_utility.format_error_backtrace,
               in_object_type   => null);
     --    
     pkg_mail.add_email(in_email_code => p_email_code_err,
                       in_email_body => 'Остановлен процесс pkg_weekly_update.weekly_update. '||sqlerrm||' '||dbms_utility.format_error_backtrace,
                       in_email_subject => 'ERROR');      
  end weekly_update;    
  
--------------------------------------------------------------------------
procedure recalc_weekrdwh_p1
is
vLog_id        integer;
vLog_det       varchar2(4000);
vRes           varchar2(99);
s_mview_name   varchar2(256);
--
n_max_question_id number(19);
begin
  --начала события
   insert into weekly_update_log l
      (l.process, l.p_begin, l.p_status, l.p_date)
   values
      ('RECALC_WEEKRDWH_P1', systimestamp, 'PROCESSING', trunc(sysdate));
   commit; 
   vLog_id := weekly_update_log_seq.currval;
--если проверки пройдены, то переходим к самой загрузке
    for rec in (select object_name, object_type
                  from T_RDWH_PROC_OBJECT 
                 where type_load = 'WEEKLY' and proc_name = 'RECALC_WEEKRDWH_P1'
                   and is_used = 1
                 order by priority)
    loop
        s_mview_name := rec.object_name;
        if rec.object_type = 'MVIEW' then
           vRes := pkg_update_util.mv_truncate_refresh(rec.object_name);
           pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, vRes);
           if vRes = 1 then
              raise e_user_exception;
           end if;
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_OUT_DWH_QUESTION' then
           begin
            select max(id)
              into n_max_question_id 
              from T_OUT_DWH_QUESTION; 
            execute immediate 'truncate table T_OUT_DWH_QUESTION_VERIFICATOR';
            insert into T_OUT_DWH_QUESTION_VERIFICATOR
            Select id,
                   code,
                   name,
                   text, 
                   schema_id,
                   portition_date
              from verificator.OUT_DWH_QUESTION@verifais
             where id > n_max_question_id;
            commit; 
            execute immediate 'truncate table T_OUT_DWH_QUESTION_PRE';
            insert /*+ append */into T_OUT_DWH_QUESTION_PRE
            select /*+ parallel(20)*/
                   q.id,
                   q.code,
                   q.name,
                   dbms_lob.substr(q.text, 4000, 1),
                   q.schema_id,
                   q.portition_date
              from T_OUT_DWH_QUESTION_VERIFICATOR q;
            commit;  
            insert /*+ append*/into T_OUT_DWH_QUESTION
            select /*+ paralell(20)*/
                   q.id,
                   q.code,
                   q.name,
                   (select listagg(replace( replace(regexp_substr(q.text,'>.*?<', 1,rownum), '>', ''),'<','')) within group (order by rownum)  a
                      from dual
                   connect by rownum <= regexp_count(q.text,'>.*?<')),
                   q.schema_id,
                   q.portition_date
              from T_OUT_DWH_QUESTION_PRE q;
            commit;
            pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 0);
           exception
             when others then
               log_error(in_operation => 'pkg_weekly_update.recalc_weekrdwh_p1',
               in_error_code => sqlcode,
               in_error_message => sqlerrm||' '||dbms_utility.format_error_backtrace,
               in_object_type   => s_mview_name);
           end;         
        end if;   
    end loop;      
   -- событие окончания процесса
   put_event('RECALC_WEEKRDWH_P1_COMPLETE');
  
    -- окончание журнализации

    update weekly_update_log l
       set l.p_end       = systimestamp,
           l.p_status    = 'COMPLETE',
           l.p_detail    = vLog_det,
           l.p_total_min = pkg_update_util.get_proc_time(l.p_begin, systimestamp)
     where l.id = vLog_id;
    commit;

exception
  when e_user_exception then
    log_error(in_operation => 'pkg_weekly_update.recalc_weekrdwh_p1',
              in_error_code => '-99999',
              in_error_message => s_error_message,
              in_object_type => s_mview_name);
     --         
     pkg_mail.add_email(in_email_code => p_email_code_err,
                       in_email_body => 'Остановлен процесс pkg_weekly_update.recalc_weekrdwh_p1. '||s_error_message||'. Объект '||s_mview_name,
                       in_email_subject => 'ERROR');  
  when others then
     log_error(in_operation => 'pkg_weekly_update.recalc_weekrdwh_p1',
               in_error_code => sqlcode,
               in_error_message => sqlerrm||' '||dbms_utility.format_error_backtrace,
               in_object_type   => s_mview_name);
     --    
     pkg_mail.add_email(in_email_code => p_email_code_err,
                       in_email_body => 'Остановлен процесс pkg_weekly_update.recalc_weekrdwh_p1. '||s_error_message||'. Объект '||s_mview_name,
                       in_email_subject => 'ERROR');  
end recalc_weekrdwh_p1;
--------------------------------------------------------------------------

procedure recalc_weekrdwh_p2
is
vLog_id        integer;
vLog_det       varchar2(4000);
vRes           varchar2(99);
s_mview_name   varchar2(256);
--
c    integer; 
nr   integer;
n_max_id         number; 

v_id                    NUMBER;

v_uri                   VARCHAR2(4000);
v_hash                  VARCHAR2(4000);
v_length_col            NUMBER;

v_pay_info_id              number(20);
v_service_params_id        number(10);
v_str_value                varchar2(4000); 

 v_dep_agreement_id number(20);
 v_agreement_id number(20);
 v_card_id number(20);
 v_transfer_sum number(19,5);
 v_currency varchar2(510);
 v_external_id varchar2(510);
 v_create_date date;
 v_accept_date date;
 v_last_modification_date date;
 v_declare_id varchar2(510);
 v_is_state number(3);
 v_end_state number(10);
 v_state_description  varchar2(4000);
 v_tarif_sum number(19,5);
 v_sender_account_saldo number(19,5);
 v_receiver_account_saldo number(19,5);
 v_rate_val number(19,5);
 v_depart varchar2(510);
 v_user_id number(20);
 v_old_dep_agreement_id number(20);
 v_old_card_id number(20);
 v_is_payment_transfer number(3);
 v_old_reciev_dep_agr_id number(20);
 v_payment_id number(20);
 v_source_account_id number(20);
 v_destination_account_id number(20);  
 
 
  v_user_agent            VARCHAR2(4000);
    --v_hash                  VARCHAR2(4000);
    --v_length_col            NUMBER;
    v_device_model          VARCHAR2(200);
    v_os                    VARCHAR2(200);
    v_os_major_version      NUMBER;
    v_os_minor_version      NUMBER;
    v_browser               VARCHAR2(200);
    v_browser_major_version NUMBER;
    v_browser_minor_version NUMBER;
    
      id  number;
      method  varchar2(100);
      referer_id  number;
      uri_id  number;
      user_agent_id  number;
      user_id  number;
      session_id  number;
      asp_session_id  varchar2(100);
      date_start  date;
      process_time  number;
      server_name  varchar2(100);
      request_trace_guid  varchar2(2000);
      client_ip  varchar2(64);
      nc_client_ip  varchar2(64);
      raw_uri_id  number;
      actual_uri_id  number;
      request_parameters  varchar2(4000);
      security_tag_id number;
begin
  
   insert into weekly_update_log l
      (l.process, l.p_begin, l.p_status, l.p_date)
   values
      ('RECALC_WEEKRDWH_P2', systimestamp, 'PROCESSING', trunc(sysdate));
   commit; 
   vLog_id := weekly_update_log_seq.currval;
    for rec in (select object_name, object_type
                  from T_RDWH_PROC_OBJECT 
                 where type_load = 'WEEKLY' and proc_name = 'RECALC_WEEKRDWH_P2'
                   and is_used = 1
                 order by priority)
    loop
        s_mview_name := rec.object_name;
        if rec.object_type = 'MVIEW' then
           vRes := pkg_update_util.mv_truncate_refresh(rec.object_name);
           pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, vRes);
           if vRes = 1 then
              raise e_user_exception;
           end if;
        
           
           elsif rec.object_type = 'TABLE' and rec.object_name = 'T_KASPIKZ_LOG_URI' then  
             begin
          select max(id)
          into n_max_id
          from T_KASPIKZ_LOG_URI;
          
          c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@db_kr2; 
          DBMS_HS_PASSTHROUGH.PARSE@db_kr2(c, 
            'select
                    t.id,
                    cast(t.URI as char(4000)),
                    convert(int,t.Hash),
                    t.Length            
                    from dbo.log_URI t
                     where t.id >'||n_max_id||'
                    ');
          LOOP
            nr := DBMS_HS_PASSTHROUGH.FETCH_ROW@db_kr2(c);
            EXIT WHEN nr = 0;    
            v_id                    := null;
            v_uri                   := null;
            v_hash                  := null;
            v_length_col            := null;
            DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  1, v_id);
            DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  2, v_uri);
            DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  3, v_hash);
            DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  4, v_length_col);
            insert into T_KASPIKZ_LOG_URI(ID, URI, HASH, LENGTH_COL)
            values (v_id,
                    rtrim(v_uri),
                    trim(to_char(abs(v_hash),'XXXXXXXXX')),
                    v_length_col
                   );                                          
          END LOOP;  
          DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@db_kr2(c);   
          commit; 
           pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 0);
          exception
             when others then
                pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 1);
               log_error(in_operation => 'pkg_weekly_update.recalc_weekrdwh_p2',
               in_error_code => sqlcode,
               in_error_message => sqlerrm||' '||dbms_utility.format_error_backtrace,
               in_object_type   => s_mview_name);
           end;  
          
    elsif rec.object_type = 'TABLE' and rec.object_name = 'T_KASPIKZ_PAY_PAYINFOPARAMS' then       
      begin   
      select max(id)
      into n_max_id
      from T_KASPIKZ_PAY_PAYINFOPARAMS;
    c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@db_kr2; 
  DBMS_HS_PASSTHROUGH.PARSE@db_kr2(c, 
    'select
            t.bintId,
            t.bintPaymentInfoId,
            t.intServiceParameterId, 
            cast(t.vchValue as char(4000))                  
            from dbo.v_Pay_PayInfoParams t
            where t.bintId >'||n_max_id||' 
            ');
            
           
  LOOP
    nr := DBMS_HS_PASSTHROUGH.FETCH_ROW@db_kr2(c);
    EXIT WHEN nr = 0;    
    v_id                    := null;
    v_pay_info_id           := null;
    v_service_params_id     := null;
    v_str_value             := null;
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  1, v_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  2, v_pay_info_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  3, v_service_params_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  4, v_str_value);
     insert into T_KASPIKZ_PAY_PAYINFOPARAMS (ID, pay_info_id , service_params_id , str_value )
    values (v_id,
            v_pay_info_id ,
            v_service_params_id,
            rtrim(v_str_value) 
           );                                          
  END LOOP; 
   DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@db_kr2(c);   
  commit;  
    pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 0);
  exception
             when others then
                pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 1);
               log_error(in_operation => 'pkg_weekly_update.recalc_weekrdwh_p2',
               in_error_code => sqlcode,
               in_error_message => sqlerrm||' '||dbms_utility.format_error_backtrace,
               in_object_type   => s_mview_name);
           end;   
  
  elsif rec.object_type = 'TABLE' and rec.object_name = 'T_KASPIKZ_TRANSF_TRANSFER' then 
    begin
    
  
        select max(id)
      into n_max_id
      from T_KASPIKZ_TRANSF_TRANSFER;
    c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@db_kr2; 
  DBMS_HS_PASSTHROUGH.PARSE@db_kr2(c, 
    'select
     t.Id,
     t.DepositAgreementId,
     t.AgreementId,
     t.CardId,
     t.TransferSum,
     t.Currency,
     cast (t.ExternalId as char(765)) ExternalId,
     t.CreateDateTime,
     t.AcceptDateTime,
     t.LastModificationDateTime,
     cast (t.DeclareId as char(765)) DeclareId,
     t.IsState,
     t.EndState,
     cast (t.StateDescription as char(4000)) StateDescription, 
     t.TarifSum,
     t.SenderAccountSaldo,
     t.ReceiverAccountSaldo,
     t.Rate,
     t.Depart,
     t.UserId,
     t.OldDepositAgreementId,
     t.OldCardId,
     t.IsPaymentTransfer,
     t.OldRecieverDepositAgreementId,
     t.PaymentId, 
     t.SourceAccountId,
     t.DestinationAccountId
    
                                         
            from dbo.tb_Transfers_Transfer t
            where t.id >'||n_max_id||' ');
            
            
            
           
             
  LOOP
    nr := DBMS_HS_PASSTHROUGH.FETCH_ROW@db_kr2(c);
    EXIT WHEN nr = 0;    
     v_id :=null;
     v_dep_agreement_id :=null;
     v_agreement_id:=null;
     v_card_id :=null;
     v_transfer_sum :=null;
     v_currency :=null;
     v_external_id :=null;
     v_create_date :=null;
     v_accept_date :=null;
     v_last_modification_date :=null;
     v_declare_id :=null;
     v_is_state :=null;
     v_end_state :=null;
     v_state_description :=null;
     v_tarif_sum :=null;
     v_sender_account_saldo :=null;
     v_receiver_account_saldo :=null;
     v_rate_val :=null;
     v_depart :=null;
     v_user_id :=null;
     v_old_dep_agreement_id :=null;
     v_old_card_id :=null;
     v_is_payment_transfer :=null;
     v_old_reciev_dep_agr_id :=null;
     v_payment_id:=null; 
     v_source_account_id :=null;
     v_destination_account_id :=null;
     
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  1, v_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  2, v_dep_agreement_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  3, v_agreement_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  4, v_card_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  5, v_transfer_sum);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  6, v_currency);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  7, v_external_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  8, v_create_date);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  9, v_accept_date);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  10, v_last_modification_date);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  11, v_declare_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  12, v_is_state);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  13, v_end_state);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  14, v_state_description);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  15, v_tarif_sum);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  16, v_sender_account_saldo);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  17, v_receiver_account_saldo);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  18, v_rate_val);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  19, v_depart);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  20, v_user_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  21, v_old_dep_agreement_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  22, v_old_card_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  23, v_is_payment_transfer);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  24, v_old_reciev_dep_agr_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  25, v_payment_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  26, v_source_account_id );
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  27, v_destination_account_id);
   
      
    
     insert into T_KASPIKZ_TRANSF_TRANSFER (id, dep_agreement_id, agreement_id, card_id, transfer_sum, currency, external_id, create_date, accept_date, last_modification_date, declare_id,
      is_state, end_state, state_description,  tarif_sum, sender_account_saldo, receiver_account_saldo, rate_val, depart, user_id, old_dep_agreement_id, old_card_id, is_payment_transfer,
       old_reciev_dep_agr_id, payment_id, source_account_id, destination_account_id)
     values (  v_id,
               v_dep_agreement_id,
               v_agreement_id,
               v_card_id,
               v_transfer_sum,
               v_currency,
               rtrim(v_external_id),
               v_create_date,
               v_accept_date,
               v_last_modification_date,
               rtrim(v_declare_id),
               v_is_state,
               v_end_state,
               rtrim(v_state_description),
               v_tarif_sum,
               v_sender_account_saldo,
               v_receiver_account_saldo,
               v_rate_val,
               v_depart,
               v_user_id,
               v_old_dep_agreement_id,
               v_old_card_id,
               v_is_payment_transfer,
               v_old_reciev_dep_agr_id,
               v_payment_id, 
               v_source_account_id,
               v_destination_account_id 
           );                                          
  END LOOP; 
   DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@db_kr2(c);   
  commit; 
    pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 0);
  exception
             when others then
                pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 1);
               log_error(in_operation => 'pkg_weekly_update.recalc_weekrdwh_p2',
               in_error_code => sqlcode,
               in_error_message => sqlerrm||' '||dbms_utility.format_error_backtrace,
               in_object_type   => s_mview_name);
           end;  
  
  
  elsif rec.object_type = 'TABLE' and rec.object_name = 'T_KASPIKZ_LOG_USER_AGENT' then  
    begin
      select max(id)
  into n_max_id
  from T_KASPIKZ_LOG_USER_AGENT;
  
  c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@db_kr2; 
  DBMS_HS_PASSTHROUGH.PARSE@db_kr2(c, 
    'select
            t.id,
            cast(SUBSTRING(t.UserAgent, 1, 4000) as char(4000)),
            convert(int,t.Hash),
            t.Length,
            t.DeviceModel,
            t.OS,
            t.OSMajorVersion,
            t.OSMinorVersion,
            t.Browser,
            t.BrowserMajorVersion,
            t.BrowserMinorVersion            
            from dbo.log_UserAgent t
             where t.id >'||n_max_id||'  
           ');
        
             
  LOOP
    nr := DBMS_HS_PASSTHROUGH.FETCH_ROW@db_kr2(c);
    EXIT WHEN nr = 0;
    
    v_id                    := null;
    v_user_agent            := null;
    v_hash                  := null;
    v_length_col            := null;
    v_device_model          := null;
    v_os                    := null;
    v_os_major_version      := null;
    v_os_minor_version      := null;
    v_browser               := null;
    v_browser_major_version := null;
    v_browser_minor_version := null;
    
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  1, v_id);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  2, v_user_agent);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  3, v_hash);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  4, v_length_col);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  5, v_device_model);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  6, v_os);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  7, v_os_major_version);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  8, v_os_minor_version);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  9, v_browser);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c, 10, v_browser_major_version);
    DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c, 11, v_browser_minor_version);
    
    insert into T_KASPIKZ_LOG_USER_AGENT(ID, USER_AGENT, HASH, LENGTH_COL, DEVICE_MODEL, 
                                         OS, OS_MAJOR_VERSION, OS_MINOR_VERSION, 
                                         BROWSER, BROWSER_MAJOR_VERSION, BROWSER_MINOR_VERSION)
    values (v_id,
            rtrim(v_user_agent),
            trim(to_char(abs(v_hash),'XXXXXXXXX')),
            v_length_col,
            v_device_model,
            v_os,
            v_os_major_version,
            v_os_minor_version,
            v_browser,
            v_browser_major_version,
            v_browser_minor_version);
                     

                                         
  END LOOP;  
  DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@db_kr2(c); 
  
  commit;     
    pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 0);
           
            
            
            
           exception
             when others then
                pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 1);
               log_error(in_operation => 'pkg_weekly_update.recalc_weekrdwh_p2',
               in_error_code => sqlcode,
               in_error_message => sqlerrm||' '||dbms_utility.format_error_backtrace,
               in_object_type   => s_mview_name);
           end;
           
           
 elsif rec.object_type = 'TABLE' and rec.object_name = 'T_KASPIKZ_LOG_HTTP_REQUEST' then 
   begin
/*while n_id < n_id_end 
      loop
      n_id1:=  n_id;t
      n_id := n_id+1000000;*/
       select max(id)
  into n_max_id
  from T_KASPIKZ_LOG_HTTP_REQUEST;

     c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@db_kr2; 
      DBMS_HS_PASSTHROUGH.PARSE@db_kr2(c, 
        'select
          t.id id,
          cast(t.Method as char(100)) method,
          t.RefererId referer_id,
          t.UriID uri_id,
          t.UserAgentId user_agent_id,
          t.UserID user_id,
          t.SessionID session_id,
          cast(t.AspSessionID as char(100)) asp_session_id,
          t.TimeStamp ts,
          t.ProcessTime process_time,
          cast(t.ServerName as char(100)) server_name,
          cast(t.RequestTraceGUID as char(2000)) as request_trace_guid,
          convert(int, t.ClientIP) client_ip,
          convert(int, t.NSClientIP) nc_client_ip,
          t.RawUriID raw_uri_id,
          t.ActualUriId actual_uri_id,
          cast(t.RequestParameters as char(4000)) request_parameters,
          t.SecurityTagId
         from dbo.log_HttpRequest t
          where t.id >'||n_max_id||'
        ');
        /* where t.id > '||n_id1||' and t.id <= '||n_id||' */
      LOOP
    --    dbms_output.put_line('dd ');
        nr := DBMS_HS_PASSTHROUGH.FETCH_ROW@db_kr2(c);
        EXIT WHEN nr = 0;    
          id  := null;
          method  := null;
          referer_id  := null;
          uri_id  := null;
          user_agent_id  := null;
          user_id  := null;
          session_id  := null;
         asp_session_id  := null;
          date_start  := null;
          process_time  := null;
          server_name  := null;
          request_trace_guid  := null;
          client_ip  := null;
          nc_client_ip  := null;
          raw_uri_id  := null;
          actual_uri_id  := null;
          request_parameters  := null;
          security_tag_id := null;
      --        dbms_output.put_line('dd2 '           );
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,1,id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,2,method);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,3,referer_id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,4,uri_id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,5,user_agent_id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,6,user_id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,7,session_id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,8,asp_session_id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,9,date_start);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,10,process_time);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,11,server_name);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,12,request_trace_guid);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,13,client_ip);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,14,nc_client_ip);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,15,raw_uri_id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,16,actual_uri_id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,17,request_parameters);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,18,security_tag_id);
       --       dbms_output.put_line('dd3 '  || id );
        insert/* append*/ into T_KASPIKZ_LOG_HTTP_REQUEST(id,
                                          method,
                                          referer_id,
                                          uri_id,
                                          user_agent_id,
                                          user_id,
                                          session_id,
                                          asp_session_id,
                                          date_start,
                                          process_time,
                                          server_name,
                                          request_trace_guid,
                                          client_ip,
                                          nc_client_ip,
                                          raw_uri_id,
                                          actual_uri_id,
                                          request_parameters,
                                          security_tag_id)
        values ( id,
                  rtrim(method),
                  referer_id,
                  uri_id,
                  user_agent_id,
                  user_id,
                  session_id,
                  rtrim(asp_session_id),
                  date_start,
                  process_time,
                  rtrim(server_name),
                  rtrim(request_trace_guid),
                  TRIM(TO_CHAR(abs(client_ip),'XXXXXXXXX')),
                  TRIM(TO_CHAR(abs(nc_client_ip),'XXXXXXXXX')),
                  raw_uri_id,
                  actual_uri_id,
                  rtrim(request_parameters),
                  security_tag_id
               );  
      --   dbms_output.put_line('dd4 ');                                              
      END LOOP;  
      DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@db_kr2(c);   
      commit; 
        pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 0);
  --end loop;
exception
             when others then
                pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, 1);
               log_error(in_operation => 'pkg_weekly_update.recalc_weekrdwh_p2',
               in_error_code => sqlcode,
               in_error_message => sqlerrm||' '||dbms_utility.format_error_backtrace,
               in_object_type   => s_mview_name);
           end;      
 
           
                  
        end if;   
    end loop;      
   put_event('RECALC_WEEKRDWH_P2_COMPLETE');
  

    update weekly_update_log l
       set l.p_end       = systimestamp,
           l.p_status    = 'COMPLETE',
           l.p_detail    = vLog_det,
           l.p_total_min = pkg_update_util.get_proc_time(l.p_begin, systimestamp)
     where l.id = vLog_id;
    commit;
    

exception
  when e_user_exception then
    log_error(in_operation => 'pkg_weekly_update.recalc_weekrdwh_p2',
              in_error_code => '-99999',
              in_error_message => s_error_message,
              in_object_type => s_mview_name);
     --         
     pkg_mail.add_email(in_email_code => p_email_code_err,
                       in_email_body => 'Остановлен процесс  pkg_weekly_update.recalc_weekrdwh_p1. '||s_error_message||'. Объект '||s_mview_name,
                       in_email_subject => 'ERROR');  
  when others then
     log_error(in_operation => 'pkg_weekly_update.recalc_weekrdwh_p2',
               in_error_code => sqlcode,
               in_error_message => sqlerrm||' '||dbms_utility.format_error_backtrace,
               in_object_type   => s_mview_name);
     --    
     pkg_mail.add_email(in_email_code => p_email_code_err,
                       in_email_body => 'Остановлен процесс  pkg_weekly_update.recalc_weekrdwh_p2. '||s_error_message||'. Объект '||s_mview_name,
                       in_email_subject => 'ERROR');  
end recalc_weekrdwh_p2;
--------------------------------------------------------------------------
procedure recalc_weekrdwh(p_proc_name in varchar2)
is
vLog_id        integer;
vLog_det       varchar2(4000);
vRes           varchar2(99);
s_mview_name   varchar2(256);
--

d_date_start_ins  date;
n_max_id_doc_fraud number;
n_max_id           number;
begin
  --начала события
   insert into weekly_update_log l
      (l.process, l.p_begin, l.p_status, l.p_date)
   values
      (p_proc_name, systimestamp, 'PROCESSING', trunc(sysdate));
   commit; 
   vLog_id := weekly_update_log_seq.currval;
--если проверки пройдены, то переходим к самой загрузке
    for rec in (select object_name, object_type, is_critical
                  from T_RDWH_PROC_OBJECT 
                 where type_load = 'WEEKLY' 
                   and proc_name = p_proc_name
                   and is_used = 1
                 order by priority)
    loop
        s_mview_name := rec.object_name;
        if rec.object_type = 'MVIEW' then
           vRes := pkg_update_util.mv_truncate_refresh(rec.object_name);
           pkg_update_util.log_mv_refresh(vLog_det,rec.object_name, vRes);
           if vRes = 1 and rec.is_critical = 1 then
              raise e_user_exception;
           end if;
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_RBO_Z#MAIN_DOCUM_FRAUD_PRE' then   
           begin
           select nvl(max(id),0)
             into n_max_id_doc_fraud
             from T_RBO_Z#MAIN_DOCUM_FRAUD_PRE;
           --дата необходима для логирования времени инсерта  
           d_date_start_ins := sysdate; 
           --
           for rec in (select f.rbo_ac_fin_id from M_ACC_FRAUD_OPER f) loop
               insert into T_RBO_Z#MAIN_DOCUM_FRAUD_PRE
               select md.*
                 from V_RBO_Z#MAIN_DOCUM_PRE@rdwh11 md
                where md.c_acc_dt = rec.rbo_ac_fin_id
                  and md.id > n_max_id_doc_fraud
                  and not exists
                     (select 1 from T_RBO_Z#MAIN_DOCUM_FRAUD_PRE where id = md.id);
               insert into T_RBO_Z#MAIN_DOCUM_FRAUD_PRE
               select md.*
                 from V_RBO_Z#MAIN_DOCUM_PRE@rdwh11 md
                where md.c_acc_kt = rec.rbo_ac_fin_id
                  and md.id > n_max_id_doc_fraud
                  and not exists
                     (select 1 from T_RBO_Z#MAIN_DOCUM_FRAUD_PRE where id = md.id);
               commit;
           end loop;
           --логирование
          pkg_update_util.log_upd(vObject => s_mview_name,
                                  vStrDate => d_date_start_ins);
          pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
         exception
           when others then
             pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
             if rec.is_critical = 1 then
                s_error_message := substr(sqlerrm,1,2000);
                raise e_user_exception;                  
             else  
                log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                          in_error_code    => sqlcode,
                          in_error_message => sqlerrm,
                          in_object_type   => s_mview_name,
                          in_object_id     => null);
             end if;             

         end;                        
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_RBO_Z#MAIN_DOCUM_FRAUD' then   
           begin
            --execute immediate 'truncate table T_RBO_Z#MAIN_DOCUM_FRAUD';
            --
            --вставка данные по операциям 1860 мошенн
            --дата необходима для логирования времени инсерта  
            d_date_start_ins := sysdate; 
            --
            for rec in (select id, c_quit_doc from T_RBO_Z#MAIN_DOCUM_FRAUD_PRE t) loop  
            insert into T_RBO_Z#MAIN_DOCUM_FRAUD
            select *
              from V_RBO_Z#MAIN_DOCUM_PRE@rdwh11 md
             where c_quit_doc = rec.id
               and not exists
                   (select 1 from T_RBO_Z#MAIN_DOCUM_FRAUD where id = md.id)
            union
            select *
              from V_RBO_Z#MAIN_DOCUM_PRE@rdwh11 md
             where id = nvl(rec.c_quit_doc,0) 
               and not exists
                   (select 1 from T_RBO_Z#MAIN_DOCUM_FRAUD where id = md.id)
            union 
            select *
              from V_RBO_Z#MAIN_DOCUM_PRE@rdwh11 md
             where id = rec.id
               and not exists
                   (select 1 from T_RBO_Z#MAIN_DOCUM_FRAUD where id = md.id);
            commit;
            end loop;
            ----вставка данные по операциям 1860 вандализм
            select nvl(max(id),0)
              into n_max_id_doc_fraud
              from T_RBO_Z#MAIN_DOCUM_FRAUD
             where c_acc_dt in (select af.id
                                  from T_RBO_Z#AC_FIN af
                                  join V_RBO_Z#PL_USV pu on pu.id = af.c_main_usv
                                 where substr(pu.c_num,1,4) = '1860' 
                                   and upper(af.c_name) like '%ВАНД%' 
                                   and af.c_acc_summary is not null)
                or c_acc_kt in (select af.id
                                  from T_RBO_Z#AC_FIN af
                                  join V_RBO_Z#PL_USV pu on pu.id = af.c_main_usv
                                 where substr(pu.c_num,1,4) = '1860' 
                                   and upper(af.c_name) like '%ВАНД%' 
                                   and af.c_acc_summary is not null);
             for rec in (select af.id
                           from T_RBO_Z#AC_FIN af
                           join V_RBO_Z#PL_USV pu on pu.id = af.c_main_usv
                          where substr(pu.c_num,1,4) = '1860' 
                            and upper(af.c_name) like '%ВАНД%' 
                            and af.c_acc_summary is not null) loop  
              insert into T_RBO_Z#MAIN_DOCUM_FRAUD
              select id,
                     state_id,
                     c_document_date,
                     c_sum_nt,
                     c_quit_doc,
                     c_sum,
                     c_rate_dt,
                     c_sum_po,
                     c_rate_kt,
                     c_vid_doc,
                     c_valuta,
                     c_valuta_po,
                     c_acc_dt,
                     c_acc_kt,
                     c_date_doc,
                     c_date_prov,
                     c_document_user,
                     c_nazn,
                     c_prov_user 
                from s02.z#main_docum@rdwh_exd
               where c_acc_dt = rec.id
                 and id > n_max_id_doc_fraud;  
              commit;      
              insert into T_RBO_Z#MAIN_DOCUM_FRAUD
              select id,
                     state_id,
                     c_document_date,
                     c_sum_nt,
                     c_quit_doc,
                     c_sum,
                     c_rate_dt,
                     c_sum_po,
                     c_rate_kt,
                     c_vid_doc,
                     c_valuta,
                     c_valuta_po,
                     c_acc_dt,
                     c_acc_kt,
                     c_date_doc,
                     c_date_prov,
                     c_document_user,
                     c_nazn,
                     c_prov_user 
                from s02.z#main_docum@rdwh_exd
               where c_acc_kt = rec.id
                 and id > n_max_id_doc_fraud;  
             commit; 
            end loop;
            --логирование
            pkg_update_util.log_upd(vObject => s_mview_name,
                                    vStrDate => d_date_start_ins);
            pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
         exception
           when others then
             pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
             if rec.is_critical = 1 then
                s_error_message := substr(sqlerrm,1,2000);
                raise e_user_exception;                  
             else  
                log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                          in_error_code    => sqlcode,
                          in_error_message => sqlerrm,
                          in_object_type   => s_mview_name,
                          in_object_id     => null);
             end if;             

         end;
         
          -----------------------GBQ-------------------------------------
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_CONTENT_INFO' then  
          begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_CONTENT_INFO; 
           
             insert into T_GBQ_CONTENT_INFO
             select *
             from GBQ.GBQ_CONTENT_INFO@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end; 
      elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_TRANSACTION' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_TRANSACTION; 
           
             insert into T_GBQ_TRANSACTION
             select *
             from GBQ.GBQ_TRANSACTION@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end; 
         elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_CUSTOM_DIMENSIONS' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_CUSTOM_DIMENSIONS; 
           
             insert into T_GBQ_CUSTOM_DIMENSIONS
             select *
             from GBQ.GBQ_CUSTOM_DIMENSIONS@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;  
        
       elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_CUSTOM_METRICS' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_CUSTOM_METRICS; 
           
             /*insert into T_GBQ_CUSTOM_METRICS
             select *
             from GBQ.GBQ_CUSTOM_METRICS@KSVISIT
             where id > n_max_id;
             commit;*/
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;  
         
         elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_CUSTOM_METRICS' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_CUSTOM_METRICS; 
           
             /*insert into T_GBQ_CUSTOM_METRICS
             select *
             from GBQ.GBQ_CUSTOM_METRICS@KSVISIT
             where id > n_max_id;
             commit;*/
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;  
             
       elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_DEVICE' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_DEVICE; 
           
             /*insert into T_GBQ_DEVICE
             select *
             from GBQ.GBQ_DEVICE@KSVISIT
             where id > n_max_id;*/
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;  
                         
       elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_DEVICE' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_DEVICE; 
           
             /*insert into T_GBQ_DEVICE
             select *
             from GBQ.GBQ_DEVICE@KSVISIT
             where id > n_max_id;*/
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;  
        
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_ECOMMERCE_ACTION' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_ECOMMERCE_ACTION; 
           
             insert into T_GBQ_ECOMMERCE_ACTION
             select *
             from GBQ.GBQ_ECOMMERCE_ACTION@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;  
        
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_GEO' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_GEO; 
           
             insert into T_GBQ_GEO
             select *
             from GBQ.GBQ_GEO@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;  
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_PRODUCT' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_PRODUCT; 
           
             insert into T_GBQ_PRODUCT
             select *
             from GBQ.GBQ_PRODUCT@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;            
           end;
       elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_SOCIAL' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_SOCIAL; 
           
             insert into T_GBQ_SOCIAL
             select *
             from GBQ.GBQ_SOCIAL@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;  
         elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_TRAFFIC' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_TRAFFIC; 
           
             insert into T_GBQ_TRAFFIC
             select id,
                    hit_id,
                    cast(referral_path as varchar2(4000)) as referral_path,
                    campaign,
                    source,
                    medium,
                    keyword,
                    ad_content,
                    campaign_id,
                    gcl_id,
                    dcl_id,
                    idate             
             from GBQ.GBQ_TRAFFIC@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;   
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_PAGE' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_PAGE; 
           
             insert into T_GBQ_PAGE
             select *
             from GBQ.GBQ_PAGE@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;          
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_PROMOTION' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_PROMOTION; 
           
             insert into T_GBQ_PROMOTION
             select *
             from GBQ.GBQ_PROMOTION@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;     
  elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_APP_INFO' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_APP_INFO; 
           
             insert into T_GBQ_APP_INFO
             select *
             from GBQ.GBQ_APP_INFO@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;    
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_EXCEPTION_INFO' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_EXCEPTION_INFO; 
           
             insert into T_GBQ_EXCEPTION_INFO
             select *
             from GBQ.GBQ_EXCEPTION_INFO@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;    
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_EVENT_INFO' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_EVENT_INFO; 
           
             insert into T_GBQ_EVENT_INFO
             select *
             from GBQ.GBQ_EVENT_INFO@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_TIMING_INFO' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_TIMING_INFO; 
           
             insert into T_GBQ_TIMING_INFO
             select *
             from GBQ.GBQ_TIMING_INFO@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;    
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ;            
             
             insert into T_GBQ
              select id,
                    hit_id,
                    user_id,
                    user_phone,
                    user_email,
                    client_id,
                    tracking_id,
                    hit_date,
                    hit_hour,
                    hit_minute,
                    hit_time,
                    queue_time,
                    is_secure,
                    is_interaction,
                    currency,
                    cast (referer as varchar2(4000)),
                    data_source,
                    hit_type,
                    idate
             from GBQ.GBQ@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;               
        elsif rec.object_type = 'TABLE' and rec.object_name = 'T_GBQ_CUSTOM_GROUPS' then   
         begin 
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_CUSTOM_GROUPS; 
           
             insert into T_GBQ_CUSTOM_GROUPS
             select *
             from GBQ.GBQ_CUSTOM_GROUPS@KSVISIT
             where id > n_max_id;
             commit;
                --логирование
              pkg_update_util.log_upd(vObject => s_mview_name,
                                      vStrDate => d_date_start_ins);
              pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 0);
           exception
             when others then
               pkg_update_util.log_mv_refresh(vLog_det, s_mview_name, 1); 
               if rec.is_critical = 1 then
                  s_error_message := substr(sqlerrm,1,2000);
                  raise e_user_exception;                  
               else  
                  log_error(in_operation     => 'pkg_weekly_update.'||p_proc_name,
                            in_error_code    => sqlcode,
                            in_error_message => sqlerrm,
                            in_object_type   => s_mview_name,
                            in_object_id     => null);
               end if;             

            end;                                                                                                       
        end if;   
    end loop;      
   -- событие окончания процесса
   put_event(p_proc_name||'_COMPLETE');
  
    -- окончание журнализации

    update weekly_update_log l
       set l.p_end       = systimestamp,
           l.p_status    = 'COMPLETE',
           l.p_detail    = vLog_det,
           l.p_total_min = pkg_update_util.get_proc_time(l.p_begin, systimestamp)
     where l.id = vLog_id;
    commit;

exception
  when e_user_exception then
    log_error(in_operation => 'pkg_weekly_update.'||p_proc_name,
              in_error_code => '-99999',
              in_error_message => s_error_message,
              in_object_type => s_mview_name);
     --         
     pkg_mail.add_email(in_email_code => p_email_code_err,
                       in_email_body => 'Остановлен процесс pkg_weekly_update.'||p_proc_name||'. '||s_error_message||'. Объект '||s_mview_name,
                       in_email_subject => 'ERROR');  
  when others then
     log_error(in_operation => 'pkg_weekly_update.'||p_proc_name,
               in_error_code => sqlcode,
               in_error_message => sqlerrm||' '||dbms_utility.format_error_backtrace,
               in_object_type   => s_mview_name);
     --    
     pkg_mail.add_email(in_email_code => p_email_code_err,
                       in_email_body => 'Остановлен процесс pkg_weekly_update.'||p_proc_name||'. '||s_error_message||'. Объект '||s_mview_name,
                       in_email_subject => 'ERROR');  
end recalc_weekrdwh;
-------------------------------------------------------------------------------------------
end PKG_WEEKLY_UPDATE;
/

