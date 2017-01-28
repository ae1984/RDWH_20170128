create or replace force view u1.v_rdwh_provisions_mass as
select RP,DEL_000_007,DEL_008_030,DEL_031_060,DEL_061_090,DEL_091_120,DEL_121_150,DEL_151_180,DEL_181_210,DEL_211_240,DEL_241_270,DEL_271_300,DEL_301_330,DEL_331_360,DEL_361_390,DEL_391_420,DEL_421_450,DEL_451_480,DEL_481_510,DEL_511_540,DEL_541_570,DEL_571_600,DEL_601_630,DEL_631_660,DEL_661_690,DEL_691_720,DEL_721_750,DEL_751,WRITTEN,rep_date
from
(
select *
from (
     select *
          from (
              select  name rp,
                      p.long_delinq,
                      case
                        when p.rep_lvl = 2 and long_delinq = '721 - 750' then
                           round(nvl(p.value_nb,p.value_calc) *100,2)
                        when p.rep_lvl = 2 then
                          round(nvl(p.value_nb,p.value_calc) *100,2)
                        else
                          round(nvl(p.value_nb,p.value_calc)) end as value_nb,
                       d.yyyy_mm_dd as rep_date,
                       1 as npp
              from V_TIME_DAYS d
              join T_DWH_PROVISIONS P on p.rep_date between add_months(d.yyyy_mm_dd,-24) and  d.yyyy_mm_dd
              where p.prod = 'M'
                and ((p.rep_type = 'fact' and d.yyyy_mm_dd != p.rep_date) or (d.yyyy_mm_dd = p.rep_date))
                and p.rep_lvl in (1,2)
                and p.rep_type not like 'recalc%'
               ) t
                pivot (max(value_nb) for long_delinq in ('000 – 007' as del_000_007,'008 – 030' as del_008_030,'031 – 060' as del_031_060,
                '061 - 090' as del_061_090,'091 - 120' as del_091_120,'121 - 150' as del_121_150,'151 - 180' as del_151_180,'181 - 210' as del_181_210,
                '211 - 240' as del_211_240,'241 - 270' as del_241_270,'271 - 300' as del_271_300,'301 – 330' as del_301_330,'331 - 360' as del_331_360,
                '361 - 390' as del_361_390,
                '391 - 420' as del_391_420,'421 - 450' as del_421_450,'451 - 480' as del_451_480,'481 - 510' as del_481_510,'511 - 540' as del_511_540,
                '541 - 570' as del_541_570,'571 - 600' as del_571_600,'601 - 630' as del_601_630,
                '631 - 660' as del_631_660,'661 - 690' as del_661_690,'691 - 720' as del_691_720,'721 - 750' as del_721_750,'>750' as del_751,
                'Written' as written
          ) ) order by rp)

/*union all
   ---Итоги report mass
select cast(' Пункт № 77' as varchar2(50)) as rp, cast(null as number) as gross,cast(null as number) as ifrs  ,cast(null as number),cast(null as number)
 ,cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number)
 ,cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number)
 ,cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number)
  from dual*/

union all
select rp,
       rep_date,
       3 as npp,
       gross,
       ifrs
       ,cast(null as number),cast(null as number)
       ,cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number)
       ,cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number)
       ,cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number),cast(null as number)
from (
       select *
       from (
       select name as rp,
              rep_date,
              p.long_delinq,
              case when rep_type= 'itog3' then p.value_nb*100 else round(p.value_nb,2) end as value_nb
                  from U1.T_DWH_PROVISIONS P
                where p.prod = 'M'
                  and p.rep_lvl in( 3)
                  and p.rep_type not like 'recalc%'
         )
        pivot (max(value_nb)
               for long_delinq in ('Gross' as Gross,'IFRS' as IFRS  )
               )
     )
union all
     select * from (
select  name as rp,
              rep_date,
              p.long_delinq,
                    case when p.rep_lvl = 3 then
                           nvl(p.value_nb, p.value_calc)*100
                         else
                           round(nvl(p.value_nb,p.value_calc) )
                     end  as value_nb,

                     4 as npp
from t_dwh_provisions p
where p.rep_type like '%recalc%'
  and prod = 'M'
order by prod,rep_lvl, rep_type,long_delinq
)    pivot (max(value_nb) for long_delinq in ('000 – 007' as del_000_007,'008 – 030' as del_008_030,'031 – 060' as del_031_060,
                '061 - 090' as del_061_090,'091 - 120' as del_091_120,'121 - 150' as del_121_150,'151 - 180' as del_151_180,'181 - 210' as del_181_210,
                '211 - 240' as del_211_240,'241 - 270' as del_241_270,'271 - 300' as del_271_300,'301 – 330' as del_301_330,'331 - 360' as del_331_360,
                '361 - 390' as del_361_390,
                '391 - 420' as del_391_420,'421 - 450' as del_421_450,'451 - 480' as del_451_480,'481 - 510' as del_481_510,'511 - 540' as del_511_540,
                '541 - 570' as del_541_570,'571 - 600' as del_571_600,'601 - 630' as del_601_630,
                '631 - 660' as del_631_660,'661 - 690' as del_661_690,'691 - 720' as del_691_720,'721 - 750' as del_721_750,'>750' as del_751,
                'Written' as written
          ) )
) order by npp,rp,rep_date
;
comment on column U1.V_RDWH_PROVISIONS_MASS.RP is 'Дата остатков';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_000_007 is 'Просрочка 0-7 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_008_030 is 'Просрочка 8-30 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_031_060 is 'Просрочка 31-60 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_061_090 is 'Просрочка 61-90 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_091_120 is 'Просрочка 91-120 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_121_150 is 'Просрочка 121-150 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_151_180 is 'Просрочка 151-180 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_181_210 is 'Просрочка 181-210 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_211_240 is 'Просрочка 211-240 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_241_270 is 'Просрочка 241-270 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_271_300 is 'Просрочка 271-300 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_301_330 is 'Просрочка 301-330 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_331_360 is 'Просрочка 331-360 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_361_390 is 'Просрочка 361-390 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_391_420 is 'Просрочка 391-420 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_421_450 is 'Просрочка 4211-450 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_451_480 is 'Просрочка 451-480 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_481_510 is 'Просрочка 481-510 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_511_540 is 'Просрочка 511-540 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_541_570 is 'Просрочка 541-570 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_571_600 is 'Просрочка 571-600 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_601_630 is 'Просрочка 601-630 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_631_660 is 'Просрочка 631-660 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_661_690 is 'Просрочка 661-690 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_691_720 is 'Просрочка 691-720 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_721_750 is 'Просрочка 721-750 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.DEL_751 is 'Просрочка более 750 дней';
comment on column U1.V_RDWH_PROVISIONS_MASS.WRITTEN is 'Сумма списания';
grant select on U1.V_RDWH_PROVISIONS_MASS to LOADDB;
grant select on U1.V_RDWH_PROVISIONS_MASS to LOADER;


