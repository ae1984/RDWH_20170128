create or replace function u1.asokr_get_fld_id_by_ctr(
          in_contract_number in varchar2,
          in_date in date,
          in_range in number := 23 -- дни
          ) return varchar2 is
  out_folder_id number := null;
  v_rnn varchar2(12);
begin

  select rnn into v_rnn from (  --- OK
        select da7.rnn from data_all da7
        where da7.contract_no = in_contract_number
              and da7.rnn is not null
        order by da7.yy_mm_report asc
      ) where rownum = 1;

  if (v_rnn is not null) then
/*
     out_folder_id := null;

  else*/

      select max(aa.folder_id) into out_folder_id
      from data_asokr aa
      where
            aa.rnn = v_rnn
            and (in_date - aa.scoring_date) <= in_range;
/*            and (in_date - add_months(aa.scoring_date,
                        trunc(months_between(in_date,aa.scoring_date)))) <= in_range;
*/

  end if;

  return(out_folder_id);

end asokr_get_fld_id_by_ctr;
/

