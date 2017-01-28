create or replace force view u1.v_oper_monit_photo as
select"FIO","IIN","DATE_PHOTO","SUBJ_OPIN","MP","MP_OPIN","PROCESS","NOTE","COMMENTS","BL_VL" from T_OPER_MONIT_PHOTO_RDWH@rdboard;
grant select on U1.V_OPER_MONIT_PHOTO to LOADDB;


