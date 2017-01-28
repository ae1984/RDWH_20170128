create or replace procedure u1.fill_sessions_active_hist_TST as

begin

insert into t_rdwh_sessions_active_hist_TS
(select * from
(select sysdate as s_date, a.osuser as os_usr, a.username as usr, a.sess_cnt as sess, a.sess_used_cnt as sess_used,
       a.sql_start_time, round((sysdate - a.sql_start_time)*60*24,2) as time_min, round(a.seconds_in_wait/60,2) as wait_min,
       (sysdate - a.sql_start_time)*3600*24 as time_sec, a.seconds_in_wait as wait_sec,
       case when a.seconds_in_wait > 0 and (sysdate - a.sql_start_time)*3600*24 - a.seconds_in_wait = 0 then 'LOCKED' else 'OK' end as is_locked,
       /*a.parall_eff,*/
       LISTAGG(st.SQL_TEXT,'') within group (order by st.piece) as sql_text,
       LISTAGG(cu.SQL_TEXT,'') within group (order by null) as sql_text_cursors,
       a.machine, a.sql_id
       ,a.JOB
       ,a.what
       ,a.blocked_objects_list
  from (select s.osuser, s.username,
               count(*) as sess_cnt,
               count(case when s.pga_tunable_mem > 0 then s.SID end) as sess_used_cnt,
               min(s.SQL_EXEC_START) as sql_start_time,
                s.machine,
               /*round(count(case when s.pga_tunable_mem > 0 then s.SID end) /
                          count(*) * 100,1) as parall_eff,*/ s.sql_id,
                          sum(s.seconds_in_wait) as seconds_in_wait
             ,max(dj.JOB) as job
             ,max(dj.what) as what
             ,listagg(do.OBJECT_NAME, ', ') within group (order by do.OBJECT_NAME) as blocked_objects_list
        from sys.v_$session s
        left join dba_jobs_running djr on djr.sid = s.sid
        left join dba_jobs dj on dj.job = djr.job
        left join v$locked_object lo on lo.SESSION_ID = s.SID
        left join dba_objects do on do.OBJECT_ID = lo.OBJECT_ID
        where s.status = 'ACTIVE'
              and s.username = 'RISK_CHDEN'
        group by s.username, s.osuser, s.machine, s.sql_id
        ) a

  left join sys.v_$sqltext st on st.SQL_ID = a.sql_id
                                 and st.PIECE in (0, 1, 2, 3)
  left join (select distinct sql_id, sql_text from sys.v_$open_cursor) cu on cu.sql_id = a.sql_id

  group by a.username, a.osuser, a.sql_id, a.sess_cnt, a.sess_used_cnt,
         a.sql_start_time, /*a.parall_eff,*/ a.machine, a.seconds_in_wait
         , a.what, a.JOB, a.blocked_objects_list
  order by 1, 2, 3 desc));

commit;

end;
/

