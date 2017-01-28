CREATE OR REPLACE TRIGGER U1.error_log_insert_after
after insert on error_log
for each row
declare 
  vCode           varchar2(100 char);
  vEmailSubjesct  varchar2(100 char);
  vMessage        clob;
  n_cnt_main      number(5):=0;
  n_cnt_mo        number(5):=0;
  n_cnt_out       number(5):=0;
  n_cnt_others    number(5):=0;
begin
  -- Триггер для отправки письма после добавления записи
  -- 20160331_ERROR_LOG_INS -- Kazymbetov_30023
  if :new.send_bool = 1 then -- Код отправки (1 - Отправить)
    -- Получение сообщения
    vMessage := :new.err_message || ' ' || :new.operation || ' ' || :new.object_type || '.';
    begin
      select count(case when is_main_object = '1' then 1 end ) as cnt_main,
         count(case when is_main_object = '2' then 1 end ) as cnt_mo,
         count(case when is_main_object = '3' then 1 end ) as cnt_out,
         count(case when is_main_object is null then 1 end ) as cnt_others
      into n_cnt_main,n_cnt_mo,n_cnt_out,n_cnt_others    
      from(
          select DISTINCT D.NAME,D.IS_MAIN_OBJECT
          from T_RDWH_DEPENDENCIES d
          where d.d_date = trunc(sysdate)
           connect by nocycle prior  d.name = d.REFERENCED_NAME and d.owner = d.REFERENCED_OWNER and d.d_date = trunc(sysdate)
           start with (d.name = :new.object_type OR d.Referenced_Name = :new.object_type)
           );
     exception 
       when others then
       n_cnt_main := 99;
     end;
    if n_cnt_main + n_cnt_mo + n_cnt_out > 0 then
      vCode := 'RDWH_OBJECT_ERR';
      vMessage := vMessage || ' От объекта зависят:';
      if n_cnt_main > 0 then
        vMessage := vMessage||' '||n_cnt_main||' основных объектов,';
      elsif  n_cnt_mo > 0 then
        vMessage := vMessage||' '||n_cnt_mo||' объектов МО,';
      elsif n_cnt_out > 0 then
        vMessage := vMessage||' '||n_cnt_out||' объектов для внешних пользователей,';
      end if;
      vMessage := substr(vMessage,1,length(vMessage)-1)||'.';
      
      
    else 
      vCode := 'RDWH_OBJECT_ERR_2';  
      vMessage := vMessage || ' От объекта зависят '||n_cnt_others||' объектов.';
    end if;
  
  
    select --c.code,
           c.email_subject
      into --vCode,
           vEmailSubjesct
      from email_code c
     where c.code = vCode;
     
    -- Запуск пакета
    pkg_mail.add_email( in_email_code => vCode,
                        in_email_body => vMessage,
                        in_email_subject => vEmailSubjesct );
  end if;
end;
/

