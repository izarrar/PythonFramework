SELECT STVDEGC.STVDEGC_CODE AS degree,
CASE
  WHEN STVDEGC.STVDEGC_CODE IN ('000000', 'NODEG') THEN 'True'
  ELSE 'False'
  END AS isNonDegreeSeeking,
TO_CHAR(CAST(STVDEGC.STVDEGC_ACTIVITY_DATE AS TIMESTAMP WITH TIME ZONE), 'YYYY-MM-DD HH:MI:SS') AS recordActivityDate,
STVDEGC.STVDEGC_DESC AS degreeDescription,
SOBCURR.SOBCURR_CURR_RULE AS curriculumRule,
SOBCURR.SOBCURR_TERM_CODE_INIT AS curriculumTermCodeInit,
STVDEGC.STVDEGC_ACAT_CODE AS acat ,
CASE
  WHEN STVACAT.STVACAT_DESC IN ('Associate Degree', 'Baccalaureate Degree') THEN 'Postsecondary < 1 year Award'
  WHEN STVACAT.STVACAT_DESC IN ('Doctoral Other','High School Program') THEN 'Post-baccalaureate Certificate'
  WHEN STVACAT.STVACAT_DESC IN ('First-Professional Degree','Post-Professional Degree') THEN 'Associates Degree'
  WHEN STVACAT.STVACAT_DESC IN ('Doctoral Degree','Masters Degree') THEN 'Doctor''s Degree (Other)'
  WHEN STVACAT.STVACAT_DESC IN ('Post Second. Cert/Dipl < 1 yr.','Post Second. Cert/Dipl >1 < 2') THEN 'Postsecondary > 2 years < 4 years Award'
ELSE '' END IPEDSAwardLevel,
STVACAT.STVACAT_DESC AS IPEDSAwardLevelRaw,
'fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4' as tenantId,
    	'42' AS groupEntityExecutionId,
	'fa748e9c-a958-11e9-a2a3-2a2ae2dbcce4' as userId,
	'processed-data/fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4/13/2019-10-01 18:06:10' AS dataPath
FROM SATURN.STVDEGC STVDEGC LEFT JOIN SATURN.STVACAT STVACAT
ON STVDEGC.STVDEGC_ACAT_CODE = STVACAT.STVACAT_CODE LEFT JOIN SATURN.SOBCURR SOBCURR
ON STVDEGC.STVDEGC_CODE = SOBCURR.SOBCURR_DEGC_CODE AND SOBCURR.SOBCURR_LOCK_IND = 'Y'
