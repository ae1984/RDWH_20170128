create or replace force view u1.v_folder_mo_sco_request as
select /*+ parallel 30*/ t.rfolder_id, t.date_create, t.folder_id, t.rfo_client_id,t.scorecard_num, t.sco_gcvp_real_need, t.mo_sco_reject, t.system_source from u1.M_FOLDER_MO_SCO_REQUEST_2013 t
union all
select /*+ parallel 30*/ t.rfolder_id, t.date_create, t.folder_id, t.rfo_client_id,t.scorecard_num, t.sco_gcvp_real_need, t.mo_sco_reject, t.system_source from u1.M_FOLDER_MO_SCO_REQUEST_2014 t
union all
select /*+ parallel 30*/ t.rfolder_id, t.date_create, t.folder_id, t.rfo_client_id,t.scorecard_num, t.sco_gcvp_real_need, t.mo_sco_reject, t.system_source from u1.M_FOLDER_MO_SCO_REQUEST_2015 t
union all
select /*+ parallel 30*/ t.rfolder_id, t.date_create, t.folder_id, t.rfo_client_id,t.scorecard_num, t.sco_gcvp_real_need, t.mo_sco_reject, t.system_source from u1.M_FOLDER_MO_SCO_REQUEST_2016 t;
grant select on U1.V_FOLDER_MO_SCO_REQUEST to LOADDB;
grant select on U1.V_FOLDER_MO_SCO_REQUEST to LOADER;


