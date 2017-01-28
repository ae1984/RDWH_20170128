create or replace force view u1.v_rdwh_provisions_auto_calc as
select "RP","DEL_000_007","DEL_008_030","DEL_031_060","DEL_061_090","DEL_091_120","DEL_121_150","DEL_151_180","DEL_181_210","DEL_211","WRITTEN","COLATERAL"
   from (
          select *
          from (
          select name rp,p.long_delinq,
                 case when p.rep_lvl = 2 then  p.value_calc*100
                   else p.value_calc end as value_calc
            from T_DWH_PROVISIONS P
          where p.rep_date between   add_months((select max(rep_date) from  T_DWH_PROVISIONS),-24) and  (select max(rep_date) from  T_DWH_PROVISIONS)
            and p.prod = 'A'
            and p.rep_type != 'pre2'
            and p.rep_type not like 'recalc%'
            and (p.rep_lvl = 1 or rep_lvl=2 and rep_date =  (select max(rep_date) from  T_DWH_PROVISIONS)   )
            ) t
            pivot (max(value_calc) for long_delinq in ('000 – 007' as del_000_007,'008 – 030' as del_008_030,'031 – 060' as del_031_060,
            '061 - 090' as del_061_090,'091 - 120' as del_091_120,'121 - 150' as del_121_150,'151 - 180' as del_151_180,'181 - 210' as del_181_210,
            '>210' as del_211,
            'Written' as written,'Colateral' as Colateral) ) order by rp)
union all
select cast(' Пункт № 77' as varchar2(50)) as rp, cast(null as number) as gross,cast(null as number) as ifrs  ,cast(null as number),cast(null as number)
      ,cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number)/*,cast(null as number)
      ,cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number)
      ,cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number)*/
      from dual
union all
---Итоги report AUTO
select rp,gross,ifrs,cast(null as number),cast(null as number)
      ,cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number)
from (
      select *
     from (
           select
                  name as rp,
                  p.long_delinq,
                  case when rep_type= 'itog3' then p.value_calc*100 else p.value_calc end as value_calc
           from T_DWH_PROVISIONS P
           where p.rep_date = (select max(rep_date) from  T_DWH_PROVISIONS)
             and p.prod = 'A'
             and p.rep_lvl in( 3)
             and p.rep_type not like 'recalc%'
   )
  pivot (max(value_calc)
         for long_delinq in ('Gross' as Gross,'IFRS' as IFRS  )
         ))
;
grant select on U1.V_RDWH_PROVISIONS_AUTO_CALC to LOADDB;
grant select on U1.V_RDWH_PROVISIONS_AUTO_CALC to LOADER;


