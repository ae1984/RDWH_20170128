﻿create or replace force view u1.v_client_cal_for_sco_motest as
select c.client_iin_last as iin,
       sum(c.total_pmts) as total_pmts,
       max(c.delinq_days_max) as delinq_days_max,
       max(c.delinq_days_max_last_rep) as delinq_days_last,
       min(c.start_date_first) as start_date_first,
       max(c.contract_amount_max) as start_con_amount_max,
       max(c.client_pmt_max) as start_pmt_max,
       max(c.number_of_contracts) as start_num_of_con,
       max(c1.bad_active_mon_debt10k_bef_4y) as bad_active_mon_debt10k_bef_4y,
       max(c2.other_deal_pmt) as other_deal_pmt,
       max(c3.last_cash_early_repay_2mm) as last_cash_early_repay_2mm,
       max(c3.last_cash_close_date) as last_cash_close_date,

       round(dbms_random.value(0, 100)) as start_cl_other_paid_sal_cnt,
       max(c.number_of_rejections_1_week) number_of_rejections_1_week,
       sum(con.x_total_debt) pre_amount_rest,
       max(c4.pmt_in_rep_sum_by_cli) pmt_in_rep_sum_by_cli,
       max(case when con.x_is_refin_prod_type=1 and con.is_credit_active=1 then 1 else 0 end) as is_refin
from V_CLIENT_CAL c
left join M_CLIENT_CAL_SCO1 c1 on c1.client_id = c.client_id
left join M_CLIENT_CAL_SCO2 c2 on c2.client_id = c.client_id
left join M_CLIENT_CAL_SCO3 c3 on c3.client_iin = c.client_iin_last
left join u1.v_dwh_portfolio_current con on con.x_client_id = c.client_id and
                                            con.is_credit_active = 1
left join M_CLIENT_CAL_SCO4 c4 on c4.iin = c.client_iin_last
where c.client_iin_last is not null
group by c.client_iin_last;
grant select on U1.V_CLIENT_CAL_FOR_SCO_MOTEST to LOADDB;
grant select on U1.V_CLIENT_CAL_FOR_SCO_MOTEST to LOADER;


