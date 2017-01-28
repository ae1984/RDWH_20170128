create or replace force view u1.nv_rfo_kas_cancel_types as
select
--RDWH2.0
      "CANCEL_TYPE","ID","C_CODE","C_TYPE","C_NAME","C_PRIORITY","C_TERM_ARR","C_ERR_LEVEL","SN","SU","PS_CANCEL","VR_CANCEL","MO_CANCEL","CP_CANCEL","MN_CANCEL","CL_CANCEL"
from (select
            ct.*
            ,ct.cancel_type as cancel_type1
      from (select case
                         when ct.c_code in
                              ('VERIFICATION_CONTACT', 'VERIFICATION_PHOTO') --or ct.c_type = 'CPR'
                          then
                          'VERIFICATION'
                         when ct.c_code in
                              ('MO_SCO_REJECT', 'BL_REJECT_ASOKR') then
                          'MIDDLE_OFFICE'
                         when ct.c_type in ('GCVP',
                                            'GCVP_OLD',
                                            'NIGHT_PRS_PKB',
                                            'NIGHT_PRS_PKB_OLD',
                                            'NIGHT_PRS_FC',
                                            'NIGHT_PRS_FC_OLD') or
                              (ct.c_type in ('AUTO', 'AUTO_OLD') and
                              ct.c_code <> 'AA_CALC_4_3RD_LOAN') then
                          'PRESCORING'
                         when ct.c_type in ('CPR', 'CPR_OLD') or
                              (ct.c_type in ('AUTO', 'AUTO_OLD') and
                              ct.c_code = 'AA_CALC_4_3RD_LOAN') then
                          'CPR'
                       /*                                       when ct.c_type in ('MANAGER') or
                        (ct.c_type in ('CLIENT_PC_TO_EKT') and
                             upper(c.c_note) like '%ОТКАЗАЛСЯ%') -- отказ клиента от лимита на карту с др кредитом
                       then 'MANAGER_CLIENT'*/
                         when ct.c_type in ('MANAGER', 'MANAGER_OLD') and
                              upper(ct.c_code) not in
                              ('НЕ УСТР. ПРОЦЕНТ',
                               'НЕ УСТР. КОМИССИИ',
                               'НЕ УСТР. ОБСЛУЖИВ.',
                               'ХОЧЕТ В ДРУГОЙ БАНК',
                               'НЕ УСТРАИВАЕТ СРОК',
                               'НЕ УСТРАИВАЕТ СУММА',
                               'ХОЧЕТ ДРУГОЙ ПРОДУКТ',
                               'НЕ УСТР. УСЛ. АЛЬТЕР',
                               'НЕ УСТР. ПЕРЕПЛАТА') then
                          'MANAGER'
                         when ct.c_type in
                              ('MANAGER', 'MANAGER_OLD', 'CLIENT_PC_TO_EKT') and -- отказ клиента от лимита на карту с др кредитом
                              upper(ct.c_code) in
                              ('НЕ УСТР. ПРОЦЕНТ',
                               'НЕ УСТР. КОМИССИИ',
                               'НЕ УСТР. ОБСЛУЖИВ.',
                               'ХОЧЕТ В ДРУГОЙ БАНК',
                               'НЕ УСТРАИВАЕТ СРОК',
                               'НЕ УСТРАИВАЕТ СУММА',
                               'ХОЧЕТ ДРУГОЙ ПРОДУКТ',
                               'НЕ УСТР. УСЛ. АЛЬТЕР',
                               'НЕ УСТР. ПЕРЕПЛАТА') then
                          'CLIENT'
                       end as cancel_type, --тип отказа
                       ct.*
                       ,ct.id as id1
           from u1.V_RFO_Z#KAS_CANCEL_TYPES ct
           ) ct) ct
            pivot(count(ct.id1) as cancel for cancel_type1 in('PRESCORING' as PS,
                                                             'VERIFICATION' as VR,
                                                             'MIDDLE_OFFICE' as MO,
                                                             'CPR' as CP,
                                                             --'MANAGER_CLIENT' as MC,
                                                             'MANAGER' as MN,
                                                             'CLIENT' as CL)
                                                            )
;
grant select on U1.NV_RFO_KAS_CANCEL_TYPES to LOADDB;


