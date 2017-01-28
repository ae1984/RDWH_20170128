create or replace function u1.check_iin_ex(in_iin varchar2, in_birthdate date, in_sex varchar2) return number is
  chk_sex number;
  tmp_sex varchar2(32 char);
begin
  
  tmp_sex := trim(upper(in_sex));
  
  if check_iin(in_iin) <> 1 then
    Return(0);
  end if;
  
  if (trunc(in_birthdate) <> get_birth_date_from_iin(in_iin)) or (trunc(in_birthdate) is null) then
    return 0;
  end if;
  
  case 
    when (tmp_sex='M'/*ale*/) OR (tmp_sex='М'/*ужской*/) OR (tmp_sex='1') OR (tmp_sex='МУЖСКОЙ') then chk_sex := 1;
    when (tmp_sex='F')        OR (tmp_sex='Ж')           OR (tmp_sex='2') OR (tmp_sex='ЖЕНСКИЙ') then chk_sex := 2;  
    else                                                                                              chk_sex := 3;
  end case;  
  
  if chk_sex = 1 then
    if 
      ((in_birthdate <  date '2000-01-01') AND (substr(in_iin,7,1) <> '3')) OR
      ((in_birthdate >= date '2000-01-01') AND (substr(in_iin,7,1) <> '5'))
    then return 0;
    end if;
  end if;
  
  if chk_sex = 2 then
    if 
      ((in_birthdate <  date '2000-01-01') AND (substr(in_iin,7,1) <> '4')) OR
      ((in_birthdate >= date '2000-01-01') AND (substr(in_iin,7,1) <> '6'))
    then return 0;
    end if;
  end if;
  
  return(1);
end check_iin_ex;
/

