SELECT 
  SSBSECT.SSBSECT_TERM_CODE termCode,
  SSBSECT.SSBSECT_PTRM_CODE partOfTerm,
  SSBSECT.SSBSECT_CRN crn,
  SSBSECT.SSBSECT_ACTIVITY_DATE recordActivityDate,
  SCBCRSE.SCBCRSE_TITLE title,
    case when SSBSECT.SSBSECT_INSM_CODE = null then null 
   when SSBSECT.SSBSECT_INSM_CODE = 'OFF' then null 
   when SSBSECT.SSBSECT_INSM_CODE = 'SELF' then 'Online or Distance Learning'
   when SSBSECT.SSBSECT_INSM_CODE = 'WLB' then 'Online or Distance Learning'
   when SSBSECT.SSBSECT_INSM_CODE = 'WEB' then 'Online or Distance Learning'
   when SSBSECT.SSBSECT_INSM_CODE = 'S5' then 'Combination'
   when SSBSECT.SSBSECT_INSM_CODE = 'TR' then 'Combination'
   when SSBSECT.SSBSECT_INSM_CODE = 'S3' then 'Combination'
   when SSBSECT.SSBSECT_INSM_CODE = 'NT' then 'Combination'
   when SSBSECT.SSBSECT_INSM_CODE = 'S4' then 'Combination'
   when SSBSECT.SSBSECT_INSM_CODE = 'ELEV8' then 'Classroom'
   when SSBSECT.SSBSECT_INSM_CODE = 'MUSIC' then 'Classroom'
   when SSBSECT.SSBSECT_INSM_CODE = 'DLEAR' then 'Classroom'
    else '' end as instructionMethod,
  SCBCRSE.SCBCRSE_SUBJ_CODE subject,
  SSBSECT.SSBSECT_CAMP_CODE campus,
  SCBCRSE.SCBCRSE_COLL_CODE college,
  SCBCRSE.SCBCRSE_DEPT_CODE department,
  SCBCRSE.SCBCRSE_CRSE_NUMB courseNumber,
  SSBSECT.SSBSECT_MAX_ENRL maxSeats,
  SCBCRSE.SCBCRSE_CREDIT_HR_HIGH creditHourHigh,
  SCBCRSE.SCBCRSE_CREDIT_HR_LOW creditHourLow,
  SCBCRSE.SCBCRSE_BILL_HR_HIGH billHourHigh,
  SCBCRSE.SCBCRSE_BILL_HR_LOW billHourLow,
  SCBCRSE.SCBCRSE_LEC_HR_HIGH lectureHourHigh,
  SCBCRSE.SCBCRSE_LEC_HR_LOW lectureHourLow,
  SCBCRSE.SCBCRSE_LAB_HR_HIGH labHourHigh,
  SCBCRSE.SCBCRSE_LAB_HR_LOW labHourLow,
  SSBSECT.SSBSECT_INSM_CODE instructionMethodRaw,
   'fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4' as tenantId,
    '310' AS groupEntityExecutionId,
'65354417-dff9-40cf-ad8d-e7eb5c0b77ad' as userId,
'processed-data/fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4/4/2019-12-18 11:51:50' AS dataPath
FROM SATURN.SSBSECT SSBSECT
INNER JOIN SATURN.SCBCRSE SCBCRSE
    ON SCBCRSE.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE 
        AND SCBCRSE.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
        AND SCBCRSE.SCBCRSE_EFF_TERM = (SELECT MAX(SCBCRSE1.SCBCRSE_EFF_TERM)
                                        FROM SATURN.SCBCRSE SCBCRSE1
                                        WHERE SCBCRSE1.SCBCRSE_SUBJ_CODE = SCBCRSE.SCBCRSE_SUBJ_CODE
                                        AND SCBCRSE1.SCBCRSE_CRSE_NUMB = SCBCRSE.SCBCRSE_CRSE_NUMB
                                        AND SCBCRSE1.SCBCRSE_EFF_TERM <= SSBSECT.SSBSECT_TERM_CODE)