create or replace function u1.data_all_get_start_date_by_ctr(
       in_contract_number in varchar2) return varchar2 is
  out_start_date date := null;
begin
  
  for r in (
        select start_date from (
                  select da7.start_date from data_all da7
                  where da7.contract_no = in_contract_number
                        and da7.start_date is not null
                  order by da7.yy_mm_report asc
              ) where rownum = 1) loop
      
     out_start_date := r.start_date;
  
  end loop;
  
  return(out_start_date);

end data_all_get_start_date_by_ctr;
/

