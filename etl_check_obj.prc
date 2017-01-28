create or replace procedure u1.ETL_CHECK_OBJ (in_object_name in varchar2) is
  CNT_ROW             constant varchar2(26) := 'CNT_ROW';
  CNT_UNIQ_VAL        constant varchar2(26) := 'CNT_UNIQ_VAL';
  PERCENT_NULL_VALUES constant varchar2(26) := 'PERCENT_NULL_VALUES';
  CUSTOM              constant varchar2(26) := 'CUSTOM';
  v_sql    varchar2(1024);
  v_result number;
  
begin
  for x in (
    select *
      from T_ETL_CHECK_OBJ h
     where h.is_active = 1
       and h.object_name = in_object_name
    ) 
    loop
      v_sql    := null;
      v_result := null;
      if x.check_code = CNT_ROW then
        v_sql := 'select count(1) from ' || x.object_name;
        execute immediate v_sql into v_result;
        if v_result < x.value then
          raise_application_error(-20000,'Object:' || x.object_name || ', rule:'||CNT_ROW||'; (result:)'||v_result ||' less (const:)'|| x.value );
        end if;
      
      elsif x.check_code = CNT_UNIQ_VAL then
        v_sql := 'select count(distinct(' || x.column_name || ')) from ' || x.object_name;
        execute immediate v_sql into v_result;
        if v_result < x.value then
          raise_application_error(-20000,'Object:' || x.object_name || ', rule:'||CNT_UNIQ_VAL||'; (result:)'||v_result ||' less (const:)'|| x.value );
        end if;
      
      elsif x.check_code = PERCENT_NULL_VALUES then
        v_sql := 'select round(sum(case when ' || x.column_name ||' is null then 1 else 0 end)/count(*),2) from ' || x.object_name;
        execute immediate v_sql into v_result;
        if v_result > x.value then
          raise_application_error(-20000,'Object:' || x.object_name || ', rule:'||PERCENT_NULL_VALUES||'; (result:)'||v_result ||' larger (const:)'|| x.value );
        end if;
         
      elsif x.check_code = CUSTOM then
        --v_sql := 'BEGIN ' || x.proc_name||'('''||(x.object_name)||'''); end;';
        --raise_application_error(-20000,'Object:' || x.object_name);
        v_sql := 'BEGIN ' || x.proc_name || '; end;';
        execute immediate v_sql;
      end if;
      
  end loop;


end ETL_CHECK_OBJ;
/

