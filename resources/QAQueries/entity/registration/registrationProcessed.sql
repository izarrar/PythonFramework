SELECT
  SFRSTCA.SFRSTCA_PIDM personId,
  SFRSTCA.SFRSTCA_ACTIVITY_DATE recordActivityDate,
  SFRSTCA.SFRSTCA_CRN crn,
  SFRSTCA.SFRSTCA_TERM_CODE termCode,
  
  CASE WHEN SFRSTCA.SFRSTCA_RSTS_CODE IN ('DW','MT','ZZ') THEN 'Enrolled'
		WHEN SFRSTCA.SFRSTCA_RSTS_CODE = 'TW' THEN 'Not Enrolled'
		WHEN SFRSTCA.SFRSTCA_RSTS_CODE = 'RE' THEN 'Unknown'
  ELSE '' END registrationStatus,
  
  SFRSTCA.SFRSTCA_CREDIT_HR enrollmentCreditHours,
  SFRSTCA.SFRSTCA_CAMP_CODE campus,
  'True' isIPEDSReportable,
  SFRSTCA.SFRSTCA_RSTS_CODE registrationStatusRaw,
   'fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4' as tenantId,
    	'370' AS groupEntityExecutionId,
	'65354417-dff9-40cf-ad8d-e7eb5c0b77ad' as userId,
	'processed-data/fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4/3/2019-12-20 10:19:58' AS dataPath
FROM SATURN.SFRSTCA SFRSTCA
WHERE SFRSTCA.SFRSTCA_SOURCE_CDE = 'BASE'