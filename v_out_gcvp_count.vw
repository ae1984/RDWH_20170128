create or replace force view u1.v_out_gcvp_count as
select /*+ parallel 5*/
       t.rep_date,
       t.count_gcvp
  from m_gcvp_count t;
grant select on U1.V_OUT_GCVP_COUNT to IT6_USER;
grant select on U1.V_OUT_GCVP_COUNT to LOADDB;
grant select on U1.V_OUT_GCVP_COUNT to LOADER;


