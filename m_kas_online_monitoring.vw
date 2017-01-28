﻿create or replace force view u1.m_kas_online_monitoring as
select
       oc.id as claim_id,
       ob.id as buy_id,
       ob.c_date_create as buy_date_create,--дата заказа
       ob.c_process_id as order_id,--номер заказа
       cmp.c_name as status,
       sd.c_name as status1,

       cl.c_inn,--ИИН клиента
       c.id as folder_id,--номер папки

       g.c_sal as GCVP_sal,--официальная зарплата(ГЦВП)

       p.report_type,
       p.report_status,--Статус отчета ПКБ
       p.active_contracts,
       p.closed_contracts,
       p.total_debt,--общий долг по всем кредитам
       p.delinq_amount,--просроченная сумма по всем кредитам
       pkb_contract_status,
       contract_status_clean,

       clp.c_place_birth,
       fca.inc_sal,
       coalesce(fca.inc_sal,0) + coalesce(fca.inc_sal_add,0) +
                coalesce(fca.inc_sal_spouse,0) + coalesce(fca.inc_rent,0) +
                coalesce(fca.inc_pension_benefits,0) + coalesce(fca.inc_interest,0) as form_income_total,
       fca.sex,
       fca.marital_status,
       fca.fio_wife_full,--ФИО супруга
       fca.phone_wife,--телефон супруга
       cr.prod_type,--тип продукта
       cr.num_active_credits,
       cr.total_debt_cli,--общий долг клиента перед Банком
       cr.total_pmt_cli,
       q.is_categ_a,--Клиент категории А
       q.is_client_new,--Новый клиент

       mob_ch.num_cli, --сколько еще клиентов указали этот мобильный
       part_cli.appl_count_7d, --количество заявок этого клиента у этого партнера за 7 дней
       dev.device_cat_by_phone_30d,
       dev.device_subcat_by_phone_30d,
       def_hist.first_con_start_date,
       def_hist.con_cnt,
       def_hist.active_con,
       def_hist.max_dpd,--максимальное дней просрочки
       def_hist.IS_default_exists,-- Имеется ли просрочка
       fca.reg_address_region||', '||fca.reg_address_city||', '||fca.reg_address_district||', '||fca.reg_address_street||', '||fca.reg_address_house||', '||fca.reg_address_flat as reg_address,--адрес регистрации
       fca.fact_address_region||', '||fca.fact_address_city||', '||fca.fact_address_district||', '||fca.reg_address_street||', '||fca.fact_address_house||', '||fca.fact_address_flat as fact_adr,--адрес проживания

       f.c_client,
       f.c_business,
       f.c_n,
       c.c_st_depart,
       c.c_way,
       c.c_point,
       c.c_create_user,
       cd.c_info_cred#summa_cred,
       cd.c_shop,

       upper(i.c_name) as product_name,--название товара
       upper(tn.c_code) as tov_category,--категория товара
       oc.c_form_client_st#inn,--ИИН клиента
       oc.c_form_client_st#mobile#numb,--моб тел клиента
       i.c_price,
       sp.avg_amount_7d,
         round((i.c_price -   sp.avg_amount_7d)/  sp.avg_amount_7d * 100)||' %' as dif,
         case when oc.c_check_result is null then 'Одобрен на сайте' end as approved_on_SITE,--средняя цена за последние 7 дней

       i.c_price as product_price,--цена товара

       upper(sd.c_code) as code_status,
       upper(sd.c_name) as name_status,
       m.p_rfoid as RFO_partner_name,
       m.uniqueid as merchant_uniqid,
       m.name as merchant_name,--Название Продавца
       m.p_active as merchant_status,
       s2.p_rfoid as RFO_shop_code,--Код Продавца в РФО
       s2.p_name as shop_name,--Название Продавца в РФО
       s2.p_active as shop_status,
       dnp.x_dnp_name,
       dnp.x_dnp_region,
       cmp.c_code,
       case when so.c_prod_code_lev2 = 'MONEY_LKN' or so.c_prod_code_lev2 = 'MONEY_LK' then 1
         else 0 end as LK,-- Есть ли у клиента спецпредложение в РФО (ЛК не ЛК)

       fcd.is_sign_require,--Будет ли идти клиент на подписание в отделение
       fcd.pos_name,-- Отделение для подписания
       fcd.rfo_contract_id,
       ku.reg_date,--регистрация на kaspi.kz
       c.c_date_create--Дата и время создания заявки

