create or replace force view u1.v_time_holidays as
select cv.value as holiday, min(wd.yyyy_mm_dd) as first_work_day
  from M_RBO_CALENDAR_VALUE cv
  join (select td.yyyy_mm_dd
         from V_TIME_DAYS td
        where yyyy_mm_dd >= to_date('01-02-2008','dd-mm-yyyy')
          and yyyy_mm_dd <= last_day(sysdate)
          and not exists
           (select 1 from M_RBO_CALENDAR_VALUE
             where calendar_name in ('HOLIDAYS','HOLIDAYS_W')
               and value = td.yyyy_mm_dd)) wd on wd.yyyy_mm_dd > cv.value
 where calendar_name in ('HOLIDAYS','HOLIDAYS_W')
   and cv.value >= to_date('01-02-2008','dd-mm-yyyy')
 group by cv.value;
comment on table U1.V_TIME_HOLIDAYS is 'Информация по выходным дням(включает праздник и дни переноса выходных) с 01-02-2008';
comment on column U1.V_TIME_HOLIDAYS.HOLIDAY is 'Выходной день';
comment on column U1.V_TIME_HOLIDAYS.FIRST_WORK_DAY is 'Первый рабочий день после выходного дня';
grant select on U1.V_TIME_HOLIDAYS to LOADDB;
grant select on U1.V_TIME_HOLIDAYS to LOADER;


