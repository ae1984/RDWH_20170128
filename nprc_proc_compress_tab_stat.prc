create or replace procedure u1.NPRC_PROC_COMPRESS_TAB_STAT(p_id number) is
begin
  update NT_PROCESS_COMPRESS_TABLE
     set processed_dt = sysdate
  where id = p_id;
  commit;
end NPRC_PROC_COMPRESS_TAB_STAT;
/

