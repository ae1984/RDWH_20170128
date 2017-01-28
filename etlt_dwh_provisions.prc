create or replace procedure u1.ETLT_DWH_PROVISIONS is
      s_mview_name     varchar2(30) := 'T_DWH_PROVISIONS';
      vStrDate         date := sysdate;
      d_max_date       date;
      d_date_load      date := trunc(sysdate);
      s_error varchar2(2000);
      e_user_exception exception;
    begin
      select max(p.rep_date)
        into d_max_date
        from T_DWH_PROVISIONS p;
      --
      for cur in (select d_max_date + level as rep_date
                    from dual
                   where d_max_date + level < d_date_load
                 connect by rownum < d_date_load - d_max_date
                   order by 1
       ) loop
         p_calc_provisions_dwh(p_date =>  cur.rep_date,p_type => 1,p_error => s_error);
         if s_error is not null then
           raise e_user_exception;
         end if;
       end loop;


     end ETLT_DWH_PROVISIONS;
/

