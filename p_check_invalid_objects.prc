create or replace procedure u1.P_CHECK_INVALID_OBJECTS
as
--процедура по проверке инвалидных объектов после каких-либо доработок
v_sql          varchar2(4000);
n_tmp          number;
vCode          email_code.code%type;
vEmailSubjesct email_code.email_subject%type;
vMessage       varchar2(4000);
v_object_id    number;
begin
 v_object_id := error_log_id_seq.nextval;
for rec in (select 'alter ' || o.object_type || ' ' || o.object_name ||
                       ' compile' as sql_t, o.object_name, po.load_group, o.object_type
              from user_objects o
              left join t_rdwh_proc_object po on po.object_name = o.object_name
                                             and po.is_used = 1
             where   o.status = 'INVALID'
                     and o.object_type = 'VIEW'
                or (o.object_type = 'MATERIALIZED VIEW'
                   and po.object_name is not null
                   and po.object_name != 'M_CLIENT_DRAW_DOWN')

             order by object_name) loop
   begin
    --комипиляция
    v_sql := rec.sql_t;
    execute immediate v_sql;
   exception
    when others then
    log_error(in_operation => 'check_error',
              in_error_code => sqlcode,
              in_error_message => 'Ошибка компиляции:'||sqlerrm,
              in_object_type => rec.object_type||' '||rec.object_name,
              in_object_id => v_object_id,
              in_send_bool => 0);
   end;
   --проверяем ошибки по dba_error
   select count(1) into n_tmp from dba_errors where owner = 'U1' and name = rec.object_name;
   if n_tmp > 0 then
      --отправка сообщения
      log_error(in_operation => 'check_error',
                in_error_code => '-1000',
                in_error_message => 'Объект инвалидный',
                in_object_type => rec.object_type||' '||rec.object_name,
                in_object_id => v_object_id,
                in_send_bool => 0);
   end if;
   ----проверяем что отсутсвуют связи в dba_dependencies(что означает ошибка)
   select count(1) into n_tmp from dba_dependencies where owner = 'U1' and name = rec.object_name;
   if n_tmp = 0 and nvl(rec.load_group,'LOAD') not like '%LOAD%' then
      --отправка сообщения
      log_error(in_operation => 'check_error',
                in_error_code => '-1000',
                in_error_message => 'У объекта отсутствуют подчиненные объекты',
                in_object_type => rec.object_type||' '||rec.object_name,
                in_object_id => v_object_id,
                in_send_bool => 0);
   end if;
end loop;
--проверяем ошибки по пакетам, функциям и процедурам
for rec in (select 'alter ' || type || ' ' || name ||
                   ' compile' as sql_t, name, type
              from dba_errors
             where owner = 'U1'
               and type in ('TRIGGER','PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')
            union
            select 'alter ' || object_type || ' ' || object_name ||
                   ' compile' as sql_t, object_name, object_type
              from dba_objects
             where owner = 'U1'
               and status != 'VALID'
               and object_type in ('TRIGGER','PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')) loop
   --сначала компиляция
   begin
    --комипиляция
    v_sql := rec.sql_t;
    execute immediate v_sql;
   exception
    when others then
    log_error(in_operation => 'check_error',
              in_error_code => sqlcode,
              in_error_message => 'Ошибка компиляции:'||sqlerrm,
              in_object_type => rec.type||' '||rec.name,
              in_object_id => v_object_id,
              in_send_bool => 0);
   end;
end loop;
for rec in (select distinct type ||' '||name as object_name
              from dba_errors
             where owner = 'U1'
               and type in ('TRIGGER','PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')
            union
            select object_type||' '||object_name as object_name
              from dba_objects
             where owner = 'U1'
               and status != 'VALID'
               and object_type in ('TRIGGER','PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')) loop
   log_error(in_operation => 'check_error',
                in_error_code => '-1000',
                in_error_message => 'Объект инвалидный',
                in_object_type => rec.object_name,
                in_object_id => v_object_id,
                in_send_bool => 0);
end loop;
--собираем все полученные ошибки и отправляем письмо
--если ошибок нет, то отправляем письмо с соответвующем текстом
select c.code,
       c.email_subject
  into vCode,
       vEmailSubjesct
  from email_code c
 where c.code = 'RDWH_OBJECT_ERR';
select count(1)
  into n_tmp
  from error_log
 where lower(operation) = 'check_error'
   and trunc(err_date) = trunc(sysdate)
   and object_id = v_object_id;
if n_tmp = 0 then
   --ошибок нет
   -- Получение сообщения
    vMessage := 'В базе RDWH отсутствуют инвалидные объекты.';
    -- Запуск пакета
    pkg_mail.add_email( in_email_code => vCode,
                        in_email_body => vMessage,
                        in_email_subject => vEmailSubjesct );
else
  -- Получение сообщения
    select listagg(object_type||chr(9)||err_message,chr(10)) within group (order by length(object_type),object_type)
      into vMessage
      from error_log
     where lower(operation) = 'check_error'
       and trunc(err_date) = trunc(sysdate)
       and object_id = v_object_id;
    vMessage := 'В базе RDWH существуют инвалидные объекты:'||chr(10)||vMessage;
    -- Запуск пакета
    pkg_mail.add_email( in_email_code => vCode,
                        in_email_body => vMessage,
                        in_email_subject => vEmailSubjesct );
end if;
end;
/

