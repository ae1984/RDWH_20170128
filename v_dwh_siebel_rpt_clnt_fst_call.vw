create or replace force view u1.v_dwh_siebel_rpt_clnt_fst_call as
select f.call_id,
       f.call_date,
       f.call_duration,
       f.mgr_name,
       f.mgr_position,
       f.topic1,
       f.topic2,
       f.client_iin,
       f.client_name,
       f.client_phone,
       f.client_language,
       f.prod_type_list,
       f.client_address
  from (select * from M_DWH_SBL_RPT_CLT_CALL_ITOG d
         order by d.call_id desc) f
 where rownum < 121;
grant select on U1.V_DWH_SIEBEL_RPT_CLNT_FST_CALL to LOADDB;
grant select on U1.V_DWH_SIEBEL_RPT_CLNT_FST_CALL to LOADER;
grant select on U1.V_DWH_SIEBEL_RPT_CLNT_FST_CALL to NPS;


