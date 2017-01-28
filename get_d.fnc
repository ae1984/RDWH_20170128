create or replace function u1.Get_D  (  dIn      in date    :=  null  -- Заданная дата
        ,  cIn_Par    in varchar2  :=  null  -- Требования
        ,  nIn_Step  in number  :=  1    -- Шаг движения
        )
  return date
is
  dRet    date;
  nStep    number := 1;
begin

  nStep := nvl( nIn_Step, 1 );

  -- we.df( 'Get_D:: ENTER dIn:'|| to_char(dIn,'dd/mm/yyyy') );
  -- we.df( 'Get_D:: cIn_Par:'|| cIn_Par );
  -- we.df( 'Get_D:: nStep:'|| nStep );

  dRet := trunc( nvl( dIn, sysdate ) ) + nStep;
  -- we.df( 'Get_D:: dRet:'|| to_char(dRet,'dd/mm/yyyy') );

  loop
    if    cIn_Par is null
      or  cIn_Par like '%[D#%]%'  and instr( cIn_Par, '[D#'|| to_char(dRet,'d') ||']' ) > 0
    then
      exit;
    end if;
    dRet := dRet + nStep;
  end loop;

  -- we.df( 'Get_D:: RETURN dRet:'|| to_char(dRet,'dd/mm/yyyy') );

  return dRet;
end;
/

