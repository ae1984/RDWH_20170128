create or replace procedure u1.ETLT_POPULATE_MO_REJECT
         is --T_MO_REJECT_PARAM
         s_mview_name     varchar2(30) := 'T_MO_REJECT_PARAM';
         vStrDate         date := sysdate;
        begin
          for r in (select distinct dp.code
                    from u1.V_MO_D_CALC dp
                    where (dp.code like 'C_MO_SCO_REJECT_PRE_%' or
                           dp.code = 'C_MO_SCO_REJECT_KN' or
                           dp.code = 'C_MO_SCO_REJECT' or
                           dp.code = 'C_SC_REJECT_KN' or
                           dp.code = 'C_MO_SCO_REJECT_81' or

                           dp.code = 'C_SC_AA_REJECT_PRE_2' or
                           dp.code = 'C_SC_AA_REJECT_PRE_22' or
                           dp.code = 'C_SC_AA_REJECT_PRE_9' or
                           dp.code = 'C_SC_AA_REJECT_PRE_17' or

                           dp.code = 'C_SC_AA_REJECT_POST_PRE_2' or
                           dp.code = 'C_SC_AA_REJECT_POST_PRE_22' or
                           dp.code = 'C_SC_AA_REJECT_POST_PRE_9' or
                           dp.code = 'C_SC_AA_REJECT_POST_PRE_17' or
                           
                           dp.code = 'C_PRSC_REJECT_PRE_81'
                           ))
          loop
            ETLT_POPULATE_MO_REJECT_PARAM(in_reject_code => r.code);
          end loop;

       end ETLT_POPULATE_MO_REJECT;
/

