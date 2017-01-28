create or replace procedure u1.NPRC_ETL_SEND_MSG1 is
       v_msg varchar2(2000);
       v_i number;
begin
    v_msg:='У указанных ниже объектов необходимо понизить параллельность до значений не более 30ти на sql-запрос'
         ||chr(10)||chr(10)||chr(10)||'Sql_id; Количество сессий на запрос; Наименование объекта; Кто вносил изменения'||chr(10)||chr(10)||chr(10);
    v_i:=0;
    for rec in (
        select t.sql_id||' ; '|| t.cnt_pses||' ; '|| t.object_name ||' ; '|| t.programmer as msg
        from (
        select t.sql_id, t.cnt_pses, nvl(o.object_name,substr(s.sql_text,1,100)) as object_name
               ,listagg(c.os_user,', ')within group (order by c.cdt desc) as programmer
        from (
            /*select t.sql_id
                ,max(t.cnt_pses) as cnt_pses
            from NT_SQL_MONITOR_HIST t
            where t.sql_exec_start>=trunc(sysdate)
                  and extract (hour from cast(t.sql_exec_start as timestamp) ) in (0,1,2,3,4,5,6,7,8,9)
                  and t.cnt_pses > 61
            group by t.sql_id
            order by min(t.sql_exec_start)*/
            select t.sql_id
                ,max(t.cnt_pses) as cnt_pses
            from NT_SQL_MONITOR_HIST t
            where t.sql_exec_start>=trunc(sysdate)
                  and extract (hour from cast(t.sql_exec_start as timestamp) ) in (0,1,2,3,4,5,6,7,8)
                  and t.cnt_pses > 61
            group by t.sql_id
            union             
            select t.sql_id
                  ,max(cnt_ses) as cnt_pses 
            from NT_SQL_SESSION_COUNT_HIST t
            where t.sdt>=trunc(sysdate)
                  and extract (hour from cast(t.sdt as timestamp) ) in (0,1,2,3,4,5,6,7,8)
                  and t.cnt_ses > 61
                  and t.sql_id is not null
            group by t.sql_id            
        ) t
        join NT_SQLID s on s.sql_id = t.sql_id
        left join all_objects o on o.owner='U1' and upper(substr(s.sql_text,1,100)) like '%"'||o.object_name||'"%'  and o.object_type='MATERIALIZED VIEW'
        left join (
            select t.obj_name,t.os_user ,max(t.change_date) as cdt 
            from (
               select  obj_name,os_user, change_date from NT_RDWH_SCHEMA_CHANGES where os_user<>'ORACLE' and ora_event='CREATE' 
               union 
               select  obj_name,os_user, change_date from NT_RDWH_SCHEMA_CHANGES_HIST where os_user<>'ORACLE' and ora_event='CREATE'
            )t
            group by t.obj_name,t.os_user        
        ) c on c.obj_name=o.object_name
        group by t.sql_id, t.cnt_pses, nvl(o.object_name,substr(s.sql_text,1,100))
        ) t   
        where rownum<=15
        order by t.cnt_pses desc
    ) loop
       v_msg:=v_msg||rec.msg||chr(10)||chr(10);
       v_i:=v_i+1;
    end loop;
    v_msg:=v_msg||chr(10)||chr(10)||'Полный текст SQL-запроса: select * from u1.NT_SQLID t where t.sql_id=<id запроса>';
    if v_i>0 then
      -- dbms_output.put_line(v_msg);
       pkg_mail.add_email(in_email_code =>'RDWH_DAILY_ERR',
                                          --'TEST',
                        in_email_body => v_msg,
                        in_email_subject => 'ETL_DAILY');            
    end if;
end NPRC_ETL_SEND_MSG1;
/

