create or replace procedure u1.NPRC_ETL_SEND_MSG2 is
       v_msg varchar2(2000);
       v_i number;
       v_cnt number;
begin
    v_msg:='Ежедневный пересчет не окончен. По следующим объектам пересчет не завершен:'||chr(10)||chr(10);
    v_i:=0;
    select count(1) into v_cnt
    from NT_RDWH_PROC_OBJECT_HIST t
    left join update_log l on l.object_name=t.object_name and l.begin_refresh>=trunc(sysdate) and  l.status='OK'
    where t.sdt>=trunc(sysdate)-1 and t.type_load='DAILY' and t.is_used=1 and t.proc_name<>'JOB' and l.id is null ;
    
            
    for rec in (
            select t.object_name||chr(10) as txt
            from NT_RDWH_PROC_OBJECT_HIST t
            left join update_log l on l.object_name=t.object_name and l.begin_refresh>=trunc(sysdate) and  l.status='OK'
            where t.sdt>=trunc(sysdate)-1 and t.type_load='DAILY' and t.is_used=1 and t.proc_name<>'JOB' and l.id is null and rownum<=30
    ) loop
       v_msg:=v_msg||rec.txt;
       v_i:=v_i+1;
    end loop;
    
    if v_cnt>30 then
      v_msg:=v_msg||chr(10)||'+ ещё '||to_char(v_cnt-30)||' объектов'||chr(10);
    end if;
    
    if v_i<=0 then v_msg:='Ежедневный пересчет окончен. Детали: select * from u1.NV_DAILY_UPDATE_LOG'; 
    end if;
    
      -- dbms_output.put_line(v_msg);
       pkg_mail.add_email(in_email_code =>'RDWH_DAILY_UPD_UAMR' /*'RDWH_DAILY_ERR'*/,
                                          --'TEST',
                        in_email_body => substr(v_msg,1,2000),
                        in_email_subject => 'ETL_DAILY');            

    
end NPRC_ETL_SEND_MSG2;
/

