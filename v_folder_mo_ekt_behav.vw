create or replace force view u1.v_folder_mo_ekt_behav as
select --y.date_create as folder_create_date,
       x."RFOLDER_ID",x."DATE_CREATE",x."IIN",x."RFO_CLIENT_ID",
       x."RFO_FOLDER_ID",x."IS_CATEG_A",x."SC_EKT_BEHV_RISKY_GOODS_CNT",
       x."SC_IS_30D_SAL_INCRS_OVER_10K",x."SC_EKT_ONL_REJECT_SCORE",x."IN_SCO_SALARY",
       x."SC_EKT_60D_KN_REJECT",x."SC_EKT_BEHAVIOR_SCORE",x."SC_EKT_60D_RISKY_GOODS_CNT",
       x."RISKY_GOODS_COUNT",x."SC_ONL_30D_MAX_SALARY",x."SC_EKT_60D_ONL_REJECT",
       x."SC_EKT_30D_ONL_REJECT",x."SC_EKT_BEHAVIOR_RES_PRE",x."SC_EKT_BEHV_CTRL_GR_RES_PRE",x."MO_SCO_REJECT_8",x."MO_SCO_REJECT"
from
(
select *
from M_FOLDER_MO_EKT_BEHAV t
union
select *
from M_FOLDER_MO_EKT_BEHAV_2 t
) x
;
grant select on U1.V_FOLDER_MO_EKT_BEHAV to LOADDB;
grant select on U1.V_FOLDER_MO_EKT_BEHAV to LOADER;


