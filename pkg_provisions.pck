create or replace package u1.PKG_PROVISIONS is

  -- Author  : RYBALOV_22857
  -- Created : 27.06.2014 14:22:30
  -- Purpose : 
  
  procedure dwh_PROVISIONS;
  procedure percentages;
  procedure ref_prov;
  procedure vintage_upd;
  procedure disconnect_sessions;
end PKG_PROVISIONS;
/

create or replace package body u1.PKG_PROVISIONS is

procedure dwh_PROVISIONS --return dwh_PROVISIONSList pipelined 
is
max_month date;
rep_month date;
last_day date;
weekend number;
begin

          -- Заполняем неявный курсор данными 
  for info in (select b.rep_month,
                 nvl(b."000"+nvl(t1.not_delinquent,0),0) as not_delinquent,
                 nvl(b."<30"+nvl(t1.p_30,0),0) as p_30,
                 nvl(b."031-060"+nvl(t1.p_031_060,0),0) as p_031_060,
                 nvl(b."061-090"+nvl(t1.p_061_090,0),0) as p_061_090,
                 nvl(b."091-120"+nvl(t1.p_091_120,0),0) as p_091_120,
                 nvl(b."121-150"+nvl(t1.p_121_150,0),0) as p_121_150,
                 nvl(b."151-180"+nvl(t1.p_151_180,0),0) as p_151_180,
                 nvl(b."181-210"+nvl(t1.p_181_210,0),0) as p_181_210,
                 nvl(b."211-240"+nvl(t1.p_211_240,0),0) as p_211_240,
                 nvl(b."241-270"+nvl(t1.p_241_270,0),0) as p_241_270,       
                 nvl(b."271-300"+nvl(t1.p_271_300,0),0) as p_271_300,
                 nvl(b."301-330"+nvl(t1.p_301_330,0),0) as p_301_330,
                 nvl(b."331-360"+nvl(t1.p_331_360,0),0) as p_331_360,
                 nvl(b."361-390"+nvl(t1.p_361_390,0),0) as p_361_390,
                 nvl(b."391-420"+nvl(t1.p_391_420,0),0) as p_391_420,       
                 nvl(b."421-450"+nvl(t1.p_421_450,0),0) as p_421_450,
                 nvl(b."451-480"+nvl(t1.p_451_480,0),0) as p_451_480,
                 nvl(b."481-510"+nvl(t1.p_481_510,0),0) as p_481_510,
                 nvl(b."511-540"+nvl(t1.p_511_540,0),0) as p_511_540, 
                 nvl(b."541-570"+nvl(t1.p_541_570,0),0) as p_541_570,       
                 nvl(b."571-600"+nvl(t1.p_571_600,0),0) as p_571_600,
                 nvl(b."601-630"+nvl(t1.p_601_630,0),0) as p_601_630,
                 nvl(b."631-660"+nvl(t1.p_631_660,0),0) as p_631_660,
                 nvl(b."661-690"+nvl(t1.p_661_690,0),0) as p_661_690, 
                 nvl(b."691-720"+nvl(t1.p_691_720,0),0) as p_691_720,       
                 nvl(b."721-750"+nvl(t1.p_721_750,0),0) as p_721_750,
                 nvl(b.">750"+nvl(t1.p_750,0),0) as p_750 
 from (
select to_date(a.rep_month, 'yyyy - mm') as rep_month,
sum(a."000")/1000 as "000",
sum(a."<30")/1000 as          "<30",  
sum(a."031-060")/1000 as      "031-060",
sum(a."061-090")/1000 as      "061-090",
sum(a."091-120")/1000 as      "091-120",
sum(a."121-150")/1000 as      "121-150",
sum(a."151-180")/1000 as      "151-180",
sum(a."181-210")/1000 as      "181-210",
sum(a."211-240")/1000 as      "211-240",
sum(a."241-270")/1000 as      "241-270",
sum(a."271-300")/1000 as      "271-300",
sum(a."301-330")/1000 as      "301-330",
sum(a."331-360")/1000 as      "331-360",
sum(a."361-390")/1000 as      "361-390",
sum(a."391-420")/1000 as      "391-420",
sum(a."421-450")/1000 as      "421-450",
sum(a."451-480")/1000 as      "451-480",
sum(a."481-510")/1000 as      "481-510",
sum(a."511-540")/1000 as      "511-540",
sum(a."541-570")/1000 as      "541-570",
sum(a."571-600")/1000 as      "571-600",
sum(a."601-630")/1000 as      "601-630",
sum(a."631-660")/1000 as      "631-660",
sum(a."661-690")/1000 as      "661-690",
sum(a."691-720")/1000 as      "691-720",
sum(a."721-750")/1000 as      "721-750",
sum(a.">750")/1000-2718312 as ">750"
from (               
   select 
   case when (t.delinq_days_old is null or t.delinq_days_old <=5) and t.yy_mm_report >= '2012 - 12' and t.yy_mm_report <= '2013 - 03' then sum(t.total_debt)
        when (t.delinq_days_old is null or t.delinq_days_old <=7) and t.yy_mm_report >= '2013 - 04' and t.yy_mm_report <= '2013 - 11' then sum(t.total_debt)
        when (t.delinq_days_old is null or t.delinq_days_old <=1) and t.yy_mm_report >= '2013 - 12' and t.yy_mm_report <= '2014 - 01' then sum(t.total_debt)
        when (t.delinq_days_old is null or t.delinq_days_old <=3) and t.yy_mm_report = '2014 - 02' then sum(t.total_debt)
        when (t.delinq_days_old is null or t.delinq_days_old <=2) and t.yy_mm_report = '2014 - 03' then sum(t.total_debt)
        when (t.delinq_days_old is null or t.delinq_days_old <=3) and t.yy_mm_report = '2014 - 04' then sum(t.total_debt)
        when (t.delinq_days_old is null or t.delinq_days_old <=5) and t.yy_mm_report = '2014 - 05' then sum(t.total_debt)
        when (t.delinq_days_old is null or t.delinq_days_old <=1) and t.yy_mm_report = '2014 - 06' then sum(t.total_debt)
        when (t.delinq_days_old is null or t.delinq_days_old <=9) and t.yy_mm_report = '2014 - 07' then sum(t.total_debt)
        when (t.delinq_days_old is null or t.delinq_days_old <=8) and t.yy_mm_report = '2014 - 08' then sum(t.total_debt)
        when (t.delinq_days_old is null or t.delinq_days_old <=7) and t.yy_mm_report > '2014 - 08' then sum(t.total_debt)          
        when (t.delinq_days_old is null or t.delinq_days_old = 0) and t.yy_mm_report < '2012 - 12' then sum(t.total_debt) end as "000",
   case when (t.delinq_days_old >=6 and t.delinq_days_old <=30) and t.yy_mm_report >= '2012 - 12' and t.yy_mm_report <= '2013 - 03' then sum(t.total_debt)
        when (t.delinq_days_old >=8 and t.delinq_days_old <=30) and t.yy_mm_report >= '2013 - 04' and t.yy_mm_report <= '2013 - 11' then sum(t.total_debt)
        when (t.delinq_days_old >=2 and t.delinq_days_old <=30) and t.yy_mm_report >= '2013 - 12' and t.yy_mm_report <= '2014 - 01' then sum(t.total_debt)
        when (t.delinq_days_old >=4 and t.delinq_days_old <=30) and t.yy_mm_report = '2014 - 02' then sum(t.total_debt)
        when (t.delinq_days_old >=3 and t.delinq_days_old <=30) and t.yy_mm_report = '2014 - 03' then sum(t.total_debt)
        when (t.delinq_days_old >=4 and t.delinq_days_old <=30) and t.yy_mm_report = '2014 - 04' then sum(t.total_debt)
        when (t.delinq_days_old >=6 and t.delinq_days_old <=30) and t.yy_mm_report = '2014 - 05' then sum(t.total_debt)
        when (t.delinq_days_old >=2 and t.delinq_days_old <=30) and t.yy_mm_report = '2014 - 06' then sum(t.total_debt)
        when (t.delinq_days_old >=10 and t.delinq_days_old <=30) and t.yy_mm_report = '2014 - 07' then sum(t.total_debt)
        when (t.delinq_days_old >=9 and t.delinq_days_old <=30) and t.yy_mm_report = '2014 - 08' then sum(t.total_debt)
        when (t.delinq_days_old >=8 and t.delinq_days_old <=30) and t.yy_mm_report > '2014 - 08' then sum(t.total_debt)                  
        when (t.delinq_days_old >=1 and t.delinq_days_old <=30) and t.yy_mm_report < '2012 - 12' then sum(t.total_debt) end as "<30",  
   case when t.delinq_days_old >=31 and t.delinq_days_old <=60 then sum(t.total_debt) end as "031-060",
   case when t.delinq_days_old >=61 and t.delinq_days_old <=90 then sum(t.total_debt) end as "061-090",
   case when t.delinq_days_old >=91 and t.delinq_days_old <=120 then sum(t.total_debt) end as "091-120",   
   case when t.delinq_days_old >=121 and t.delinq_days_old <=150 then sum(t.total_debt) end as "121-150",
   case when t.delinq_days_old >=151 and t.delinq_days_old <=180 then sum(t.total_debt) end as "151-180",
   case when t.delinq_days_old >=181 and t.delinq_days_old <=210 then sum(t.total_debt) end as "181-210",
   case when t.delinq_days_old >=211 and t.delinq_days_old <=240 then sum(t.total_debt) end as "211-240",
   case when t.delinq_days_old >=241 and t.delinq_days_old <=270 then sum(t.total_debt) end as "241-270",                    
   case when t.delinq_days_old >=271 and t.delinq_days_old <=300 then sum(t.total_debt) end as "271-300",
   case when t.delinq_days_old >=301 and t.delinq_days_old <=330 then sum(t.total_debt) end as "301-330",
   case when t.delinq_days_old >=331 and t.delinq_days_old <=360 then sum(t.total_debt) end as "331-360",
   case when t.delinq_days_old >=361 and t.delinq_days_old <=390 then sum(t.total_debt) end as "361-390",
   case when t.delinq_days_old >=391 and t.delinq_days_old <=420 then sum(t.total_debt) end as "391-420",
   case when t.delinq_days_old >=421 and t.delinq_days_old <=450 then sum(t.total_debt) end as "421-450",
   case when t.delinq_days_old >=451 and t.delinq_days_old <=480 then sum(t.total_debt) end as "451-480", 
   case when t.delinq_days_old >=481 and t.delinq_days_old <=510 then sum(t.total_debt) end as "481-510",
   case when t.delinq_days_old >=511 and t.delinq_days_old <=540 then sum(t.total_debt) end as "511-540",
   case when t.delinq_days_old >=541 and t.delinq_days_old <=570 then sum(t.total_debt) end as "541-570",  
   case when t.delinq_days_old >=571 and t.delinq_days_old <=600 then sum(t.total_debt) end as "571-600",
   case when t.delinq_days_old >=601 and t.delinq_days_old <=630 then sum(t.total_debt) end as "601-630",
   case when t.delinq_days_old >=631 and t.delinq_days_old <=660 then sum(t.total_debt) end as "631-660",
   case when t.delinq_days_old >=661 and t.delinq_days_old <=690 then sum(t.total_debt) end as "661-690",  
   case when t.delinq_days_old >=691 and t.delinq_days_old <=720 then sum(t.total_debt) end as "691-720",
   case when t.delinq_days_old >=721 and t.delinq_days_old <=750 then sum(t.total_debt) end as "721-750",
   case when t.delinq_days_old >750 then sum(t.total_debt) end as ">750",                         
   t.yy_mm_report as rep_month from v_portfolio t 
               where 
               not exists( select null from v_portfolio t1 where t1.product_refin_last in ('АВТО_БУ','АВТО') and t1.status = 'OPEN' 
            and t1.client_id = t.client_id and t1.yy_mm_report = t.yy_mm_report)
               
               and t.yy_mm_report >= '2010 - 12'   
            group by t.delinq_days_old,t.yy_mm_report) a
            group by a.rep_month) b
            left join provis_amendment t1 on trunc(b.rep_month,'mm') = trunc(t1.rep_month,'mm')
            order by 1
   ) loop
                                                                            
  --rep_month := info.rep_date; 
     
  -- тут смотрим, если есть на текущий месяц данные, то перезаписываем, если нету, то просто записываем.
  max_month := null;
  select nvl(max(t.rep_month),to_Date('01.01.1900','dd.mm.yyyy')) into max_month from PORT_FOR_PROV t;
  --если в этом месяце запись уже была, удаляем ее и записываем свежие данные, если небыло, то просто записываем свежие данные
  weekend := 0;
  -- берем последний рабочий день месяца, с учетом праздников и выходных.
  select LAST_DAY(info.rep_month) into last_day from dual;
  select nvl(max(ww.day_weekends),0) into weekend from T_HOLIDAYS ww where ww.data = last_day;
  rep_month := last_day - weekend;
  if max_month < info.rep_month/*rep_month */then
  begin
    insert into PORT_FOR_PROV (REP_MONTH, NOT_DELINQUENT, P_30, P_031_060, P_061_090, P_091_120, P_121_150, P_151_180, P_181_210, P_211_240, 
                            P_241_270, P_271_300, P_301_330, P_331_360, P_361_390, P_391_420, P_421_450, P_451_480, P_481_510, P_511_540, 
                            P_541_570, P_571_600, P_601_630, P_631_660, P_661_690, P_691_720, P_721_750, P_750)
                    VALUES (info.rep_month/*rep_month*/, info.not_delinquent, info.p_30, info.p_031_060, info.p_061_090, info.p_091_120, info.p_121_150, info.p_151_180, info.p_181_210, info.p_211_240, 
                            info.p_241_270, info.p_271_300, info.p_301_330, info.p_331_360, info.p_361_390, info.p_391_420, info.p_421_450, info.p_451_480, info.p_481_510, info.p_511_540,
                            info.p_541_570, info.p_571_600, info.p_601_630, info.p_631_660, info.p_661_690, info.p_691_720, info.p_721_750, info.p_750);  
    commit;                           
  end;  
  end if; 
  end loop; 
  percentages;
