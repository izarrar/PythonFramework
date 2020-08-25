SELECT DISTINCT
  STVTERM.STVTERM_CODE termCode,
  STVTERM.STVTERM_ACTIVITY_DATE recordActivityDate,
  STVTERM.STVTERM_DESC termCodeDescription,
  STVTERM.STVTERM_START_DATE startDate,
  STVTERM.STVTERM_END_DATE endDate,
  STVTERM.STVTERM_ACYR_CODE academicYear,
  STVTERM.STVTERM_FA_PROC_YR financialAidYear,
  SFRSTCR.SFRSTCR_PTRM_CODE partOfTerm,
  (SELECT STVPTRM.STVPTRM_DESC
   FROM SATURN.STVPTRM STVPTRM
   WHERE STVPTRM.STVPTRM_CODE = SFRSTCR.SFRSTCR_PTRM_CODE) partOfTermDescription,
  CASE
    WHEN substr(STVTERM.STVTERM_CODE, 5, 2) IN ('10', '20') then STVTERM.STVTERM_START_DATE + 15
    WHEN substr(STVTERM.STVTERM_CODE, 5, 2) IN ('30') then STVTERM.STVTERM_START_DATE + 5
    ELSE STVTERM.STVTERM_START_DATE + 5
  END censusDate,
  substr(STVTERM.STVTERM_CODE, 5, 2) termType,
  CASE
    WHEN substr(STVTERM.STVTERM_CODE, 5, 2) IN ('10', '20') then 12
    ELSE 6
  END requiredFullTimeHoursUG,
  CASE
    WHEN substr(STVTERM.STVTERM_CODE, 5, 2) IN ('10', '20') then 12
    ELSE 6
  END requiredFullTimeHoursGR,
1 isIPEDSReportable
FROM SATURN.STVTERM STVTERM
LEFT JOIN SATURN.SFRSTCR SFRSTCR
  ON SFRSTCR.SFRSTCR_TERM_CODE = STVTERM.STVTERM_CODE