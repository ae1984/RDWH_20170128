create or replace force view u1.v_client_rfo_empl as
select distinct c.rfo_client_id, c.iin, c.rnn, c.name_last, c.name_first, c.name_patronymic, c.birth_date,
       t.c_username as login, t.c_name as user_name, t.c_empl, t.c_kas_date_inhand as date_start
from V_RFO_Z#USER t
join V_CLIENT_RFO_BY_ID c on c.rfo_client_id = t.c_empl;
grant select on U1.V_CLIENT_RFO_EMPL to LOADDB;
grant select on U1.V_CLIENT_RFO_EMPL to LOADER;


