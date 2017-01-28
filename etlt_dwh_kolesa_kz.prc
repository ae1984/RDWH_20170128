create or replace procedure u1.ETLT_DWH_KOLESA_KZ is
  s_mview_name     varchar2(30) := 'T_DWH_KOLESA_KZ';
  v_max_kolesa_id  number;
  v_sql            varchar2(255);
       
begin
  select /*+parallel(1)*/ max(t.kolesa_id)
    into v_max_kolesa_id
    from T_DWH_KOLESA_KZ t;
  
  v_sql := 'alter session enable parallel dml';
  execute immediate(v_sql);
  
  delete /*+ parallel(event5 8) */
    from T_DWH_KOLESA_KZ t
   where t.kolesa_id in (
                         select r.kolesa_id
                           from DWH_STAGE.S64_KOLESA_KZ@RDWH_EXD r
                          where r.kolesa_updated_at <> t.kolesa_updated_at
                        );
  commit;
  
    
  insert /*+ parallel(event5 8) */ into T_DWH_KOLESA_KZ
     (KOLESA_ID,
      KOLESA_BRAND,
      KOLESA_MODEL,
      KOLESA_YEAR,
      KOLESA_COLOR,
      KOLESA_PRICE,
      KOLESA_PHONE,
      KOLESA_EMAIL,
      KOLESA_REGION,
      KOLESA_FUEL,
      KOLESA_VOLUME,
      KOLESA$CHANGE_DATE,
      KOLESA_PUBLICATION_DATE,
      KOLESA_CREATED_AT,
      KOLESA_UPDATED_AT,
      KOLESA_TEXT,
      KOLESA_CAR_BODY,
      KOLESA_CAR_TRANSM,
      KOLESA_EMERGENCY,
      KOLESA_CAR_ORDER,
      KOLESA_CUSTOM,
      KOLESA_CONDITION,
      KOLESA_SWEEL,
      KOLESA_PRICE_CURRENCY,
      KOLESA_CAR_DWHEEL,
      KOLESA_CAR_RUN,
      KOLESA_TORG,
      KOLESA_PRICE_USER,
      KOLESA_KAS_DATE,
      KOLESA_KAS_STO,
      KOLESA_KAS_STATE,
      KOLESA_KAS_ELECTRONICS,
      KOLESA_KAS_WHEEL,
      KOLESA_KAS_ENGINE,
      KOLESA_KAS_INTERIOR,
      KOLESA_KAS_BODY,
      KOLESA_KAS_INTEREST_FREE,
      KOLESA_COLOR_M,
      KOLESA_AVTOSALON_REF,
      KOLESA_ACTIVE_BOOL)
      
  select t.*, 
         case 
           when to_number(trunc(sysdate) - t.kolesa_updated_at) > 7 
             or t.kolesa_updated_at is null then 
               0
           else 
             1 
         end    as kolesa_active_bool 
    from DWH_STAGE.S64_KOLESA_KZ@RDWH_EXD t 
    left join T_DWH_KOLESA_KZ k on k.kolesa_id = t.kolesa_id
   where k.kolesa_id is null
   --where t.kolesa_id > v_max_kolesa_id
     ;
  commit;
    
end ETLT_DWH_KOLESA_KZ;
/