end dwh_PROVISIONS;


procedure percentages --return dwh_PROVISIONSList pipelined 
is
-- переменные знаменателей     а тут для числителей
r_not_delinquent number := 0;  p_not_delinquent number := 0;
r_do_30 number := 0;           p_do_30 number := 0;
r_31_60 number := 0;           p_31_60 number := 0;
r_61_90 number := 0;           p_61_90 number := 0;
r_91_120 number := 0;          p_91_120 number := 0;
r_121_150 number := 0;         p_121_150 number := 0; 
r_151_180 number := 0;         p_151_180 number := 0;
r_181_210 number := 0;         p_181_210 number := 0;
r_211_240 number := 0;         p_211_240 number := 0;
r_241_270 number := 0;         p_241_270 number := 0;
r_271_300 number := 0;         p_271_300 number := 0;
r_301_330 number := 0;         p_301_330 number := 0;
r_331_360 number := 0;         p_331_360 number := 0;
r_361_390 number := 0;         p_361_390 number := 0; 
r_391_420 number := 0;         p_391_420 number := 0;
r_421_450 number := 0;         p_421_450 number := 0;
r_451_480 number := 0;         p_451_480 number := 0;
r_481_510 number := 0;         p_481_510 number := 0;
r_511_540 number := 0;         p_511_540 number := 0;
r_541_570 number := 0;         p_541_570 number := 0;
r_571_600 number := 0;         p_571_600 number := 0;
r_601_630 number := 0;         p_601_630 number := 0;
r_631_660 number := 0;         p_631_660 number := 0;
r_661_690 number := 0;         p_661_690 number := 0;
r_691_720 number := 0;         p_691_720 number := 0;
r_721_750 number := 0;         p_721_750 number := 0;
r_750 number := 0;             p_750 number := 0;
                max_month date;
                rep_month date;
                last_day date;
                weekend number := 0;
