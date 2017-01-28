create or replace procedure u1.ETLT_KASPIKZ_FRM_REGISTRATION
     is
        vStrDate date := sysdate;
        s_mview_name     varchar2(30) := 'T_KASPIKZ_FRM_REGISTRATION';
        n_max_id number;
        c    integer;
        nr   integer;
        v_id                    NUMBER;

        v_uri                   VARCHAR2(4000);
        v_hash                  VARCHAR2(4000);
        v_length_col            NUMBER;
        val  VARCHAR2(4000);
        id  number;
        cnt_mini_prof number;
        phone_number varchar2(100);
        reg_type number;
        cnt_sent_msg number;
        start_date date;
        ex_user_id number;
        is_otp_skipped number;
        is_otp_success number;
        date_otp_proc date;
        is_bd_skip number;
        is_bd_success number;
        pmp_iin varchar2(100);
        pmp_BirthDate date;
        pmp_RboId varchar2(100);
        pmp_RfoId varchar2(100);
        pmp_Siebel_Id varchar2(510);
        pmp_First_Name varchar2(510);
        pmp_Last_Name varchar2(510);
        pmp_Middle_Name varchar2(510);
        pmp_DocNumber varchar2(100);
        pmp_Email varchar2(510);
        Last_Action_Date date;
        Has_Authentic_Otp number;
        Has_Authentic_UserData number;
        Is_NewRegIstration number;
        Is_Reg_Products number;
        Is_Authentic_by_userdata number;
        Is_Authentic_by_otp number;
        mp_Has_Cards  number;
        mpHasWalletCards number;
        mpHasDepositAccounts  number;
        mpHasLoanAccounts  number;
        mpIin varchar2(100);
        mpRboId  varchar2(100);
        mpRfoId  varchar2(100);
        Is_Unq_BirthDate  number;
        Is_Empty_or_Dbl_BirthDate  number;
        registered_user_id number;
      begin
        select max(id) --6730013
       into n_max_id
       from T_KASPIKZ_FRM_REGISTRATION;


      c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@db_kr2;
      DBMS_HS_PASSTHROUGH.PARSE@db_kr2(c,
              'select t.Id ,
                     t.CountOfMiniProfiles,
                     t.PhoneNumber  ,
                     t.RegistrationType,
                     t.CountOfSentOtpMessages,
                     t.StartDateTimeOfRegistration,
                     t.ExistingUserId,
                     t.IsOtpStepSkipped ,
                     t.IsOtpStepSuccessfullyProcessed,
                     t.DateTimeOfOtpStepProcessing,
                     t.IsBirthDateStepSkipped ,
                     t.IsBirthDateStepSuccessfullyProcessed ,
                     t.pmpIin ,
                     t.pmpBirthDate,
                     t.pmpRboId ,
                     t.pmpRfoId ,
                     t.pmpSiebelId ,
                     cast(t.pmpFirstName as char(510)),
                     cast(t.pmpLastName as char(510)) ,
                     cast(t.pmpMiddleName as char(510)) ,
                     t.pmpDocNumber ,
                     t.pmpEmail ,
                     t.LastActionDateTime ,
                     t.HasAuthenticationByOtp ,
                     t.HasAuthenticationByUserData ,
                     t.IsNewRegistration ,
                     t.IsRegisteringOfUserWithoutProducts ,
                     t.IsRequiredAuthenticationByUserData ,
                     t.IsRequiredAuthenticationByOtp ,
                     t.mpHasCards,
                     t.mpHasWalletCards ,
                     t.mpHasDepositAccounts ,
                     t.mpHasLoanAccounts,
                     t.mpIin ,
                     t.mpRboId ,
                     t.mpRfoId,
                     t.apdIsThereProfileWithNotEmptyUniqueBirthDate ,
                     t.apdIsThereProfileWithEmptyOrDoubleBirthDate,
                     t.RegisteredUserId
              from dbo.tb_Framework_RegistrationData t
              where t.Id > '|| n_max_id);

    LOOP
    --    dbms_output.put_line('dd ');
    nr := DBMS_HS_PASSTHROUGH.FETCH_ROW@db_kr2(c);
    EXIT WHEN nr = 0;
    id := null;
    cnt_mini_prof := null;
    phone_number :=null;
    reg_type := null;
    cnt_sent_msg := null;
    start_date := null;
    ex_user_id := null;
    is_otp_skipped := null;
    is_otp_success := null;
    date_otp_proc := null;
    is_bd_skip := null;
    is_bd_success := null;
    pmp_iin :=null;
    pmp_BirthDate :=null;
    pmp_RboId :=null;
    pmp_RfoId :=null;
    pmp_Siebel_Id :=null;
    pmp_First_Name :=null;
    pmp_Last_Name :=null;
    pmp_Middle_Name :=null;
    pmp_DocNumber :=null;
    pmp_Email :=null;
    Last_Action_Date :=null;
    Has_Authentic_Otp :=null;
    Has_Authentic_UserData :=null;
    Is_NewRegIstration :=null;
    Is_Reg_Products :=null;
    Is_Authentic_by_userdata :=null;
    Is_Authentic_by_otp :=null;
    mp_Has_Cards  :=null;
    mpHasWalletCards :=null;
    mpHasDepositAccounts  :=null;
    mpHasLoanAccounts  :=null;
    mpIin :=null;
    mpRboId  :=null;
    mpRfoId  :=null;
    Is_Unq_BirthDate  :=null;
    Is_Empty_or_Dbl_BirthDate  :=null;
    registered_user_id := null;

      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,1,id);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,2,cnt_mini_prof);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,3,phone_number);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,4,reg_type);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,5,cnt_sent_msg);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,6,start_date);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,7,ex_user_id);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,8,is_otp_skipped);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,9,is_otp_success);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,10,date_otp_proc);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,11,is_bd_skip);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,12,is_bd_success);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,13,pmp_iin);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,14,pmp_birthdate);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,15,pmp_rboid);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,16,pmp_rfoid);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,17,pmp_siebel_id);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,18,pmp_first_name);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,19,pmp_last_name);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,20,pmp_middle_name);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,21,pmp_docnumber);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,22,pmp_email);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,23,last_action_date);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,24,has_authentic_otp);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,25,has_authentic_userdata);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,26,is_newregistration);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,27,is_reg_products);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,28,is_authentic_by_userdata);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,29,is_authentic_by_otp);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,30,mp_has_cards);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,31,mphaswalletcards);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,32,mphasdepositaccounts);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,33,mphasloanaccounts);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,34,mpiin);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,35,mprboid);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,36,mprfoid);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,37,is_unq_birthdate);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,38,is_empty_or_dbl_birthdate);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,39,registered_user_id);

       --       dbms_output.put_line('dd3 '  || id );
        insert/* append*/ into T_KASPIKZ_FRM_REGISTRATION(id,
                                                          cnt_mini_prof,
                                                          phone_number,
                                                          reg_type,
                                                          cnt_sent_msg,
                                                          start_date,
                                                          ex_user_id,
                                                          is_otp_skipped,
                                                          is_otp_success,
                                                          date_otp_proc,
                                                          is_bd_skip,
                                                          is_bd_success,
                                                          pmp_iin,
                                                          pmp_birthdate,
                                                          pmp_rboid,
                                                          pmp_rfoid,
                                                          pmp_siebel_id,
                                                          pmp_first_name,
                                                          pmp_last_name,
                                                          pmp_middle_name,
                                                          pmp_docnumber,
                                                          pmp_email,
                                                          last_action_date,
                                                          has_authentic_otp,
                                                          has_authentic_userdata,
                                                          is_newregistration,
                                                          is_reg_products,
                                                          is_authentic_by_userdata,
                                                          is_authentic_by_otp,
                                                          mp_has_cards,
                                                          mphaswalletcards,
                                                          mphasdepositaccounts,
                                                          mphasloanaccounts,
                                                          mpiin,
                                                          mprboid,
                                                          mprfoid,
                                                          is_unq_birthdate,
                                                          is_empty_or_dbl_birthdate,
                                                          registered_user_id
 )
        values ( id,
                  cnt_mini_prof,
                  phone_number,
                  reg_type,
                  cnt_sent_msg,
                  start_date,
                  ex_user_id,
                  is_otp_skipped,
                  is_otp_success,
                  date_otp_proc,
                  is_bd_skip,
                  is_bd_success,
                  pmp_iin,
                  pmp_birthdate,
                  pmp_rboid,
                  pmp_rfoid,
                  pmp_siebel_id,
                  rtrim(pmp_first_name),
                  rtrim(pmp_last_name),
                  rtrim(pmp_middle_name),
                  pmp_docnumber,
                  pmp_email,
                  last_action_date,
                  has_authentic_otp,
                  has_authentic_userdata,
                  is_newregistration,
                  is_reg_products,
                  is_authentic_by_userdata,
                  is_authentic_by_otp,
                  mp_has_cards,
                  mphaswalletcards,
                  mphasdepositaccounts,
                  mphasloanaccounts,
                  mpiin,
                  mprboid,
                  mprfoid,
                  is_unq_birthdate,
                  is_empty_or_dbl_birthdate,
                  registered_user_id
               );
     END LOOP;
      DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@db_kr2(c);
      commit;


    end ETLT_KASPIKZ_FRM_REGISTRATION ;
/

