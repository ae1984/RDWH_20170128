create or replace procedure u1.ETLT_DWH_CRED_REG is
v_max_date date;
begin
  select /*+ parallel(1) */  max(t.C_OPDATE)  into v_max_date  from T_DWH_CRED_REG t;

  /*if v_max_date is null then
    v_max_date := to_date('30092014', 'ddmmyyyy');
  end if;*/
  insert into T_DWH_CRED_REG
  SELECT /*+parallel(tt,16) */
       t.ID,
       t.C_1,
       t.C_2,
       t.C_4,
       t.C_3,
       t.C_36,
       t.C_5,
       t.C_12,
       t.C_13,
       t.C_14,
       t.C_15,
       t.C_33,
       t.C_38,
       t.C_17,
       t.C_19,
       t.C_21,
       t.C_25,
       t.C_27,
       t.C_29,
       t.C_31,
       t.C_23,
       t.C_16,
       t.C_18,
       t.C_20,
       t.C_24,
       t.C_26,
       t.C_28,
       t.C_22,
       t.C_41,
       t.C_42,
       t.C_43,
       t.C_8,
       t.C_9,
       t.C_10,
       substr(t.C_11, 1, 512),
       t.C_30,
       t.C_32,
       t.C_34,
       t.C_35,
       t.C_37,
       t.C_39,
       substr(t.C_40, 1, 512),
       t.C_44
  from ibs.VW_CRIT_REG_IBSO_BY_DAY@dwh_old t -- реал
  where t.C_1 >  v_max_date;
  commit;  
end ETLT_DWH_CRED_REG;
/

