create or replace force view u1.v_rdwh_onl_cred_fraud_bl as
select /*+ parallel(15) */
  distinct
   cl.id as rfo_client_id,
   cl.c_inn as inn,
   last_value(cp.c_date_create) ignore nulls over (partition by cl.id order by c.c_date
                                                                    range between unbounded preceding and unbounded following) as date_cr,
   last_value(c.c_date) ignore nulls over (partition by cl.id order by c.c_date
                                                                    range between unbounded preceding and unbounded following) as date_cncl,
   last_value(c.c_note) ignore nulls over (partition by cl.id order by c.c_date
                                                                    range between unbounded preceding and unbounded following) as note_cncl,
   last_value(f.c_n) ignore nulls over (partition by cl.id order by c.c_date
                                                                    range between unbounded preceding and unbounded following) as fld_numb,
   last_value(bp.c_code) ignore nulls over (partition by cl.id order by c.c_date
                                                                    range between unbounded preceding and unbounded following) as code_bp,
   last_value(bp.c_name) ignore nulls over (partition by cl.id order by c.c_date
                                                                    range between unbounded preceding and unbounded following) as name_bp,
   last_value(ct.c_code) ignore nulls over (partition by cl.id order by c.c_date
                                                                    range between unbounded preceding and unbounded following) as code_cncl

  from V_RFO_Z#FOLDERS f
  join V_RFO_Z#BUS_PROCESS bp
    on bp.id=f.c_business
  join V_RFO_Z#KAS_CANCEL c
    on f.id = c.c_folders
  join V_RFO_Z#KAS_CANCEL_TYPES ct
    on ct.id = c.c_type
  join V_RFO_Z#CM_CHECKPOINT cp
    on cp.id = f.id
  join V_RFO_Z#CLIENT cl on cl.id = f.c_client
 where trunc(cp.c_date_create) <trunc(sysdate)
  --and f.c_client in (2792230379,16855065459,51708509883)
   and ((ct.c_code = 'ПОДОЗР. МОШЕННИЧЕСТВ') --ПОДОЗРЕНИЕ В МОШЕННИЧЕСТВЕ
        or ((upper(c.c_note) like '%НЕ%ВНУШАЕТ%ДОВЕР%' or
        upper(c.c_note) like '%ПРЕДОСТАВЛЕНИЕ%ЛОЖНОЙ%ИНФОРМАЦ%' or
        upper(c.c_note) like '%ВЕДЕТ%СЕБЯ%ПОДОЗРИТЕЛЬН%' or
        upper(c.c_note) like '%ПЕРЕПИСЫВ%С%БУМАГ%' or
        upper(c.c_note) like '%ЧИТА%С%МОБИЛЬН%ТЕЛЕФОН%' or
        upper(c.c_note) like '%ВЫЗЫВАЕТ%СОМНЕН%' or
        upper(c.c_note) like '%ИНФОРМАЦ%С%БУМАЖК%ЧИТА%' or
        upper(c.c_note) like '%ИНФОРМАЦ%ДАЕТ%НЕУВЕРЕНН%' or
        upper(c.c_note) like '%НЕ%В%АДЕКВАТН%СОСТОЯН%' or
        upper(c.c_note) like '%НЕ%ВНУЧАЕТ%ДОВЕР%' or
        upper(c.c_note) like '%НЕ%ВЫЗЫВ%ДОВЕР%' or
        upper(c.c_note) like '%ЯВЛЯЕТСЯ%ПОДОЗРИТЕЛЬН%' or
        upper(c.c_note) like '%ПОДОЗРЕН%В%МОШЕННИЧЕСТВ%') and
        ct.c_code in ('ТЕХПРИЧИНА',
                          'ПРОЧЕЕ',
                          'НЕ ТРЕЗВЫЙ',
                          'НЕ УСТР. ПЕРЕПЛАТА',
                          'ИЗМЕН. АНКЕТ. ДАННЫХ',
                          'НЕТ СХЕМЫ',
                          'НЕ УСТР. УСЛ. АЛЬТЕР')))

group by cl.id,cl.c_inn,c.c_note,c.c_date,f.c_n,bp.c_code,bp.c_name,c.c_date,cp.c_date_create,ct.c_code
;
grant select on U1.V_RDWH_ONL_CRED_FRAUD_BL to LOADDB;


