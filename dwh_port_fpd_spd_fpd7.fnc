create or replace function u1.dwh_port_fpd_spd_fpd7 return dwh_port_fpd_spd_fpd7List pipelined as
  weekends date;
  days integer;
  fpd date;
  spd date;
  fpd7 date;
  sales_num number;
  fpd_num number;
  spd_num number;
  fpd7_num number;
  fpd60_num number;
  fpd60 date;
begin          -- Заполняем неявный курсор данными
  for info in (select /*+parallel(1)*/ * from V_DWH_PORT_FPD_SPD_FPD7_PRE1
               /*select \*+ parallel(30) *\ add_months(t.start_date,+1) as fpd, t.rep_date,
                  t.START_DATE, t.DELINQ_DAYS, sum(t.TOTAL_DEBT) as debt,
                   count(distinct t.CLIENT_ID) as count_client,
                   count(distinct t.deal_number) as count_deal_number
                   from v_DWH_PORT t
                   left join v_dwh_port_cards_credits c on c.deal_number = t.DEAL_NUMBER
                   where t.START_DATE > to_date('01.08.2013','dd.mm.yyyy') and (t.prod_type <> 'РЕФИНАНСИРОВАНИЕ/РЕСТРУКТУРИЗАЦИЯ' or c.prod_name is null)
                   group by t.rep_date, t.START_DATE, t.DELINQ_DAYS*/
                 ) loop
       -- обнуляем ВСЕ!!!!  и идем по циклу до конца курсора
       weekends := null;
       days := null;
       fpd := null;
       spd := null;
       fpd7 := null;
       fpd60 := null;
       sales_num := null;
       fpd_num := null;
       spd_num := null;
       fpd7_num := null;
       fpd60_num := null;
       --блок получения верного дня первого платежа ( FPD )
       --Тут смотрим выходные дни в честь праздника. Выпал ли день первого платежа на какой либо праздник или рабочий день в воскресенье или субботу
         -- Если выпал ставим дату этого праздника, если нет, то левую дату, к примеру 01.01.2000
       select nvl(max(we.data),to_date('01.01.2000','dd.mm.yyyy')) into weekends from T_HOLIDAYS we where we.data = info.fpd;
       -- тут получаем кол-во дней выходных если дата первого платежа выпала на праздник.
       select nvl(max(we.day_weekends),0) into days from T_HOLIDAYS we where we.data = info.fpd;
       -- смотрим, нашли ли мы праздник
       if weekends > to_date('01.01.2001','dd.mm.yyyy') then
         begin
         -- если есть праздник или рабочий день в субботу или воскресенье, то к fpd прибавляем кол во дней выходных
           -- если рабочий день в субботу или воскресенье, то days будет равным 0
         fpd := info.fpd+days;
         end;
         else
         fpd := info.fpd;

       end if;
       --FPD end
       --все, верный FPD мы получили
       -- теперь получаем spd и fpd7
       spd:= fpd + 30;
       fpd60:= fpd + 60;
       fpd7 := fpd + 7;
       -- ставим метку, если дата отчета равна дате начала действия договора
       if info.rep_date = info.start_date
         then sales_num := 1;
         else sales_num := 0;
       end if;
       -- ставим метку, если дата отчета равна дате первого платежа договора и просрочка больше 0, тоесть клиент не заплатил еще
       if (info.rep_date = fpd) and (info.delinq_days>0)
         then fpd_num := 1;
         else fpd_num := 0;
       end if;
       -- ставим метку, если дата отчета равна дате первого платежа договора + 30 дней и просрочка больше 15 дней, тоесть клиент уже второй платеж не оплатил
       if (info.rep_date = spd) and (info.delinq_days>15)
         then spd_num := 1;
         else spd_num := 0;
       end if;

       if (info.rep_date = fpd60) and (info.delinq_days>45)
         then fpd60_num := 1;
         else fpd60_num := 0;
       end if;
       -- ставим метку, если дата отчета равна дате первого платежа договора + 7 дней и просрочка больше 0 дней, тоесть клиент просрочил первый платеж
         --и в течение недели не оплатил
       if (info.rep_date = fpd7) and (info.delinq_days>0)
         then fpd7_num := 1;
         else fpd7_num := 0;
       end if;
       -- заполняем объект данными. по сути мы циклом заполняем таблицу и потом выдаем ее как переменную в результат функции
       pipe row (dwh_port_fpd_spd_fpd7Object(info.rep_date,info.start_date,info.delinq_days,info.debt,info.count_client,info.count_deal_number,fpd,fpd7,spd,fpd60,sales_num,fpd_num,fpd7_num,spd_num,fpd60_num));
  end loop;
  return;
end dwh_port_fpd_spd_fpd7;
/

