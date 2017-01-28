create or replace procedure u1.send_email_j_tmp is
  v_conn utl_smtp.Connection;
--  v_crlf varchar2(4) := '<br>';
  v_crlf varchar2(4) := chr(13)||chr(10);  
  v_tab varchar2(1) := chr(9);  
  v_subject varchar2(300);
  v_message varchar2(2000);
begin

  select 'sessions = ' || nvl(to_char(sum(t.sess)),'0') ||
         '; used = ' || nvl(to_char(sum(t.sess_used)),'0') ||
         '; locked = ' || count(case when t.is_locked = 'LOCKED' then t.sql_id end)
  into v_subject
  from V_SYS_SESSIONS_ACTIVE t
  where t.usr in ('U1','DM','LOADER');

/*  v_message := '<html><head><meta http-equiv=Content-Type content="text/html; charset=koi8-r"></head><body lang=RU>' || --v_crlf ||
               'Date: '   || to_char(systimestamp, 'dd-mm-yyyy hh24:mi:ss.ff') || v_crlf ||
               'From: '   || 'rdwh@kaspibank.kz' || v_crlf ||
               'Subject: '|| v_subject || v_crlf;*/

  v_message := 'Date: '   || to_char(systimestamp, 'dd-mm-yyyy hh24:mi:ss.ff') || v_crlf ||
               'From: '   || 'rdwh@kaspibank.kz' || v_crlf ||
               'Subject: '|| v_subject || v_crlf;

/*  for a in (
        select '<table>' as text from dual union all
        select '<tr><td>'||t.os_usr||'</td><td>'||t.usr||'</td><td>'||t.sess||'</td><td>'||t.sess_used||
               '</td><td>'||t.sql_start_time||'</td><td>'||t.program||'</td><td>'||t.SQL_TEXT||
               '</td><td>'||t.machine||'</td><td>'||t.sql_id||'</td></tr>' as text
        from V_SYS_SESSIONS_ACTIVE t
        union all select '</table></body></html>' as text from dual
    ) loop*/
  
  for a in (
        select 'os_usr'||v_tab||'usr'||v_tab||'sess'||v_tab||'sess_used'||
               v_tab||'sql_start_time'||v_tab||'time_min'||v_tab||'wait_min'||
               v_tab||'program'||
               v_tab||'machine'||v_tab||'sql_id' as text
        from dual union all
        select t.os_usr||v_tab||t.usr||v_tab||t.sess||v_tab||t.sess_used||
               v_tab||to_char(t.sql_start_time,'YYYY-MM-DD hh24:mi:ss')||v_tab||t.time_min||v_tab||t.wait_min||
               v_tab||t.program||v_tab||t.machine||v_tab||t.sql_id||
               case when t.sql_text_cursors is not null then v_crlf||v_tab||'SQL CURSORS:  '||t.sql_text_cursors end || 
               case when t.sql_text is not null then v_crlf||v_tab||'SQL TEXT:  '||t.sql_text end as text
        from V_SYS_SESSIONS_ACTIVE t
    ) loop    
    
    v_message := v_message || a.text || v_crlf || '------------------------' || v_crlf;
    
  end loop;
  
  v_conn := utl_smtp.open_connection('relay2.bc.kz', 25);
  utl_smtp.Helo(v_conn, 'relay2.bc.kz');
  utl_smtp.Mail(v_conn, 'rdwh@kaspibank.kz');
  utl_smtp.Rcpt(v_conn, 'Zhan.Nurgaliyev@kaspibank.kz');
       
  utl_smtp.open_data(c => v_conn);
  utl_smtp.write_data(c => v_conn, data => v_message);
  utl_smtp.close_data(c => v_conn);
  utl_smtp.quit(v_conn);


/*begin
  sys.dbms_scheduler.create_job(job_name            => 'U1.JOB_TMP_JAN_EMAIL_DEBUG',
                                job_type            => 'STORED_PROCEDURE',
                                job_action          => 'send_email_j_tmp',
                                start_date          => sysdate,
                                repeat_interval     => 'Freq=Minutely;Interval=10',
                                end_date            => to_date(null),
                                job_class           => 'DEFAULT_JOB_CLASS',
                                enabled             => true,
                                auto_drop           => false,
                                comments            => '');
end;*/
      
end send_email_j_tmp;
/

