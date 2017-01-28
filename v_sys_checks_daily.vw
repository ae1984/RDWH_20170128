create or replace force view u1.v_sys_checks_daily as
select 17 as n, 'KAS_NB_TAXPAYER - ACTUALITY <= 3 days' as test_name,
      case when trunc(sysdate) - x.test_value <= 3 then 'OK' else 'NOK' end as test_result,
      to_char(x.test_value,'yyyy-mm-dd') as test_info,
      'MAIN' as test_proc
from (select trunc(max(t.c_date_last_upd)) as test_value from V_RFO_Z#KAS_NB_TAXPAYER t
) x union all
select 2 as n, 'ERROR LOG - ERRORS COUNT TODAY = 0' as test_name,
      case when x.test_value = 0 then 'OK' else 'ERROR' end as test_result,
      'count error today = '||to_char(x.test_value) as test_info,
      'MAIN' as test_proc
from (select count(1) as test_value from ERROR_LOG t where trunc(t.err_date) >= trunc(sysdate) and
                t.operation not in ('pkg_daily_update.check_RFOSNAP_availability','kill_sessions',
                                    'pkg_daily_update_rbo.check_RBOSNAP_availability')
             and t.operation not like '%pkg_monthly_update%'
             and t.operation not like '%pkg_weekly_update%'
) x union all
select 4 as n, 'ERROR LOG - ERRORS COUNT LAST 3 DAYS = 0' as test_name,
      case when x.test_value = 0 then 'OK' else 'NOK' end as test_result,
      'count error last 3 days = '||to_char(x.test_value) as test_info,
      'MAIN' as test_proc
from (select count(1) as test_value from ERROR_LOG t where trunc(t.err_date) >= trunc(sysdate) - 2 and
                t.operation not in ('pkg_daily_update.check_RFOSNAP_availability','kill_sessions',
                                    'pkg_daily_update_rbo.check_RBOSNAP_availability')
                and t.operation not like '%pkg_monthly_update%'
                and t.operation not like '%pkg_weekly_update%'
) x union all
select 5 as n, 'DAILY UPDATE - COMPLETE (19 processes)' as test_name,
      case when x.test_value = 19 then 'OK' else 'ERROR' end as test_result,
      'processes = '||to_char(x.test_value) as test_info,
      'MAIN' as test_proc
from (select count(1) as test_value from DAILY_UPDATE_LOG t
        where trunc(t.p_begin) = trunc(sysdate) and t.p_status = 'COMPLETE'
          and t.proc_type = 'MAIN'
) x union all
select 6 as n, 'DAILY UPDATE PROCESS - NO ERRORS' as test_name,
      case when x.test_value = 0 then 'OK' else 'ERROR' end as test_result,
      'count error process = '||to_char(x.test_value) as test_info,
      'MAIN' as test_proc
from (select count(1) as test_value from DAILY_UPDATE_LOG t
                where trunc(t.p_begin) = trunc(sysdate) and upper(t.p_detail) like '%ERROR%'
) x union all
select 7 as n, 'DAILY UPDATE - FINISH TIME < 08:45' as test_name,
      case when (to_date(to_char(trunc(sysdate),'yyyy-mm-dd')||' 08:45','yyyy-mm-dd hh24:mi') -
            x.test_value) > 0 then 'OK' else 'ERROR' end as test_result,
      to_char(x.test_value,'hh24:mi') as test_info,
      'MAIN' as test_proc
from (select (cast(t.e_timestamp as date)) as test_value from DAILY_UPDATE_EVENT t
                  where trunc(t.e_date) = trunc(sysdate) and event = 'PROCESS_COMPLETE') x
union all
select 8 as n, 'DAILY UPDATE - RFO SNAP READY TIME < 03:00' as test_name,
      case when (to_date(to_char(trunc(sysdate),'yyyy-mm-dd')||' 03:00','yyyy-mm-dd hh24:mi') -
            x.test_value) > 0 then 'OK' else 'NOK' end as test_result,
      to_char(x.test_value,'hh24:mi') as test_info,
      'MAIN' as test_proc
from (select cast(min(ul.e_timestamp) as date) as test_value
        from daily_update_event ul
       where ul.event like 'RFO_SNAP_READY' and ul.e_date = trunc(sysdate)
) x union all
select 9 as n, 'DAILY UPDATE - RFO EXD READY TIME < 03:00' as test_name,
      case when (to_date(to_char(trunc(sysdate),'yyyy-mm-dd')||' 03:00','yyyy-mm-dd hh24:mi') -
            x.test_value) > 0 then 'OK' else 'NOK' end as test_result,
      to_char(x.test_value,'hh24:mi') as test_info,
      'MAIN' as test_proc
