SELECT
  SORLCUR.SORLCUR_PIDM personID,
  SORLCUR.SORLCUR_TERM_CODE termCodeEffective,
  SORLCUR.SORLCUR_ACTIVITY_DATE recordActivityDate,
  SORLFOS.SORLFOS_PRIORITY_NO fieldOfStudyPriority,
  SORLFOS.SORLFOS_LFST_CODE fieldOfStudyType,
  SORLFOS.SORLFOS_MAJR_CODE curriculumCode,
  SORLCUR.SORLCUR_DEGC_CODE degree,
  SORLCUR.SORLCUR_COLL_CODE college,
  SORLFOS.SORLFOS_CSTS_CODE || '_' || SORLCUR.SORLCUR_LMOD_CODE curriculumStatus,
  SORLCUR.SORLCUR_LEVL_CODE academicTrackLevelRaw,
  1 isIPEDSReportable
FROM SATURN.SORLCUR SORLCUR
INNER JOIN SATURN.SORLFOS SORLFOS on SORLCUR.SORLCUR_PIDM = SORLFOS.SORLFOS_PIDM
      AND SORLCUR.SORLCUR_TERM_CODE = SORLFOS.SORLFOS_TERM_CODE
      AND SORLCUR.SORLCUR_SEQNO = SORLFOS.SORLFOS_LCUR_SEQNO
      AND SORLFOS.SORLFOS_CACT_CODE = 'ACTIVE'
WHERE SORLCUR.SORLCUR_CACT_CODE = 'ACTIVE'

UNION

SELECT
  SORLCUR.SORLCUR_PIDM personID,
  SORLFOS.SORLFOS_TERM_CODE termCodeEffective,
  SORLFOS.SORLFOS_ACTIVITY_DATE recordActivityDate,
  SORLFOS.SORLFOS_PRIORITY_NO fieldOfStudyPriority,
  SORLFOS.SORLFOS_LFST_CODE fieldOfStudyType,
  SORLFOS.SORLFOS_MAJR_CODE curriculumCode,
  SORLCUR.SORLCUR_DEGC_CODE degree,
  SORLCUR.SORLCUR_COLL_CODE college,
  SORLFOS.SORLFOS_CSTS_CODE || '_' || SORLCUR.SORLCUR_LMOD_CODE curriculumStatus,
  SORLCUR.SORLCUR_LEVL_CODE academicTrackLevelRaw,
  1 isIPEDSReportable
FROM SATURN.SORLCUR SORLCUR
INNER JOIN SATURN.SORLFOS SORLFOS on SORLCUR.SORLCUR_PIDM = SORLFOS.SORLFOS_PIDM
      AND SORLCUR.SORLCUR_TERM_CODE = SORLFOS.SORLFOS_TERM_CODE
      AND SORLCUR.SORLCUR_SEQNO = SORLFOS.SORLFOS_LCUR_SEQNO
      AND SORLFOS.SORLFOS_CACT_CODE = 'ACTIVE'
WHERE SORLCUR.SORLCUR_CACT_CODE = 'ACTIVE'