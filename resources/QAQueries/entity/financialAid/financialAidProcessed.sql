SELECT
	RPRATRM.RPRATRM_PIDM personId,
	RPRATRM.RPRATRM_ACTIVITY_DATE recordActivityDate,
	RPRATRM.RPRATRM_PERIOD termCode,
    RPRATRM.RPRATRM_AIDY_CODE financialAidYear,
CASE WHEN RFRBASE.RFRBASE_FTYP_CODE IN ('LOAN','FELO') THEN 'Loan'
WHEN RFRBASE.RFRBASE_FTYP_CODE IN ('WORK') THEN 'Work Study'
WHEN RFRBASE.RFRBASE_FTYP_CODE IN ('GRNT') THEN 'Grant'
WHEN RFRBASE.RFRBASE_FTYP_CODE IN ('SCHL') THEN 'Scholarship'
ELSE '' END fundType,

	RFRBASE.RFRBASE_FUND_CODE fundCode,
	CASE
WHEN RFRBASE.RFRBASE_FSRC_CODE IN ('STAT') THEN 'State'
WHEN RFRBASE.RFRBASE_FSRC_CODE IN ('FDRL') THEN 'Federal'
WHEN RFRBASE.RFRBASE_FSRC_CODE IN ('INST') THEN 'Institution'
WHEN RFRBASE.RFRBASE_FSRC_CODE IN ('OTHR') THEN 'Other'
ELSE '' END fundSource,

CASE
WHEN RPRATRM.RPRATRM_AWST_CODE IN ('ACPT') THEN 'Accepted'
WHEN RPRATRM.RPRATRM_AWST_CODE IN ('OFRD') THEN 'Offered'
WHEN RPRATRM.RPRATRM_AWST_CODE IN ('ESTI') THEN 'Declined'
WHEN RPRATRM.RPRATRM_AWST_CODE IN ('WACP') THEN 'Cancelled'
ELSE '' END awardStatus,

	CASE
		WHEN RFRBASE.RFRBASE_FTYP_CODE = 'GRNT'
		AND RFRBASE.RFRBASE_FUND_CODE = 'PELL'
		AND RFRBASE.RFRBASE_FSRC_CODE = 'FDRL' THEN 'True'
		ELSE 'False'
	END isPellGrant,
	CASE
		WHEN RFRBASE.RFRBASE_FTYP_CODE IN ('GRNT',
		'LOAN')
		AND RFRBASE.RFRBASE_FUND_CODE IN ('SEOG','ACG','SMRT','TEACH','PERK','DIRECT','DLUNSB','STFD','STFDB','UNSTFD','PELL')
		AND RFRBASE.RFRBASE_FSRC_CODE = 'FDRL' THEN 'True'
		ELSE 'False'
	END isTitleIV,
	CASE
		WHEN RFRBASE.RFRBASE_FTYP_CODE = 'LOAN'
		AND RFRBASE.RFRBASE_FUND_CODE = 'DIRECT'
		AND RFRBASE.RFRBASE_FSRC_CODE = 'FDRL' THEN 'True'
		ELSE 'False'
	END isSubsidizedDirectLoan,
	RPRATRM.RPRATRM_ACCEPT_AMT acceptedAmount,
	RPRATRM.RPRATRM_OFFER_AMT offeredAmount,
	RPRATRM.RPRATRM_PAID_AMT paidAmount,
	CASE
		WHEN RFRBASE.RFRBASE_FTYP_CODE = 'LOAN' THEN RPRATRM.RPRATRM_ACCEPT_AMT
		ELSE RPRATRM.RPRATRM_OFFER_AMT
	END IPEDSReportableAmount,
     (SELECT ROUND(SUM(RCRAPP4.RCRAPP4_FISAP_INC),2)
  FROM FAISMGR.RCRAPP4 RCRAPP4
 INNER JOIN FAISMGR.RCRAPP1 RCRAPP1 ON RCRAPP1.RCRAPP1_AIDY_CODE = RCRAPP4.RCRAPP4_AIDY_CODE
  AND RCRAPP1.RCRAPP1_PIDM = RCRAPP4.RCRAPP4_PIDM
  AND RCRAPP1.RCRAPP1_SEQ_NO = RCRAPP4.RCRAPP4_SEQ_NO
 WHERE RCRAPP1.RCRAPP1_PIDM = RPRATRM.RPRATRM_PIDM
  AND RCRAPP1.RCRAPP1_CURR_REC_IND ='Y'
  AND RCRAPP1.RCRAPP1_AIDY_CODE = (SELECT MAX(RCRAPP1_1.RCRAPP1_AIDY_CODE)
                                   FROM FAISMGR.RCRAPP1 RCRAPP1_1
                                   WHERE RCRAPP1_1.RCRAPP1_PIDM = RCRAPP1.RCRAPP1_PIDM
                                      AND RCRAPP1_1.RCRAPP1_AIDY_CODE <= RPRATRM.RPRATRM_AIDY_CODE
                                      AND RCRAPP1_1.RCRAPP1_CURR_REC_IND ='Y' ) )  familyIncome,
    'True' isIPEDSReportable,
	RFRBASE.RFRBASE_FTYP_CODE fundTypeRaw,
	RFRBASE.RFRBASE_FSRC_CODE fundSourceRaw,
	RPRATRM.RPRATRM_AWST_CODE awardStatusRaw,
	'fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4' as tenantId,
    	'369' AS groupEntityExecutionId,
	'65354417-dff9-40cf-ad8d-e7eb5c0b77ad' as userId,
	'processed-data/fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4/10/2019-12-20 10:19:58' AS dataPath
FROM
	FAISMGR.RPRATRM RPRATRM
LEFT JOIN FAISMGR.RFRBASE RFRBASE ON
	RPRATRM.RPRATRM_FUND_CODE = RFRBASE.RFRBASE_FUND_CODE
	AND RFRBASE.RFRBASE_FTYP_CODE IS NOT NULL
	AND RFRBASE.RFRBASE_FSRC_CODE IS NOT NULL
