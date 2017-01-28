create or replace force view u1.v_folder_all_history as
select cp.id as folder_id,
       h.id as history_id,
       h.c_line_time as line_time,
       upper(l.c_name) as line_name,
       upper(p1.c_name) as point_from_name,
       upper(p2.c_name) as point_to_name,
       upper(u.c_name) as user_name,
       upper(c.c_value) as user_position,
       l.id as line_id,
       p1.id as point_from_id,
       p2.id as point_to_id,
       u.id as user_id,
       p1.c_code as point_from_code,
       p2.c_code as point_to_code
from V_RFO_Z#CM_CHECKPOINT cp
join V_RFO_Z#CM_HISTORY h on h.collection_id = cp.c_history
join V_RFO_Z#CM_LINE l on l.id = h.c_line
join V_RFO_Z#CM_POINT p1 on p1.id = l.c_from_p
join V_RFO_Z#CM_POINT p2 on p2.id = l.c_to_p
left join V_RFO_Z#USER u on u.id = h.c_user
left join V_RFO_Z#CASTA c on c.id = u.c_casta
--where cp.id = 22623784211 -- экт
--where cp.id = 22897261610 -- кн
--order by 2
;
grant select on U1.V_FOLDER_ALL_HISTORY to LOADDB;
grant select on U1.V_FOLDER_ALL_HISTORY to LOADER;


