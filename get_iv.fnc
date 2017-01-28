create or replace function u1.get_iv(in_schema varchar2 := 'DM',
                                  in_sample_t varchar2,
                                  in_sample_transform_t varchar2,
                                  in_param_name varchar2,
                                  in_param_transform_name varchar2,
                                  in_pk_col_name varchar2 := 'rfo_contract_id',
                                  in_bad_col_name varchar2
                                  ) return number is
  Result number;
  v_sql varchar2(20000);
begin
  v_sql := 'select max(aa.iv)
from (
  select a.*,
         sum(a.iv_pre) over (order by a.med_val) iv
  from (
      select zz.*,
             case when zz.dbad <> 0 then ln(zz.dgood/zz.dbad) else 0 end as woe,
             (zz.dgood - zz.dbad)*ln(zz.dgood/zz.dbad) iv_pre
      from (
          select z.bin_val,
                 z.med_val,
                 z.cnt_good,
                 z.cnt_bad,
                 z.cnt_all,
                 z.cnt_good_cum,
                 z.cnt_bad_cum,
                 z.cnt_all_cum,
                 round(z.cnt_good/max(z.cnt_good_cum) over (order by z.med_val desc), 5) dgood,
                 round(z.cnt_bad/max(z.cnt_bad_cum) over (order by z.med_val desc), 5) dbad
          from (
              select x.bin_val,
                     x.med_val,
                     x.cnt_good,
                     x.cnt_bad,
                     x.cnt_good + x.cnt_bad cnt_all,
                     sum(x.cnt_good) over (order by x.med_val) cnt_good_cum,
                     sum(x.cnt_bad) over (order by x.med_val) cnt_bad_cum,
                     sum(x.cnt_good + x.cnt_bad) over (order by x.med_val) cnt_all_cum
              from (';
  if (not in_param_name is null) then
     v_sql := v_sql || 'select g."' || in_param_transform_name || '" bin_val,
                             g.med_val,
                             g.cnt cnt_good,
                             b.cnt cnt_bad
                      from ';
  else
    v_sql := v_sql || 'select g."' || in_param_transform_name || '" bin_val,
                             g.cnt med_val,
                             g.cnt cnt_good,
                             b.cnt cnt_bad
                      from ';
  end if;

  if (not in_param_name is null) then
    v_sql := v_sql ||    '(select t."' || in_param_transform_name || '",
                                 median(t2."' || in_param_name || '") med_val, count(*) cnt
                          from ' || in_schema || '.' || in_sample_transform_t || ' t
                          join ' || in_schema || '.' || in_sample_t || ' t2 on t2.' || in_pk_col_name || ' = t.' || in_pk_col_name || '
                          where t.' || in_bad_col_name || ' = 0
                          group by t."' || in_param_transform_name || '") g
                      full outer join (select t."' || in_param_transform_name || '",
                                              median(t2."' || in_param_name || '") med_val, count(*) cnt
                          from ' || in_schema || '.' || in_sample_transform_t || ' t
                          join ' || in_schema || '.' || in_sample_t || ' t2 on t2.' || in_pk_col_name || ' = t.' || in_pk_col_name || '
                          where t.' || in_bad_col_name || ' = 1
                          group by t."' || in_param_transform_name || '") b on b."' || in_param_transform_name || '" = g."' || in_param_transform_name || '"
                      order by 2';
  else
    v_sql := v_sql ||    '(select t."' || in_param_transform_name || '",
                                 nvl(min(t2."' || in_param_transform_name || '"), -1) med_val, count(*) cnt
                          from ' || in_schema || '.' || in_sample_transform_t || ' t
                          join ' || in_schema || '.' || in_sample_t || ' t2 on t2.' || in_pk_col_name || ' = t.' || in_pk_col_name || '
                          where t.' || in_bad_col_name || ' = 0
                          group by t."' || in_param_transform_name || '") g
                      full outer join (select t."' || in_param_transform_name || '",
                                              nvl(min(t2."' || in_param_transform_name || '"), -1) med_val, count(*) cnt
                          from ' || in_schema || '.' || in_sample_transform_t || ' t
                          join ' || in_schema || '.' || in_sample_t || ' t2 on t2.' || in_pk_col_name || ' = t.' || in_pk_col_name || '
                          where t.' || in_bad_col_name || ' = 1
                          group by t."' || in_param_transform_name || '") b on b."' || in_param_transform_name || '" = g."' || in_param_transform_name || '"
                      order by 2';
  end if;
  v_sql := v_sql || ') x
            ) z
         ) zz
   ) a
) aa';

  /*insert into T_GKIM_WOE_SQL (DATE_CREATE, SQL_TXT) values (sysdate, v_sql);
  commit;*/
  execute immediate v_sql into Result;
  return(Result);
exception when others then
  u1.log_error(in_operation => 'get_iv', in_error_code => sqlcode, in_error_message => sqlerrm);
  return -1;
end get_iv;
/
grant execute on U1.GET_IV to DM;
grant execute on U1.GET_IV to RISK_AAMAN;