begin 
--просчитываем все знаменатели
  select sum(t.not_delinquent) ,  sum(t.p_30) ,
         sum(t.p_031_060) , sum(t.p_061_090) ,
         sum(t.p_091_120) , sum(t.p_121_150) ,
         sum(t.p_151_180) , sum(t.p_181_210) , 
         sum(t.p_211_240) , sum(t.p_241_270) ,
         sum(t.p_271_300) , sum(t.p_301_330) ,
         sum(t.p_331_360) , sum(t.p_361_390) ,
         sum(t.p_391_420) , sum(t.p_421_450) ,
         sum(t.p_451_480) , sum(t.p_481_510) ,
         sum(t.p_511_540) , sum(t.p_541_570) ,
         sum(t.p_571_600) , sum(t.p_601_630) ,
         sum(t.p_631_660) , sum(t.p_661_690) ,
         sum(t.p_691_720) , sum(t.p_721_750) ,
         sum(t.p_750) 
     into          
         r_not_delinquent,r_do_30,r_31_60,r_61_90,r_91_120,r_121_150,r_151_180,
         r_181_210,r_211_240,r_241_270,r_271_300,r_301_330,r_331_360,r_361_390,r_391_420,
         r_421_450,r_451_480,r_481_510,r_511_540,r_541_570,r_571_600,r_601_630,r_631_660,
         r_661_690,r_691_720,r_721_750,r_750       
    from port_for_prov t
  --where t.rep_month >= to_date('2012 - 06','yyyy - mm') and t.rep_month < to_date('2014 - 06','yyyy - mm');
  where t.rep_month >= add_months(trunc(sysdate,'mm'),-25) and t.rep_month < add_months(trunc(sysdate,'mm'),-1);  -- +2

