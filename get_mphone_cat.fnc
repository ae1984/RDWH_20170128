create or replace function u1.GET_MPHONE_CAT(phoneNumb in varchar2, catType in number) return number
as
fNumb        varchar2(7);
numb         varchar2(7);
res          number default 0;
repeat_count number;

begin
---------------------------------------------------------------------------
-- Функция анализа цифровой особенности номера сотового телефона клиента --
---------------------------------------------------------------------------
case
     when regexp_like(phoneNumb, '^[0-9]{11}$')    then fNumb := substr(phoneNumb,5,7);
     when regexp_like(phoneNumb, '^[+][0-9]{10}$') then fNumb := substr(phoneNumb,5,7);
     when regexp_like(phoneNumb, '^[+][0-9]{11}$') then fNumb := substr(phoneNumb,6,7);
     when regexp_like(phoneNumb, '^[0-9]{10}$')    then fNumb := substr(phoneNumb,4,7);
     when regexp_like(phoneNumb, '^[0-9]{11}[ ]')  then fNumb := substr(phoneNumb,5,7);
     else null;
   end case;
if fNumb is not null then
  case
      --Check1 3 повторения и более
      when catType = 1 then
                        begin
                          for i in 1..length(fNumb) loop
                            numb := substr(fNumb,i,1);
                            repeat_count := 1;

                            if numb <> ' ' then
                               repeat_count := regexp_count(fNumb, numb);
                               fNumb := replace(fNumb, numb, ' ');
                            end if;

                            if repeat_count >= 3 then res := res + 1; end if;
                          end loop;
                        end;
       --Check2 2 и более повторения двузначных чисел
       when catType = 2 then
                        begin
                          for i in 1..2 loop
                            numb := substr(fNumb,i*2,2);
                            repeat_count := 0;

                            repeat_count := regexp_count(substr(fNumb,i*2+2,2), numb);

                            if repeat_count >=1 then res := res + 1; end if;

                          end loop;
                        end;
       --Check3 2 два зеркальных  двузначных чисела отличающихся на 11. Пример 55 66
       when catType = 3 then
                        begin
                          for i in 1..2 loop
                            numb := substr(fNumb,i*2,2);
                            repeat_count := 0;

                            if substr(numb,1,1) = substr(numb,2,1) then
                               repeat_count := regexp_count(substr(fNumb,i*2+2,2)-11, numb) || regexp_count(substr(fNumb,i*2+2,2)+11, numb);
                            end if;

                            if repeat_count >=1 then res := res + 1; end if;
                          end loop;
                        end;
       --Check4 2 два зеркальных двузначных чисела. Пример 44 99
       when catType = 4 then
                        begin
                           for i in 1..2 loop
                              numb := substr(fNumb,i*2,2);

                              if substr(numb,1,1) = substr(numb,2,1) and substr(fNumb,i*2+2,1) = substr(fNumb,i*2+3,1) then

                                 res := res + 1;

                              end if;


                            end loop;
                        end;
       --Check5 2 двузначных чисела в одной десятке. Пример 25 29
       when catType = 5 then
                        begin
                          for i in 1..2 loop
                            numb := substr(fNumb,i*2,2);

                            if substr(numb,1,1) = substr(fNumb,i*2+2,1) then

                               res := res + 1;

                            end if;

                          end loop;
                        end;
       --Check6 цифры по порядку
       when catType = 6 then
                        begin
                          for i in 1..5 loop
                          repeat_count := 0;
                          numb := substr(fNumb,i,1);

                          case when substr(fNumb,i,1)+1 = substr(fNumb,i+1,1) and substr(fNumb,i,1)+2 = substr(fNumb,i+2,1)
                                    then res := res + 1;
                               when substr(fNumb,i,1)-1 = substr(fNumb,i+1,1) and substr(fNumb,i,1)-2 = substr(fNumb,i+2,1)
                                    then res := res + 1;
                            else null;
                          end case;

                        end loop;
                        end;
       else null;
  end case;

end if;

return res;

end;
/

