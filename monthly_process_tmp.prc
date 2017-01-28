create or replace procedure u1.MONTHLY_PROCESS_TMP is
begin

    begin

      --execute immediate 'alter materialized view V_ORG_GCVP compile';
      --execute immediate 'alter materialized view V_ORG_CAL compile';
      --execute immediate 'alter materialized view V_CONTRACT_EKT compile';
      --execute immediate 'alter materialized view V_CONTRACT_EKT compile';
      --execute immediate 'alter materialized view V_CONTRACT_FOLDER_ALL_LINK_RFO compile';
      --execute immediate 'alter materialized view M_FOLDER_CON_MINER_1 compile';---
      --execute immediate 'alter materialized view M_FOLDER_CON_MINER_2 compile';---
      --execute immediate 'alter materialized view M_FOLDER_CON_MINER_3 compile';---
      --execute immediate 'alter materialized view M_FOLDER_CON_MINER_4 compile';---
      execute immediate 'alter materialized view M_FOLDER_CON_MINER compile';
      --execute immediate 'alter materialized view M_FOLDER_CON_MINER_3 compile';
      --execute immediate 'alter materialized view M_FOLDER_CON_MINER_4 compile';
      --execute immediate 'alter materialized view V_CLIENT_HISTORY compile';
      --execute immediate 'alter materialized view V_PORTFOLIO compile';

    exception
      when others then
        null;
    end;


    --dbms_mview.refresh(list => 'V_ORG_GCVP', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'V_ORG_CAL', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'V_CONTRACT_EKT', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'V_CONTRACT_EKT', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'V_CONTRACT_FOLDER_ALL_LINK_RFO', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'M_FOLDER_CON_MINER_1', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'M_FOLDER_CON_MINER_2', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'M_FOLDER_CON_MINER_3', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'M_FOLDER_CON_MINER_4', method => 'C', parallelism => 30, atomic_refresh => false);
    dbms_mview.refresh(list => 'M_FOLDER_CON_MINER', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'M_FOLDER_CON_MINER_3', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'M_FOLDER_CON_MINER_4', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'V_CLIENT_HISTORY', method => 'C', parallelism => 30, atomic_refresh => false);
    --dbms_mview.refresh(list => 'V_PORTFOLIO', method => 'C', parallelism => 30, atomic_refresh => false);

end MONTHLY_PROCESS_TMP;
/

