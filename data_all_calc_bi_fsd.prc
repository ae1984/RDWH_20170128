create or replace procedure u1.data_all_calc_bi_fsd(
       in_yymmreport varchar2       
       ) is
  v_seq      NUMBER(38); -- для отслеживания
begin
-- запускается для нового отчета

  for d in (
        select min(r.start_date) as fsd, r.c_client_id
        from (select distinct t.start_date, t.c_client_id
                   from DATA_ALL t
                   where t.c_client_id in (
                                       select distinct x.c_client_id from DATA_ALL x
                                               where x.yy_mm_report = in_yymmreport
              --                    and x.c_first_start_date is null ------- REMOVE!
                                  )
                         and t.start_date is not null
                    ) r 
        group by r.c_client_id
    ) loop

  update /*+rule*/ data_all set
    c_first_start_date = d.fsd--,
--    is_calculated_for_bi = 6
  where c_client_id = d.c_client_id
   and yy_mm_report = in_yymmreport;  
  
  commit;
  
  -- увеличиваем sequence для отслеживания ------------------------------------
  select data_all_calc_bi_fsd_seq.nextval into v_seq from dual;
  
  end loop;    

end data_all_calc_bi_fsd;
/

