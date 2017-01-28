create or replace function u1.check_iin(in_iin varchar2) return number is
  Result number := 0;

  v_sum number := 0;
begin
  begin
    if (not in_iin is null and length(trim(in_iin)) = 12) then
      for i in 1..length(in_iin)-1 loop
        v_sum := v_sum + (to_number(substr(in_iin, i, 1))*i);
      end loop;
      
      result := mod(v_sum, 11);
      
      if (result >= 10) then
        v_sum := 0;
        for i in 1..length(in_iin)-1 loop
          if (i < 10) then
             v_sum := v_sum + (to_number(substr(in_iin, i, 1))*(i+2));
          else 
             v_sum := v_sum + (to_number(substr(in_iin, i, 1))*(i-9));
          end if;
        end loop;
        
        result := mod(v_sum, 11);
      end if;
      
     
      if (result > 9) then
        return -1;
      else 
        if (result = to_number(substr(in_iin, 12,1))) then
          return 1;
        else
          return 0;
        end if;
      end if;
    end if;
  exception when others then
    log_trace(in_operation => 'check_iin, ' || in_iin, in_error_code => sqlcode, in_error_message => sqlerrm);
  end;

  return -1;
end check_iin;
/