--просчитываем все числители
  
  select sum(t.p_30) ,
         sum(t.p_031_060) , sum(t.p_061_090) ,
         sum(t.p_091_120) , sum(t.p_121_150) ,
         sum(t.p_151_180) , sum(t.p_181_210) , 
         sum(t.p_211_240) , sum(t.p_241_270) ,
         sum(t.p_271_300) , sum(t.p_301_330) ,
         sum(t.p_331_360) , sum(t.p_361_390) ,
         sum(t.p_391_420) , sum(t.p_421_450) ,
         sum(t.p_451_480) , sum(t.p_481_510) ,
         sum(t.p_511_540) , sum(t.p_541_570) ,
         sum(t.p_571_600) , sum(t.p_601_630) ,
         sum(t.p_631_660) , sum(t.p_661_690) ,
         sum(t.p_691_720) , sum(t.p_721_750) ,
         sum(t.p_750), max(t.rep_month) 
     into          
         p_do_30,p_31_60,p_61_90,p_91_120,p_121_150,p_151_180,
         p_181_210,p_211_240,p_241_270,p_271_300,p_301_330,p_331_360,p_361_390,p_391_420,
         p_421_450,p_451_480,p_481_510,p_511_540,p_541_570,p_571_600,p_601_630,p_631_660,
         p_661_690,p_691_720,p_721_750,p_750, max_month       
    from port_for_prov t
  --where t.rep_month >= to_date('2012 - 07','yyyy - mm') and t.rep_month < to_date('2014 - 07','yyyy - mm');
  where t.rep_month >= add_months(trunc(sysdate,'mm'),-24);-- and t.rep_month <= add_months(trunc(sysdate,'mm'),0);   

-- просчитываем проценты при условии, что если результат БОЛЕЕ 100%, то округляем до 100%
-- для того что бы не размазывать код, используем переменные знаменателей для записи в них процентов.

r_not_delinquent := round(p_do_30/r_not_delinquent,9);
r_do_30 := round(p_31_60/r_do_30,9);
r_31_60 := round(p_61_90/r_31_60,9);
r_61_90 := round(p_91_120/r_61_90,9);
r_91_120 := round(p_121_150/r_91_120,9);
r_121_150 := round(p_151_180/r_121_150,9);
r_151_180 := round(p_181_210/r_151_180,9);
r_181_210 := round(p_211_240/r_181_210,9);
r_211_240 := round(p_241_270/r_211_240,9);
r_241_270 := round(p_271_300/r_241_270,9);
r_271_300 := round(p_301_330/r_271_300,9);
r_301_330 := round(p_331_360/r_301_330,9);
r_331_360 := round(p_361_390/r_331_360,9);
r_361_390 := round(p_391_420/r_361_390,9);
r_391_420 := round(p_421_450/r_391_420,9);
r_421_450 := round(p_451_480/r_421_450,9);
r_451_480 := round(p_481_510/r_451_480,9);
r_481_510 := round(p_511_540/r_481_510,9);
r_511_540 := round(p_541_570/r_511_540,9);
r_541_570 := round(p_571_600/r_541_570,9);
r_571_600 := round(p_601_630/r_571_600,9);
r_601_630 := round(p_631_660/r_601_630,9);
r_631_660 := round(p_661_690/r_631_660,9);
r_661_690 := round(p_691_720/r_661_690,9);
r_691_720 := round(p_721_750/r_691_720,9);
r_721_750 := round((p_750)/(r_721_750+r_750),3);

