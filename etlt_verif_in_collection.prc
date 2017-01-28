create or replace procedure u1.ETLT_VERIF_IN_COLLECTION
     is
       s_mview_name     varchar2(30) := 'T_VERIF_IN_COLLECTION';
       vStrDate         date := sysdate;
       v_max_id         number;
     begin
        select max(t.id) into v_max_id from T_VERIF_IN_COLLECTION t;

        insert /*+ append */ into T_VERIF_IN_COLLECTION --34сек
        select /*+ driving_site*/ 
              ID
              ,IS_COPIED
              ,PORTITION_DATE
              ,CLIENT_ID
              ,VERIFICATION_ID
              ,FOLDERS_ID
              ,FOLDERS_DATE
              ,LAST_NAME
              ,FIRST_NAME
              ,SUR_NAME
              ,IIN
              ,DATE_BIRTH
              ,ADR_REG_POST_IND
              ,ADR_REG_STREET
              ,ADR_REG_HOUSE
              ,ADR_REG_FRAME
              ,ADR_REG_FLAT
              ,ADR_REG_DATE_BEGIN
              ,ADR_REG_REGION
              ,ADR_REG_DISTRICT
              ,ADR_REG_PLACE
              ,ADR_FACT_POST_IND
              ,ADR_FACT_STREET
              ,ADR_FACT_HOUSE
              ,ADR_FACT_FRAME
              ,ADR_FACT_FLAT
              ,ADR_FACT_DATE_BEGIN
              ,ADR_FACT_REGION
              ,ADR_FACT_DISTRICT
              ,ADR_FACT_PLACE
              ,ORG_NAME
              ,ORG_CASTA
              ,ORG_STAZH_DATE
              ,ORG_DEP
              ,VERIFY_CONTACTS_ARR
              ,VERIFY_IMAGES_ARR
              ,BRANCH_MANAGER
              ,VERIFY_STATUS
              ,VERIFY_GROUP
              ,VERIFY_PR_CR
              ,PKB_IS_EMPTY
              ,DATE_LAST_EDIT
              ,DATE_CREATE
              ,NEED_VERIFY_CONT
              ,NEED_VERIFY_MODIFIED_DATA
              ,ONLY_CONTACT
              ,DOC_DATE_END
              ,DOC_DATE_ISSUE
              ,DOC_NUM
              ,DOC_WHO
              ,PLACE_BIRTH
              ,POINT_TYPE
        from verificator.in_collection@verifais t
        where t.id > v_max_id;
        commit;

     end ETLT_VERIF_IN_COLLECTION;
/

