create or replace force view u1.v_pkb_report_gt_online as
select /*+ parallel(30)*/
    p.id as report_id,
    trunc(fd.c_doc_date) as report_date,
    fd.c_doc_date as report_date_time,
    p.c_rnn as iin_rnn,
    c.id as pkb_merged_contract_id,
    cast (case when p.c_rpt_type = 4 then 'СТАНДАРТНЫЙ'
         when p.c_rpt_type = 6 then 'РАСШИРЕННЫЙ'
         else 'ПЕРВИЧНЫЙ' end as varchar2(100)) as report_type,
    cast (case when p.c_status = 'SubjectNotFound' then 'БЕКИ' else upper(p.c_status) end as varchar2(60)) as report_status,
    cast (case when p.c_pkb_report_ref is not null then 1 else 0 end as number(1)) as is_from_cache,
    p.c_si_noec as active_contracts_raw,
     case when p.c_si_noec like '%(%' then
         to_number(REPLACE(substr(p.c_si_noec,1,instr(p.c_si_noec,'(')-2),'.',','))
     when p.c_si_noec is not null then
         to_number(p.c_si_noec) end  as active_contracts,
    p.c_si_notc as closed_contracts_raw,
     case when p.c_si_notc like '%(%' then
         to_number(REPLACE(substr(p.c_si_notc,1,instr(p.c_si_notc,'(')-2),'.',','))
     when p.c_si_notc is not null then
         to_number(p.c_si_notc) end as  closed_contracts,
    p.c_si_tod as total_debt_raw,
    get_pkb_debt_from_text(p.c_si_tod,trunc(fd.c_doc_date)) as total_debt,
    p.c_si_tdo as delinq_amount_raw,
    get_pkb_debt_from_text(p.c_si_tdo,trunc(fd.c_doc_date)) as delinq_amount,
    ---------
    cast( case when p.c_ci = c.collection_id then 'АКТИВНЫЙ'
     when p.c_closed_ci = c.collection_id then 'ЗАКРЫТЫЙ' end as varchar2(100)) as pkb_contract_status,
    upper(c.c_contr_status) as contract_status,
    cast( case when c.c_contr_status not like '% - %' then upper(c.c_contr_status)
         else upper(substr(c.c_contr_status,0,instr(c.c_contr_status,' - ') - 1)) end as varchar(750)) as contract_status_clean,
    c.c_monthly_payment as monthly_payment_raw,
    get_pkb_debt_from_text(c.c_monthly_payment,trunc(fd.c_doc_date)) as monthly_payment,
    c.c_last_update,
    c.c_currency,
    c.c_appl_date,
    c.c_date_begin,
    c.c_date_end,
    c.c_fact_gash_date,
    c.c_outstanding_sum as outstanding_sum_raw,
    get_pkb_debt_from_text(c.c_outstanding_sum,trunc(fd.c_doc_date)) as outstanding_sum,
    c.c_overdue_sum as overdue_sum_raw,
    get_pkb_debt_from_text(c.c_overdue_sum,trunc(fd.c_doc_date)) as overdue_sum,
    upper(c.c_subj_role) as c_subj_role,
    upper(c.c_fin_inst) as c_fin_inst,
    c.c_amount,
    get_pkb_debt_from_text(c.c_amount,trunc(fd.c_doc_date)) as amount,
    c.c_credit_usage,
    c.c_residual_amount,
    c.c_credit_limit as credit_limit_raw,
    get_pkb_debt_from_text(c.c_credit_limit,trunc(fd.c_doc_date)) as credit_limit,
    c.c_ovrd_instalments,
    c.c_pc as pkb_pc_id,
    c.c_total_ammount as total_amount_raw,
    get_pkb_debt_from_text(c.c_total_ammount,trunc(fd.c_doc_date)) as total_amount,
    c.c_guarantee_val as guarantee_val_raw,
    get_pkb_debt_from_text(c.c_guarantee_val,trunc(fd.c_doc_date)) as guarantee_val,
    p.c_id_doc_arr,
    p.c_si_subj_role,
    c.C_PLEDGE_TYPE_VAL,
    decode(p.c_rep_source, 1, 'ГКБ', 'ПКБ') as report_source,
    p.c_error_status
from T_RFO_Z#PKB_REPORT p
join T_RFO_Z#FDOC fd on  fd.id = p.id
                     and fd.class_id = 'PKB_REPORT'
