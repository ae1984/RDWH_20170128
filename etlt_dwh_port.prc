create or replace procedure u1.ETLT_DWH_PORT is
      s_mview_name     varchar2(30) := 'DWH_PORT';
      vStrDate         date := sysdate;
      v_max_date       timestamp;
    begin

    select max(t.rep_date) into v_max_date
    from DWH_PORT t;

    --update DWH_PORT

      insert /*+ append enable_parallel_dml parallel(10)*/ into DWH_PORT
      select /*+ parallel(20) */
        xx.rep_date,xx.deal_number,xx.total_debt,xx.total_debt_decrease,xx.delinq_days,xx.delinq_days_previous,
        xx.start_date,xx.prod_type,xx.delinq_days_old,xx.delinq_amount,xx.is_card,xx.client_id,xx.is_active,
        xx.is_on_balance,xx.pmt_date,
            case when
              min(xx.rep_date) over (partition by xx.deal_number) - start_date < 15 then
              min(xx.pmt_date) over (partition by xx.deal_number) end as
        pmt_date_first,
      case when au.rbo_contract_id is not null then 'AVTO' else xx.prod_type end as prod_avto,
       xx.is_on_balance_prev
      from (
      select
        x.*,
            case when x.total_debt_decrease > 0 or
                  (x.delinq_days != 0 and delinq_days_previous = 0)
                  then x.rep_date end as
        pmt_date
      from (
      select t.rep_date, t.deal_number,
             t.x_total_debt as total_debt,
                 max(t.x_total_debt) over (partition by t.deal_number
                        order by t.rep_date range between 1 preceding
                        and 1 preceding) - t.x_total_debt as
             total_debt_decrease,
             t.x_delinq_days as delinq_days,
                 max(t.x_delinq_days) over (partition by t.deal_number
                        order by t.rep_date range between 1 preceding
                        and 1 preceding) as
             delinq_days_previous,
             t.x_start_date as start_date,
             t.prod_type,
             t.delinq_days_old,
             t.x_delinq_amount as delinq_amount,
             t.x_is_card as is_card,
             t.x_client_id as client_id,
             t.x_is_active as is_active,
             t.is_on_balance,
             lag(t.is_on_balance) over (partition by t.deal_number order by t.rep_date) as is_on_balance_prev
      from DWH_PORT_T t
      ) x
      ) xx
      left join M_RBO_CONTRACT_AUTO au on au.contract_number = xx.deal_number
                                 and au.date_begin <= xx.rep_date
                                 and au.date_close >= xx.rep_date
      where xx.rep_date > v_max_date
      ;
      commit;




    /*begin
      --v_sql := 'ALTER INDEX DWH_PORT_IND1 REBUILD;';
      --execute immediate v_sql;
      dbms_stats.gather_table_stats(ownname => 'U1', tabname => 'DWH_PORT', degree => 30);

      pkg_object_update_util.log_upd(s_mview_name, vStrDate, 'OK');

      exception when others then
        rollback;

         u1.log_error (in_operation => '.P_DWH_PORT',
                               in_error_code => sqlcode,
                               in_error_message => substr(dbms_utility.format_error_backtrace||','||sqlerrm,1,2000),
                               in_object_type => s_mview_name,
                               in_object_id => null);
        return;
     end;*/

     end ETLT_DWH_PORT;
/

