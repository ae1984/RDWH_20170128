create or replace procedure u1.p_calc_provisions_dwh(p_date in date,p_type in number default 1,p_error out varchar2)
--p_type -1 новый расчет, 2- пересчет с измененнными данными ,3 - только пересчет на посл  день месяца
is
  e_user_exception exception;
  d_rep_date date:= p_date;
  n_value_750 number;
  n_val_721_750 number;
  n_val_691_720 number;
  s_prod varchar2(2) := 'M';
  n_bal number;
  n_spis number;
  n_prov number;
  n_colat number;
  n_value_750 number;
  n_val_nb_721_750 number;
  n_val_nb_691_720 number;
  n_bal_nb number;
  n_spis_nb number;
  n_prov_nb number;
  n_colat_nb number;
  n_num number;
  n_num_nb number;
  n_count_dwh number(10);
  n_count_rep number(10);
  d_rep_date20 date ;--:= trunc(d_rep_date,'mm')+19;
  n_mass_sum3_nb number;
  n_auto_sum3_nb number;
  n_mass_sum2_nb number;
  n_auto_sum2_nb number;
  n_mass_sum3_clc number;
  n_auto_sum3_clc number;
  n_mass_sum2_clc number;
  n_auto_sum2_clc number;
  n_prov_auto_clc number := 0;
  n_prov_mass_clc number := 0;
  n_prov_auto_nb number := 0;
  n_prov_mass_nb number := 0;
  n_auto_sum4_clc number;
  n_mass_sum4_clc number;
  n_auto_sum4_nb number;
  n_mass_sum4_nb number;

  n_total_npl_mass number;
  n_total_npl_auto number;
  /*
  n_sum3_npl_auto number;
  n_sum3_not_npl_auto number;
   number;
  n_sum3_not_npl_auto_calc number;
   */
  n_sum3_npl_mass number;
  n_sum3_not_npl_mass number;
  n_sum3_npl_mass_calc number;
  n_sum3_not_npl_mass_calc  number;

  n_sum_npl_mass number;
  n_sum_not_npl_mass number;
  n_sum_npl_auto number;
  n_sum_not_npl_auto number;
  n_proc_npl number;
  N_SUM_NOT_NPL_MASS_CALC number;
  N_SUM_NOT_NPL_auto_CALC number;
  n_sum4_npl_calc number;
  n_sum4_npl number;
