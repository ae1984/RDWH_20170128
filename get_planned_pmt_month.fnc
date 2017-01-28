create or replace function u1.get_planned_pmt_month(
          in_yy_mm_report in varchar2,
          in_yy_mm_start in varchar2,
          in_end_date in date
          ) return number is
  out_planned_pmt_month number := 0;
  num_months number := 0;
  is_card number;
begin

  select MONTHS_BETWEEN(
         to_date(in_yy_mm_report,'yyyy - mm'),
         to_date(in_yy_mm_start,'yyyy - mm')
         ) into num_months
       from dual;

  select nvl2(in_end_date,1,2) into is_card from dual; 

  if (num_months > 0) then
     out_planned_pmt_month := num_months - is_card + 1;
  end if;

  return(out_planned_pmt_month);

end get_planned_pmt_month;
/

