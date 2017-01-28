create or replace procedure u1.ETLT_KASPISH_SHOPS_PRICES is
  s_mview_name     varchar2(30) := 'T_KASPISH_SHOPS_PRICES';
  vStrDate         date := sysdate;
  DateMax         date;

begin
  select max(t.rep_date)
    into DateMax
    from T_KASPISH_SHOPS_PRICES t;
  
  if DateMax < trunc(sysdate) then  
    insert /*+ append enable_parallel_dml parallel(10)*/ into T_KASPISH_SHOPS_PRICES
    SELECT trunc(sysdate)           as rep_date,
           upper(item_t8.uniqueid)  as m_uid,
           upper(item_t8.name)      as m_name,
           upper(item_t8.p_rfoid)   as m_rfo_id,
           item_t0.code             as p_mas_code,
           upper(lp_t0.p_name)      as p_mas_name,
           item_t3.code             as p_mer_code,
           upper(lp_t3.p_name)      as p_mer_name,
           item_t10.p_id            as pr_mer_city_id,
           upper(lp_t10.p_name)     as pr_mer_city_name,
           item_t9.p_price          as pr_mer_price,
           item_t9.p_starttime      as pr_mer_start_time
      FROM U1.M_KASPISH_PRODUCTS item_t0 JOIN U1.M_KASPISH_PRODUCTSLP lp_t0 ON item_t0.PK = lp_t0.ITEMPK AND lp_t0.LANGPK =8796093317152 ,
           U1.M_KASPISH_CATALOGS item_t1,
           U1.M_KASPISH_CATALOGVERSIONS item_t2,
           U1.M_KASPISH_PRODUCTS item_t3 JOIN U1.M_KASPISH_PRODUCTSLP lp_t3 ON item_t3.PK = lp_t3.ITEMPK AND lp_t3.LANGPK =8796093317152 ,
           U1.M_KASPISH_CATALOGS item_t4,
           U1.M_KASPISH_CATALOGVERSIONS item_t5,
           U1.M_KASPISH_PRODUCTREFERENCES item_t6,
           U1.M_KASPISH_PRODUCTREFERENCES item_t7,
           U1.M_KASPISH_MERCHANT item_t8,
           U1.M_KASPISH_PRICEROWS item_t9,
           U1.M_KASPISH_CITY item_t10 JOIN U1.M_KASPISH_CITYLP lp_t10 ON item_t10.PK = lp_t10.ITEMPK AND lp_t10.LANGPK =8796093317152 ,
           U1.M_KASPISH_ENUMERATIONVALUES item_t11
     WHERE ( item_t0.p_catalogversion  =  item_t2.PK
       and  item_t2.p_catalog  =  item_t1.PK
       and  item_t2.p_version  = 'Online'
       and  item_t1.p_id  = 'kaspishoppingProductCatalog'
       and  item_t3.p_catalogversion  =  item_t5.PK
       and  item_t5.p_catalog  =  item_t4.PK
       and  item_t5.p_version  = 'Online'
       and  item_t4.p_supplier  =  item_t8.PK
       and  item_t6.p_source  =  item_t0.PK
       and  item_t6.p_target  =  item_t3.PK
       and  item_t7.p_source  =  item_t3.PK
       and  item_t7.p_target  =  item_t0.PK
       and  item_t9.p_product  =  item_t3.PK
       and  item_t9.p_city  =  item_t10.PK
       and  item_t9.p_endtime  > sysdate
       and  item_t0.p_approvalstatus  =  item_t11.PK
       and  item_t3.p_approvalstatus  =  item_t11.PK )
       and ((item_t0.TypePkString = 8796096495698
       and item_t1.TypePkString in (8796117008466, 8796105146450, 8796095610962)
       and item_t2.TypePkString in  (8796116811858,8796094201938)
       and item_t3.TypePkString=8796096495698
       and item_t4.TypePkString IN  (8796117008466, 8796105146450, 8796095610962)
       and item_t5.TypePkString IN  (8796116811858, 8796094201938)
       and item_t6.TypePkString = 8796104523858
       and item_t7.TypePkString = 8796104523858
       and item_t8.TypePkString = 8796102328402
       and item_t9.TypePkString = 8796120547410
       and item_t10.TypePkString = 8796106195026
       and item_t11.TypePkString = 8796113502290 ));
    commit;
  end if;
  
end ETLT_KASPISH_SHOPS_PRICES;
/