begin

   select count(1)
   into n_count_dwh
   from dwh_port d
   where rep_date = d_rep_date
   ;
  if n_count_dwh = 0 then
    p_error := p_error||' Невозможно запустить пересчет. Нет данных в DWH_PORT на '|| to_char(d_rep_date,'dd.mm.yyyy');
    raise e_user_exception;
  end if;
  n_count_dwh := 0;
  --
  select count(1)
   into n_count_dwh
   from dwh_port d
   where rep_date = d_rep_date and d.prod_avto = 'AVTO'
   ;
  if n_count_dwh = 0 then
    p_error := p_error||' Невозможно запустить пересчет. Нет данных по авто в DWH_PORT на '|| to_char(d_rep_date,'dd.mm.yyyy');
    raise e_user_exception;
  end if;
  --
   n_count_dwh := 0;
  select count(1)
  into n_count_dwh
  from T_DWH_PORT_AUTO  a
  where a.rep_date = d_rep_date;
  if n_count_dwh = 0 then
     p_error := p_error||' Невозможно запустить пересчет. Нет данных  в T_DWH_PORT_AUTO на '|| to_char(d_rep_date,'dd.mm.yyyy');
    raise e_user_exception;
  end if;
  n_count_dwh := 0;
  select count(1)
  into n_count_dwh
  from dba_mview_analysis a
  where mview_name = 'M_CONTRACT_PORT_DISCOUNT'
    and a.LAST_REFRESH_DATE < d_rep_date;
   if n_count_dwh = 1 then
    p_error := p_error||' Невозможно запустить пересчет. Не обновлен M_CONTRACT_PORT_DISCOUNT на '|| to_char(d_rep_date,'dd.mm.yyyy');
    raise e_user_exception;
  end if;

  if p_type = 1 then
  -- Сначала собираем на 24 месяца назад всю задолженность на балансе и внебалансе
      update T_DWH_PROVISIONS p
      set rep_type = 'pre2'
      where rep_type = 'pre';



    -- dbms_output.put_line('rr');
       for rec in (select  value as rep_date,'fact' as rep_type
                   from M_RBO_CALENDAR_VALUE r
                   where value between add_months(trunc(d_rep_date,'MM'),-1) and trunc(d_rep_date,'MM')
                     and r.calendar_name = 'LAST_MONTH_DAY'
                  union all
                  select d_rep_date as rep_date,'pre' as rep_type
                   from dual
                  order by rep_date
                ) loop
  -- поскольку последний рабочий день месяца сначала берется просто как день расчета, то на следующий день ставим признак, что это последний рабочий день месяца

                  update T_DWH_PROVISIONS
                  set rep_type = 'fact'
                  where rep_type = 'pre2'
                    and rep_date = rec.rep_date
                    and rec.rep_type = 'fact';
                  commit;


                  update T_DWH_PROVISIONS p
                  set rep_type = 'pre'
                  where p.rep_type = 'pre2'
                  and p.rep_date = p_date
                  and rec.rep_type = 'pre';

                 --Проверяем есть ли уже расчет на заданные даты
                  select count(1)
                    into n_count_rep
                  from T_DWH_PROVISIONS p
                  where p.rep_date = rec.rep_date
                    and p.rep_type in( 'pre','fact');

                    if n_count_rep = 0 then
                        insert into T_DWH_PROVISIONS(REP_DATE,PROD,LONG_DELINQ,VALUE_CALC,IS_ON_BALANCE,REP_LVL,REP_TYPE,NAME)
                          Select /*+ parallel(20)*/ rep_date,prod, long_delinq, sum(total_debt)/1000 as debt, IS_ON_BALANCE,1 as lvl,rec.rep_type,name
                                from
                                (
                                 select t.rep_date,
                                         d.Prod,
                                         d.name as long_delinq,
                                         nvl(t.TOTAL_DEBT,0) + nvl(pd.TOTAL_DISCOUNT,0) as Total_Debt,
                                         d.is_on_balance as is_on_balance,
                                         to_char(rec.rep_date,'yyyy.mm.dd') as name
                                 from dwh_port t
                                 left join M_CONTRACT_PORT_DISCOUNT pd on pd.rep_date = t.rep_date and pd.CONTRACT_NUMBER = t.deal_number
                                 left join T_RDWH_DELINQ_DAYS d on d.prod = case when t.prod_avto = 'AVTO'  then 'A'  else 'M' end
                                                                and d.is_on_balance = 1 and nvl(t.delinq_days,0) between d.day_min and d.day_max
                                                               -- and d.name != 'Colateral'
                                 where t.rep_date =rec.rep_date and t.IS_ON_BALANCE <> 'I'
                               /*union all
                               ---/// добавила задолженность по картам KASPI_RED, скорее всего все будут без просрочки
                                 select kp.rep_date,
                                           d.Prod,
                                           d.name as long_delinq,
                                           nvl(kp.TOTAL_DEBT,0)  as Total_Debt,
                                           d.is_on_balance as is_on_balance,
                                           to_char(rec.rep_date,'yyyy.mm.dd') as name
                                   from M_DWH_KASPIRED_PORT kp
                                   left join T_RDWH_DELINQ_DAYS d on d.prod = 'M'
                                                                  and d.is_on_balance = 1 and nvl(kp.delinq_days,0) between d.day_min and d.day_max
                                   where kp.rep_date = rec.rep_date -- and t.IS_ON_BALANCE <> 'I' --вынос за баланс пока не предусмотрен
                              */ --//
                              union all
                              select rec.rep_date,d.prod,d.name as long_delinq,0 as total_debt,d.is_on_balance,to_char(rec.rep_date,'yyyy.mm.dd') as name
                              from T_RDWH_DELINQ_DAYS d
                              where d.is_on_balance = 1
                               )
                              group by prod,rep_date, long_delinq, IS_ON_BALANCE,name
                              order by long_delinq;

                    --отдельно по внебалансу
                    -- Списания по картам KASPI_RED не предусмотрено
                           insert into T_DWH_PROVISIONS(REP_DATE,PROD,LONG_DELINQ,VALUE_CALC,IS_ON_BALANCE,REP_LVL,REP_TYPE,NAME)
                           Select /*+parallel(20)*/ rep_date,prod, long_delinq, sum(total_debt)/1000 as debt, IS_ON_BALANCE,1 as lvl,rec.rep_type,name
                                from
                                (
                                 select /*+ parallel 20*/ t.rep_date,
                                         d.prod as Prod,
                                         d.name as long_delinq,
                                         nvl(t.TOTAL_DEBT,0) + nvl(pd.TOTAL_DISCOUNT,0) as Total_Debt,
                                          d.is_on_balance,
                                         to_char(rec.rep_date,'yyyy.mm.dd') as name
                                 from DWH_PORT t
                                 left join M_CONTRACT_PORT_DISCOUNT pd on pd.rep_date = t.rep_date and pd.CONTRACT_NUMBER = t.deal_number
                                 left join T_RDWH_DELINQ_DAYS d on d.prod = case when t.prod_avto = 'AVTO'  then 'A'  else 'M' end
                                                                and  d.is_on_balance = 0  and nvl(t.delinq_days,0) between d.day_min and d.day_max
                                                               -- and d.name != 'Colateral'
                                 where t.rep_date = rec.rep_date
                                   and t.IS_ON_BALANCE = 'W'
                              union all
                              select rec.rep_date,d.prod,d.name as long_delinq,0 as total_debt,d.is_on_balance,to_char(rec.rep_date,'yyyy.mm.dd') as name
                              from T_RDWH_DELINQ_DAYS d
                              where d.is_on_balance = 0
                               )
                              group by prod,rep_date, long_delinq, IS_ON_BALANCE,name
                              order by long_delinq;

            --отдельно по приведенной стоимости обеспечения
                 insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,is_on_balance,rep_lvl,rep_type,name)
                select /*+parallel(20)*/ p.rep_date,p.prod,'Colateral' as long_delinq, a.PV_market ,p.is_on_balance,p.rep_lvl,p.rep_type,p.name
                  from (
                     select t.rep_date, sum ((t.market_cost*0.7)/(1+nvl(t.eff_rate,0)))/1000 as PV_market
                        from u1.T_DWH_PORT_AUTO t
                       where t.delinq_days >180 and t.market_cost > 0
                       and nvl(t.is_gu_sale,0) = 0
                       and t.rep_date = rec.rep_date
                       and t.is_on_balance = 'Y'
                       group by t.rep_date
                      ) a
                  left join T_DWH_PROVISIONS  p on p.prod = 'A' and p.long_delinq ='Written' and p.rep_date = a.rep_date and p.rep_type != 'pre2'
                  order by rep_date;

              end if;
            end loop;
         commit;
      end if;
      commit;


      if p_type != 3 then
          -- Расчет провизий
          --чистим результаты
        delete from T_DWH_PROVISIONS t
        where t.rep_date = d_rep_date
          and t.rep_lvl>1;
        commit;

          --расчет Пункт № 59.2
          insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,name,rep_type)
            select /*+parallel(20)*/ d_rep_date,prod, long_delinq ,
                   case when value_calc > 1 then 1 else value_calc end as value_calc,
                   case when value_nb > 1 then 1 else value_nb end as value_nb,
                    is_on_balance,rep_lvl ,name,'item2' as rep_type
            from
              (
              select d_rep_date,
                     prod,
                     long_delinq ,
                     round(lead(sum(round(col2,5)),1,0) over ( order by n_del) /sum(round(col1,5)),4) as value_calc,
                     round(lead(sum(round(col2_nb,5)),1,0) over ( order by n_del) /sum(round(col1_nb,5)),4) as value_nb,
                     is_on_balance,
                     2 as rep_lvl,
                     'Пункт № 59.2' as name
              from
                   (select p.rep_date,
                           p.long_delinq,
                           p.value_calc,
                           2 as rep_lvl,
                           dense_rank() over (order by rep_date) n_dat,
                           dense_rank() over (partition by rep_date order by long_delinq) n_del,
                           case when dense_rank() over (order by rep_date) between 1 and 24 then value_calc else 0 end as col1,
                           case when dense_rank() over (order by rep_date) between 2 and 25 then value_calc else 0 end as col2,
                           case when dense_rank() over (order by rep_date) between 1 and 24 then nvl(value_nb,value_calc) else 0 end as col1_nb,
                           case when dense_rank() over (order by rep_date) between 2 and 25 then nvl(value_nb,value_calc)  else 0 end as col2_nb,
                           p.is_on_balance,
                           p.prod
                      from T_DWH_PROVISIONS P
                      where p.rep_date between   add_months(d_rep_date,-24) and d_rep_date
                        and p.prod = s_prod
                        and p.rep_lvl = 1
                        and long_delinq not in ('>750','Written')
                        and p.rep_type in ('pre','fact')
                      order by long_delinq ,rep_date ,p.prod
                      )
                 group by long_delinq,n_del,is_on_balance,prod
             )
             where long_delinq != '721 - 750'
          union all
          select d_rep_date,
                 s_prod as prod,
                 '721 - 750' as long_delinq,
                  round(power(round(case when sum(round(col2,5))/sum(round(col1,5)) > 1 then 1 else sum(round(col2,5))/sum(round(col1,5)) end,4),6),4) as value_calc,
                  round(power(round(case when sum(round(col2_nb,5))/sum(round(col1_nb,5)) > 1 then 1 else sum(round(col2_nb,5))/sum(round(col1_nb,5)) end,4),6),4) as value_nb,
                  is_on_balance,
                  2 as rep_lvl,
                  'Пункт № 59.2' as name,
                  'item2' as rep_type
           from
               (
               select p.rep_date,p.long_delinq,
                      case when long_delinq = '>750' and dense_rank() over (order by rep_date) between 2 and 25 then value_calc else 0 end as col2,
                      case when dense_rank() over (order by rep_date) between 1 and 24 then value_calc else 0 end as col1,
                      case when long_delinq = '>750' and dense_rank() over (order by rep_date) between 2 and 25 then nvl(value_nb,value_calc)  else 0 end as col2_nb,
                      case when dense_rank() over (order by rep_date) between 1 and 24 then nvl(value_nb,value_calc)  else 0 end as col1_nb,
                      p.prod,
                      p.is_on_balance
                    from T_DWH_PROVISIONS P
                  where p.rep_date between   add_months(d_rep_date,-24) and d_rep_date
                    and p.prod = s_prod
                    and p.rep_lvl = 1
                    and p.rep_type in ('pre','fact')
                    and long_delinq  in ('>750','721 - 750')
                  order by long_delinq ,rep_date ,p.prod
                  )
           group by prod,is_on_balance;
         commit;

        select value_calc, nvl(value_nb,value_calc)
        into n_val_691_720, n_val_nb_691_720
        from T_DWH_PROVISIONS
        where rep_type = 'item2'
          and prod = s_prod
          and long_delinq = '691 - 720'
          and rep_date = d_rep_date
          ;
         -- dbms_output.put_line( 'n_val_691_720='||n_val_691_720||' n_val_nb_691_720='||n_val_nb_691_720);
        n_num := 1;
        n_num_nb := 1;
        for rec in (select rep_date,
                           prod,
                           long_delinq,
                           value_calc,
                           value_nb,
                           is_on_balance,
                           rep_lvl,
                           rep_type,
                           name
                      from T_DWH_PROVISIONS
                      where rep_type = 'item2'
                      and long_delinq != 'Colateral'
                      and prod = s_prod
                      and long_delinq != '721 - 750'
                      and rep_date = d_rep_date
                      order by long_delinq desc
          ) loop
           n_num := n_num*rec.value_calc;
           n_num_nb := n_num_nb*rec.value_nb;

           insert into T_DWH_PROVISIONS (rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,name,rep_type)
           values (rec.rep_date,rec.prod,rec.long_delinq,round(n_num,4),round(n_num_nb,4),rec.is_on_balance,rec.rep_lvl,'Пункт № 59.3','item3');
          end loop;
        commit;
       --пункт 3-5
        select value_calc, nvl(value_nb,value_calc)
        into n_val_691_720, n_val_nb_691_720
        from T_DWH_PROVISIONS
        where rep_type = 'item2'
          and prod = s_prod
          and long_delinq = '691 - 720'
          and rep_date = d_rep_date
          ;

        select value_calc, nvl(value_nb,value_calc)
          into n_val_721_750,n_val_nb_721_750
        from T_DWH_PROVISIONS
        where rep_type = 'item2'
          and prod=s_prod
          and long_delinq = '721 - 750'
          and rep_date = d_rep_date;

       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,name,rep_type)
         select /*+parallel(20)*/ d_rep_date,p.prod,p.long_delinq ,round(p.value_calc * n_val_721_750,4) as value_calc,
         round(nvl(p.value_nb, p.value_calc) * n_val_nb_721_750,4) as value_calc,
         is_on_balance,2,'Пункт № 60.1' as name,'item4' as rep_type
           from T_DWH_PROVISIONS p
          where rep_type = 'item3'
            and prod=s_prod
            and rep_date = d_rep_date;

       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
            select /*+parallel(20)*/ d_rep_date,
              dd.prod,
              dd.name,
              case when dd.day_max > 360 then 1 else p.value_calc end as value_calc,
              case when dd.day_max > 360 then 1 else nvl(p.value_nb,p.value_calc) end as value_nb ,
              dd.is_on_balance,
              2 as rep_lvl,
              'item5' as rep_type  ,
              'Пункт № 60.2' as name
        from t_rdwh_delinq_days dd
         left join T_DWH_PROVISIONS  p on dd.name = p.long_delinq and dd.prod = p.prod  and p.rep_date = d_rep_date and p.rep_type = 'item4'
         where dd.prod = s_prod
           and dd.is_on_balance = 1;

       select sum(case when p.is_on_balance = 1 then value_calc end) as sum_bal,
              sum(case when p.is_on_balance = 0 then value_calc end) as sum_spis,
              sum(case when p.is_on_balance = 1 then nvl(value_nb,value_calc) end) as sum_bal_nb,
              sum(case when p.is_on_balance = 0 then nvl(value_nb,value_calc) end) as sum_spis_nb
       into n_bal,n_spis,n_bal_nb,n_spis_nb
         from T_DWH_PROVISIONS p
          where rep_date = d_rep_date
            and prod = s_prod
            and rep_lvl=1
            and p.rep_type in ('fact','pre');
       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'Gross',n_bal,n_bal_nb,1 ,3,'itog1','Portfolio');

       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'IFRS',n_bal - n_spis,n_bal_nb-n_spis_nb,1,3,'itog1','Portfolio');


        select round(sum(round(p.value_calc) * round(p1.value_calc,4)),4),
               round(sum(nvl(round(p.value_nb),round(p.value_calc)) * nvl(round(p1.value_nb,4),round(p1.value_calc,4))),4)
        into n_prov, n_prov_nb
        from T_DWH_PROVISIONS p
        left join T_DWH_PROVISIONS p1 on p.rep_date = p1.rep_date and p.prod = p1.prod and p.long_delinq = p1.long_delinq and p1.rep_type = 'item5'
        where p.rep_date = d_rep_date
          and p.prod=s_prod
          and p.rep_lvl =1
          and p.is_on_balance = 1;

       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'Gross',n_prov,n_prov_nb,1,3,'itog2','Provisions');


       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'IFRS',(n_prov - n_spis),(n_prov_nb - n_spis_nb),1,3,'itog2','Provisions');


       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'Gross',round(n_prov/n_bal,4),round(n_prov_nb/n_bal_nb,4),1,3,'itog3','Provisions %');


       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'IFRS',round((n_prov - n_spis)/(n_bal - n_spis),4) ,round((n_prov_nb - n_spis_nb)/(n_bal_nb - n_spis_nb),4),1,3,'itog3','Provisions %');
       commit   ;

       --Расчет по авто

       s_prod := 'A';

       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        select /*+parallel(20)*/ d_rep_date,
               prod,
               long_delinq ,
               case when value_calc > 1 then 1 else value_calc end as value_calc,
               case when value_nb > 1 then 1 else value_nb end as value_nb,
               is_on_balance,
               rep_lvl,
               'item2' as rep_type,
               name
         from (
               select d_rep_date,
                      prod,
                      long_delinq,
                      round(lead(sum(col2),1,0) over (order by n_del)/sum(col1),4)  as value_calc,
                      round(lead(sum(col2_nb),1,0) over ( order by n_del)/sum(col1_nb),4) as value_nb,
                      is_on_balance,
                      2 as rep_lvl,
                      'Пункт № 63.2' as name
                from
                   (select p.rep_date,
                           p.long_delinq,
                           p.value_calc,
                           2 as rep_lvl,
                           dense_rank() over (order by rep_date) n_dat,
                           dense_rank() over (partition by rep_date order by long_delinq) n_del,
                           case when dense_rank() over (order by rep_date) between 1 and 24 then value_calc else 0 end as col1,
                           case when dense_rank() over (order by rep_date) between 2 and 25 then value_calc else 0 end as col2      ,
                           case when dense_rank() over (order by rep_date) between 1 and 24 then nvl(value_nb,value_calc) else 0 end as col1_nb,
                           case when dense_rank() over (order by rep_date) between 2 and 25 then nvl(value_nb,value_calc)  else 0 end as col2_nb,
                           p.is_on_balance,
                           p.prod
                        from T_DWH_PROVISIONS P
                      where p.rep_date between add_months(d_rep_date,-24) and d_rep_date
                        and p.prod = s_prod
                        and p.rep_lvl = 1
                        and long_delinq not in ('>210','Written','Colateral')
                        and p.rep_type in ('pre','fact')
                      order by long_delinq ,rep_date ,p.prod
                    )
                  group by long_delinq,n_del,is_on_balance,prod
            ) where long_delinq != '181 - 210'
         union all
         select d_rep_date,
                s_prod as prod,
                '181 - 210' as long_delinq,
                round(power(round(case when sum(round(col2,5))/sum(round(col1,5)) > 1 then 1 else sum(round(col2,5))/sum(round(col1,5)) end,4),6),4) as value_calc,
                --power(round(case when sum(round(col2_nb,5))/sum(round(col1_nb,5)) > 1 then 1 else sum(round(col2_nb,5))/sum(round(col1_nb,5)) end,3),6) as value_nb,
                1 as value_nb,
                is_on_balance,
                2 as rep_lvl,
                'item2' as rep_type,
                'Пункт № 63.2' as name
          from (
               select p.rep_date,p.long_delinq,
                      case when long_delinq = '>210' and dense_rank() over (order by rep_date) between 2 and 25 then value_calc else 0 end as col2,
                      case when dense_rank() over (order by rep_date) between 1 and 24 then value_calc else 0 end as col1,
                      case when long_delinq = '>210' and dense_rank() over (order by rep_date) between 2 and 25 then nvl(value_nb,value_calc)  else 0 end as col2_nb,
                      case when dense_rank() over (order by rep_date) between 1 and 24 then nvl(value_nb,value_calc)  else 0 end as col1_nb,
                      p.prod,
                      p.is_on_balance
                    from T_DWH_PROVISIONS P
                  where p.rep_date between   add_months(d_rep_date,-24) and d_rep_date
                    and p.prod = s_prod
                    and p.rep_lvl = 1
                    and p.rep_type in ('pre','fact')
                    and long_delinq  in ('>210','181 - 210')
                  order by long_delinq ,rep_date ,p.prod
                  )
           group by prod,
                    is_on_balance;


       n_bal := 1;
       n_bal_nb := 1;
       for rec in (select d_rep_date as rep_date,
                          dd.prod,
                          dd.name as long_delinq,
                          nvl(p.value_calc,1) as value_calc,
                          nvl(p.value_nb,p.value_calc) as value_nb,
                          dd.is_on_balance
                  from T_RDWH_DELINQ_DAYS dd
                  left join T_DWH_PROVISIONS p on dd.name = p.long_delinq and dd.prod = p.prod and dd.is_on_balance = p.is_on_balance  and p.rep_lvl = 2 and p.rep_date = d_rep_date
                  where dd.prod = s_prod
                   and dd.is_on_balance = 1
                   and p.rep_date = d_rep_date
                   and p.rep_type = 'item2'
                   order by dd.day_min desc)
       loop
             n_bal := n_bal*rec.value_calc;
             n_bal_nb :=n_bal_nb*rec.value_nb;
              if rec.long_delinq = '181 - 210' then
                  insert into  T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
                   values
                   (rec.rep_date,rec.prod,rec.long_delinq,1,1,rec.is_on_balance,2,'item3','Пункт № 79.3' );
              else
                   insert into  T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
                   values
                   (rec.rep_date,rec.prod,rec.long_delinq,round(n_bal,4),round(n_bal_nb,4),rec.is_on_balance,2,'item3','Пункт № 79.3' );
              end if;

       end loop;
       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'>210',1,1,1,2,'item3','Пункт № 63.3');

       select sum(case when p.is_on_balance = 1 then value_calc end) as sum_bal,
              sum(case when p.is_on_balance = 0 and long_delinq = 'Written' then value_calc end) as sum_spis,
              sum(case when p.is_on_balance = 0 and long_delinq = 'Colateral' then value_calc end) as sum_colat,
              sum(case when p.is_on_balance = 1 then nvl(value_nb,value_calc) end) as sum_bal_nb,
              sum(case when p.is_on_balance = 0  and long_delinq = 'Written' then nvl(value_nb,value_calc) end) as sum_spis_nb,
              sum(case when p.is_on_balance = 0  and long_delinq = 'Colateral' then nvl(value_nb,value_calc) end) as sum_colat_nb
         into n_bal, n_spis, n_colat, n_bal_nb, n_spis_nb, n_colat_nb
       from T_DWH_PROVISIONS p
       where rep_date = d_rep_date
         and prod = s_prod
         and rep_lvl = 1;

       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'Gross',n_bal,n_bal_nb,1 ,3,'itog1','Portfolio');

       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'IFRS',n_bal - n_spis,n_bal_nb-n_spis_nb,1,3,'itog1','Portfolio');


        select round(sum(round(p.value_calc) * round(p1.value_calc,4)),4),
               round(sum(nvl(round(p.value_nb),round(p.value_calc)) * nvl(round(p1.value_nb,4),round(p1.value_calc,4))),4)
        into n_prov, n_prov_nb
        from T_DWH_PROVISIONS p
        left join T_DWH_PROVISIONS p1 on p.rep_date = p1.rep_date and
                                         p.prod = p1.prod and
                                         p.long_delinq = p1.long_delinq and
                                         p1.rep_type = 'item3'
        where p.rep_date = d_rep_date
          and p.prod = s_prod
          and p.rep_lvl =1
          and p.is_on_balance = 1;

       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'Gross',n_prov-n_colat,n_prov_nb-n_colat_nb,1,3,'itog2','Provisions');


       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'IFRS',(n_prov - n_colat - n_spis),(n_prov_nb -n_colat_nb - n_spis_nb),1,3,'itog2','Provisions');


       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'Gross',round((n_prov - n_colat)/n_bal,4),round((n_prov_nb- n_colat_nb)/n_bal_nb,4),1,3,'itog3','Provisions %');


       insert into T_DWH_PROVISIONS(rep_date,prod,long_delinq,value_calc,value_nb,is_on_balance,rep_lvl,rep_type,name)
        values
       (d_rep_date,s_prod,'IFRS',round((n_prov - n_colat - n_spis)/(n_bal - n_spis),4) ,round((n_prov_nb - n_colat_nb - n_spis_nb)/(n_bal_nb - n_spis_nb),4),1,3,'itog3','Provisions %');
       commit;
  end if;

  --запускаем пересчет провизий (Удельный вес) на последний рабочий день по зависимости от провизий от 20 числа
 select count(1)
  into n_count_dwh
  from m_rbo_calendar_value v
  where v.value = d_rep_date
    and v.calendar_name = 'LAST_MONTH_DAY';


   if to_number(to_char(d_rep_date,'DD')) > 20 then
    select min (d.yyyy_mm_dd)
    into d_rep_date20
    from V_TIME_DAYS d
    where d.yyyy_mm_dd between trunc(d_rep_date,'mm')+19 and d_rep_date
    and not exists (select 1  from  M_RBO_CALENDAR_VALUE where calendar_name in ('HOLIDAYS','HOLIDAYS_W') and value = d.yyyy_mm_dd );
  else d_rep_date20 := to_date('01-01-9999','dd-mm-yyyy');
  end if;

 --if n_count_dwh > 0 then -- только для последнего расчетного дня месяца рассчет скорректированных провизий
  if d_rep_date20 < d_rep_date then --после 20-го числа на каждый день рассчитываем УВ


   select count(1)
   into n_count_dwh
   from T_DWH_PROVISIONS d
   where rep_date = d_rep_date20;
  if n_count_dwh = 0 then
     p_error := p_error||' Невозможно запустить пересчет. Нет данных в T_DWH_PROVISIONS на '|| to_char(d_rep_date20,'dd.mm.yyyy');
     raise e_user_exception;
   end if;

  select max(value_nb) keep (dense_rank last order by rep_date)
  into n_proc_npl
  from t_dwh_provisions
  where long_delinq = 'NPL'
  and prod = 'M';

  if nvl(n_proc_npl,0) = 0 then
      p_error := p_error||' Невозможно запустить пересчет. Нет данных по процентам NPL';
     raise e_user_exception;
  end if;

   --Удаляем пересчет, если он уже был
    delete
    from T_DWH_PROVISIONS p
    where p.rep_date = d_rep_date
      and p.rep_type like 'recalc%';
    commit;

    -- сначала собираем на отчетный день  всю задолженность на балансе
    insert into T_DWH_PROVISIONS(REP_DATE,PROD,LONG_DELINQ,VALUE_CALC,IS_ON_BALANCE,REP_LVL,REP_TYPE,NAME)
    Select /*+ parallel(20)*/ rep_date,prod, long_delinq, round(sum(total_debt)/1000) as debt, IS_ON_BALANCE,1 as lvl,rep_type,name
          from
          (
            select t.rep_date,
                   d.prod as prod,
                   d.name as long_delinq,
                   nvl(t.TOTAL_DEBT,0) + nvl(pd.TOTAL_DISCOUNT,0) as Total_Debt,
                   d.is_on_balance as is_on_balance,
                   'recalc' as rep_type,
                   'r_'||to_char(d_rep_date,'yyyy.mm.dd') as name
           from DWH_PORT t
           left join M_CONTRACT_PORT_DISCOUNT pd on pd.rep_date = t.rep_date and pd.CONTRACT_NUMBER = t.deal_number
           left join T_RDWH_DELINQ_DAYS d on d.prod =  case when t.prod_avto = 'AVTO'  then 'A' else 'M' end
                                          and d.is_on_balance = 1 and nvl(t.delinq_days,0) between d.day_min and d.day_max
                                         -- and d.name != 'Colateral'
           where t.rep_date =d_rep_date and t.IS_ON_BALANCE = 'Y'
        union all
        select d_rep_date,d.prod,d.name as long_delinq,0 as total_debt,d.is_on_balance,'recalc' as rep_type,'r_'||to_char(d_rep_date,'yyyy.mm.dd') as name
        from T_RDWH_DELINQ_DAYS d
        where d.is_on_balance = 1
          and d.prod = 'M'
         union all
        select d_rep_date,'A',d.name as long_delinq,0 as total_debt,d.is_on_balance,'recalc' as rep_type,'r_'||to_char(d_rep_date,'yyyy.mm.dd') as name
        from T_RDWH_DELINQ_DAYS d
        where d.is_on_balance = 1
          and d.prod = 'A'
         )
        group by prod, rep_date, long_delinq, IS_ON_BALANCE, name, rep_type
        order by long_delinq;
      commit;

      -- берем итоговые ставки провизий по авто на 20-е число
      select
          value_calc, value_nb
      into n_prov_auto_clc, n_prov_auto_nb
      from T_DWH_PROVISIONS P
      where long_delinq  ='IFRS'
      and rep_type in ('itog3')
      and rep_date = d_rep_date20
      and prod = 'A';
     -- p_error := 'n_prov_auto_clc='||n_prov_auto_clc||';n_prov_auto_nb='||n_prov_auto_nb;

     -- берем итоговые ставки провизий по масс на 20-е число
      select value_calc, value_nb
      into n_prov_mass_clc,n_prov_mass_nb
      from T_DWH_PROVISIONS P
      where long_delinq  ='IFRS'
      and rep_type in ('itog3')
      and rep_date = d_rep_date20
      and prod = 'M';
    --  p_error := p_error ||'n_prov_mass_clc='||n_prov_mass_clc||';n_prov_mass_nb='||n_prov_mass_nb;

     --теперь суммы, которые мы должны посадить по общей ставке на 20-е число
      insert into T_DWH_PROVISIONS(REP_DATE,PROD,LONG_DELINQ,VALUE_CALC,Value_nb,IS_ON_BALANCE,REP_LVL,REP_TYPE,NAME)
      select rep_date,
              prod,
              long_delinq,
              round(value_calc * (case when prod = 'A' then n_prov_auto_clc else n_prov_mass_clc end)) as value_calc,
              round(value_calc * (case when prod = 'A' then n_prov_auto_nb else n_prov_mass_nb end)) as value_nb,
              1,
              2,
              'recalc2',
              'Нетто провизии'
      from T_DWH_PROVISIONS
      where rep_date =  d_rep_date
        and rep_type = 'recalc'
      order by rep_type,prod,long_delinq;
      commit;

       --приведенная стоимость
      select round(sum(d.value_calc))
          into n_colat
      from T_DWH_PROVISIONS d
      where d.rep_date = d_rep_date
        and d.long_delinq  in ('Colateral')
        and prod = 'A';

      select sum(value_calc)-- задолженность по всем авто с просрочкой > 180
        into n_num
      from T_DWH_PROVISIONS p
      join t_rdwh_delinq_days d on d.name = p.long_delinq and d.prod = p.prod
      where rep_date =  d_rep_date
        and rep_type = 'recalc'
        and p.prod = 'A'
        and d.day_min > 180;