left join T_RFO_Z#KAS_PKB_CI c on c.collection_id = p.c_ci
                               or c.collection_id = p.c_closed_ci
where nvl(p.c_rpt_type,0)  != 2
  and p.id in (select id from T_PKB_REPORT_GT)
union all
select /*+ parallel(30)*/
    p.id as report_id,
    trunc(fd.c_doc_date) as report_date,
    fd.c_doc_date as report_date_time,
    p.c_rnn as iin_rnn,
    s.id as pkb_merged_contract_id,
    cast (case when p.c_rpt_type = 4 then 'СТАНДАРТНЫЙ'
         when p.c_rpt_type = 6 then 'РАСШИРЕННЫЙ'
         else 'ПЕРВИЧНЫЙ' end as varchar2(100)) as report_type,
    cast (case when p.c_status = 'SubjectNotFound' then 'БЕКИ' else upper(p.c_status) end as varchar2(60)) as report_status,
    cast (case when p.c_pkb_report_ref is not null then 1 else 0 end as number(1)) as is_from_cache,
    p.c_si_noec as active_contracts_raw,
     case when p.c_si_noec like '%(%' then
         to_number(REPLACE(substr(p.c_si_noec,1,instr(p.c_si_noec,'(')-2),'.',','))
     when p.c_si_noec is not null then
         to_number(p.c_si_noec) end  as active_contracts,
    p.c_si_notc as closed_contracts_raw,
     case when p.c_si_notc like '%(%' then
         to_number(REPLACE(substr(p.c_si_notc,1,instr(p.c_si_notc,'(')-2),'.',','))
     when p.c_si_notc is not null then
         to_number(p.c_si_notc) end  as closed_contracts,
    p.c_si_tod as total_debt_raw,
    get_pkb_debt_from_text(p.c_si_tod,trunc(fd.c_doc_date)) as total_debt,
    p.c_si_tdo as delinq_amount_raw,
    get_pkb_debt_from_text(p.c_si_tdo,trunc(fd.c_doc_date)) as delinq_amount,
    ---------
    cast( case when s.c_value is not null then 'АКТИВНЫЙ' end as varchar2(100)) as pkb_contract_status,
    upper(s.c_value) as contract_status,
    cast( case when s.c_value not like '% - %' then upper(s.c_value)
         else upper(substr(s.c_value,0,instr(s.c_value,' - ') - 1)) end as varchar(750)) as contract_status_clean,
    '' as monthly_payment_raw,
    0 as monthly_payment,
    '' as c_last_update,
    '' as c_currency,
    '' as c_appl_date,
    '' as c_date_begin,
    '' as c_date_end,
    '' as c_fact_gash_date,
    '' as outstanding_sum_raw,
    0 as outstanding_sum,
    '' as overdue_sum_raw,
    0 as overdue_sum,
    '' as c_subj_role,
    '' as c_fin_inst,
    '' as c_amount,
    0 as amount,
    '' as c_credit_usage,
    '' as c_residual_amount,
    '' as credit_limit_raw,
    0 as credit_limit,
    '' as c_ovrd_instalments,

    null as pkb_pc_id,
    null as total_amount_raw,
    null as total_amount,
    null as guarantee_val_raw,
    null as guarantee_val,
    null as c_id_doc_arr,
    null as c_si_subj_role,
    null as C_PLEDGE_TYPE_VAL,
    decode(p.c_rep_source, 1, 'ГКБ', 'ПКБ') as report_source,
    p.c_error_status
from T_RFO_Z#PKB_REPORT p
join T_RFO_Z#FDOC fd on fd.id = p.id and fd.class_id = 'PKB_REPORT'
left join (select s2.collection_id,min(s2.id) as id,
                        (listagg(s2.c_value,'#') within group (order by s2.c_value)) c_value
                 from(
                  select s1.collection_id,
                        s1.id ,
                        s1.c_value,
                        row_number() over(ORDER BY s1.collection_id) num
                   from T_RFO_Z#KAS_STRING_250 s1
                  ) s2
                  where num <= 5
                  group by s2.collection_id) s on s.collection_id = p.c_agre_statuses
where p.c_rpt_type = 2
  and p.id in (select id from T_PKB_REPORT_GT)
;
grant select on U1.V_PKB_REPORT_GT_ONLINE to LOADDB;


