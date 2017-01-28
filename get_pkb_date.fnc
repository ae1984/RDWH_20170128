create or replace function u1.Get_Pkb_Date return date is
     dSys date := trunc(sysdate);   -- Системная дата
     d4        date;                     -- Последний четверг предыдущего месяца
     d1        date;                     -- Понедельник, предшествующий последнему четвергу предыдущего месяца
     d5        date;                     -- Первая пятница текущего месяца
     dRet date;                     -- Возвращаемая дата
begin

     -- we.df( 'Get_Pkb_Date:: dSys:'|| to_char(dSys,'dd/mm/yyyy') );

     -- Получим первую пятницу текущего месяца ( исключая первое число )
     d5 := Get_D( add_months( last_day(dSys) + 2 ,-1 ), '[D#6]',  1 );
     -- we.df( 'Get_Pkb_Date:: d5:'|| to_char(d5,'dd/mm/yyyy') );

     -- Если системная дата больше d5
     if dSys > d5 then
          -- we.df( 'Get_Pkb_Date:: dSys > d5' );
          -- Получим последний четверг прошлого месяца
          d4 := Get_D( add_months( last_day(dSys) ,-1 ), '[D#5]', -1 );
          -- Получим понедельник, предшествующий последнему четвергу предыдущего месяца
          d1 := Get_D( d4, '[D#2]', -1 );
          -- we.df( 'Get_Pkb_Date:: d4:'|| to_char(d4,'dd/mm/yyyy') );
          -- we.df( 'Get_Pkb_Date:: d1:'|| to_char(d1,'dd/mm/yyyy') );
     else
          -- Получим последний четверг позапрошлого месяца
          d4 := Get_D( add_months( last_day(dSys) ,-2 ), '[D#5]', -1 );
          -- Получим понедельник, предшествующий последнему четвергу позапрошлого месяца
          d1 := Get_D( d4, '[D#2]', -1 );
          -- we.df( 'Get_Pkb_Date:: d4:'|| to_char(d4,'dd/mm/yyyy') );
          -- we.df( 'Get_Pkb_Date:: d1:'|| to_char(d1,'dd/mm/yyyy') );
     end if;

     dRet := d1;

     -- we.df( 'Get_Pkb_Date:: dRet:'|| to_char(dRet,'dd/mm/yyyy') );

     return dRet;
end;
/