-- теперь вычисляем сколько посадим, если будем создавать провизии по корзинам просрочки, т. е. задолженность по корзинам просрочки * на ставки по каждой корзине  просрочки на 20-е число
     -- для авто с кол-вом дней просрочки > 180 учитываем приведенную стоимость

      insert into T_DWH_PROVISIONS(REP_DATE,PROD,LONG_DELINQ,VALUE_CALC,Value_nb,IS_ON_BALANCE,REP_LVL,REP_TYPE,NAME)
      select /*+parallel(20)*/ tt.rep_date,tt.prod,tt.long_delinq,
             case
               when tt.prod = 'A' and tt.day_min > 180 then
                    round(tt.value_calc *t.value_calc - tt.value_calc*n_colat/n_num)
               else
                     round(tt.value_calc *t.value_calc)  end as value_calc,
             case
                when tt.prod = 'A' and tt.day_min > 180 then
                   round(tt.value_calc *t.value_nb - tt.value_calc*n_colat/n_num)
                 else round(t.value_nb * tt.value_calc) end as value_nb,
             1,
             2,
             'recalc3',
             'Промежуточные провизии'
      from
          (select p.rep_date,
                 p.prod,
                 p.long_delinq,
                 round(value_calc,4) as value_calc,
                 round(value_nb,4) as value_nb,
                 p.rep_type
          from T_DWH_PROVISIONS p
          where rep_date =  d_rep_date20
          and ((rep_type = 'item3' and  p.prod = 'A') or ( rep_type = 'item5' and  p.prod = 'M'))
         ) t
      join (
              select p.rep_date,
                     p.prod,
                     p.long_delinq,
                     round(p.VALUE_CALc) as value_calc,
                     round(p.value_nb) as value_nb,
                     p.rep_type,
                     d.day_min
              from T_DWH_PROVISIONS p
              join t_rdwh_delinq_days d on d.name = p.long_delinq and d.prod = p.prod
              where rep_date =  d_rep_date
              and rep_type = 'recalc'
              order by rep_type,prod,long_delinq) tt on tt.prod = t.prod and tt.long_delinq = t.long_delinq;
      commit;



          select
                  sum(case when d.rep_type = 'recalc2' and d.prod = 'A' then d.value_nb else 0 end) as value2_auto,
                  sum(case when d.rep_type = 'recalc2' and d.prod = 'M' then d.value_nb else 0 end) as value2_mass,
                  sum(case when d.rep_type = 'recalc2' and d.prod = 'A' then d.value_calc else 0 end) as value2_auto_clc,
                  sum(case when d.rep_type = 'recalc2' and d.prod = 'M' then d.value_calc else 0 end) as value2_mass_clc,
                  sum(case when d.rep_type = 'recalc' and d.prod = 'M' and rd.day_min > 90 and rd.day_min <= 360 then d.value_calc else 0 end) as total_npl_mass,--total_debt не NPL масс
                 -- sum(case when d.rep_type = 'recalc' and d.prod = 'A' and rd.day_min > 90 and rd.day_min <= 360 then d.value_calc else 0 end) as total_npl_auto,   --total_debt не NPL авто

                 -- sum(case when d.rep_type = 'recalc3' and d.prod = 'A' and rd.day_min > 90 then d.value_nb else 0 end) as value3_npl_auto,--промежуточные провизии NPL
                --  sum(case when d.rep_type = 'recalc3' and d.prod = 'A' and rd.day_min <= 90 then d.value_nb else 0 end) as value3_not_npl_auto,--промежуточные провизии не NPL

                --  sum(case when d.rep_type = 'recalc3' and d.prod = 'A' and rd.day_min > 90 then d.value_calc else 0 end) as value3_npl_auto_calc,--промежуточные провизии NPL
                --  sum(case when d.rep_type = 'recalc3' and d.prod = 'A' and rd.day_min <= 90 then d.value_calc else 0 end) as value3_not_npl_auto_calc,--промежуточные провизии не NPL

                  sum(case when d.rep_type = 'recalc3' and d.prod = 'M' and rd.day_min > 90 and rd.day_min <= 360 then d.value_nb else 0 end) as value3_npl_mass,--промежуточные провизии NPL
                  sum(case when d.rep_type = 'recalc3' and d.prod = 'M' and rd.day_min <= 90 then d.value_nb else 0 end) as value3_not_npl_mass,--промежуточные провизии не NPL

                  sum(case when d.rep_type = 'recalc3' and d.prod = 'M' and rd.day_min > 90 then d.value_calc else 0 end) as value3_npl_mass_calc,--промежуточные провизии NPL
                  sum(case when d.rep_type = 'recalc3' and d.prod = 'M' and rd.day_min <= 90 then d.value_calc else 0 end) as value3_not_npl_mass_calc,--промежуточные провизии не NPL

                  -----------------------------------------------------------------------------------------------
                  sum(case when d.rep_type = 'recalc3' and d.prod = 'A' then d.value_nb else 0 end) as value3_auto,
                  sum(case when d.rep_type = 'recalc3' and d.prod = 'A' then d.value_calc else 0 end) as value3_auto_clc,
                 -- sum(case when d.rep_type = 'recalc3' and d.prod = 'M' then d.value_nb else 0 end) as value3_mass, --старый расчет масс
                --  sum(case when d.rep_type = 'recalc3' and d.prod = 'M' then d.value_calc else 0 end) as value3_mass_clc,
                  --------------------------------------------------------------------------------------------------------
                  sum(case when d.rep_type = 'recalc3' and d.prod = 'A' and rd.day_min < 181 then d.value_nb else 0 end) as value4_auto,
                  sum(case when d.rep_type = 'recalc3' and d.prod = 'A' and rd.day_min < 181 then d.value_calc else 0 end) as value4_auto_clc
                 /* sum(case when d.rep_type = 'recalc3' and d.prod = 'M' and rd.day_min < 361 then d.value_nb else 0 end) as value4_mass,--старый расчет масс
                  sum(case when d.rep_type = 'recalc3' and d.prod = 'M' and rd.day_min < 361 then d.value_calc else 0 end) as value4_mass_clc*/
          into n_auto_sum2_nb,n_mass_sum2_nb,n_auto_sum2_clc,n_mass_sum2_clc, n_total_npl_mass,--,n_total_npl_auto,
               n_sum3_npl_mass,n_sum3_not_npl_mass,n_sum3_npl_mass_calc,n_sum3_not_npl_mass_calc ,   --промежуточные провизии NPL и не NPL
               n_auto_sum3_nb,n_auto_sum3_clc,/*n_mass_sum3_nb,n_mass_sum3_clc,*/
               n_auto_sum4_nb,n_auto_sum4_clc/*,n_mass_sum4_nb,n_mass_sum4_clc*/
          from T_DWH_PROVISIONS d
          join T_RDWH_DELINQ_DAYS rd on rd.name = d.long_delinq and rd.prod = d.prod
          where d.rep_date = d_rep_date
            and d.rep_type in ('recalc3','recalc2','recalc');

    --Для авто оставляем старый расчет, рассмотреть возможно поменять на новый, но в DWH_NEW надо будет доработать логику

       insert into T_DWH_PROVISIONS(REP_DATE,PROD,LONG_DELINQ,VALUE_CALC,Value_nb,IS_ON_BALANCE,REP_LVL,REP_TYPE,NAME)
       select /*+parallel(20)*/ p.rep_date,
              p.prod,
              p.long_delinq,
              case when d.day_min < 181 and p.prod = 'A' then round(p.value_calc-p.value_calc/n_auto_sum4_clc*(n_auto_sum3_clc -  n_auto_sum2_clc))
                --   when d.day_min < 361 and p.prod = 'M' then round(p.value_calc-p.value_calc/n_mass_sum4_clc*(n_mass_sum3_clc -  n_mass_sum2_clc))
                   when p.prod = 'A' then value_calc end as value_calc,
              case when d.day_min < 181 and p.prod = 'A' then round(p.value_nb-p.value_nb/n_auto_sum4_nb*(n_auto_sum3_nb -  n_auto_sum2_nb))
               --    when d.day_min < 361 and p.prod = 'M' then round(p.value_nb-p.value_nb/n_mass_sum4_nb*(n_mass_sum3_nb -  n_mass_sum2_nb))
                   when p.prod = 'A' then value_nb end as value_nb,
              p.is_on_balance,
              2,
              'recalc4',
              'Скоректированые провизии'
       from  T_DWH_PROVISIONS p
       join t_rdwh_delinq_days d on d.name = p.long_delinq and d.prod = p.prod
       where p.rep_date = d_rep_date
         and p.rep_type = 'recalc3'
         and p.prod = 'A';
         commit;


 --Для масс считаем с учетом, чтобы минимум 50% от NPL (значение n_proc_npl - параметр изменяется вручную) ушло в провизии, для того, чтобы с портфеля NPL создавать большую сумму провизий
   --   n_sum_npl_mass := n_total_npl_mass * n_proc_npl; -- создать по NPL   в промежутке 90 - 360 дней просрочки
   --   n_sum_npl_auto := n_total_npl_auto * n_proc_npl;

       -- создать по не NPL
     -- n_sum_not_npl_mass := n_mass_sum2_nb - n_total_npl_mass;
    --  n_sum_not_npl_mass_calc := n_mass_sum2_clc - n_total_npl_mass;

   if n_sum_not_npl_mass < 0 or n_sum_not_npl_mass_calc < 0 then
      p_error := substr(p_error||' Невозможно продолжать расчет УВ. Отрицательные значения! n_sum_not_npl_mass='||n_sum_not_npl_mass||';n_sum_not_npl_mass_calc='||n_sum_not_npl_mass_calc,1,2000);
     raise e_user_exception;
   end if;

  /*    n_sum_not_npl_auto := n_auto_sum2_nb - n_sum_npl_auto;
      n_sum_not_npl_auto_calc := n_auto_sum2_clc - n_sum_npl_auto;
 */
