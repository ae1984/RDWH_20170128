create or replace force view u1.v_out_rfo_client_category as
select /*+ no_parallel*/
     f.folder_date_create_mi as rep_date
     ,f.iin as client_iin
     ,case when f.is_categ_a = 1 then 'A'
         when f.is_categ_b = 1 then 'B'
         when f.is_categ_b = 0 and f.is_client_new_by_con = 0 then 'C'
         when f.is_categ_b = 0 and f.is_client_new_by_con = 1 then 'D' end as category
from U1.M_FOLDER_CON_CANCEL f;
comment on column U1.V_OUT_RFO_CLIENT_CATEGORY.REP_DATE is 'Дата';
comment on column U1.V_OUT_RFO_CLIENT_CATEGORY.CLIENT_IIN is 'ИИН клиента';
comment on column U1.V_OUT_RFO_CLIENT_CATEGORY.CATEGORY is 'Категория';
grant select on U1.V_OUT_RFO_CLIENT_CATEGORY to IT6_USER;
grant select on U1.V_OUT_RFO_CLIENT_CATEGORY to LOADDB;


