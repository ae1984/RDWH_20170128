create or replace function u1.data_all_get_rnn_by_ctr(
       in_contract_number in varchar2) return varchar2 is
  out_rnn varchar2(12) := null;
begin
  
  for r in (
        select rnn from (
                  select da7.rnn from data_all da7
                  where da7.contract_no = in_contract_number
                        and da7.rnn is not null
                  order by da7.yy_mm_report asc
              ) where rownum = 1) loop
      
     out_rnn := r.rnn;
  
  end loop;
  
  return(out_rnn);

end data_all_get_rnn_by_ctr;
/

