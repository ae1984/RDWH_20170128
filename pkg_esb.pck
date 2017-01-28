create or replace package u1.pkg_esb is

  -- Author  : KIM_17004
  -- Created : 18/12/2015 15:40:14
  -- Purpose :

  -- Public function and procedure declarations
  procedure add_art_process(in_art_process_arr u1.t_art_process_arr,
                            out_status    out varchar2, --Статус выполнения (OK, ERROR)
                            out_err_txt   out varchar2);

end pkg_esb;
/
grant execute on U1.PKG_ESB to ESB_USER;


create or replace package body u1.pkg_esb is

  procedure add_art_process(in_art_process_arr u1.t_art_process_arr,
                            out_status    out varchar2, --Статус выполнения (OK, ERROR)
                            out_err_txt   out varchar2)
  as
  begin
    begin
      for i in in_art_process_arr.first .. in_art_process_arr.last
      loop
        insert into u1.t_art_process (
               start_date,
               auth_err, trans_err, all_err,
               all_0,
               auth_ok, trans_ok, all_ok)
        values (in_art_process_arr(i).start_date,
                in_art_process_arr(i).auth_err, in_art_process_arr(i).trans_err, in_art_process_arr(i).all_err,
                in_art_process_arr(i).all_0,
                in_art_process_arr(i).auth_ok, in_art_process_arr(i).trans_ok, in_art_process_arr(i).all_ok);
      end loop;
      commit;

      out_status := 'OK';
      out_err_txt := '';

    exception when others
      then
        rollback;
        out_status := 'ERROR';
        out_err_txt := SQLERRM;
    end;

  end add_art_process;
end pkg_esb;
/
grant execute on U1.PKG_ESB to ESB_USER;


