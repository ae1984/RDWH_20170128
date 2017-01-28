create or replace force view u1.v_out_pkb_count as
select /*+ parallel 5*/
       t.pkb_report_date,
       t.cnt_all,
       t.cnt_prim,
       t.cnt_stnd,
       t.cnt_notfound
  from m_pkb_count t;
grant select on U1.V_OUT_PKB_COUNT to IT6_USER;
grant select on U1.V_OUT_PKB_COUNT to LOADDB;
grant select on U1.V_OUT_PKB_COUNT to LOADER;


