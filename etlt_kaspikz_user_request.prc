create or replace procedure u1.ETLT_KASPIKZ_USER_REQUEST
 is
 vStrDate date := sysdate;
 s_mview_name     varchar2(30) := 'T_KASPIKZ_USER_REQUEST';
 d_src_commit_date_load date;
 d_src_commit_date_last date;
  begin
       select max(src_commit_date)
        into d_src_commit_date_load
        from s37.s$LOG_HTTPREQUEST@rdwh_exd;

      select last_date-10/24/60/60
        into d_src_commit_date_last
        from T_RDWH_INCREMENT_TABLES_LOAD
       where object_name = s_mview_name;


        delete from T_KASPIKZ_USER_REQUEST
         where log_http_request_id in (select id from U1.T_S37_S$LOG_HTTPREQUEST);

    insert into T_KASPIKZ_USER_REQUEST
    select /*+ parallel(30)*/
           distinct
           ua.rfo_id as rfo_client_id, ua.last_name||' '||ua.first_name as client_name, ua.inn as client_inn,  ua.is_blocked,
           u.wrong_auth_tries, u.reg_date,
           hr.user_id,
           kl.login_val_prev as login_val,
           kl.change_date,
           kl.is_disabled,
           coalesce(us.user_id_fact, hr.user_id) as user_id_pre,
           coalesce(us.login_val, kl.login_val_prev)  as login_val_pre,
           case when substr(hr.nc_client_ip,1,1) in ('1','2','3','4','5','6','7','8','9','0','A','B','C','D','E','F') then
           trim(to_char(replace(replace(replace(replace(replace(replace(substr(hr.nc_client_ip,1,1),'A',10),'B',11),'C',12),'D',13),'E',14),'F',15)*16 + replace(replace(replace(replace(replace(replace(substr(hr.nc_client_ip,2,1),'A',10),'B',11),'C',12),'D',13),'E',14),'F',15),'999')) || '.' ||
           trim(to_char(replace(replace(replace(replace(replace(replace(substr(hr.nc_client_ip,3,1),'A',10),'B',11),'C',12),'D',13),'E',14),'F',15)*16 + replace(replace(replace(replace(replace(replace(substr(hr.nc_client_ip,4,1),'A',10),'B',11),'C',12),'D',13),'E',14),'F',15),'999')) || '.' ||
           trim(to_char(replace(replace(replace(replace(replace(replace(substr(hr.nc_client_ip,5,1),'A',10),'B',11),'C',12),'D',13),'E',14),'F',15)*16 + replace(replace(replace(replace(replace(replace(substr(hr.nc_client_ip,6,1),'A',10),'B',11),'C',12),'D',13),'E',14),'F',15),'999')) || '.' ||
           trim(to_char(replace(replace(replace(replace(replace(replace(substr(hr.nc_client_ip,7,1),'A',10),'B',11),'C',12),'D',13),'E',14),'F',15)*16 + replace(replace(replace(replace(replace(replace(substr(hr.nc_client_ip,8,1),'A',10),'B',11),'C',12),'D',13),'E',14),'F',15),'999')) end as nc_client_ip_dec,
           hr.security_tag_id,
           ls.device_id,
           tb.id as user_agent_id,
           tb.user_agent,
           hr.session_id,
           hr.date_start,
           ss.start_time,
           ss.last_act_time,
           ss.close_time,
           ss.is_valid,
           hr.nc_client_ip,
           hr.id as log_http_request_id  from u1.M_KASPIKZ_USERS_ALL ua
      join u1.M_KASPIKZ_USERS     u on u.id = ua.user_id       --не поняла зачем я так делаю
      join u1.M_KASPIKZ_LOGINS    kl on kl.user_id = ua.user_id
      join u1.T_KASPIKZ_LOG_HTTP_REQUEST hr on hr.user_id = ua.user_id
      left join u1.M_KASPIKZ_USER_CHANGE_LOGIN us on us.user_id_calc = hr.user_id
                                                         and coalesce(us.login_date_begin,to_date('01-01-1900','dd-mm-yyyy')) <= hr.date_start
                                                         and us.login_date_end >= hr.date_start
      left join u1.M_KASPIKZ_LOG_SECURITYTAG  ls on ls.id = hr.security_tag_id
      join u1.T_KASPIKZ_LOG_USER_AGENT   tb on tb.id = hr.user_agent_id
      join u1.M_KASPIKZ_SESSIONS         ss on ss.id = hr.session_id
        where hr.id in (select id from U1.T_S37_S$LOG_HTTPREQUEST);
        commit;
            --сохраняем информацию о послeдней загрузке
        update t_rdwh_increment_tables_load
           set last_date = d_src_commit_date_load
         where object_name = s_mview_name;
        commit;

 end ETLT_KASPIKZ_USER_REQUEST;
 --
/

