create or replace force view u1.test_v_rfo_z#cm_checkpoint as
select t.id, t.class_id, t.c_way, t.c_point, t.c_users, t.c_history, t.c_work_type, t.c_flags, t.c_timers, t.state_id, t.c_create_user, (t.c_date_create+4) c_date_create, t.c_st_depart
    from V_RFO_Z#CM_CHECKPOINT t;
grant select on U1.TEST_V_RFO_Z#CM_CHECKPOINT to LOADDB;
grant select on U1.TEST_V_RFO_Z#CM_CHECKPOINT to LOADER;


