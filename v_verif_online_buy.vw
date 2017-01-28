create or replace force view u1.v_verif_online_buy as
select
       oc.id as claim_id,
       ob.id as buy_id,
       ob.c_date_create as buy_date_create,
       ob.c_process_id as order_id,
       cmp.c_name as status,
       sd.c_name as status1,

       cl.c_inn,
       c.id as folder_id,

       g.c_sal as GCVP_sal,

       p.report_type,
       p.report_status,
       p.active_contracts,
       p.closed_contracts,
       p.total_debt,
       p.delinq_amount,
       pkb_contract_status,
       contract_status_clean,

       clp.c_place_birth,
       fca.inc_sal,
       coalesce(fca.inc_sal,0) + coalesce(fca.inc_sal_add,0) +
                coalesce(fca.inc_sal_spouse,0) + coalesce(fca.inc_rent,0) +
                coalesce(fca.inc_pension_benefits,0) + coalesce(fca.inc_interest,0) as form_income_total,
       fca.sex,
       fca.marital_status,
       fca.fio_wife_full,
       fca.phone_wife,
       oc.c_form_client_st#mobile#numb,
       cr.prod_type,
       cr.num_active_credits,
       cr.total_debt_cli,
       cr.total_pmt_cli,
       q.is_categ_a,
       q.is_client_new,

       mob_ch.num_cli,
       part_cli.appl_count_7d,
       dev.device_cat_by_phone_30d,
       dev.device_subcat_by_phone_30d,
       def_hist.first_con_start_date,
       def_hist.con_cnt,
       def_hist.active_con,
       def_hist.max_dpd,
       def_hist.IS_default_exists,
       fca.reg_address_region||', '||fca.reg_address_city||', '||fca.reg_address_district||', '||fca.reg_address_street||', '||fca.reg_address_house||', '||fca.reg_address_flat as reg_address,
       fca.fact_address_region||', '||fca.fact_address_city||', '||fca.fact_address_district||', '||fca.reg_address_street||', '||fca.fact_address_house||', '||fca.fact_address_flat as fact_adr,

       f.c_client,
       f.c_business,
       f.c_n,
       c.c_st_depart,
       c.c_way,
       c.c_point,
       c.c_create_user,
       cd.c_info_cred#summa_cred,
       cd.c_shop,
       --cl.c_inn,
       upper(i.c_name) as product_name,
       upper(tn.c_code) as tov_category,
       oc.c_form_client_st#inn,
       --oc.c_form_client_st#mobile#numb,--
       i.c_price,
       sp.avg_amount_7d,
         round((i.c_price -   sp.avg_amount_7d)/  sp.avg_amount_7d * 100)||' %' as dif,
         case when oc.c_check_result is null then 'Одобрен на сайте' end as approved_on_SITE,

       i.c_price as product_price,


       upper(sd.c_code) as code_status,
       upper(sd.c_name) as name_status,
       m.p_rfoid as RFO_partner_name,
       m.uniqueid as merchant_uniqid,
       m.name as merchant_name,
       m.p_active as merchant_status,
       s2.p_rfoid as RFO_shop_code,
       s2.p_name as shop_name,
       s2.p_active as shop_status,
       dnp.x_dnp_name,
       dnp.x_dnp_region,
       cmp.c_code



from u1.t_RFO_Z#KAS_ONLINE_CLAIM oc

join u1.t_RFO_Z#KAS_ONLINE_BUY ob on oc.c_buy_ref = ob.id
left join u1.m_client_cal_categ q on q.rfo_client_id = oc.c_client_ref
left join u1.v_RFO_Z#STATUS_DOG sd on sd.id = ob.c_state_id
join u1.t_RFO_Z#CM_CHECKPOINT c on c.id = oc.c_folder_ref
join u1.t_RFO_Z#FOLDERS f on f.id = c.id
join u1.t_RFO_Z#RDOC rd on rd.collection_id = f.c_docs
join u1.t_RFO_Z#FDOC fd on fd.id = rd.c_doc and fd.class_id = 'CREDIT_DOG'
join u1.t_RFO_Z#CREDIT_DOG cd on cd.id = rd.c_doc and cd.c_shop is not null
join u1.t_RFO_Z#CL_PRIV clp on clp.id = f.c_client
join u1.t_RFO_Z#CLIENT cl on cl.id = clp.id
join u1.t_RFO_Z#PROD_INFO i on i.collection_id = cd.c_d#type_cred#prod#prod_info11
join u1.t_RFO_Z#KAS_TOV_NAME tn on tn.id = i.c_name_ref
left join u1.m_kaspish_orders o on ob.c_process_id = o.code
left join u1.m_online_device dev on o.p_gaclientid = dev.ga_client_id and trunc(o.createdts) = dev.yyyy_mm_dd
left join u1.v_form_client_all_rfo fca on fca.form_client_id = oc.c_form_client_ref
join u1.t_RFO_Z#SHOPS s on s.id = ob.c_shop
join u1.m_kaspish_pointofservice s2 on s.c_code=s2.p_rfoid
join u1.m_Kaspish_Merchant m on s2.p_merchant=m.pk

