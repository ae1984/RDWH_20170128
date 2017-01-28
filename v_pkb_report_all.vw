create or replace force view u1.v_pkb_report_all as
select /*+first_rows*/
    p.id as report_id,
    trunc(fd.c_doc_date) as report_date,
    fd.c_doc_date as report_date_time,
--    fld.id as folder_id,
    p.c_rnn as iin_rnn,
--   s.id as pkb_primary_contract_id,
--   c.id as pkb_std_ext_contract_id,
    nvl(s.id, c.id) as pkb_merged_contract_id,

    decode(p.c_rep_source, 1, 'ГКБ', 'ПКБ') as report_source,

       case when p.c_rpt_type = 4 then 'СТАНДАРТНЫЙ'
            when p.c_rpt_type = 6 then 'РАСШИРЕННЫЙ'
            else 'ПЕРВИЧНЫЙ' end as
    report_type,
    case when p.c_status = 'SubjectNotFound' then 'БЕКИ' else upper(p.c_status) end as report_status,
    case when p.c_pkb_report_ref is not null then 1 else 0 end as is_from_cache,

    p.c_dateofbirth as birth_date,
    p.c_gender as gender,
    upper(p.c_education) as education,
    upper(p.c_matrialstatus) as marital_status,
    p.c_fiuniquenumberid as pkb_client_id,
    p.c_surname as name_last,
    p.c_name as name_first,
    p.c_fathersname as name_patronymic,
    p.c_birthname as birth_name,
    upper(p.c_cityofbirth) as birth_city,
    upper(p.c_regionofbirth) as birth_region,
    upper(p.c_countryofbirth) as birth_country,
    p.c_registrationid,
    upper(p.c_street) as street,
    upper(p.c_city) as city,
    p.c_zipcode,
    upper(p.c_region) as region,
    p.c_addressinserted as address_insert_date,
    upper(p.c_number_house) as house_number,
    upper(p.c_b_classification) as client_classification,
    upper(p.c_resident) as resident,
    upper(p.c_s_position) as position,
    upper(p.c_citizenship) as citizenship,
    upper(p.c_f_citizenship) as f_citizenship,
    upper(p.c_eag) as occupation_sector,
    upper(p.c_nsoc) as client_negative_status,
    upper(p.c_nsoa) as contract_negative_status,
    upper(p.c_contactinfo) as contact_info,
    p.c_dateofrptissue as date_of_rpt_issue,

    p.c_si_noec as active_contracts_raw,
     case when p.c_si_noec like '%(%' then
         to_number(substr(p.c_si_noec,1,instr(p.c_si_noec,'(')-2))
     when p.c_si_noec is not null then
         to_number(p.c_si_noec) end as
    active_contracts,

    p.c_si_notc as closed_contracts_raw,
     case when p.c_si_notc like '%(%' then
         to_number(substr(p.c_si_notc,1,instr(p.c_si_notc,'(')-2))
     when p.c_si_notc is not null then
         to_number(p.c_si_notc) end as
    closed_contracts,

    p.c_si_tod as total_debt_raw,
    get_pkb_debt_from_text(p.c_si_tod,nvl(trunc(fd.c_doc_date),trunc(sysdate))) as total_debt,

    p.c_si_tdo as delinq_amount_raw,
    get_pkb_debt_from_text(p.c_si_tdo,nvl(trunc(fd.c_doc_date),trunc(sysdate))) as delinq_amount,

    p.c_si_nora as rejected_application_count,
    p.c_si_noi as application_count_one_year,
    p.c_patent as patent_number,
    p.c_agre_statuses,
    p.c_ci,
    --  p.c_rpt_type,
    p.c_si_debtor#noec#total,
    p.c_si_debtor#noec#instalment_cr,
    p.c_si_debtor#noec#cards,
    p.c_btor#noec#noninstalment_cr47,
    p.c_si_debtor#notc#total,
    p.c_si_debtor#notc#instalment_cr,
    p.c_si_debtor#notc#cards,
    p.c_btor#notc#noninstalment_cr51,
    p.c_si_debtor#nora#total,
    p.c_si_debtor#nora#instalment_cr,
    p.c_si_debtor#nora#cards,
    p.c_btor#nora#noninstalment_cr55,
    p.c_si_debtor#tod#total,
    p.c_si_debtor#tod#instalment_cr,
    p.c_si_debtor#tod#cards,
    p.c_ebtor#tod#noninstalment_cr59,
    p.c_si_debtor#tdo#total,
    p.c_si_debtor#tdo#instalment_cr,
    p.c_si_debtor#tdo#cards,
    p.c_ebtor#tdo#noninstalment_cr63,
    p.c_si_debtor#noi,
    p.c_si_debtor#noi_1,
    p.c_si_debtor#noi_2,
    p.c_si_debtor#noi_3,
    p.c_si_guarantor#noec#total,
    p.c_arantor#noec#instalment_cr69,
    p.c_si_guarantor#noec#cards,
    p.c_ntor#noec#noninstalment_cr71,
    p.c_si_guarantor#notc#total,
    p.c_arantor#notc#instalment_cr73,
    p.c_si_guarantor#notc#cards,
    p.c_ntor#notc#noninstalment_cr75,
    p.c_si_guarantor#nora#total,
    p.c_arantor#nora#instalment_cr77,
    p.c_si_guarantor#nora#cards,
    p.c_ntor#nora#noninstalment_cr79,
    p.c_si_guarantor#tod#total,
    p.c_uarantor#tod#instalment_cr81,
    p.c_si_guarantor#tod#cards,
    p.c_antor#tod#noninstalment_cr83,
    p.c_si_guarantor#tdo#total,
    p.c_uarantor#tdo#instalment_cr85,
    p.c_si_guarantor#tdo#cards,
    p.c_antor#tdo#noninstalment_cr87,
    p.c_si_guarantor#noi,
    p.c_si_guarantor#noi_1,
    p.c_si_guarantor#noi_2,
    p.c_si_guarantor#noi_3,
    p.c_id_doc_arr,
    p.c_closed_ci,
    upper(p.c_dop_field) as c_dop_field,
    p.c_pkb_report_ref,
    ---------

    case when p.c_ci = c.collection_id or s.c_value is not null then 'АКТИВНЫЙ'
     when p.c_closed_ci = c.collection_id then 'ЗАКРЫТЫЙ' end as pkb_contract_status,

    --  c.id,
    c.collection_id,
    upper(c.c_dog_type) as c_dog_type,
    c.c_num_dog,
    upper(c.c_cr_purpose) as c_cr_purpose,
    upper(nvl(c.c_contr_status, s.c_value)) as contract_status, --

    case when coalesce(c.c_contr_status, s.c_value) not like '% - %' then upper(coalesce(c.c_contr_status, s.c_value))
     else upper(substr(coalesce(c.c_contr_status, s.c_value),0,
             instr(coalesce(c.c_contr_status, s.c_value),' - ') - 1)) end as contract_status_clean,

    upper(c.c_guarantee_type) as c_guarantee_type,
    c.c_guarantee_val,
    upper(c.c_dog_class) as c_dog_class,
    c.c_total_ammount,
    c.c_instalments_num,
    upper(c.c_payments_period) as c_payments_period,
    upper(c.c_payments_method) as c_payments_method,

    c.c_monthly_payment as monthly_payment_raw,
