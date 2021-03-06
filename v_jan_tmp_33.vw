﻿create or replace force view u1.v_jan_tmp_33 as
with ppx as (
    select * from (
        select ci.rfo_client_id as client_ref, px.client_iin as iin, px.report_type_orig,
               'PKB' as report_kind,
                 --px.active_contracts, px.report_status, px.rfo_report_date,
                 case when px.active_contracts = 0 and px.report_status != 'БЕКИ' then px.rfo_report_date + 45
                      else px.rfo_report_date + 15 end as date_expire, --cache_last_date
                 px.rep_id_max as report_id
        from (
            select p.report_iin_rnn as client_iin, p.report_type as report_type_orig,
                   max(p.report_id) as rep_id_max,
                   max(p.rfo_report_date) keep (dense_rank last order by p.report_id) as rfo_report_date,
                   max(p.active_contracts) keep (dense_rank last order by p.report_id) as active_contracts,
                   max(p.report_status) keep (dense_rank last order by p.report_id) as report_status
            from V_PKB_REPORT p
            where p.rfo_report_date > trunc(sysdate) - 50 and p.is_from_cache = 0
            group by p.report_iin_rnn, p.report_type
        ) px
        left join V_CLIENT_RFO_BY_IIN ci on ci.iin = px.client_iin
    ) where date_expire > trunc(sysdate) - 16
), ggx as (
    select * from (
        select ci.rfo_client_id as client_ref, gx.client_iin as iin,
               'GCVP' as report_kind,
               --gx.rep_date, gx.error_code, gx.max_pmt_date,
                 case when gx.error_code in (1,2,3,91,92,93,94) then gx.rep_date + 60
                      when gx.max_pmt_date is not null and gx.max_pmt_date + 30 >= gx.rep_date
                           then gx.max_pmt_date + 30
                      when gx.max_pmt_date is not null then gx.rep_date
                      else gx.rep_date + 15 end as date_expire, --cache_last_date
                 gx.rep_id_max as report_id
        from (
            select g.client_iin,
                   max(g.gcvp_rep_id) as rep_id_max,
                   max(g.rep_date) keep (dense_rank last order by g.gcvp_rep_id) as rep_date,
                   max(g.error_code) keep (dense_rank last order by g.gcvp_rep_id) as error_code,
                   max(g.max_pmt_date) keep (dense_rank last order by g.gcvp_rep_id) as max_pmt_date
            from V_GCVP_REPORT g
            where g.rep_date > trunc(sysdate) - 70 and g.is_from_cache = 0
            group by g.client_iin
        ) gx
        left join V_CLIENT_RFO_BY_IIN ci on ci.iin = gx.client_iin
    ) where date_expire > trunc(sysdate) - 16
)
select max(r.client_ref) as client_ref,
       r.iin, max(r.report_kind) as report_kind,
       max(r.date_expire) as date_expire,
       max(r.report_id) keep (dense_rank last order by r.date_expire) as report_id, r.report_type
from (
    select ppx.*, 2 as report_type from ppx
    where ppx.report_type_orig in ('ПЕРВИЧНЫЙ','СТАНДАРТНЫЙ','РАСШИРЕННЫЙ')
    union all
    select ppx.*, 4 as report_type from ppx
    where ppx.report_type_orig in ('СТАНДАРТНЫЙ','РАСШИРЕННЫЙ')
    union all
    select ppx.*, 6 as report_type from ppx
    where ppx.report_type_orig in ('РАСШИРЕННЫЙ')
) r group by r.iin, r.report_type
union all
select ggx."CLIENT_REF",ggx."IIN",ggx."REPORT_KIND",ggx."DATE_EXPIRE",ggx."REPORT_ID", null as report_type from ggx
;
grant select on U1.V_JAN_TMP_33 to LOADDB;
grant select on U1.V_JAN_TMP_33 to LOADER;


