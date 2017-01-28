create or replace procedure u1.ETLT_CON_REFIN_LINK_PERC_PRE is
      s_mview_name         varchar2(30) := 'T_CON_REFIN_LINK_PERCENT_PRE';
      vStrDate             date := sysdate;
      n_part_percent       number;
      n_refin_percent      number;
      n_total_percent      number;
    begin

      execute immediate 'truncate table T_CON_REFIN_LINK_PERCENT_PRE';
      --
      for rec in (select rpc.*,
               (case when rpc.date_change = rpc.refin_date then round((rpc.refin_summa/rpc.total_debt)*100,4) end) as new_refin_percent,
               (100 - nvl(sum((case when rpc.date_change = rpc.refin_date then round((rpc.refin_summa/rpc.total_debt)*100,4) end))
                       over (partition by rbo_contract_id_to, date_change),0)) as percent_ost,
               lead(rpc.date_change) over (partition by rpc.rbo_contract_id_to order by rpc.date_change) as date_change_next
          from M_RBO_CONTRACT_REF_PERC_CHANGE rpc
         order by rbo_contract_id_to, date_change, decode(rpc.date_change,rpc.refin_date,0,1)) loop
       if rec.date_change = rec.refin_date then
          n_part_percent := rec.new_refin_percent;
       else
          select nvl((select lp.part_percent
                  from T_CON_REFIN_LINK_PERCENT_PRE lp
                 where lp.rbo_contract_id_to = rec.rbo_contract_id_to
                   and lp.refin_rbo_contract_id = rec.refin_rbo_contract_id
                   and lp.date_change <= rec.date_change - 1
                   and nvl(lp.date_change_end,trunc(sysdate)) >= rec.date_change - 1),0)  as refin_percent,
               nvl((select sum(lp.part_percent)
                  from T_CON_REFIN_LINK_PERCENT_PRE lp
                 where lp.rbo_contract_id_to = rec.rbo_contract_id_to
                   and lp.date_change <= rec.date_change - 1
                   and nvl(lp.date_change_end,trunc(sysdate)) >= rec.date_change - 1
                   and exists (select 1 from M_RBO_CONTRACT_REF_PERC_CHANGE rp
                                where rp.rbo_contract_id_to = lp.rbo_contract_id_to
                                  and rp.refin_rbo_contract_id = lp.refin_rbo_contract_id
                                  and rp.date_change = rec.date_change)),0) +
               nvl((select 100 - nvl(sum(lp.part_percent),0)
                  from T_CON_REFIN_LINK_PERCENT_PRE lp
                 where lp.rbo_contract_id_to = rec.rbo_contract_id_to
                   and lp.date_change <= rec.date_change - 1
                   and nvl(lp.date_change_end,trunc(sysdate)) >= rec.date_change - 1
                   ),0) as total_percent
             into n_refin_percent, n_total_percent
             from dual;
          n_part_percent := round(n_refin_percent*rec.percent_ost/n_total_percent,4);
       end if;
       insert into T_CON_REFIN_LINK_PERCENT_PRE
       values(rec.rbo_contract_id_to,rec.refin_rbo_contract_id,rec.date_change,rec.date_change_end,rec.refin_summa,rec.refin_date,rec.total_debt,n_part_percent);
       commit;
       end loop;


    end ETLT_CON_REFIN_LINK_PERC_PRE;
/

