create or replace force view u1.v_dhk_ref_delinq as
select --+ parallel(5)
       t.days_del_from,
       t.days_del_to,
       t.del_short,
       t.del_long,
       t.del_middle,
       t.del
  from U1.REF_DELINQ t
;
grant select on U1.V_DHK_REF_DELINQ to LOADDB;
grant select on U1.V_DHK_REF_DELINQ to LOADER;


