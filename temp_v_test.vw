create or replace force view u1.temp_v_test as
select
    d.contract_number,
    d.prescoring_result,
    d.scoring_result,
    --d.scoring_status,
    1 as numberx
from data_asokr d
where rownum < 10
;
grant select on U1.TEMP_V_TEST to LOADDB;
grant select on U1.TEMP_V_TEST to LOADER;


