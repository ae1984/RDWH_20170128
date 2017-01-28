create or replace procedure u1.ETLT_KASPIKZ_LOG_HTTP_REQUEST
 is
 vStrDate date := sysdate;
 s_mview_name     varchar2(30) := 'T_KASPIKZ_LOG_HTTP_REQUEST';
 d_src_commit_date_load date;
 d_src_commit_date_last date;
  begin
      select max(src_commit_date)
        into d_src_commit_date_load
        from s37.s$LOG_HTTPREQUEST@rdwh_exd;

          dbms_output.put_line('d_src_commit_date_load= '||to_char(d_src_commit_date_load,'dd-mm-yyy hh24:mi:ss'));

      select last_date-10/24/60/60
        into d_src_commit_date_last
        from t_rdwh_increment_tables_load
       where object_name = s_mview_name;

        dbms_output.put_line('d_src_commit_date_last= '||to_char(d_src_commit_date_last,'dd-mm-yyy hh24:mi:ss'));

       delete from T_S37_S$LOG_HTTPREQUEST;
       commit;

       insert into T_S37_S$LOG_HTTPREQUEST
       select distinct id
         from s37.s$LOG_HTTPREQUEST@rdwh_exd
        where src_commit_date between d_src_commit_date_last and d_src_commit_date_load
          and row_status = 'I';
       commit;

        delete from T_KASPIKZ_LOG_HTTP_REQUEST
         where id in (select id from T_S37_S$LOG_HTTPREQUEST);

        insert into T_KASPIKZ_LOG_HTTP_REQUEST
        select t.id as id,
          t.Method as method,
          t.RefererId as referer_id,
          t.UriID as uri_id,
          t.UserAgentId as user_agent_id,
          t.UserID as user_id,
          t.SessionID as session_id,
          t.AspSessionID as asp_session_id,
          t.TimeStamp as ts,
          t.ProcessTime as process_time,
          t.ServerName as server_name,
          t.RequestTraceGUID as request_trace_guid,
          t.ClientIP as client_ip,
          t.NSClientIP as nc_client_ip,
          t.RawUriID as raw_uri_id,
          t.ActualUriId as actual_uri_id,
          cast(substr(t.RequestParameters,1,2000) as varchar2(4000)) request_parameters,
          t.SecurityTagId
          from s37.LOG_HTTPREQUEST@rdwh_exd t
        where id in (select distinct id
                       from s37.s$LOG_HTTPREQUEST@rdwh_exd
                      where src_commit_date between d_src_commit_date_last and d_src_commit_date_load
                        and row_status = 'I');
        commit;
        --сохраняем информацию о послeдней загрузке
        update t_rdwh_increment_tables_load
           set last_date = d_src_commit_date_load
         where object_name = s_mview_name;
        commit;


 end ETLT_KASPIKZ_LOG_HTTP_REQUEST;
/