from u1.t_RFO_Z#KAS_ONLINE_CLAIM oc --На Частое обновление (в режиме онлайн времени)
join u1.m_kaspikz_users_all kua on to_number(replace(kua.rfo_id, 'X', ''))= oc.c_client_ref
join u1.m_kaspikz_users ku on ku.id=kua.user_id
join u1.t_RFO_Z#KAS_ONLINE_BUY ob on oc.c_buy_ref = ob.id--На Частое обновление (в режиме онлайн времени)
left join u1.m_client_cal_categ q on q.rfo_client_id = oc.c_client_ref --на Т-1 (категория клиентов на сегодняшний день)
left join u1.v_RFO_Z#STATUS_DOG sd on sd.id = ob.c_state_id --на Т-1 (справочник)
join u1.t_RFO_Z#CM_CHECKPOINT c on c.id = oc.c_folder_ref --На Т-1 (справочник)
join u1.t_RFO_Z#FOLDERS f on f.id = c.id --На Частое обновление (в режиме онлайн времени)
join u1.t_RFO_Z#RDOC rd on rd.collection_id = f.c_docs--На Частое обновление (в режиме онлайн времени)
join u1.t_RFO_Z#FDOC fd on fd.id = rd.c_doc and fd.class_id = 'CREDIT_DOG'--На Частое обновление (в режиме онлайн времени)
join u1.t_RFO_Z#CREDIT_DOG cd on cd.id = rd.c_doc and cd.c_shop is not null--На Частое обновление (в режиме онлайн времени)
join u1.t_RFO_Z#CL_PRIV clp on clp.id = f.c_client--На Частое обновление (в режиме онлайн времени)
join u1.t_RFO_Z#CLIENT cl on cl.id = clp.id--На Частое обновление (в режиме онлайн времени)
join u1.t_RFO_Z#PROD_INFO i on i.collection_id = cd.c_d#type_cred#prod#prod_info11--На Частое обновление (в режиме онлайн времени)
join u1.t_RFO_Z#KAS_TOV_NAME tn on tn.id = i.c_name_ref--На Частое обновление (в режиме онлайн времени)
left join u1.m_kaspish_orders o on ob.c_process_id = o.code--На Частое обновление (в режиме онлайн времени)
left join u1.m_online_device dev on o.p_gaclientid = dev.ga_client_id and trunc(o.createdts) = dev.yyyy_mm_dd--На Частое обновление (в режиме онлайн времени)
left join u1.v_form_client_all_rfo fca on fca.form_client_id = oc.c_form_client_ref--На Частое обновление (в режиме онлайн времени)
join u1.t_RFO_Z#SHOPS s on s.id = ob.c_shop--На Частое обновление (в режиме онлайн времени)
join u1.m_kaspish_pointofservice s2 on s.c_code=s2.p_rfoid--На Частое обновление (в режиме онлайн времени)
join u1.m_Kaspish_Merchant m on s2.p_merchant=m.pk--На Частое обновление (в режиме онлайн времени)

left join u1.V_RFO_Z#STRUCT_DEPART sd on sd.id = c.c_st_depart--На Частое обновление (в режиме онлайн времени)
left join u1.V_POS dnp on dnp.pos_code = sd.c_code--На Частое обновление (в режиме онлайн времени)
left join u1.V_RFO_Z#CM_POINT cmp on cmp.id=c.c_point--На Частое обновление (в режиме онлайн времени)
left join u1.M_ONLINE_SIGMA_res sp on ob.c_process_id = sp.order_id--На Частое обновление (в режиме онлайн времени)
left join risk_aaman.cred_lim_case_fin2 cr on cr.rfo_client_id = oc.c_client_ref --на Т-1 (актуальная задолженность на сегодняшний день)
left join -- проверка по мобильному телефону (сколько еще клиентов указали этот мобильный)
(select oc.c_form_client_st#mobile#numb as mob_tel, count(distinct oc.c_form_client_st#inn) as num_cli From u1.t_RFO_Z#KAS_ONLINE_CLAIM oc
group by oc.c_form_client_st#mobile#numb) mob_ch on mob_ch.mob_tel = oc.c_form_client_st#mobile#numb



left join --количество заявок клиента по партнеру за последние 7 дней
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
from u1.T_RFO_Z#KAS_GCVP_REPORT g)--На Частое обновление (в режиме онлайн времени)
where rn  = 1) g on cl.c_inn = g.c_iin and trunc(ob.c_date_create) = trunc(g.c_statement_date)
--PKB
left join (select * From
(select p.*,
row_number () over (partition by p.iin_rnn,trunc(report_date) order by report_id desc) as rn
from u1.t_pkb_report p)--На Частое обновление (в режиме онлайн времени)
where rn  = 1) p on cl.c_inn = p.iin_rnn and trunc(ob.c_date_create) = trunc(p.report_date)


join (select  oc.id as claim_id,
              case when count(kd1.id)>0 then 1 else 0 end is_sign_require,
              upper(sd.c_name) as pos_name,
              cd.id as rfo_contract_id

from u1.v_RFO_Z#KAS_ONLINE_CLAIM oc
join u1.v_RFO_Z#CM_CHECKPOINT c on c.id = oc.c_folder_ref
join u1.v_RFO_Z#FOLDERS f on f.id = c.id
join u1.v_RFO_Z#RDOC rd on rd.collection_id = f.c_docs
join u1.v_RFO_Z#CREDIT_DOG cd on cd.id = rd.c_doc and cd.c_shop is not null
left join u1.V_RFO_Z#STRUCT_DEPART sd on sd.id = c.c_st_depart
left join u1.v_RFO_Z#KAS_UNIVERSA_REF s1 on s1.collection_id = oc.c_mng_vis_scen
left join u1.v_RFO_Z#KAS_UNIVERSAL_D kd1 on kd1.id = s1.c_value
group by oc.id,sd.c_name, cd.id) fcd on fcd.claim_id = oc.id  ---- Отделения для подписи,подпсиь,rfo contract Id


left join (select *
from V_RFO_Z#KAS_EMP_LIMIT t
join V_RFO_Z#KAS_SPEC_PRODUCT c on c.collection_id = t.c_spec_product
                                   and c.c_date_edit >= trunc(sysdate) - 1
join V_RFO_Z#KAS_SPEC_PROD_CL c2 on c2.id = c.id
where t.c_kas_sas_date >= trunc(sysdate)  - 1
order by t.c_inn) so on so.c_client=clp.id -- Есть ли у клиента спецпредложение в РФО (ЛК не ЛК)

where c.c_date_create > trunc(sysdate) and
      ob.c_date_create > trunc(sysdate)       --ВСЕ ЗАЯВКИ НА СЕГОДНЯ
;
grant select on U1.M_KAS_ONLINE_MONITORING to LOADDB;

