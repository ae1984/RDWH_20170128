create or replace procedure u1.ETLT_DWH_PORT_AUTO is
      s_mview_name         varchar2(30) := 'T_DWH_PORT_AUTO';
      vStrDate             date := sysdate;
      d_max_date           date;
      d_date_load          date := trunc(sysdate);
    begin

     select max(d.rep_date)
       into d_max_date
       from T_DWH_PORT_AUTO d;
     --
     for cur in (select d_max_date + level as rep_date
                   from dual
                  where d_max_date + level < d_date_load
                connect by rownum < d_date_load - d_max_date
                  order by 1
      ) loop
       insert /*+  append */ into T_DWH_PORT_AUTO(rep_date,deal_number,prod_type,total_debt,delinq_days,delinq_days_old,discount,eff_rate,reduced_cost,market_cost,total_ts_cost,total_set_cost,zalog_cost,is_on_balance,IS_GU_SALE,SALE_AMOUNT,SALE_DATE,ZALOG_CONTRACT_NUMBER)
        select /*+ parallel(20)*/ p.rep_date,
               p.deal_number,
               p.prod_type,
               p.total_debt,
               p.delinq_days,
               p.delinq_days_old,
               abs(t.total_discount) discount,
               ef.eff_rate eff_rate,
               max(ac.reduced_cost) keep (dense_rank last order by ac.date_calc_mm) reduced_cost,     --Восстановленная стоимость
               max(ac.market_cost) keep (dense_rank last order by ac.date_calc_mm) market_cost,       --Рыночная стоимость
               max(ac.total_ts_cost) keep (dense_rank last order by ac.date_calc_mm) total_ts_cost,   --Итоговая оценочная стоимость (автомат)
               max(ac.total_set_cost) keep (dense_rank last order by ac.date_calc_mm) total_set_cost, --Итоговая оценочная стоимость (ПОЗ)
               max(ac.zalog_cost) keep (dense_rank last order by ac.date_calc_mm) zalog_cost,          --Залоговая стоимость
               p.is_on_balance,
               max(case when coalesce(ac.zal_sale_date,ac.sale_date) <= p.rep_date
                        then 1 else 0 end) keep (dense_rank last order by ac.date_calc) is_gu_sale,
               max(ac.sale_amount) keep (dense_rank last order by ac.date_calc) sale_amount,
               max(ac.sale_date) keep (dense_rank last order by ac.date_calc) sale_date,
               max(ac.zalog_contract_number ) keep (dense_rank last order by ac.date_calc) zalog_contract_number
        from DWH_PORT p
        left join M_CONTRACT_PORT_DISCOUNT t on p.deal_number = t.contract_number -- по всем
                                                  and t.rep_date = p.rep_date

        left join (select distinct contract_number ,
                          max(e.rate_number) keep (dense_rank last order by rep_date) over(partition by contract_number) as eff_rate
                          from  M_EFF_RATE e
                          where e.rep_date <=  cur.rep_date  ) ef on ef.contract_number = p.deal_number  -- только по авто
        left join M_AUTO_COLLATERAL ac on ac.contract_number = p.deal_number
                                       --and ac.date_calc_mm <= trunc(cur.rep_date,'mm')
                                      and ac.date_calc <= p.rep_date
                                      /*and (ac.date_close is null
                                                  or ac.date_close > cur.rep_date)*/
        where p.rep_date = cur.rep_date
          and p.prod_type in ('АВТОКРЕДИТОВАНИЕ','АВТОКРЕДИТОВАНИЕ БУ','АВТОКРЕДИТЫ','РЕФИНАНСИРОВАНИЕ АВТОКРЕДИТА','ЗАЛОГОВОЕ АВТОКРЕДИТОВАНИЕ')
        group by p.rep_date,
                 p.deal_number,
                 p.prod_type,
                 p.total_debt,
                 p.delinq_days,
                 p.delinq_days_old,
                 abs(t.total_discount),
                 ef.eff_rate,
                 p.is_on_balance;
         commit;
     end loop;


    end ETLT_DWH_PORT_AUTO;
/

