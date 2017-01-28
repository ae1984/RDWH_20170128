create or replace force view u1.v_tmp_dwh_port_auto as
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance
from M_TMP_DWH_PORT_31102014 t
union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance
 from M_TMP_DWH_PORT_20112014

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance
from M_TMP_DWH_PORT_28112014

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_22122014

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_31122014

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_20012015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_30012015
union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_20022015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_27022015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_17032015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_20032015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_31032015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_20042015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance from M_TMP_DWH_PORT_30042015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance
from M_TMP_DWH_PORT_20052015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance
from M_TMP_DWH_PORT_29052015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance
from M_TMP_DWH_PORT_15062015
union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,cast(null as varchar2(10)) as is_on_balance
from M_TMP_DWH_PORT_22062015
union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance
from M_TMP_DWH_PORT_30062015
union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance
from M_TMP_DWH_PORT_07072015
union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance
from
M_TMP_DWH_PORT_09072015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance
from
M_TMP_DWH_PORT_15072015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance
from M_TMP_DWH_PORT_20072015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance
from M_TMP_DWH_PORT_31072015

union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance
from M_TMP_DWH_PORT_15082015
union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance
from M_TMP_DWH_PORT_16082015
union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance
from M_TMP_DWH_PORT_20082015
union all
select rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance
from M_TMP_DWH_PORT_23082015;
grant select on U1.V_TMP_DWH_PORT_AUTO to LOADDB;
grant select on U1.V_TMP_DWH_PORT_AUTO to LOADER;


