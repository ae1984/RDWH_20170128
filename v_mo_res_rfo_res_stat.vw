create or replace force view u1.v_mo_res_rfo_res_stat as
select
to_char(r.res_date,'Mon dd') as res_date,
count(distinct r.c_res_mo_id) as res_cnt,
-- BL_REJECT - mo results
count(distinct case when r.res_par_code = 'BL_REJECT' then r.c_res_mo_id end) as bl_reject_all_res,
count(distinct case when r.res_par_code = 'BL_REJECT' and r.is_to_cancel = 1 then r.c_res_mo_id end) as bl_reject_event_res,
count(distinct case when r.res_par_code = 'BL_REJECT' and r.res_par_value is null then r.c_res_mo_id end) as bl_reject_null_res,
---
count(distinct case when r.res_par_code = 'BL_REJECT' and r.cancel_type_code = 'BL_REJECT' then r.c_res_mo_id end) as bl_reject_canc_epo_res,
count(distinct case when r.res_par_code = 'BL_REJECT' and r.cancel_type_code = 'BL_REJECT' then r.cancel_id end) as bl_reject_canc_epo_canc,
count(distinct case when r.res_par_code = 'BL_REJECT' and r.cancel_type_code = 'BL_REJECT_ASOKR' then r.c_res_mo_id end) as bl_reject_canc_ps_res,
count(distinct case when r.res_par_code = 'BL_REJECT' and r.cancel_type_code = 'BL_REJECT_ASOKR' then r.cancel_id end) as bl_reject_canc_ps_canc,
-- BL_REJECT - clients
count(distinct case when r.res_par_code = 'BL_REJECT' then r.c_client_ref end) as bl_reject_all_clnt,
count(distinct case when r.res_par_code = 'BL_REJECT' and r.is_to_cancel = 1 then r.c_client_ref end) as bl_reject_1_clnt,
-- MON_NEED
count(distinct case when r.res_par_code = 'MON_NEED' then r.c_res_mo_id end) as mon_need_all_res,
count(distinct case when r.res_par_code = 'MON_NEED' and r.is_to_cancel = 1 then r.c_res_mo_id end) as mon_need_event_res,
count(distinct case when r.res_par_code = 'MON_NEED' and r.res_par_value is null then r.c_res_mo_id end) as mon_need_null_res
---
from V_MO_RES_RFO_RES_CANCEL r
--where r.is_to_cancel = 1
group by r.res_date
order by 1
;
grant select on U1.V_MO_RES_RFO_RES_STAT to LOADDB;
grant select on U1.V_MO_RES_RFO_RES_STAT to LOADER;


