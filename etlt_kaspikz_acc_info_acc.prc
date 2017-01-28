create or replace procedure u1.ETLT_KASPIKZ_ACC_INFO_ACC
 is
 vStrDate date := sysdate;
 s_mview_name     varchar2(30) := 'T_KASPIKZ_ACC_INFO_ACC';
 d_src_commit_date_load date;
 d_src_commit_date_last date;
  begin
      select max(src_commit_date)
        into d_src_commit_date_load
        from s37.s$tb_AccountInfo_Accounts@rdwh_exd;

      select last_date-10/24/60/60
        into d_src_commit_date_last
        from t_rdwh_increment_tables_load
       where object_name = 'T_KASPIKZ_ACC_INFO_ACC';

        delete from T_KASPIKZ_ACC_INFO_ACC
         where id in (select distinct bintid
                        from s37.s$tb_AccountInfo_Accounts@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);

        insert into T_KASPIKZ_ACC_INFO_ACC
        select bintid,
               bintuserid,
               intsimpleid,
               vchbranch,
               vchbankid,
               vchbanknumber,
               vchname,
               dcmbalance,
               vchcurrency,
               vchaccounttype,
               cast(substr(vchextendedinfo,1,2000) as varchar2(2000 char))  as vchextendedinfo,
               dtlastupdate,
               bitisclosed,
               bitisblocked,
               bitisvisible,
               bitisactive,
               bitnameischanged
        from s37.tb_AccountInfo_Accounts@rdwh_exd
        where bintid in (select distinct bintid
                        from s37.s$tb_AccountInfo_Accounts@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        commit;
        --сохраняем информацию о послeдней загрузке
        update t_rdwh_increment_tables_load
           set last_date = d_src_commit_date_load
         where object_name = s_mview_name;
        commit;


 end ETLT_KASPIKZ_ACC_INFO_ACC;
/

