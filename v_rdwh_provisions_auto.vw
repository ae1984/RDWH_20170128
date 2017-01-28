create or replace force view u1.v_rdwh_provisions_auto as
select  rp,
        del_000_007,
        del_008_030,
        del_031_060,
        del_061_090,
        del_091_120,
        del_121_150,
        del_151_180,
        del_181_210,
        del_211,
        written,
        colateral,
        rep_date
   from (
     select *
          from (
              select name rp,
                     p.long_delinq,
                     case
                       when p.rep_date between to_date('20-09-2015','dd-mm-yyyy') and to_date('13-12-2015','dd-mm-yyyy') or
                            p.rep_date >= to_date('01-01-2016','dd-mm-yyyy') then
                            case when p.rep_lvl = 2 then
                               round( p.value_calc*100,2)
                             else
                               round(p.value_calc) end
                     else
                         case when p.rep_lvl = 2 then
                           round(nvl(p.value_nb, p.value_calc)*100,1)
                         else
                           round(nvl(p.value_nb,p.value_calc),2) end
                     end  as value_nb,
                     d.yyyy_mm_dd as rep_date,
                     1 as npp
                from V_TIME_DAYS d
                 join T_DWH_PROVISIONS P on p.rep_date between add_months(d.yyyy_mm_dd,-24) and  d.yyyy_mm_dd
              where p.prod = 'A'
                and (p.rep_lvl = 1 or rep_lvl=2  )
                and ((p.rep_type = 'fact' and d.yyyy_mm_dd != p.rep_date) or (d.yyyy_mm_dd = p.rep_date))
                and p.rep_type not like 'recalc%'
            ) t
      pivot (max(value_nb) for long_delinq in ('000 – 007' as del_000_007,'008 – 030' as del_008_030,'031 – 060' as del_031_060,
      '061 - 090' as del_061_090,'091 - 120' as del_091_120,'121 - 150' as del_121_150,'151 - 180' as del_151_180,'181 - 210' as del_181_210,
      '>210' as del_211,
      'Written' as written,'Colateral' as Colateral) )
union all
---Итоги report AUTO
select rp,
       rep_date,
       3 as npp,
       gross,
       ifrs,
       cast(null as number),
       cast(null as number),
       cast(null as number),
       cast(null as number),
       cast(null as number),
       cast(null as number),
       cast(null as number),
       cast(null as number),
       cast(null as number)
from (
      select *
      from (
           select
                  name as rp,
                  rep_date,
                  p.long_delinq,
                  case
                    when p.rep_date between to_date('20-09-2015','dd-mm-yyyy') and to_date('13-12-2015','dd-mm-yyyy') or
                         p.rep_date >= to_date('01-01-2016','dd-mm-yyyy')  then
                           case when rep_type= 'itog3' then p.value_calc*100 else round(p.value_calc,2) end
                    else
                           case when rep_type= 'itog3' then p.value_nb*100 else round(p.value_nb,2) end
                  end as value_nb
           from T_DWH_PROVISIONS P
           where p.prod = 'A'
             and p.rep_lvl in( 3)
             and p.rep_type not like 'recalc%'
          )
  pivot (max(value_nb)
         for long_delinq in ('Gross' as Gross,'IFRS' as IFRS  )
         )
  )
union all
select *
          from (
          select name rp,
                 p.long_delinq,
                 case when p.rep_date between to_date('20-09-2015','dd-mm-yyyy') and to_date('13-12-2015','dd-mm-yyyy')
                   or p.rep_date >= to_date('01-01-2016','dd-mm-yyyy') then
                   case when rep_type = 'recalc5' then
                       round( p.value_calc*100,2)
                     else
                       round(p.value_calc,2) end
                   end  as value_nb,
                 d.yyyy_mm_dd as rep_date,
                 4 as npp
            from V_TIME_DAYS d
             join T_DWH_PROVISIONS P on p.rep_date between add_months(d.yyyy_mm_dd,-24) and  d.yyyy_mm_dd
          where
             p.prod = 'A'
           -- and (p.rep_lvl = 1 or rep_lvl=2  )
           and ((p.rep_type = 'fact' and d.yyyy_mm_dd != p.rep_date) or (d.yyyy_mm_dd = p.rep_date))
           and p.rep_type like 'recalc%'
            ) t
      pivot (max(value_nb) for long_delinq in ('000 – 007' as del_000_007,'008 – 030' as del_008_030,'031 – 060' as del_031_060,
      '061 - 090' as del_061_090,'091 - 120' as del_091_120,'121 - 150' as del_121_150,'151 - 180' as del_151_180,'181 - 210' as del_181_210,
      '>210' as del_211,
      'Written' as written,'Colateral' as Colateral) )

)
order by npp,rp,rep_date
;
comment on column U1.V_RDWH_PROVISIONS_AUTO.RP is 'Дата отсатков';
comment on column U1.V_RDWH_PROVISIONS_AUTO.DEL_000_007 is 'Просрочка 0-7 дней';
comment on column U1.V_RDWH_PROVISIONS_AUTO.DEL_008_030 is 'Просрочка 8-30 дней';
comment on column U1.V_RDWH_PROVISIONS_AUTO.DEL_031_060 is 'Просрочка 31-60 дней';
comment on column U1.V_RDWH_PROVISIONS_AUTO.DEL_061_090 is 'Просрочка 61-90 дней';
comment on column U1.V_RDWH_PROVISIONS_AUTO.DEL_091_120 is 'Просрочка 91-120 дней';
comment on column U1.V_RDWH_PROVISIONS_AUTO.DEL_121_150 is 'Просрочка 121-150 дней';
comment on column U1.V_RDWH_PROVISIONS_AUTO.DEL_151_180 is 'Просрочка 151-180 дней';
comment on column U1.V_RDWH_PROVISIONS_AUTO.DEL_181_210 is 'Просрочка 181-210 дней';
comment on column U1.V_RDWH_PROVISIONS_AUTO.DEL_211 is 'Просрочка более 210 дней';
comment on column U1.V_RDWH_PROVISIONS_AUTO.WRITTEN is 'Сумма списания';
comment on column U1.V_RDWH_PROVISIONS_AUTO.COLATERAL is 'Залоговая стоимость';
grant select on U1.V_RDWH_PROVISIONS_AUTO to LOADDB;
grant select on U1.V_RDWH_PROVISIONS_AUTO to LOADER;