--           to_number(replace(replace(replace(regexp_substr(c.c_monthly_payment,'[^A-Z]+'),' ',''),' ',''),',','.')) *
--           decode(regexp_substr(c.c_monthly_payment,'[A-Z]+'),'KZT',1,'USD',150,'EUR',200,'GBP',230,'RUB',5,'RUR',5,1) as
--    monthly_payment,
    get_pkb_debt_from_text(c.c_monthly_payment,nvl(trunc(fd.c_doc_date),trunc(sysdate))) as monthly_payment,

    c.c_last_update,
    upper(c.c_type_of_founding) as c_type_of_founding,
    c.c_currency,
    c.c_appl_date,
    c.c_date_begin,
    c.c_date_end,
    c.c_fact_gash_date,
    c.c_oustanding_num,
    c.c_outstanding_sum,
    c.c_overdue_sum,
    upper(c.c_subj_role) as c_subj_role,
    upper(c.c_fin_inst) as c_fin_inst,
    c.c_pc,
    c.c_add_info,
    c.c_amount,
    c.c_credit_usage,
    c.c_residual_amount,
    c.c_credit_limit,
    c.c_ovrd_instalments,
    c.c_dop_field as pkb_contract_dop_field
from V_RFO_Z#PKB_REPORT p
left join V_RFO_Z#KAS_PKB_CI c on c.collection_id = p.c_ci or c.collection_id = p.c_closed_ci
left join V_RFO_Z#KAS_STRING_250 s on s.collection_id = p.c_agre_statuses and p.c_rpt_type  = 2
join V_RFO_Z#FDOC fd on fd.id = p.id and fd.class_id = 'PKB_REPORT'
;
grant select on U1.V_PKB_REPORT_ALL to LOADDB;
grant select on U1.V_PKB_REPORT_ALL to LOADER;