left join u1.V_RFO_Z#STRUCT_DEPART sd on sd.id = c.c_st_depart
left join u1.V_POS dnp on dnp.pos_code = sd.c_code
left join u1.V_RFO_Z#CM_POINT cmp on cmp.id=c.c_point
left join u1.M_ONLINE_SIGMA_res sp on ob.c_process_id = sp.order_id
left join risk_aaman.cred_lim_case_fin2 cr on cr.rfo_client_id = oc.c_client_ref
left join
(select oc.c_form_client_st#mobile#numb as mob_tel, count(distinct oc.c_form_client_st#inn) as num_cli From u1.t_RFO_Z#KAS_ONLINE_CLAIM oc
group by oc.c_form_client_st#mobile#numb) mob_ch on mob_ch.mob_tel = oc.c_form_client_st#mobile#numb
left join
(select oc.c_form_client_st#inn as cli_iin,
m.p_rfoid as rfo_partner_name,
count(1) as appl_count_7d

From u1.t_RFO_Z#KAS_ONLINE_CLAIM oc
join u1.t_RFO_Z#KAS_ONLINE_BUY ob on oc.c_buy_ref = ob.id
left join u1.v_RFO_Z#STATUS_DOG sd on sd.id = ob.c_state_id
join u1.t_RFO_Z#SHOPS s on s.id = ob.c_shop
join u1.m_kaspish_pointofservice s2 on s.c_code=s2.p_rfoid
join u1.m_Kaspish_Merchant m on s2.p_merchant=m.pk

where trunc(ob.c_date_create)>trunc(sysdate-7)
group by oc.c_form_client_st#inn,m.p_rfoid) part_cli on part_cli.cli_iin = oc.c_form_client_st#inn and part_cli.rfo_partner_name = m.p_rfoid




left join (select client_inn,
       min(b.start_date) as first_con_start_Date,
       count(distinct b.rbo_contract_Id) as con_cnt,
       count(case when date_fact_end is not null then b.rbo_contract_id end) as active_con,
       max(d.del_days_max_x) as MAX_DPD,
       count(case when nvl(d.del_days_x,0)>0 then b.rbo_contract_id end) as IS_default_exists
from u1.m_rbo_contract_bas b
left join u1.m_rbo_contract_del d on b.rbo_contract_id = d.rbo_contract_id
where b.product_type not like 'ОПТИМИЗАЦИЯ'
and b.rbo_contract_id is not null
group by b.client_inn) def_hist on oc.c_form_client_st#inn = def_hist.client_inn
--GCVP

left join (select * From
(select g.*,
row_number () over (partition by c_iin,trunc(c_statement_date) order by c_statement_date desc) as rn
from u1.T_RFO_Z#KAS_GCVP_REPORT g) where rn  = 1) g on cl.c_inn = g.c_iin and trunc(ob.c_date_create) = trunc(g.c_statement_date)
--PKB
left join (select * From
(select p.*,
row_number () over (partition by p.iin_rnn,trunc(report_date) order by report_id desc) as rn
from u1.t_pkb_report p)
where rn  = 1) p on cl.c_inn = p.iin_rnn and trunc(ob.c_date_create) = trunc(p.report_date)

where c.c_date_create > trunc(sysdate)
  and ob.c_date_create > trunc(sysdate)
;
grant select on U1.V_VERIF_ONLINE_BUY to LOADDB;
grant select on U1.V_VERIF_ONLINE_BUY to RISK_VERIF;


