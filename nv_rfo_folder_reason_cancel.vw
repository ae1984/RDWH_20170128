create or replace force view u1.nv_rfo_folder_reason_cancel as
select
--RDWH2.0
    cl.c_folders as folder_id
    ,clt.cancel_type --тип отказа
    ,clt.c_code
    ,clt.c_name
    ,clt.ps_cancel --отказ прескоринга (окончательный расчет с другими признаками)
    ,clt.vr_cancel --отказ верификатора (окончательный расчет с другими признаками)
    ,clt.mo_cancel --отказ МО (окончательный расчет с другими признаками)
    ,clt.cp_cancel --отказ ЦПР (окончательный расчет с другими признаками)
    ,clt.mn_cancel --отказ менеджера (окончательный расчет с другими признаками)
    ,clt.cl_cancel --отказ клиента (окончательный расчет с другими признаками)
from u1.V_RFO_Z#KAS_CANCEL cl
left join u1.NV_RFO_KAS_CANCEL_TYPES clt on clt.id = cl.c_type
where (cl.c_hist_err_level = 1 or -- выбираем критичные отказы
      (clt.c_type in ('CLIENT_PC_TO_EKT') and upper(cl.c_note) like '%ОТКАЗАЛСЯ%'))
group by
    cl.c_folders
    ,clt.cancel_type
    ,clt.c_code
    ,clt.c_name
    ,clt.ps_cancel
    ,clt.vr_cancel
    ,clt.mo_cancel
    ,clt.cp_cancel
    ,clt.mn_cancel
    ,clt.cl_cancel
;
grant select on U1.NV_RFO_FOLDER_REASON_CANCEL to LOADDB;


