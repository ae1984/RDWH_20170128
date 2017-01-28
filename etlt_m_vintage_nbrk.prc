create or replace procedure u1.ETLT_M_VINTAGE_NBRK is
   v_sql varchar2(32000);
begin
   v_sql := 'drop materialized view M_VINTAGE_NBRK';
   execute immediate v_sql;
   -- пересозлание матвью с изменением перечня полей (добавились данные еще за 1 месяц)   
   select 'create materialized view M_VINTAGE_NBRK nologging parallel 30 build deferred refresh force on demand as
     select '||col_list|| ' from '||TABLE_NAME
     into v_sql
   from (
   select listagg('"'||c.COLUMN_NAME||'"',',') within group (order by COLUMN_ID) as col_list,
         c.TABLE_NAME
   from dba_tab_columns c 
   where c.OWNER = 'U1' 
     and c.TABLE_NAME = 'M_VINTAGE_NBRK_PRE'
     and (c.COLUMN_NAME in ('QUARTER','SALES','')            
     or c.COLUMN_NAME < to_char(sysdate,'yyyy-mm'))
     group by  c.TABLE_NAME);
   execute immediate v_sql;
   --непоседственно обновление
   NPRC_MV_TRUNCATE_REFRESH('M_VINTAGE_NBRK');

end ETLT_M_VINTAGE_NBRK;
/

