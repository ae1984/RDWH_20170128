create or replace procedure u1.NPRC_SEND_ERROR_2MAIL is
    v_sec number;
    v_cnt number;
begin
   /*ошибки,которые сами собой не решатся*/
   select (sysdate - max(ins_dt)) *24*60*60 into v_sec from NT_TASKS_EXECUTE t;
   if v_sec>=3600 then
     u1.log_error (in_operation => 'U1.NJOB_TASKS_CREATE',
                   in_error_code => null,
                   in_error_message => 'U1.NJOB_TASKS_CREATE перестал отрабатывать и добавлять задачи на исполнение в NT_TASKS_EXECUTE',
                   in_object_type => 'JOB',
                   in_object_id => null);

    pkg_mail.add_email(in_email_code => 'RDWH_OBJECT_ERR',
                       in_email_body => 'Очень критично! U1.NJOB_TASKS_CREATE перестал отрабатывать и добавлять задачи на исполнение в NT_TASKS_EXECUTE'||
                                        'Время простоя: '||to_char(round(v_sec/60))||' минут',
                       in_email_subject => 'PEP');

    NPRC_TASKS_CREATE;
   end if;
  /**/

  for rec in (
    select object_name, max(id) as id
    from NT_TASKS_EXECUTE t
    where t.ins_dt >=trunc(sysdate)--2
         and t.task_name like 'DAILY_%'
         and t.status = 'FAILED'
         and t.send_mail is null
         and t.object_name not in (select object_name from NV_NEW_RDWH_PROC_OBJECTS)
    group by  object_name
    having count(*) > 120) loop

     u1.log_error (in_operation => 'DAILY. '||rec.object_name,
                   in_error_code => null,
                   in_error_message => 'Ошибка в ежедневном пересчете! Детали: select * from NT_TASKS_EXECUTE where id='||to_char(rec.id),
                   in_object_type => '',
                   in_object_id => null);

     pkg_mail.add_email(in_email_code => 'RDWH_OBJECT_ERR',
                        in_email_body => 'Ошибка в ежедневном пересчете! Проблема с объектом '||rec.object_name
                                         ||'. Детали: select * from NT_TASKS_EXECUTE where id='||to_char(rec.id),
                        in_email_subject => 'ETL_DAILY');

     update NT_TASKS_EXECUTE
        set send_mail=sysdate
     where ins_dt >=trunc(sysdate) and status = 'FAILED' and object_name=rec.object_name;
     commit;
     --dbms_output.put_line(rec.object_name);
  end loop;

  if to_number(to_char(sysdate, 'HH24MI'))>620 then
      for rec in (
        select t.object_name, max(t.id) as id
        from NT_TASKS_EXECUTE t
        left join NT_TASKS_EXECUTE a on a.object_name=t.object_name and a.task_end>=trunc(sysdate) and a.status='COMPLETED'
        where t.ins_dt >=trunc(sysdate)--2
             and t.task_name like 'DAILY_%'
             and t.status = 'FAILED'
             and t.send_mail is null
             and a.id is null
             and t.object_name not in (select object_name from NV_NEW_RDWH_PROC_OBJECTS)
        group by  t.object_name
        having count(*) > 10
      ) loop

         u1.log_error (in_operation => 'DAILY. '||rec.object_name,
                       in_error_code => null,
                       in_error_message => 'Ошибка в ежедневном пересчете! Детали: select * from NT_TASKS_EXECUTE where id='||to_char(rec.id),
                       in_object_type => '',
                       in_object_id => null);

         pkg_mail.add_email(in_email_code => 'RDWH_OBJECT_ERR',
                            in_email_body => 'Ошибка в ежедневном пересчете! Проблема с объектом '||rec.object_name
                                             ||'. Детали: select * from NT_TASKS_EXECUTE where id='||to_char(rec.id),
                            in_email_subject => 'ETL_DAILY');

         update NT_TASKS_EXECUTE
            set send_mail=sysdate
         where ins_dt >=trunc(sysdate) and status = 'FAILED' and object_name=rec.object_name;
         commit;
         --dbms_output.put_line(rec.object_name);
      end loop;
  end if;

  if to_number(to_char(sysdate, 'HH24MI')) between 200 and 300 then
      select count(*) into v_cnt
      from NT_TASKS_EXECUTE t
      where
          t.ins_dt >=trunc(sysdate) and t.status='COMPLETED'
          and extract (hour from cast(t.task_start as timestamp)) in (0,1)
          and t.task_name like 'DAILY_%';
      if v_cnt < 250   then
         u1.log_error (in_operation => 'DAILY. ',
                       in_error_code => null,
                       in_error_message => 'Ошибка в ежедневном пересчете! По плану должно к 2 ночи быть рассчитано >400 объектов',
                       in_object_type => '',
                       in_object_id => null);

         pkg_mail.add_email(in_email_code => 'RDWH_OBJECT_ERR',
                            in_email_body => 'Ошибка в ежедневном пересчете!  '
                                             ||'По плану должно к 2 ночи быть рассчитано >400 объектов',
                            in_email_subject => 'ETL_DAILY');
      end if;
  end if;

  if to_number(to_char(sysdate, 'HH24MI')) between 300 and 400 then
      select count(*) into v_cnt
      from NT_TASKS_EXECUTE t
      where
          t.ins_dt >=trunc(sysdate) and t.status='COMPLETED'
          and extract (hour from cast(t.task_start as timestamp)) in (0,1,2)
          and t.task_name like 'DAILY_%';
      if v_cnt < 350   then
         u1.log_error (in_operation => 'DAILY. ',
                       in_error_code => null,
                       in_error_message => 'Ошибка в ежедневном пересчете! По плану должно к 3 ночи быть рассчитано >550 объектов',
                       in_object_type => '',
                       in_object_id => null);

         pkg_mail.add_email(in_email_code => 'RDWH_OBJECT_ERR',
                            in_email_body => 'Ошибка в ежедневном пересчете!  '
                                             ||'По плану должно к 3 ночи быть рассчитано >550 объектов',
                            in_email_subject => 'ETL_DAILY');
      end if;
  end if;



  if to_number(to_char(sysdate, 'HH24MI')) between 700 and 800 then
      select count(*) into v_cnt
      from NT_TASKS_EXECUTE t
      where
          t.ins_dt >=trunc(sysdate) and t.status='COMPLETED'
          and extract (hour from cast(t.task_start as timestamp)) in (0,1,2,3,4,5,6)
          and t.task_name like 'DAILY_%';
      if v_cnt < 600   then
         u1.log_error (in_operation => 'DAILY. ',
                       in_error_code => null,
                       in_error_message => 'Ошибка в ежедневном пересчете! По плану должно к 7 утра быть рассчитано >900 объектов',
                       in_object_type => '',
                       in_object_id => null);

         pkg_mail.add_email(in_email_code => 'RDWH_OBJECT_ERR',
                            in_email_body => 'Ошибка в ежедневном пересчете!  '
                                             ||'По плану должно к 7 утра быть рассчитано >900 объектов',
                            in_email_subject => 'ETL_DAILY');
      end if;
  end if;

  /*ошибки, которые сами собой не решатся*/
  for rec in (
        select t.object_name, max(t.id) as id
           , case
               when t.err like '%invalid username/password; logon denied%' then 'invalid username/password; logon denied'
               when t.err like '%the password has expired%' then 'the password has expired'
               when t.err like '%the account is locked%' then 'the account is locked'
               when t.err like '%index%or partition of such index is in unusable state%' then 'index or partition of such index is in unusable state'
             end as err1
        from NT_TASKS_EXECUTE t
        left join NT_TASKS_EXECUTE a on a.object_name=t.object_name and a.task_end>=trunc(sysdate) and a.status='COMPLETED'
        where t.ins_dt >=trunc(sysdate)--2
             and t.task_name like 'DAILY_%'
             and t.object_name not in (select object_name from NV_NEW_RDWH_PROC_OBJECTS)
             and t.status = 'FAILED'
             and (
                t.err like '%invalid username/password; logon denied%'
                or t.err like '%the password has expired%'
                or t.err like '%the account is locked%'
                or t.err like '%index%or partition of such index is in unusable state%'
             )
             and t.send_mail is null
             and a.id is null
        group by  t.object_name  ,
             case
               when t.err like '%invalid username/password; logon denied%' then 'invalid username/password; logon denied'
               when t.err like '%the password has expired%' then 'the password has expired'
               when t.err like '%the account is locked%' then 'the account is locked'
               when t.err like '%index%or partition of such index is in unusable state%' then 'index or partition of such index is in unusable state'
             end
        having count(*) > 2
  ) loop

     u1.log_error (in_operation => 'DAILY. '||rec.object_name,
                   in_error_code => null,
                   in_error_message => 'Ошибка в ежедневном пересчете! '||rec.err1||'. Детали: select * from NT_TASKS_EXECUTE where id='||to_char(rec.id),
                   in_object_type => '',
                   in_object_id => null);

     pkg_mail.add_email(in_email_code => 'RDWH_OBJECT_ERR',
                        in_email_body => 'Ошибка в ежедневном пересчете! '||rec.err1||'. Проблема с объектом '||rec.object_name
                                         ||'. Детали: select * from NT_TASKS_EXECUTE where id='||to_char(rec.id),
                        in_email_subject => 'ETL_DAILY');

     update NT_TASKS_EXECUTE
        set send_mail=sysdate
     where ins_dt >=trunc(sysdate) and status = 'FAILED' and err like '%'||rec.err1||'%' and object_name=rec.object_name;
     commit;
     --dbms_output.put_line(rec.object_name);
  end loop;




end NPRC_SEND_ERROR_2MAIL;
/

