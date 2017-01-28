create or replace force view u1.v_rdwh_provisions_mass_sw as
select  RP,DEL_000_007,DEL_008_030,DEL_031_060,DEL_061_090,DEL_091_120,DEL_121_150,DEL_151_180,DEL_181_210,DEL_211_240,DEL_241_270,DEL_271_300,DEL_301_330,DEL_331_360,DEL_361_390,DEL_391_420,DEL_421_450,DEL_451_480,DEL_481_510,DEL_511_540,DEL_541_570,DEL_571_600,DEL_601_630,DEL_631_660,DEL_661_690,DEL_691_720,DEL_721_750,DEL_751,WRITTEN,rep_date
   from (
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
                 1 as npp
            from V_TIME_DAYS d
             join T_DWH_PROVISIONS P on p.rep_date between add_months(d.yyyy_mm_dd,-24) and  d.yyyy_mm_dd
          where
             p.prod = 'M'
           -- and (p.rep_lvl = 1 or rep_lvl=2  )
           and ((p.rep_type = 'fact' and d.yyyy_mm_dd != p.rep_date) or (d.yyyy_mm_dd = p.rep_date))
           and p.rep_type like 'recalc%'
            ) t
      pivot (max(value_nb) for long_delinq in ('000 – 007' as del_000_007,'008 – 030' as del_008_030,'031 – 060' as del_031_060,
                '061 - 090' as del_061_090,'091 - 120' as del_091_120,'121 - 150' as del_121_150,'151 - 180' as del_151_180,'181 - 210' as del_181_210,
                '211 - 240' as del_211_240,'241 - 270' as del_241_270,'271 - 300' as del_271_300,'301 – 330' as del_301_330,'331 - 360' as del_331_360,
                '361 - 390' as del_361_390,
                '391 - 420' as del_391_420,'421 - 450' as del_421_450,'451 - 480' as del_451_480,'481 - 510' as del_481_510,'511 - 540' as del_511_540,
                '541 - 570' as del_541_570,'571 - 600' as del_571_600,'601 - 630' as del_601_630,
                '631 - 660' as del_631_660,'661 - 690' as del_661_690,'691 - 720' as del_691_720,'721 - 750' as del_721_750,'>750' as del_751,
                'Written' as written) )

/*union all
select cast(' Пункт № 77' as varchar2(50)) as rp,
       cast(null as date) as rep_date,
       2 as npp, cast(null as number) as gross,
       cast(null as number) as ifrs  ,
       cast(null as number),
       cast(null as number)
      ,cast(null as number),
      cast(null as number),
      cast(null as number),
      cast(null as number),
      cast(null as number),
      cast(null as number),
      cast(null as number)
      from dual*/
/*union all
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
                    when p.rep_date between to_date('20-09-2015','dd-mm-yyyy') and to_date('13-12-2015','dd-mm-yyyy') then
                        case when rep_type= 'itog3' then p.value_calc*100 else round(p.value_calc,2) end
                    else
                        case when rep_type= 'itog3' then p.value_nb*100 else round(p.value_nb,2) end
                  end as value_nb
           from T_DWH_PROVISIONS P
           where p.prod = 'A'
             and p.rep_lvl in( 3)
             and p.rep_type like 'recalc%'
          )
  pivot (max(value_nb)
         for long_delinq in ('Gross' as Gross,'IFRS' as IFRS  )
         )
  )*/
) order by npp,rp,rep_date
;
comment on table U1.V_RDWH_PROVISIONS_MASS_SW is 'Удельный вес по портфелю без авто';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.RP is 'Отчетная дата';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_000_007 is 'Суммы в границе 0-7 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_008_030 is 'Суммы в границе 8-30 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_031_060 is 'Суммы в границе 31-60 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_061_090 is 'Суммы в границе 61-90 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_091_120 is 'Суммы в границе 91-120 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_121_150 is 'Суммы в границе 121-150 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_151_180 is 'Суммы в границе 151-180 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_181_210 is 'Суммы в границе 181-210 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_211_240 is 'Суммы в границе 211-240 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_241_270 is 'Суммы в границе 241-270 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_271_300 is 'Суммы в границе 271-300 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_301_330 is 'Суммы в границе 301-330 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_331_360 is 'Суммы в границе 331-360 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_361_390 is 'Суммы в границе 361-390 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_391_420 is 'Суммы в границе 391-420 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_421_450 is 'Суммы в границе 421-450 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_451_480 is 'Суммы в границе 451-480 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_481_510 is 'Суммы в границе 481-510 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_511_540 is 'Суммы в границе 511-540 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_541_570 is 'Суммы в границе 541-570 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_571_600 is 'Суммы в границе 571-600 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_601_630 is 'Суммы в границе 601-630 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_631_660 is 'Суммы в границе 631-660 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_661_690 is 'Суммы в границе 661-690 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_691_720 is 'Суммы в границе 691-720 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_721_750 is 'Суммы в границе 721-750 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.DEL_751 is 'Суммы в границе >751 дней просрочки';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.WRITTEN is 'Списание';
comment on column U1.V_RDWH_PROVISIONS_MASS_SW.REP_DATE is 'Отчетная дата';
grant select on U1.V_RDWH_PROVISIONS_MASS_SW to LOADDB;
grant select on U1.V_RDWH_PROVISIONS_MASS_SW to LOADER;


