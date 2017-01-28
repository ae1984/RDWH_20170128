create or replace force view u1.v_delinq as
select
    d.yy_mm_report,
    d.contract_number,
    d.is_card,
    d.deling_total_2
from data_delinq d;
grant select on U1.V_DELINQ to LOADDB;
grant select on U1.V_DELINQ to LOADER;


