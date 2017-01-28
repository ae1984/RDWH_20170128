create or replace procedure u1.ETLCHK_KASPIKZ_CLIENT_PMT_3M is
      v_row_cnt  number;

    begin
      select count(1)
        into v_row_cnt
        from U1.M_KASPIKZ_CLIENT_PMT_3M
       where rownum < 2;

      if v_row_cnt = 0 then
        raise_application_error(-20000, 'Объект пустой');
      end if;

    end ETLCHK_KASPIKZ_CLIENT_PMT_3M;
/

