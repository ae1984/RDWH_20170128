create or replace procedure u1.ETLT_M_MATRIX_PORT_1
  is
   s_mview_name     varchar2(30) := 'M_MATRIX_PORT_1';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

begin
  delete from M_MATRIX_PORT_1 where yyyy_mm_dd>=trunc(sysdate)-30;
  insert into M_MATRIX_PORT_1
  select /*+parallel(10)*/
         td.yyyy_mm_dd,td.yyyy, td.text_yyyy_mm, td.text_yyyy_mm_dd_week_day,
         bp.product_type, bp.product, bp.city, p.is_on_balance,
         ---
         count(1) as cnt, count(distinct p.rbo_contract_id) as contract_cnt,
         count(distinct p.rbo_client_id) as cli_cnt,
         sum(p.total_debt) / 1000000 as debt_all_mln,

         sum(case when p.delinq_days_cli > 0 and p.delinq_days_cli <= 7  then p.total_debt end) / 1000000 as debt_del_1_7_mln,
         sum(case when p.delinq_days_cli > 7 and p.delinq_days_cli <= 30 then p.total_debt end) / 1000000 as debt_del_8_30_mln,
         sum(case when p.delinq_days_cli > 30 and p.delinq_days_cli <= 60 then p.total_debt end) / 1000000 as debt_del_31_60_mln,
         sum(case when p.delinq_days_cli > 60 and p.delinq_days_cli <= 90 then p.total_debt end) / 1000000 as debt_del_61_90_mln,
         sum(case when p.delinq_days_cli > 90 then p.total_debt end) / 1000000 as debt_del_91_XX_mln,

         sum(case when coalesce(p.delinq_days_cli,0) = 0 then p.total_debt end) / 1000000 as debt_del_0_mln,
         sum(case when p.delinq_days_cli > 0 and p.delinq_days_cli <= 90 then p.total_debt end) / 1000000 as debt_del_1_90_mln,
         sum(case when p.delinq_days_cli > 7 and p.delinq_days_cli <= 90 then p.total_debt end) / 1000000 as debt_del_8_90_mln,

         sum(case when p.delinq_days_cli = 1 then p.total_debt end) / 1000000 as debt_del_1_mln,
         sum(case when p.delinq_days_cli = 8 then p.total_debt end) / 1000000 as debt_del_8_mln,
         sum(case when p.delinq_days_cli = 31 then p.total_debt end) / 1000000 as debt_del_31_mln,
         sum(case when p.delinq_days_cli = 61 then p.total_debt end) / 1000000 as debt_del_61_mln,
         sum(case when p.delinq_days_cli = 91 then p.total_debt end) / 1000000 as debt_del_91_mln
  from U1.M_MATRIX_PORT_1_PRE bp
  join U1.T_RBO_PORT p on p.rbo_contract_id = bp.rbo_contract_id
                           and p.rep_date >=trunc(sysdate)-30 --to_date('2014-01-01','yyyy-mm-dd')
  join U1.V_TIME_DAYS td on td.yyyy_mm_dd = p.rep_date
  group by td.yyyy_mm_dd, td.yyyy, td.text_yyyy_mm, td.text_yyyy_mm_dd_week_day,
           bp.product_type, bp.product, bp.city, p.is_on_balance;
  commit;

end ETLT_M_MATRIX_PORT_1;
/

