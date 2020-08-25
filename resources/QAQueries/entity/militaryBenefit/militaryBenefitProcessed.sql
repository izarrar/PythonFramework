SELECT TBRACCD.TBRACCD_PIDM personId, TBRACCD.TBRACCD_ENTRY_DATE recordActivityDate, TBRACCD.TBRACCD_TERM_CODE termCode, CASE WHEN TBRACCD.TBRACCD_DETAIL_CODE IN ('ARMP','FFPG') THEN 'GI' WHEN TBRACCD.TBRACCD_DETAIL_CODE IN ('ARMY','FSEG') THEN 'DoD' WHEN TBRACCD.TBRACCD_DETAIL_CODE IN ('NAVP','VMS') THEN 'Unknown' ELSE '' END benefitType, TBRACCD.TBRACCD_DETAIL_CODE benefitTypeRaw, TBRACCD.TBRACCD_AMOUNT benefitAmount, '37ae73e1-cbb3-4250-bfc2-54343450f1af' as tenantId, '65' AS groupEntityExecutionId, '0afcf47a-3421-4875-89d8-0bcbbdd548a9' as userId, 'processed-data/37ae73e1-cbb3-4250-bfc2-54343450f1af/25/2019-10-10 12:48:13' AS dataPath FROM TAISMGR.TBRACCD TBRACCD WHERE TBRACCD_DETAIL_CODE IN ('ARMY', 'ARMP','NAVP','VMS','FSEG','FFPG')