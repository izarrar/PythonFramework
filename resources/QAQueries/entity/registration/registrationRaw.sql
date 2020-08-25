SELECT
  SFRSTCA.SFRSTCA_PIDM personId,
  SFRSTCA.SFRSTCA_ACTIVITY_DATE recordActivityDate,
  SFRSTCA.SFRSTCA_CRN crn,
  SFRSTCA.SFRSTCA_TERM_CODE termCode,
  SFRSTCA.SFRSTCA_RSTS_CODE registrationStatus,
  SFRSTCA.SFRSTCA_CREDIT_HR enrollmentCreditHours,
  SFRSTCA.SFRSTCA_CAMP_CODE campus,
  1 isIPEDSReportable
FROM SATURN.SFRSTCA SFRSTCA
WHERE SFRSTCA.SFRSTCA_SOURCE_CDE = 'BASE'