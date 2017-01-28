create or replace function u1.get_pkb_debt_from_text_test(
          in_str in varchar2,
          dat in date
          ) return number is
  v_str_all varchar2(500);
  v_str varchar2(50);
  v_str_begin_pos number;
  v_cur_rate number;
  v_result number := 0;
  sim varchar(5);
begin
  -- вычисление общей задолженности с первичного отчета ПКБ
  -- принимает строку (пример: '343 098,00 KZT + 3 973,94 USD')

  -- удаляем пробелы двух видов, меняем , на . и добавляем + в начало и конец для удобства
  v_str_all := replace(replace(upper(in_str),' ',''),' ','');
  SELECT TO_CHAR(0, 'fmd') into sim FROM sys.dual;
  v_str_all := '+' || replace(replace(v_str_all,',',sim),'.',sim) || '+';
    for v_loop_count in 1 .. regexp_count(v_str_all,'[+]') - 1 loop

      v_str_begin_pos := instr(v_str_all,'+',1,v_loop_count) + 1;
      v_str := substr(v_str_all, v_str_begin_pos,
                         instr(v_str_all,'+',1,v_loop_count + 1) - v_str_begin_pos);

      -- курсы валют
  if dat < to_date('01.01.2013','dd.mm.yyyy') then
      if length(regexp_substr(v_str,'[A-Z]+')) = 3
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'KZT',1,'USD',149,'EUR',184,'GBP',230,'RUB',4.6,'RUR',4.6,1)
          into v_cur_rate from dual;
      elsif length(regexp_substr(v_str,'[A-Z]+')) = 2
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'KZ',1,'US',149,'EU',184,'GB',230,'RU',4.6,1)
          into v_cur_rate from dual;
      elsif length(regexp_substr(v_str,'[A-Z]+')) = 1
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'K',1,'U',149,'E',184,'G',230,'R',4.6,1)
          into v_cur_rate from dual;
      end if;
  elsif dat >= to_date('01.01.2013','dd.mm.yyyy') and dat < to_date('01.01.2014','dd.mm.yyyy') then
      if length(regexp_substr(v_str,'[A-Z]+')) = 3
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'KZT',1,'USD',150,'EUR',200,'GBP',230,'RUB',4.6,'RUR',4.6,1)
          into v_cur_rate from dual;
      elsif length(regexp_substr(v_str,'[A-Z]+')) = 2
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'KZ',1,'US',150,'EU',200,'GB',230,'RU',4.6,1)
          into v_cur_rate from dual;
      elsif length(regexp_substr(v_str,'[A-Z]+')) = 1
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'K',1,'U',150,'E',200,'G',230,'R',4.6,1)
          into v_cur_rate from dual;
      end if;
  elsif dat >= to_date('01.01.2014','dd.mm.yyyy') and dat < to_date('11.02.2014','dd.mm.yyyy') then
      if length(regexp_substr(v_str,'[A-Z]+')) = 3
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'KZT',1,'USD',154,'EUR',211,'GBP',230,'RUB',4.6,'RUR',4.6,1)
          into v_cur_rate from dual;
      elsif length(regexp_substr(v_str,'[A-Z]+')) = 2
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'KZ',1,'US',154,'EU',211,'GB',230,'RU',4.6,1)
          into v_cur_rate from dual;
      elsif length(regexp_substr(v_str,'[A-Z]+')) = 1
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'K',1,'U',154,'E',211,'G',230,'R',4.6,1)
          into v_cur_rate from dual;
      end if;
  elsif dat >= to_date('11.02.2014','dd.mm.yyyy') then
      if length(regexp_substr(v_str,'[A-Z]+')) = 3
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'KZT',1,'USD',183,'EUR',250,'GBP',230,'RUB',5.3,'RUR',5.3,1)
          into v_cur_rate from dual;
      elsif length(regexp_substr(v_str,'[A-Z]+')) = 2
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'KZ',1,'US',183,'EU',250,'GB',230,'RU',5.3,1)
          into v_cur_rate from dual;
      elsif length(regexp_substr(v_str,'[A-Z]+')) = 1
      then
          select decode(regexp_substr(v_str,'[A-Z]+'),
             'K',1,'U',183,'E',250,'G',230,'R',5.3,1)
          into v_cur_rate from dual;
      end if;
   end if;

      v_result := v_result + to_number(regexp_substr(v_str,'[^A-Z]+')) * v_cur_rate;

  end loop;

return v_result;

  exception
    when others then
--      log_error('get_pkb_debt_from_text', sqlcode, sqlerrm, pMV_Name, null);
      return(null);
end get_pkb_debt_from_text_test;
/

