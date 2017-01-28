create or replace function u1.get_num_months(
          in_yy_mm_report in varchar2,
          in_yy_mm_start in varchar2
          ) return number is
  out_num_months number := 0;
begin

  select MONTHS_BETWEEN(
         to_date(in_yy_mm_report,'yyyy - mm'),
         to_date(in_yy_mm_start,'yyyy - mm')
         ) into out_num_months
       from dual;

  if (out_num_months < 0) then
     out_num_months := 0;
  end if;

  return(out_num_months);

end get_num_months;
/

