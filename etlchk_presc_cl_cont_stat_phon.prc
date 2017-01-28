create or replace procedure u1.ETLCHK_PRESC_CL_CONT_STAT_PHON is
      v_row_cnt  number;

    begin
      select count(1)
        into v_row_cnt
        from U1.M_PRESC_CL_CONT_STAT_PHONE_CNT
       where rownum < 2;

      if v_row_cnt = 0 then
        raise_application_error(-20000, 'Объект пустой');
      end if;

    end ETLCHK_PRESC_CL_CONT_STAT_PHON;
/