from (select cast(min(ul.e_timestamp) as date) as test_value
        from daily_update_event ul
       where ul.event like 'RFO_EXD_READY' and ul.e_date = trunc(sysdate)
) x union all
select 10 as n, 'DAILY UPDATE - DWH READY TIME < 05:30' as test_name,
      case when (to_date(to_char(trunc(sysdate),'yyyy-mm-dd')||' 05:30','yyyy-mm-dd hh24:mi') -
            x.test_value) > 0 then 'OK' else 'NOK' end as test_result,
      to_char(x.test_value,'hh24:mi') as test_info,
      'MAIN' as test_proc
from (select cast(min(ul.e_timestamp) as date) as test_value from daily_update_event ul
       where ul.event = 'DWH_READY' and ul.e_date = trunc(sysdate)
) x union all
select 11 as n, 'DWH PORTFOLIO - COMPLETE (report date = yesterday)' as test_name,
      case when test_value = trunc(sysdate) - 1 then 'OK' else 'ERROR' end as test_result,
      to_char(x.test_value,'yyyy-mm-dd') as test_info,
      'MAIN' as test_proc
from (select max(t.rep_date) as test_value from V_DWH_PORTFOLIO_CURRENT t
) x union all
select 12 as n, 'DWH PORTFOLIO - TOTAL DEBT (deviation since 2014-09-26 < 20%)' as test_name,
      case when abs(test_value) < 0.20 then 'OK' else 'ERROR' end as test_result,
      to_char(round(test_value*100,2)) as test_info,
      'MAIN' as test_proc
from (select (sum(t.x_total_debt) - 680044938800.53) / 680044938800.53 as test_value
        from V_DWH_PORTFOLIO_CURRENT t
        where t.x_is_credit_issued = 1
) x union all
select 13 as n, 'DWH PORTFOLIO - DELINQ DAYS (deviation since 2014-09-26 < 20%)' as test_name,
      case when abs(test_value) < 0.2 then 'OK' else 'NOK' end as test_result,
      to_char(round(test_value*100,2)) as test_info,
      'MAIN' as test_proc
from (select (sum(t.x_delinq_days) - 429415580) / 429415580 as test_value
        from V_DWH_PORTFOLIO_CURRENT t
        where t.x_is_credit_issued = 1
) x union all
select 19 as n, 'DWH PORT - COMPLETE (max report date = yesterday)' as test_name,
      case when test_value = trunc(sysdate) - 1 then 'OK' else 'ERROR' end as test_result,
      'max report date = '||to_char(x.test_value,'yyyy-mm-dd') as test_info,
      'MAIN' as test_proc
from (select max(t.rep_date) as test_value from DWH_PORT t
) x union all
/*select 13 as n, 'SEND_BL_TO_SCORING - ALL SENT TO SCORING (deviation < 20)' as test_name,
      case when abs(test_value) < 20 then 'OK' else 'ERROR' end as test_result,
      to_char(test_value) as test_info
from (select (select count(*) from V_PHONE_COUNTER_CANCEL_BL) -
       (select count(*) from "_bl_universal"@sc18) as test_value from dual
) x union all*/
/*select 14 as n, 'SEND_TAX_IIN_RNN_TO_SCORING - ALL SENT TO SCORING (deviation = 0)' as test_name,
      case when test_value = 0 then 'OK' else 'ERROR' end as test_result,
      to_char(test_value) as test_info
from (select (select count(*) from V_CLIENT_TAX) -
      (select count(*) from "_IIN_to_RNN"@sc18) as test_value from dual
) x union all*/
select 18 as n, 'V_RFO_BLACK_LIST - UNKNOWN ADD REASON TYPES = 0' as test_name,
      case when test_value = 0 then 'OK' else 'ERROR' end as test_result,
      to_char(test_value) as test_info,
      'MAIN' as test_proc
from (select (select count(*) from V_RFO_BLACK_LIST t where t.note_type = 'UNKNOWN') as test_value from dual
) x
/*union all
select 14 as n, 'SEND_BL_TO_SCORING - EXTRA ENTRIES IN SCORING < 20' as test_name,
      case when x.test_value < 20 then 'OK' else 'ERROR' end as test_result,
      to_char(x.test_value) as test_info
from (select count(*) as test_value from "_bl_universal"@sc18 s
       where not exists (select 1 from V_PHONE_COUNTER_CANCEL_BL t
                 where t.iin = s."iin")
) x */
union all
select 1 as n, 'RECALC_ADD_P1_PROCESS' as test_name,
      case when test_value = 1 then 'OK' else 'ERROR' end as test_result,
      (select p_detail from daily_update_log t where t.process = 'RECALC_ADD_P1' and p_date = trunc(sysdate) and p_status = 'COMPLETE') as test_info,
      'ADD' as test_proc