-- высчитываем строку произведений и уже готовые проценты
-- так же что бы не размазывать код, используем переменные числителей для записи в них процентов.
-- не красиво так рассчитывать, но надежно
p_not_delinquent := /*CEIL(*/round(round((case when r_not_delinquent>10 then 1 else r_not_delinquent end) * 
                    (case when r_do_30>1 then 1 else r_do_30 end) *
                    (case when r_31_60>1 then 1 else r_31_60 end) *
                    (case when r_61_90>1 then 1 else r_61_90 end) *
                    (case when r_91_120>1 then 1 else r_91_120 end) *                    
                    (case when r_121_150>1 then 1 else r_121_150 end) * 
                    (case when r_151_180>1 then 1 else r_151_180 end) *
                    (case when r_181_210>1 then 1 else r_181_210 end) *
                    (case when r_211_240>1 then 1 else r_211_240 end) *
                    (case when r_241_270>1 then 1 else r_241_270 end) *
                    (case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 
                    
p_do_30 :=          /*CEIL(*/round(round((case when r_do_30>1 then 1 else r_do_30 end) * 
                    (case when r_31_60>1 then 1 else r_31_60 end) *
                    (case when r_61_90>1 then 1 else r_61_90 end) *
                    (case when r_91_120>1 then 1 else r_91_120 end) *                    
                    (case when r_121_150>1 then 1 else r_121_150 end) * 
                    (case when r_151_180>1 then 1 else r_151_180 end) *
                    (case when r_181_210>1 then 1 else r_181_210 end) *
                    (case when r_211_240>1 then 1 else r_211_240 end) *
                    (case when r_241_270>1 then 1 else r_241_270 end) *
                    (case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;  
                    
p_31_60 :=          /*CEIL(*/round(round((case when r_31_60>1 then 1 else r_31_60 end) *
                    (case when r_61_90>1 then 1 else r_61_90 end) *
                    (case when r_91_120>1 then 1 else r_91_120 end) *                    
                    (case when r_121_150>1 then 1 else r_121_150 end) * 
                    (case when r_151_180>1 then 1 else r_151_180 end) *
                    (case when r_181_210>1 then 1 else r_181_210 end) *
                    (case when r_211_240>1 then 1 else r_211_240 end) *
                    (case when r_241_270>1 then 1 else r_241_270 end) *
                    (case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 
                    
p_61_90 :=          /*CEIL(*/round(round((case when r_61_90>1 then 1 else r_61_90 end) *
                    (case when r_91_120>1 then 1 else r_91_120 end) *                    
                    (case when r_121_150>1 then 1 else r_121_150 end) * 
                    (case when r_151_180>1 then 1 else r_151_180 end) *
                    (case when r_181_210>1 then 1 else r_181_210 end) *
                    (case when r_211_240>1 then 1 else r_211_240 end) *
                    (case when r_241_270>1 then 1 else r_241_270 end) *
                    (case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 

p_91_120 :=         /*CEIL(*/round(round((case when r_91_120>1 then 1 else r_91_120 end) *                    
                    (case when r_121_150>1 then 1 else r_121_150 end) * 
                    (case when r_151_180>1 then 1 else r_151_180 end) *
                    (case when r_181_210>1 then 1 else r_181_210 end) *
                    (case when r_211_240>1 then 1 else r_211_240 end) *
                    (case when r_241_270>1 then 1 else r_241_270 end) *
                    (case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;                                                                               

p_121_150 :=        /*CEIL(*/round(round((case when r_121_150>1 then 1 else r_121_150 end) * 
                    (case when r_151_180>1 then 1 else r_151_180 end) *
                    (case when r_181_210>1 then 1 else r_181_210 end) *
                    (case when r_211_240>1 then 1 else r_211_240 end) *
                    (case when r_241_270>1 then 1 else r_241_270 end) *
                    (case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;  
                    
p_151_180 :=        /*CEIL(*/round(round((case when r_151_180>1 then 1 else r_151_180 end) *
                    (case when r_181_210>1 then 1 else r_181_210 end) *
                    (case when r_211_240>1 then 1 else r_211_240 end) *
                    (case when r_241_270>1 then 1 else r_241_270 end) *
                    (case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;   
                   
p_181_210 :=        /*CEIL(*/round(round((case when r_181_210>1 then 1 else r_181_210 end) *
                    (case when r_211_240>1 then 1 else r_211_240 end) *
                    (case when r_241_270>1 then 1 else r_241_270 end) *
                    (case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;  
                    
p_211_240 :=        /*CEIL(*/round(round((case when r_211_240>1 then 1 else r_211_240 end) *
                    (case when r_241_270>1 then 1 else r_241_270 end) *
                    (case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 
                     
p_241_270 :=        /*CEIL(*/round(round((case when r_241_270>1 then 1 else r_241_270 end) *
                    (case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;  
                    
p_271_300 :=        /*CEIL(*/round(round((case when r_271_300>1 then 1 else r_271_300 end) *
                    (case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;  
                    
p_301_330 :=        /*CEIL(*/round(round((case when r_301_330>1 then 1 else r_301_330 end) *
                    (case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 
                    
p_331_360 :=        /*CEIL(*/round(round((case when r_331_360>1 then 1 else r_331_360 end) *
                    (case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;  
                    
p_361_390 :=        /*CEIL(*/round(round((case when r_361_390>1 then 1 else r_361_390 end) *                    
                    (case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 
                    
p_391_420 :=        /*CEIL(*/round(round((case when r_391_420>1 then 1 else r_391_420 end) *
                    (case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;  
                    
p_421_450 :=        /*CEIL(*/round(round((case when r_421_450>1 then 1 else r_421_450 end) *                    
                    (case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 
                    
p_451_480 :=        /*CEIL(*/round(round((case when r_451_480>1 then 1 else r_451_480 end) * 
                    (case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;   
                    
p_481_510 :=        /*CEIL(*/round(round((case when r_481_510>1 then 1 else r_481_510 end) *
                    (case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 
                    
p_511_540 :=        /*CEIL(*/round(round((case when r_511_540>1 then 1 else r_511_540 end) *   
                    (case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;  
                    
p_541_570 :=        /*CEIL(*/round(round((case when r_541_570>1 then 1 else r_541_570 end) * 
                    (case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 
                    
p_571_600 :=        /*CEIL(*/round(round((case when r_571_600>1 then 1 else r_571_600 end) * 
                    (case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;                                                                                                                                                                                                                                                                                  

p_601_630 :=        /*CEIL(*/round(round((case when r_601_630>1 then 1 else r_601_630 end) *
                    (case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 
                    
p_631_660 :=        /*CEIL(*/round(round((case when r_631_660>1 then 1 else r_631_660 end) *
                    (case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 
                    
p_661_690 :=        /*CEIL(*/round(round((case when r_661_690>1 then 1 else r_661_690 end) *   
                    (case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/;  
                    
p_691_720 :=        /*CEIL(*/round(round((case when r_691_720>1 then 1 else r_691_720 end),9)*POWER(r_721_750,6),/*5*/3)*100/*0)/10*/; 

p_721_750 :=        100;
p_750 :=            100;   

  -- тут смотрим, если есть на текущий месяц данные, то перезаписываем, если нету, то просто записываем.
  /*select trunc(max(t.rep_month),'mm') into max_month from PROVISIONS_PERCENTAGES t;
  select max(t.rep_month) into rep_month from PROVISIONS t;*/
  select nvl(max(t.rep_month),to_Date('01.01.1900','dd.mm.yyyy')) into rep_month from PERCEN_FOR_PROV t 
          where trunc(t.rep_month,'mm') = trunc(add_months(max_month,1),'mm');
  --если в этом месяце запись уже была, удаляем ее и записываем свежие данные, если небыло, то просто записываем свежие данные
  max_month := add_months(max_month,1);
  weekend := 0;
  -- берем последний рабочий день месяца, с учетом праздников и выходных.
  select LAST_DAY(max_month) into last_day from dual;
  select nvl(max(ww.day_weekends),0) into weekend from T_HOLIDAYS ww where ww.data = last_day;
  --max_month := last_day - weekend;
  max_month := trunc(sysdate);
  if max_month = rep_month then
  begin
    delete from PERCEN_FOR_PROV t where t.rep_month = max_month; 
    commit;
    insert into PERCEN_FOR_PROV (REP_MONTH, NOT_DELINQUENT, P_30, P_031_060, P_061_090, P_091_120, P_121_150, P_151_180, P_181_210, P_211_240, 
                            P_241_270, P_271_300, P_301_330, P_331_360, P_361_390, P_391_420, P_421_450, P_451_480, P_481_510, P_511_540, 
                            P_541_570, P_571_600, P_601_630, P_631_660, P_661_690, P_691_720, P_721_750, P_750)
                    VALUES (max_month,p_not_delinquent, P_DO_30, P_31_60, P_61_90, P_91_120, P_121_150, P_151_180, P_181_210, P_211_240, P_241_270,
                            P_271_300, P_301_330, P_331_360, P_361_390, P_391_420, P_421_450, P_451_480, P_481_510, P_511_540, P_541_570,
                            P_571_600, P_601_630, P_631_660, P_661_690, P_691_720, P_721_750, P_750);  
    commit;                           
  end;
  else   
  begin
    insert into PERCEN_FOR_PROV (REP_MONTH, NOT_DELINQUENT, P_30, P_031_060, P_061_090, P_091_120, P_121_150, P_151_180, P_181_210, P_211_240, 
                            P_241_270, P_271_300, P_301_330, P_331_360, P_361_390, P_391_420, P_421_450, P_451_480, P_481_510, P_511_540, 
                            P_541_570, P_571_600, P_601_630, P_631_660, P_661_690, P_691_720, P_721_750, P_750)
                    VALUES (max_month,p_not_delinquent, P_DO_30, P_31_60, P_61_90, P_91_120, P_121_150, P_151_180, P_181_210, P_211_240, P_241_270,
                            P_271_300, P_301_330, P_331_360, P_361_390, P_391_420, P_421_450, P_451_480, P_481_510, P_511_540, P_541_570,
                            P_571_600, P_601_630, P_631_660, P_661_690, P_691_720, P_721_750, P_750);          
    commit;
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (0,7,p_not_delinquent,max_month);
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (8,30,P_DO_30,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (31,60,P_31_60,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (61,90,P_61_90,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (91,120,P_91_120,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (121,150,P_121_150,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (151,180,P_151_180,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (181,210,P_181_210,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (211,240,P_211_240,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (241,270,P_241_270,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (271,300,P_271_300,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (301,330,P_301_330,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (331,360,P_331_360,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (361,390,P_361_390,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (391,420,P_391_420,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (421,450,P_421_450,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (451,480,P_451_480,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (481,510,P_481_510,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (511,540,P_511_540,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (541,570,P_541_570,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (571,600,P_571_600,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (601,630,P_601_630,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (631,660,P_631_660,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (661,690,P_661_690,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (691,720,P_691_720,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (721,750,P_721_750,max_month); 
    insert into ref_provisions (days_del_from,days_del_to,provision,a_date) values (751,1000000000,P_750,max_month); 
    commit;
    ref_prov;
  end;
  end if; 
                                                  
end percentages;    

procedure ref_prov
is
  max_date date;
begin
   for info in (select * from PERCEN_FOR_PROV p where p.rep_month >= to_date('31.12.2012','dd.mm.yyyy')) loop
     select nvl(max(p.a_date),null) into max_date from ref_provision p where p.a_date = info.rep_month;
     if max_date is null then 
     begin   
     insert into ref_provision (days_del,provision,a_date) values ('Не на просрочке',info.not_delinquent,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('до 30 дней',info.p_30,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('031-060',info.p_031_060,info.rep_month);  
     insert into ref_provision (days_del,provision,a_date) values ('061-090',info.p_061_090,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('091-120',info.p_091_120,info.rep_month);  
     insert into ref_provision (days_del,provision,a_date) values ('121-150',info.p_121_150,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('151-180',info.p_151_180,info.rep_month);  
     insert into ref_provision (days_del,provision,a_date) values ('181-210',info.p_181_210,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('211-240',info.p_211_240,info.rep_month);  
     insert into ref_provision (days_del,provision,a_date) values ('241-270',info.p_241_270,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('271-300',info.p_271_300,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('301-330',info.p_301_330,info.rep_month);  
     insert into ref_provision (days_del,provision,a_date) values ('331-360',info.p_331_360,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('361-390',info.p_361_390,info.rep_month);  
     insert into ref_provision (days_del,provision,a_date) values ('391-420',info.p_391_420,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('421-450',info.p_421_450,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('451-480',info.p_451_480,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('481-510',info.p_481_510,info.rep_month);  
     insert into ref_provision (days_del,provision,a_date) values ('511-540',info.p_511_540,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('541-570',info.p_541_570,info.rep_month);  
     insert into ref_provision (days_del,provision,a_date) values ('571-600',info.p_571_600,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('601-630',info.p_601_630,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('631-660',info.p_631_660,info.rep_month);  
     insert into ref_provision (days_del,provision,a_date) values ('661-690',info.p_661_690,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('691-720',info.p_691_720,info.rep_month);  
     insert into ref_provision (days_del,provision,a_date) values ('721-750',info.p_721_750,info.rep_month);
     insert into ref_provision (days_del,provision,a_date) values ('>750',info.p_750,info.rep_month);
     commit;
     end;
     end if;
   end loop;
end ref_prov; 

procedure vintage_upd
is
  vRes integer;
  vLog_det varchar2(4000);
  begin
    -- непосредственно процесс обновления
    vRes := pkg_update_util.mv_truncate_refresh('m_VINTAGE_RECORDS');
    pkg_update_util.log_mv_refresh(vLog_det, 'm_VINTAGE_RECORDS', vRes);  

    vRes := pkg_update_util.mv_truncate_refresh('VINTAGE_SALE_DOCS');
    pkg_update_util.log_mv_refresh(vLog_det, 'VINTAGE_SALE_DOCS', vRes);  
end vintage_upd;


procedure disconnect_sessions 
is
sql_id varchar2(100);
sql_code varchar2(3000);
length_sql number := 0;
simvol number := 0;
v_conn      utl_smtp.Connection;
v_crlf      VARCHAR2(2) := chr(13)||chr(10);
v_message clob;
v_server    VARCHAR2(30);
v_port number;
v_from      VARCHAR2(128);
email VARCHAR2(50);
p_name VARCHAR2(50);
begin
     --получаем инфу по сессиям, которые в статусе WAITING (ожидание). Их мы будем удаялть!!! 
     for info in (select * from (
                  select count(*) as session_count,
                         count(case when s.PGA_TUNABLE_MEM > 0 then s.SID end) as session_active_count,
                         round(count(case when s.PGA_TUNABLE_MEM > 0 then s.SID end) /
                               count(*) * 100,1) as par_effect_rate,
                         s.OSUSER, s.username, s.MACHINE,s.SQL_ID
                  from SYS.V_$SESSION s
                  where s.STATE = 'WAITING' and s.STATUS = 'ACTIVE' and 
                        s.USERNAME = 'U1' and s.OSUSER <> 'orcl' 
                  group by s.username, s.OSUSER, s.MACHINE,s.SQL_ID
                  order by 1 desc) a where a.session_count > 15) loop
     begin
       --проверяем, есть ли у нас в логе на удаление уже сессия по текущему в курсоре пользователю
       select nvl(max(l.sql_id),'0') into sql_id from T_S_DISCONNECT_SESSIONS_LOG l where l.osuser = info.osuser and 
                                                     l.sql_id = info.sql_id and l.is_discon = 1;
       -- если нету, то парсим запрос, определям сколько минут ожидать сессию еще.
       if sql_id = '0' then 
       begin
         select max(length(s.SQL_FULLTEXT)) into length_sql from SYS.V_$SQL s where s.SQL_ID = info.sql_id;
         select max(s.SQL_TEXT) into sql_code from SYS.V_$SQL s where s.SQL_ID = info.sql_id;
         if INSTR(sql_code,'select *') = 1 /*and length_sql <= 100*/ then 
           begin
           insert into T_S_DISCONNECT_SESSIONS_LOG(osuser, parallel_count, sql_id, time_adding, minutes_waiting, is_discon) 
                 values (info.osuser,info.session_count,info.sql_id,sysdate,15,1);
           commit;      
           end;
         end if;
       end;
       end if;
     end;
     end loop;       
     --если есть, то проверям не пора ли отрубать сессии.   


     for discon in (select * from DISCONNECT_SESSIONS_LOG l where l.is_discon = 1) loop
--как все отлажу, надо поставить sysdate >=
       if sysdate >= discon.time_adding+discon.minutes_waiting/(24*60) then
         begin
           -- проверяем, не ушла ли сессия.
           select count(*) into simvol from sys.v_$session sq where sq.status = 'ACTIVE' and sq.SQL_ID = discon.sql_id;
           if simvol >= 15 then
             v_server := 'relay2.bc.kz'; 
             v_port := 25;
             v_from := 'rdwh@kaspibank.kz';
             v_conn := utl_smtp.open_connection(v_server, v_port);
             utl_smtp.Helo(v_conn, v_server);
             utl_smtp.Mail(v_conn, v_from); 
             v_message := 'Date: '   || to_char(systimestamp, 'dd-mm-yyyy hh24:mi:ss.ff') || v_crlf ||
                   'From: '   || v_from || v_crlf ||
                   'Subject: '|| 'Необходимо закрыть селект.' || v_crlf; 
             v_message := v_message || 'To: ';
             -- тут пока наглухо забью свой майл на время теста.
             
             
             select lm.email, lm.name into email, p_name from T_S_LOGIN_AND_MAIL_UAMR lm where lm.login like '%'||discon.osuser; 
             utl_smtp.Rcpt(v_conn, email);
              
             -- v_message := v_message ||'Andrey.Rybalov@kaspibank.kz';
             if email = 'Zhan.Nurgaliyev@kaspibank.kz' then               
               v_message := v_message || email || '; Grigoriy.I.Kim@kaspibank.kz';
               utl_smtp.Rcpt(v_conn, 'Grigoriy.I.Kim@kaspibank.kz');            
             elsif email = 'Grigoriy.I.Kim@kaspibank.kz' then               
               v_message := v_message || email || '; Zhan.Nurgaliyev@kaspibank.kz'; 
               utl_smtp.Rcpt(v_conn, 'Zhan.Nurgaliyev@kaspibank.kz');            
             else               
               v_message := v_message || email || '; Grigoriy.I.Kim@kaspibank.kz; Zhan.Nurgaliyev@kaspibank.kz';  
               utl_smtp.Rcpt(v_conn, 'Grigoriy.I.Kim@kaspibank.kz');               
               utl_smtp.Rcpt(v_conn, 'Zhan.Nurgaliyev@kaspibank.kz');
             end if;
               
             v_message := v_message || v_crlf || v_crlf;
             select sq.SQL_TEXT into sql_code from SYS.V_$SQL sq where sq.SQL_ID = discon.sql_id;
             
             v_message := v_message || p_name ||', убери пожалуйста свой селект с id:    ' ||discon.sql_id|| v_crlf ||v_crlf
                                    || sql_code || v_crlf || v_crlf ||'Спасибо!'||v_crlf; 
             v_message := convert(v_message, 'UTF8');                                              
             utl_smtp.open_data(c => v_conn);
             utl_smtp.write_raw_data(c => v_conn, data => utl_raw.cast_to_raw(v_message));  
             utl_smtp.close_data(c => v_conn);
             utl_smtp.quit(v_conn);                                                   
             update DISCONNECT_SESSIONS_LOG l set l.is_discon = 0 where l.sql_id = discon.sql_id;
             commit;
           else  
             update DISCONNECT_SESSIONS_LOG l set l.is_discon = 0 where l.sql_id = discon.sql_id; 
             commit;
           end if;
         end;
       end if;
     end loop;       
  
end disconnect_sessions;


begin
null;
end PKG_PROVISIONS;
/

