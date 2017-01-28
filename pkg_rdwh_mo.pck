create or replace package u1.pkg_rdwh_mo is

  -- Author  : KIM_17004
  -- Created : 27/01/2016 13:35:49
  -- Purpose :

  procedure populate_mo_reject_param(in_reject_code varchar2);

  procedure populate_mo_reject;

end pkg_rdwh_mo;
/
grant execute on U1.PKG_RDWH_MO to RISK_GKIM;


create or replace package body u1.pkg_rdwh_mo is

  procedure populate_mo_reject_param(in_reject_code varchar2)
  is
  begin
    delete from u1.t_mo_reject_param t
    where t.reject_code = in_reject_code;
    commit;

    for r in (select t.*,
                     cast(b.date_apply as date) as batch_date_apply
              from u1.v_mo_d_calc t
              join u1.v_mo_batch b on b.id = t.batch_id
              where t.code = in_reject_code)
    loop

      for r2 in ( select regexp_substr(r.script, '#\w+#', 1, level) as reject_param,
                         level lv
                  from dual
                  connect by level <=  regexp_count(r.script, '#\w+#'))
      loop
        insert into u1.t_mo_reject_param (
               reject_code,
               param_code,
               lv, batch_id, batch_date)
        values (r.code,
                replace(r2.reject_param, '#', ''),
                r2.lv, r.batch_id, r.batch_date_apply);
      end loop;
    end loop;

    commit;

  end populate_mo_reject_param;



  procedure populate_mo_reject is
  begin
    for r in (select distinct dp.code
              from u1.v_mo_d_calc dp
              where (dp.code like 'C_MO_SCO_REJECT_PRE_%' or
                     dp.code = 'C_MO_SCO_REJECT_KN' or
                     dp.code = 'C_MO_SCO_REJECT' or
                     dp.code = 'C_SC_REJECT_KN' or
                     dp.code = 'C_MO_SCO_REJECT_81' or
                     
                     dp.code = 'C_SC_AA_REJECT_PRE_2' or
                     dp.code = 'C_SC_AA_REJECT_PRE_22' or
                     dp.code = 'C_SC_AA_REJECT_PRE_9' or
                     dp.code = 'C_SC_AA_REJECT_PRE_17' or
                     
                     dp.code = 'C_SC_AA_REJECT_POST_PRE_2' or
                     dp.code = 'C_SC_AA_REJECT_POST_PRE_22' or
                     dp.code = 'C_SC_AA_REJECT_POST_PRE_9' or
                     dp.code = 'C_SC_AA_REJECT_POST_PRE_17' or
                     
                     dp.code = 'C_PRSC_REJECT_PRE_81'
                     ))
    loop
      populate_mo_reject_param(r.code);
    end loop;
  end;


end pkg_rdwh_mo;
/
grant execute on U1.PKG_RDWH_MO to RISK_GKIM;


