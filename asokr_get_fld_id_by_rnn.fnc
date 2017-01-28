create or replace function u1.asokr_get_fld_id_by_rnn(
          in_rnn in varchar2,
          in_date in date,
          in_range in number -- дни
          ) return varchar2 is
  out_folder_id number;
begin

  if (in_rnn is null) then

     out_folder_id := null;

  else

      select max(aa.folder_id) into out_folder_id
      from data_asokr aa
      where
            aa.rnn = in_rnn
            and (in_date - aa.scoring_date) <= in_range;
  end if;

  return(out_folder_id);

end asokr_get_fld_id_by_rnn;
/

