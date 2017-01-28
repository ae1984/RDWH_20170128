create or replace procedure u1.ETLT_RFO_CL_PRIV is
   s_mview_name     varchar2(30) := 'T_RFO_Z#CL_PRIV';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

  begin
    --дата необходима для логирования времени инсерта
    d_date_start_ins := sysdate;
    select max(src_commit_date)-5/24/60/60
      into d_src_commit_date_load
      from s01.s$Z#CL_PRIV@rdwh_exd;
    select last_date
      into d_src_commit_date_last
      from t_rdwh_increment_tables_load
     where object_name = 'T_RFO_Z#CL_PRIV';
    --
    delete from T_RFO_Z#CL_PRIV
     where id in (select distinct id
                    from s01.s$Z#CL_PRIV@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    insert into T_RFO_Z#CL_PRIV
    select id,
           c_date_pers,
           c_sex#0,
           c_sex#male,
           c_sex#female,
           c_certificates,
           c_pasport#type,
           c_pasport#num,
           c_pasport#seria,
           translate(upper(c_pasport#who),
                     chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                     chr(53390)||chr(53380)||chr(53381),
                     chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                     chr(53936)||chr(53906)||chr(53922)) as
                     c_pasport#who,
           c_pasport#date_doc,
           translate(upper(c_pasport#place),
                     chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                     chr(53390)||chr(53380)||chr(53381),
                     chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                     chr(53936)||chr(53906)||chr(53922)) as
                     c_pasport#place,
           c_pasport#date_end,
           translate(upper(c_last_name),
                chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                chr(53390)||chr(53380)||chr(53381),
                chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                chr(53936)||chr(53906)||chr(53922)) as
                c_last_name,
           translate(upper(c_first_name),
                chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                chr(53390)||chr(53380)||chr(53381),
                chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                chr(53936)||chr(53906)||chr(53922)) as
           c_first_name,
                translate(upper(c_sur_name),
                chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                chr(53390)||chr(53380)||chr(53381),
                chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                chr(53936)||chr(53906)||chr(53922)) as
                c_sur_name,
           c_add_props,
           translate(upper(c_work#org#name),
                chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                chr(53390)||chr(53380)||chr(53381),
                chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                chr(53936)||chr(53906)||chr(53922)) as
                c_work#org#name,
           c_work#org#rnn,
           c_work#org#address#post_ind,
           translate(upper(c_work#org#address#place),
                chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                chr(53390)||chr(53380)||chr(53381),
                chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                chr(53936)||chr(53906)||chr(53922)) as
                c_work#org#address#place,
           c_work#org#address#adr_type,
           c_work#org#address#date_begin,
           c_work#org#address#date_end,
           c_work#org#address#house,
           c_work#org#address#frame,
           c_work#org#address#flat,
           translate(upper(c_work#org#address#street),
                chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                chr(53390)||chr(53380)||chr(53381),
                chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                chr(53936)||chr(53906)||chr(53922)) as
                c_work#org#address#street,
           translate(upper(c_work#org#address#region),
                chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                chr(53390)||chr(53380)||chr(53381),
                chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                chr(53936)||chr(53906)||chr(53922)) as
                c_work#org#address#region,
           c_work#org#address#district,
           c_work#org#add_props,
           c_work#prev_exp,
           c_work#month_profit,
           c_work#add_props,
           c_work#org#address#region_ref,
--  C_K#ORG#ADDRESS#DISTRICT_REF31
           c_resident,
           translate(upper(c_work#department),
                chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                chr(53390)||chr(53380)||chr(53381),
                chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                chr(53936)||chr(53906)||chr(53922)) as
                c_work#department,
           c_client_categ,
           c_pasport#depart_code,
           c_work#org#address#city,
           translate(upper(c_place_birth),
                chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                chr(53390)||chr(53380)||chr(53381),
                chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                chr(53936)||chr(53906)||chr(53922)) as
                c_place_birth,
           c_work#org#address#place_ref,
           c_work#org#address#country
      from s01.Z#CL_PRIV@rdwh_exd t
     where id in (select distinct id
                    from s01.s$Z#CL_PRIV@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    commit;
    --сохраняем информацию о послeдней загрузке
    update t_rdwh_increment_tables_load
       set last_date = d_src_commit_date_load
     where object_name = 'T_RFO_Z#CL_PRIV';
    commit;

 end ETLT_RFO_CL_PRIV;
   --
/

