create or replace function u1.GET_FOLDER_BARCODE ( in_folder_id in number ) return varchar2 is
    v_str varchar2(1000);
    v_cnt  number;
    v_folder_id number;

begin
  select count(1)
    into v_cnt
    from m_cancel_order_d;

  select rpad('0', v_cnt, '0')
    into v_str
    from dual;


  v_folder_id := 0;
  for rec in (
    select /*+ parallel(16)*/
           t.folder_id,
           t.rule_order
      from m_folder_cancel_barcode t
     where t.folder_id = in_folder_id
       and t.rule_order is not null
  )
  loop
      if v_folder_id <> rec.folder_id then
         select rpad('0', (select count(1) from m_cancel_order_d), '0')
           into v_str
           from dual;

       v_folder_id:=rec.folder_id;

      end if;
      v_str:= substr(v_str, 1, rec.rule_order - 1) || '1' || substr(v_str, rec.rule_order + 1, v_cnt);
  end loop;
  return(v_str);
end GET_FOLDER_BARCODE;
/

