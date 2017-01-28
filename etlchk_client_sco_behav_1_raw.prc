create or replace procedure u1.ETLCHK_CLIENT_SCO_BEHAV_1_RAW is
      v_row_cnt  number;

    begin
      select count(1)
        into v_row_cnt
        from U1.M_CLIENT_SCO_BEHAV_1_RAW
       where rownum < 2;

      if v_row_cnt = 0 then
        raise_application_error(-20000, 'Объект пустой');
      end if;

    end ETLCHK_CLIENT_SCO_BEHAV_1_RAW;
/

