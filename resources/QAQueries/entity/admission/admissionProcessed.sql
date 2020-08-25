SELECT
	SARADAP.SARADAP_PIDM personId,
	SARADAP.SARADAP_ACTIVITY_DATE recordActivityDate,
	SARADAP.SARADAP_TERM_CODE_ENTRY termCodeApplied,
  CASE
  WHEN SARADAP.SARADAP_APST_CODE IN ('W','U') THEN 'Complete'
  WHEN SARADAP.SARADAP_APST_CODE IN ('R','I') THEN 'Incomplete'
  ELSE '' END applicationStatus,
  SARADAP.SARADAP_APPL_DATE applyDate,
    CASE
  WHEN SARADAP.SARADAP_LEVL_CODE IN ('HS','GD') THEN 'Undergrad'
  WHEN SARADAP.SARADAP_LEVL_CODE IN ('PR','RE') THEN 'Graduate'
  ELSE '' END studentLevel,
    CASE
  WHEN SARADAP.SARADAP_STYP_CODE IN ('0','M') THEN 'Returning'
  WHEN SARADAP.SARADAP_STYP_CODE IN ('3','H') THEN 'First Time'
  WHEN SARADAP.SARADAP_STYP_CODE IN ('P', 'I') THEN 'Transfer'
  ELSE '' END studentType,
    CASE
  WHEN SARAPPD.SARAPPD_APDC_CODE IN ('04','FO') THEN 'Accepted'
  WHEN SARAPPD.SARAPPD_APDC_CODE IN ('AA','R4') THEN 'Not Accepted'
  ELSE '' END admissionDecision,
  SARADAP.SARADAP_APPL_NO applicationNumber,
    CASE
  WHEN SARADAP.SARADAP_ADMT_CODE IN ('QS','HS') THEN 'New Applicant'
  WHEN SARADAP.SARADAP_ADMT_CODE IN ('SB','SP') THEN 'Readmit'
  WHEN SARADAP.SARADAP_ADMT_CODE IN ('RE','AD') THEN 'Internal Transfer/Transition'
  ELSE '' END admissionType,
SARADAP.SARADAP_APST_CODE applicationStatusRaw,
SARADAP.SARADAP_LEVL_CODE studentLevelRaw,
SARADAP.SARADAP_STYP_CODE studentTypeRaw,
SARAPPD.SARAPPD_APDC_CODE admissionDecisionRaw,
SARADAP.SARADAP_ADMT_CODE admissionTypeRaw,
'fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4' AS tenantId,
'377' AS groupEntityExecutionId,
'65354417-dff9-40cf-ad8d-e7eb5c0b77ad' AS userId,
'processed-data/fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4/13/2019-12-20 13:02:39' AS dataPath
FROM
SATURN.SARADAP SARADAP
LEFT JOIN SATURN.SARAPPD SARAPPD ON
SARADAP.SARADAP_PIDM = SARAPPD.SARAPPD_PIDM
AND SARADAP.SARADAP_TERM_CODE_ENTRY = SARAPPD.SARAPPD_TERM_CODE_ENTRY
AND SARADAP.SARADAP_APPL_NO = SARAPPD.SARAPPD_APPL_NO