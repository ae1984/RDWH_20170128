create or replace procedure u1.ETLT_POPULATE_MO_REJECT_PARAM(in_reject_code varchar2)
        is
        -- s_mview_name     varchar2(30) := 'POPULATE_MO_REJECT_PARAM(T_MO_REJECT_PARAM)';
         s_mview_name     varchar2(30) := 'T_MO_REJECT_PARAM';
        begin
          delete from u1.T_MO_REJECT_PARAM t
          where t.reject_code = in_reject_code;
          commit;

          for r in (select t.*,
                           cast(b.date_apply as date) as batch_date_apply
                    from u1.V_MO_D_CALC t
                    join u1.V_MO_BATCH b on b.id = t.batch_id
                    where t.code = in_reject_code)
          loop
            for r2 in ( select regexp_substr(r.script, '#\w+#', 1, level) as reject_param,
                               level lv
                        from dual
                        connect by level <=  regexp_count(r.script, '#\w+#'))
                loop
                  insert into u1.T_MO_REJECT_PARAM (
                         reject_code,
                         param_code,
                         lv,
                         batch_id,
                         batch_date)
                  values (r.code,
                          replace(r2.reject_param, '#', ''),
                          r2.lv,
                          r.batch_id,
                          r.batch_date_apply);
                end loop;
           end loop;
           commit;


      end ETLT_POPULATE_MO_REJECT_PARAM;
/

