create or replace force view u1.v_luna_result as
select "SIMILARITY","RFO_CLIENT_ID","LUNA_ID","RFO_CLIENT_ID2","LUNA_ID2" from u1.t_luna_result_1
            union all
            select "SIMILARITY","RFO_CLIENT_ID","LUNA_ID","RFO_CLIENT_ID2","LUNA_ID2" from u1.t_luna_result_2
            union all
            select "SIMILARITY","RFO_CLIENT_ID","LUNA_ID","RFO_CLIENT_ID2","LUNA_ID2" from u1.t_luna_result_3
            union all
            select "SIMILARITY","RFO_CLIENT_ID","LUNA_ID","RFO_CLIENT_ID2","LUNA_ID2" from u1.t_luna_result_4
            union all
            select "SIMILARITY","RFO_CLIENT_ID","LUNA_ID","RFO_CLIENT_ID2","LUNA_ID2" from u1.t_luna_result_6;
grant select on U1.V_LUNA_RESULT to LOADDB;
grant select on U1.V_LUNA_RESULT to LOADER;