from (select count(1) as test_value from daily_update_log t where t.process = 'RECALC_ADD_P1' and p_date = trunc(sysdate) and p_status = 'COMPLETE') x
union all
select 2 as n, 'RECALC_ADD_P2_PROCESS' as test_name,
      case when test_value = 1 then 'OK' else 'ERROR' end as test_result,
      (select p_detail from daily_update_log t where t.process = 'RECALC_ADD_P2' and p_date = trunc(sysdate) and p_status = 'COMPLETE') as test_info,
      'ADD' as test_proc
from (select count(1) as test_value from daily_update_log t where t.process = 'RECALC_ADD_P2' and p_date = trunc(sysdate) and p_status = 'COMPLETE') x
union all
select 1 as n, 'DAILY RBO UPDATE - COMPLETE (10 processes)' as test_name,
      case when x.test_value = 10 then 'OK' else 'ERROR' end as test_result,
      'processes = '||to_char(x.test_value) as test_info,
      'RBO' as test_proc
from (select count(1) as test_value from DAILY_UPDATE_LOG t
        where trunc(t.p_begin) = trunc(sysdate) and t.p_status = 'COMPLETE'
          and t.proc_type = 'RBO') x
union all
select 2 as n, 'T_RBO_PORT - COMPLETE (max report date = yesterday)' as test_name,
      case when test_value = trunc(sysdate) - 1 then 'OK' else 'ERROR' end as test_result,
      'max report date = '||to_char(x.test_value,'yyyy-mm-dd') as test_info,
      'RBO' as test_proc
from (select max(t.rep_date) as test_value from T_RBO_PORT t) x
union all
select 3 as n, 'T_RBO_PORT SALDO - COMPLETE' as test_name,
      x.test_value as test_result,
      x.test_info as test_info,
      'RBO' as test_proc
from (
select
       (case when abs(sum(principal))+abs(sum(interest))+abs(sum(principal_del))+abs(sum(interest_del))+abs(sum(w_all_del)) = 0
            then 'OK'
             else 'ERROR'end) as test_value,
        (case when sum(principal) != 0 then ' Срочный ОД = '||sum(principal) end)||
        (case when sum(interest) != 0 then ' Срочные % = '||sum(interest) end)||
        (case when sum(principal_del) != 0 then ' Просроченный ОД = '||sum(principal_del) end)||
        (case when sum(interest_del) != 0 then ' Просроченные % = '||sum(interest_del) end)||
        (case when sum(w_all_del) != 0 then ' Внебаланс = '||sum(w_all_del) end) as test_info
  from (
select c_rep_date,
       sum(case when c_pl_usv_num in ('1401','1403','1411','1417') then c_summa_saldo else 0 end) principal,
       sum(case when c_pl_usv_num in ('1740') then c_summa_saldo else 0 end) interest,
       sum(case when c_pl_usv_num in ('1424') then c_summa_saldo else 0 end) principal_del,
       sum(case when c_pl_usv_num in ('1741') then c_summa_saldo else 0 end) interest_del,
       sum(case when c_pl_usv_num in ('9130') then c_summa_saldo else 0 end) w_all_del
  from t_rdwh_saldo_port
 where c_rep_date = trunc(sysdate)-1
group by c_rep_date
union all
select
       rp.rep_date,
sum(nvl(rp.principal,0))+sum(nvl(rp.overlimit,0))+sum(nvl(rp.overdraft,0)),
sum(nvl(rp.interest,0))+sum(nvl(rp.overlimit_interest,0))+sum(nvl(rp.overdraft_interest,0)),
sum(case when rp.is_on_balance = 2 then 0 else nvl(rp.principal_del,0)+nvl(rp.overlimit_del,0)+nvl(rp.overdraft_del,0) end),
sum(case when rp.is_on_balance = 2 then 0 else nvl(rp.interest_del,0)+nvl(rp.overlimit_interest_del,0)+nvl(rp.overdraft_interest_del,0) end),
sum(nvl(rp.w_principal_del,0)) + sum(nvl(rp.w_interest_del,0))+sum(nvl(rp.w_overlimit_interest_del,0))+sum(nvl(rp.w_overdraft_interest_del,0))
+sum(nvl(rp.w_overlimit_del,0))+sum(nvl(rp.w_overdraft_del,0))
  from t_rbo_port rp
 where rp.rep_date = trunc(sysdate)-1
 group by  rp.rep_date)
) x
order by test_proc, n;
grant select on U1.V_SYS_CHECKS_DAILY to LOADDB;
grant select on U1.V_SYS_CHECKS_DAILY to LOADER;