--dbms_output.put_line('n_sum_npl_mass='||n_sum_npl_mass||';n_sum3_npl_mass='||n_sum3_npl_mass||';n_sum3_not_npl_mass='||n_sum3_not_npl_mass||';n_sum_not_npl_mass='||n_sum_not_npl_mass);


       insert into T_DWH_PROVISIONS(REP_DATE,PROD,LONG_DELINQ,VALUE_CALC,Value_nb,IS_ON_BALANCE,REP_LVL,REP_TYPE,NAME)
       select /*+parallel(20)*/ p.rep_date,
              p.prod,
              p.long_delinq,
              case --when p.prod = 'A' and d.day_min <= 90 then round((p.value_calc/n_sum3_not_npl_auto_calc) * n_sum_not_npl_auto_calc ,4)
                   --when p.prod = 'A' and d.day_min > 90 then round((p.value_calc/)* n_sum_npl_auto ,4)
                   when p.prod = 'M' and d.day_min > 90 and d.day_min <= 360 then round((p.value_calc/n_sum3_npl_mass_calc)* n_total_npl_mass* n_proc_npl ,4)
                   when p.prod = 'M' and d.day_min > 360 then p.value_calc
              end as value_calc,

             case --when p.prod = 'A' and d.day_min <= 90 then round((p.value_nb/n_sum3_not_npl_auto)* n_sum_not_npl_auto  ,4)
                   --when p.prod = 'A' and d.day_min > 90 then round((p.value_nb/n_sum3_npl_auto)* n_sum_npl_auto ,4)
                   when p.prod = 'M' and d.day_min > 90 and d.day_min <= 360 then round((p.value_nb/n_sum3_npl_mass) * n_total_npl_mass* n_proc_npl,4)
                   when p.prod = 'M' and d.day_min > 360 then p.value_nb
              end as value_nb,
              p.is_on_balance,
              2,
              'recalc4',
              'Скоректированые провизии'
       from  T_DWH_PROVISIONS p
       join T_RDWH_DELINQ_DAYS d on d.name = p.long_delinq and d.prod = p.prod
       where p.rep_date = d_rep_date
         and p.rep_type = 'recalc3'
         and p.prod = 'M'
         and d.day_min > 90
         ;
         commit;

      -- Вычисляем сколько провизий создадим по NPL
         select sum(value_calc),sum(value_nb)
         into n_sum4_npl_calc,n_sum4_npl
         from T_DWH_PROVISIONS p
          join T_RDWH_DELINQ_DAYS d on d.name = p.long_delinq and d.prod = p.prod
         where p.rep_date = d_rep_date
         and p.rep_type = 'recalc4'
         and p.prod = 'M'
         and d.day_min > 90;

      -- и оставшуюся сумму провизий распределяем по не NPL
       insert into T_DWH_PROVISIONS(REP_DATE,PROD,LONG_DELINQ,VALUE_CALC,Value_nb,IS_ON_BALANCE,REP_LVL,REP_TYPE,NAME)
       select /*+parallel(20)*/ p.rep_date,
              p.prod,
              p.long_delinq,
              round((p.value_calc/n_sum3_not_npl_mass_calc)* (n_mass_sum2_clc - n_sum4_npl_calc) ,4) as value_calc,
              round((p.value_nb/n_sum3_not_npl_mass) * (n_mass_sum2_nb - n_sum4_npl),4) as value_nb,
              p.is_on_balance,
              2,
              'recalc4',
              'Скоректированые провизии'
       from  T_DWH_PROVISIONS p
       join T_RDWH_DELINQ_DAYS d on d.name = p.long_delinq and d.prod = p.prod
       where p.rep_date = d_rep_date
         and p.rep_type = 'recalc3'
         and p.prod = 'M'
         and d.day_min <= 90;
         commit;
         --рассчет УВ, как отношение скорректированных провизий к задолженности на балансе по каждой корзине просрочки

       insert into T_DWH_PROVISIONS(REP_DATE,PROD,LONG_DELINQ,VALUE_CALC,Value_nb,IS_ON_BALANCE,REP_LVL,REP_TYPE,NAME)
       select /*+parallel(20)*/ t.rep_date,
              t.prod,
              t.long_delinq,
              case when t.prod = 'M' and t.day_min > 360 then 1
                when t.value_calc = 0 then 0
                else round(tt.value_calc/t.value_calc,4) end as value_calc ,
              case when t.prod = 'M' and t.day_min > 360 then 1
                when t.value_calc = 0 then 0
                else round(tt.value_nb/t.value_calc,4) end as value_nb,
              t.IS_ON_BALANCE,
              3,
              'recalc5' ,
              'УВ'
       from
      (
              select p.rep_date,
                     p.prod,
                     p.long_delinq,
                     round(p.VALUE_CALc) as value_calc,
                     round(p.value_nb) as value_nb,
                     p.rep_type,
                     p.is_on_balance,
                     d.day_min
              from T_DWH_PROVISIONS p
              join T_RDWH_DELINQ_DAYS d on d.name = p.long_delinq and d.prod = p.prod
              where rep_date =  d_rep_date
              and rep_type = 'recalc'
              order by rep_type,prod,long_delinq ) t
       join
        (  select rep_date,
                     prod,
                     long_delinq,
                     round(VALUE_CALc) as value_calc,
                     round(value_nb) as value_nb,
                     rep_type
              from T_DWH_PROVISIONS
              where rep_date = d_rep_date
              and rep_type = 'recalc4'
              order by rep_type,prod,long_delinq)  tt on tt.prod = t.prod and tt.long_delinq = t.long_delinq;
        commit;
  end if;


exception
    when e_user_exception then
     rollback;
  --  dbms_output.put_line(p_error);
  when others then
     rollback;
     p_error := 'Error '||sqlerrm||'-'|| dbms_utility.format_error_backtrace;
   -- dbms_output.put_line('Error '||sqlerrm||'-'|| dbms_utility.format_error_backtrace);
  end p_calc_provisions_dwh;
/

