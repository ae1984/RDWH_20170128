create or replace procedure u1.ETLT_RFO_KAS_ONL_CLAIM_CANCEL is
    s_mview_name varchar2(30) := 'T_RFO_KAS_ONLINE_CLAIM_CANCEL';
    vStrDate date := sysdate;
    n_claim_id_max number;
    v_exec_txt varchar2(4000);
    V_FULL_TXT varchar2(4000);
    V_FULL_TXT_REG varchar2(4000);
    V_RULE varchar2(1000);
    V_RULE_RESULT varchar2(1000);
  BEGIN
    select max(claim_id)
      into n_claim_id_max
    from T_RFO_KAS_ONLINE_CLAIM_CANCEL c;
    --Created on 20/03/2015 by KIM_17004

    for r in (select t.id, t.c_exec_comment
              from V_RFO_Z#KAS_ONLINE_CLAIM t
              where t.id> n_claim_id_max
              )
    loop
      v_exec_txt := r.c_exec_comment || ';';
      for rr in ( SELECT regexp_substr(v_exec_txt, '[^;]+', 1, level) str --распарсиваем до ;  т е получаем строки с результатами каждой проверки
                  FROM (SELECT v_exec_txt str FROM dual) t
                        CONNECT BY regexp_instr(str, ';', 1, level) > 0)
      loop
        V_FULL_TXT := trim(substr(rr.str, 1, 4000));
        V_FULL_TXT_REG := V_FULL_TXT || ':' ;
        for r3 in (SELECT regexp_substr(V_FULL_TXT_REG, '[^:]+', 1, level) str, level lv --разбираем до :
                  FROM (SELECT V_FULL_TXT_REG str FROM dual) t
                        CONNECT BY regexp_instr(str, ':', 1, level) > 0)
        loop
          if (r3.lv = 1) then
            V_RULE := trim(substr(r3.str, 1, 1000));  --получаем точку проверки
          elsif (r3.lv = 2) then
            begin
              V_RULE_RESULT := trim(substr(coalesce(r3.str, ''), 1, 1000));  --получаем результат- ОК или ошибка
            exception when others then
              V_RULE_RESULT := '';
            end;
          end if;
        end loop;
        if (regexp_count(V_RULE, '(\[.*?\])') > 0) then  -- данные в квадратных скобках тоже разделяем
          for r4 in (SELECT regexp_substr(V_RULE, '(\[.*?\])', 1, level) str, level lv
                    FROM (SELECT V_RULE str FROM dual) t
                          CONNECT BY regexp_instr(str, '(\[.*?\])', 1, level) > 0)
          loop
            V_FULL_TXT := '';
            V_FULL_TXT_REG := '';
            V_RULE := '';
            V_RULE_RESULT := '';
            V_FULL_TXT := trim(substr(r4.str, 1, 4000));
            V_FULL_TXT_REG := regexp_replace(regexp_replace(V_FULL_TXT, '\[', ''), '\]', '') || '#' ;
            for r5 in (SELECT regexp_substr(V_FULL_TXT_REG, '[^#]+', 1, level) str, level lv
                        FROM (
                               SELECT V_FULL_TXT_REG str FROM dual) t
                               CONNECT BY regexp_instr(str, '#', 1, level) > 0)
            loop
              if (r5.lv = 1) then
                V_RULE := trim(substr(r5.str, 1, 1000));
              elsif (r5.lv = 2) then
                V_RULE_RESULT := trim(substr(r5.str, 1, 1000));
              end if;
            end loop;

            insert into T_RFO_KAS_ONLINE_CLAIM_CANCEL (ID, CLAIM_ID, RULE, RULE_RESULT, FULL_TXT)
            values (SQ_RFO_KAS_ONLINE_CLAIM_CANCEL.NEXTVAL, r.id, V_RULE, V_RULE_RESULT, V_FULL_TXT);
          end loop;
        -- Отказ при проверке блока "Прескоринг ПКБ отчета"
        -- Отказ при проверке блока "Прескоринг анкетных данных". 1
        elsif (regexp_count(V_RULE_RESULT, '(\[.*?\])') > 0) then
          insert into T_RFO_KAS_ONLINE_CLAIM_CANCEL (ID, CLAIM_ID, RULE, RULE_RESULT, FULL_TXT)
          values (SQ_RFO_KAS_ONLINE_CLAIM_CANCEL.NEXTVAL, r.id, V_RULE, V_RULE_RESULT, V_FULL_TXT);

          for r42 in (SELECT regexp_substr(V_RULE_RESULT, '(\[.*?\])', 1, level) str, level lv
                    FROM (SELECT V_RULE_RESULT str FROM dual) t
                          CONNECT BY regexp_instr(str, '(\[.*?\])', 1, level) > 0)
          loop
            V_FULL_TXT := '';
            V_FULL_TXT_REG := '';
            V_RULE := '';
            V_RULE_RESULT := '';

            V_FULL_TXT := trim(substr(r42.str, 1, 4000));
            V_FULL_TXT_REG := regexp_replace(regexp_replace(V_FULL_TXT, '\[', ''), '\]', '') || '#' ;
            for r52 in (SELECT regexp_substr(V_FULL_TXT_REG, '[^#]+', 1, level) str, level lv
                        FROM (
                               SELECT V_FULL_TXT_REG str FROM dual) t
                               CONNECT BY regexp_instr(str, '#', 1, level) > 0)
            loop
              if (r52.lv = 1) then
                V_RULE := trim(substr(r52.str, 1, 1000));
              elsif (r52.lv = 2) then
                V_RULE_RESULT := trim(substr(r52.str, 1, 1000));
              end if;
            end loop;

            insert into T_RFO_KAS_ONLINE_CLAIM_CANCEL (ID, CLAIM_ID, RULE, RULE_RESULT, FULL_TXT)
            values (SQ_RFO_KAS_ONLINE_CLAIM_CANCEL.NEXTVAL, r.id, V_RULE, V_RULE_RESULT, V_FULL_TXT);
          end loop;

        else
          insert into T_RFO_KAS_ONLINE_CLAIM_CANCEL (ID, CLAIM_ID, RULE, RULE_RESULT, FULL_TXT)
          values (SQ_RFO_KAS_ONLINE_CLAIM_CANCEL.NEXTVAL, r.id, V_RULE, V_RULE_RESULT, V_FULL_TXT);
        end if;

        V_FULL_TXT := '';
        V_FULL_TXT_REG := '';
        V_RULE := '';
        V_RULE_RESULT := '';
      end loop;

      commit;
    end loop;

    end ETLT_RFO_KAS_ONL_CLAIM_CANCEL;
/

