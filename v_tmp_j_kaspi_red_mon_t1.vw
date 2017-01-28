create or replace force view u1.v_tmp_j_kaspi_red_mon_t1 as
select m1.fld_id, m1.fld_date_create, m1.client_iin,
       upper(m1.client_name) as client_name,
       upper(p.c_name) as fld_point_name,
       m2.is_mo_reject,
       m2.mo_cred_limit_k,
       upper(d.c_name) as fld_department_name,
       upper(u.c_name) as create_user_name,
       m1.rfo_client_id,
       m1.fld_number,
       m1.fld_result_oper_note,
       m1.fld_c_docs,
       m1.fld_history_id,
--       m4."скоринг отказал",
       m4.appr_by_iin,
       m4.appr_by_mobile,
       m4.appr_by_partn,
       m4.client_is_employer,
       m4.kaspi_red_limit
       ,m4.client_category
       ,m4.client_category_union
       ,m4.sc_kaspired_appr_other_res_pre
       ,m4.sc_kaspired_appr_top_res_pre
from U1.M_TMP_J_KASPI_RED_MON_1_t1 m1
left join u1.V_RFO_Z#CM_POINT p on p.id = m1.fld_point_id
left join u1.V_RFO_Z#STRUCT_DEPART d on d.id = m1.fld_department_id
left join u1.V_RFO_Z#USER u on u.id = m1.fld_create_user_id
left join u1.M_TMP_J_KASPI_RED_MON_2_t1 m2 on m2.folder_id = m1.fld_id
left join u1.M_TMP_J_KASPI_RED_MON_4_t1 m4 on m4.folder_id = m1.fld_id
where m1.fld_date_create >= trunc(sysdate)-10
order by 2 desc
;
grant select on U1.V_TMP_J_KASPI_RED_MON_T1 to LOADDB;


