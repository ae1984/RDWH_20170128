create or replace function u1.working_days_between (start_dt in date, end_dt in date) return number is
wdays number;
begin
select (trunc(end_dt - start_dt) -
       ((case WHEN (8 - to_number(to_char(start_dt, 'D'))) > trunc(end_dt - start_dt) + 1 THEN 0
         ELSE trunc((trunc(end_dt - start_dt) - (8 - to_number(to_char(start_dt, 'D')))) / 7) + 1
         END) +

         (case WHEN mod(8 - to_char(start_dt, 'D'), 7) > trunc(end_dt - start_dt) - 1 THEN 0
          ELSE trunc((trunc(end_dt - start_dt) - (mod(8 - to_char(start_dt, 'D'), 7) + 1)) / 7) + 1
       END))
       ) into wdays from dual;
       return wdays;
end working_days_between;
/

