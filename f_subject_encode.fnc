create or replace function u1.F_SUBJECT_ENCODE(p_subject_str varchar2)
return varchar2
  -- Функция для перекодировки заголовка письма в utf-8
AS
 v_a varchar2(1000);
 v_b varchar2(24 char);
 v_result varchar2(4000);
begin
  v_a := p_subject_str;
 
  WHILE length(v_a) > 24
  LOOP
    v_b := SUBSTR(v_a, 1, 24);
    v_a := SUBSTR(v_a, 25);
    v_result :=
      v_result || '=?UTF-8?B?'
      || UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw(CONVERT(v_b, 'utf8'))))
      || '?=';
  END LOOP;
 
  IF length(v_a) > 0 THEN
    v_result :=
      v_result || '=?UTF-8?B?'
      || UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw(CONVERT(v_a, 'utf8'))))
      || '?=';
  END IF;
 
  RETURN v_result;
end;
/

