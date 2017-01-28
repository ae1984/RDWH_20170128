create or replace function u1.get_pkb_debt_from_text(
          in_str in varchar2,
          in_date in date default trunc(sysdate)
          ) return number is
  v_str_all varchar2(500);
  v_str varchar2(50);
  v_str_begin_pos number;
  v_cur_rate number;
  v_result number := 0;
  sim varchar(5);
  n_curs_USD number;
  n_curs_EUR number;
  n_curs_RUR number;
  n_curs_GBP number;    
begin
  -- вычисление общей задолженности с первичного отчета ПКБ
  -- принимает строку (пример: '343 098,00 KZT + 3 973,94 USD')
  -- 

select  c.curs_usd,c.curs_eur,c.curs_rur,c.curs_gbp
into n_curs_USD,n_curs_EUR, n_curs_RUR, n_curs_GBP 
from M_COURSES  c
where c.date_recount = in_date;


  -- удаляем пробелы двух видов, меняем , на . и добавляем + в начало и конец для удобства
  v_str_all := replace(replace(upper(in_str),' ',''),' ','');
  SELECT TO_CHAR(0, 'fmd') into sim FROM sys.dual;
  v_str_all := '+' || replace(replace(v_str_all,',',sim),'.',sim) || '+';
    for v_loop_count in 1 .. regexp_count(v_str_all,'[+]') - 1 loop

      v_str_begin_pos := instr(v_str_all,'+',1,v_loop_count) + 1;
      v_str := substr(v_str_all, v_str_begin_pos,
                         instr(v_str_all,'+',1,v_loop_count + 1) - v_str_begin_pos);

      -- курсы валют
      if length(regexp_substr(v_str,'[A-Z]+')) = 3
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'KZT',1,'USD',n_curs_USD,'EUR',n_curs_EUR,'GBP',n_curs_GBP,'RUB',n_curs_RUR,'RUR',n_curs_RUR,1)
          into v_cur_rate from dual;
      end if;
      if length(regexp_substr(v_str,'[A-Z]+')) = 2
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'KZ',1,'US',n_curs_USD,'EU',n_curs_EUR,'GB',n_curs_GBP,'RU',n_curs_RUR,'RU',n_curs_RUR,1)
          into v_cur_rate from dual;
      end if;
      if length(regexp_substr(v_str,'[A-Z]+')) = 1
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'K',1,'U',n_curs_USD,'E',n_curs_EUR,'G',n_curs_GBP,'R',n_curs_RUR,1)
          into v_cur_rate from dual;
      end if;

      v_result := v_result + to_number(regexp_substr(v_str,'[^A-Z]+')) * v_cur_rate;

  end loop;

return v_result;

  exception
    when others then
      log_error('get_pkb_debt_from_text', sqlcode, substr(sqlerrm||'-'||dbms_utility.format_error_backtrace,1,2000),null, null);
      return(null);
end get_pkb_debt_from_text;
/
grant execute on U1.GET_PKB_DEBT_FROM_TEXT to RISK_GKIM;


