create or replace procedure u1.NPRC_PROC_RESIZE_TAB_SAVESTAT(p_id number) is
begin
  update NT_PROCESS_RESIZE_TABLE
     set processed_dt = sysdate
  where id = p_id;
  commit;
end NPRC_PROC_RESIZE_TAB_SAVESTAT;
/

