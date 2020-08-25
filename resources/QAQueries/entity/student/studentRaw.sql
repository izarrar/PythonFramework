SELECT
    SGBSTDN.SGBSTDN_PIDM personId,
    SGBSTDN.SGBSTDN_ACTIVITY_DATE recordActivityDate,
    STVTERM.STVTERM_CODE termCode,
    SGBSTDN.SGBSTDN_TERM_CODE_ADMIT termCodeOnAdmission, --change based on client requirements
    SGBSTDN.SGBSTDN_STYP_CODE studentType,
    SGBSTDN.SGBSTDN_LEVL_CODE studentLevelRaw,
    SGBSTDN.SGBSTDN_STST_CODE studentStatusRaw,
    SGBSTDN.SGBSTDN_CAMP_CODE campus,
    SGBSTDN.SGBSTDN_COLL_CODE_1 college,
    ( select
      coalesce(
        max(SORHSCH.SORHSCH_GRADUATION_DATE),
        max(SORHSCH.SORHSCH_TRANS_RECV_DATE),
        max(SORHSCH.SORHSCH_ACTIVITY_DATE) )
    from SATURN.SORHSCH SORHSCH
    where SORHSCH.SORHSCH_PIDM = SGBSTDN.SGBSTDN_PIDM) highSchoolGradDate,
    ( CASE WHEN SGBSTDN.SGBSTDN_DEGC_CODE_1 IN ('000000', 'NODEG') then 1
          WHEN SGBSTDN.SGBSTDN_LEVL_CODE NOT IN ('UG', 'GR', 'PHD', 'LW') then 1
          WHEN (select STVLEVL.STVLEVL_EDI_EQUIV
                from STVLEVL STVLEVL
                where STVLEVL.STVLEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE) NOT IN ('UG', 'GR', 'PHD', 'LW') then 1
          WHEN SGBSTDN.SGBSTDN_STYP_CODE IN ('0', 'E', 'H', 'X') then 1
          ELSE 0 END ) isNonDegreeSeeking,
    (SELECT
      MIN(SFRSTCA2.SFRSTCA_TERM_CODE)
     FROM SATURN.SFRSTCA SFRSTCA2
     WHERE SFRSTCA2.SFRSTCA_PIDM = SGBSTDN.SGBSTDN_PIDM
      AND SFRSTCA2.SFRSTCA_RSTS_CODE IN ('RE', 'RW')
      AND SFRSTCA2.SFRSTCA_SOURCE_CDE = 'BASE'
      AND SFRSTCA2.SFRSTCA_SEQ_NUMBER = (SELECT MAX(SFRSTCA1.SFRSTCA_SEQ_NUMBER)
                                         FROM SATURN.SFRSTCA SFRSTCA1
                                         INNER JOIN SATURN.STVTERM STVTERM2 ON SFRSTCA1.SFRSTCA_TERM_CODE = STVTERM2.STVTERM_CODE
                                         WHERE SFRSTCA1.SFRSTCA_PIDM = SFRSTCA2.SFRSTCA_PIDM
                                            AND SFRSTCA1.SFRSTCA_TERM_CODE = SFRSTCA2.SFRSTCA_TERM_CODE
                                            AND SFRSTCA1.SFRSTCA_CRN = SFRSTCA2.SFRSTCA_CRN
                                            AND SFRSTCA1.SFRSTCA_SOURCE_CDE = SFRSTCA2.SFRSTCA_SOURCE_CDE
                                            AND SFRSTCA1.SFRSTCA_LEVL_CODE = SFRSTCA2.SFRSTCA_LEVL_CODE
                                            AND SFRSTCA1.SFRSTCA_ACTIVITY_DATE <=
                                                CASE
                                                  WHEN substr(STVTERM2.STVTERM_CODE, 5, 2) IN ('10', '20') then STVTERM2.STVTERM_START_DATE + 15
                                                  WHEN substr(STVTERM2.STVTERM_CODE, 5, 2) IN ('30') then STVTERM2.STVTERM_START_DATE + 5
                                                  ELSE STVTERM2.STVTERM_START_DATE + 5
                                                END)
     HAVING sum(SFRSTCA2.SFRSTCA_CREDIT_HR) > 0) firstTermEnrolled,

  (SELECT
    CASE
        WHEN GPA_HOURS = 0 then 0
        WHEN GPA_HOURS is null then null
        ELSE round(QUALITY_POINTS/GPA_HOURS, 3)
    END
   FROM (
    SELECT
      sum(SHRTGPA.SHRTGPA_GPA_HOURS) GPA_HOURS,
      coalesce(sum(SHRTGPA.SHRTGPA_QUALITY_POINTS), 0) QUALITY_POINTS
    FROM SATURN.SHRTGPA SHRTGPA
    WHERE SHRTGPA.SHRTGPA_PIDM = SGBSTDN.SGBSTDN_PIDM
      AND SHRTGPA.SHRTGPA_LEVL_CODE = SGBSTDN.SGBSTDN_LEVL_CODE
      AND SHRTGPA.SHRTGPA_TERM_CODE <= STVTERM.STVTERM_CODE
  ) ) cumulativeGpa,
  1 isIPEDSReportable
FROM SATURN.SGBSTDN SGBSTDN
LEFT JOIN SATURN.STVTERM STVTERM
  ON STVTERM.STVTERM_CODE <= SGBSTDN.SGBSTDN_TERM_CODE_EFF
  AND STVTERM.STVTERM_CODE >= SGBSTDN.SGBSTDN_TERM_CODE_ADMIT
  AND STVTERM.STVTERM_CODE <=     (SELECT
                                    MAX(SFRSTCA2.SFRSTCA_TERM_CODE)
                                   FROM SATURN.SFRSTCA SFRSTCA2
                                   WHERE SFRSTCA2.SFRSTCA_PIDM = SGBSTDN.SGBSTDN_PIDM
                                    AND SFRSTCA2.SFRSTCA_RSTS_CODE IN ('RE', 'RW')
                                    AND SFRSTCA2.SFRSTCA_SOURCE_CDE = 'BASE'
                                    AND SFRSTCA2.SFRSTCA_SEQ_NUMBER = (SELECT MAX(SFRSTCA1.SFRSTCA_SEQ_NUMBER)
                                                                       FROM SATURN.SFRSTCA SFRSTCA1
                                                                       INNER JOIN SATURN.STVTERM STVTERM2 ON SFRSTCA1.SFRSTCA_TERM_CODE = STVTERM2.STVTERM_CODE
                                                                       WHERE SFRSTCA1.SFRSTCA_PIDM = SFRSTCA2.SFRSTCA_PIDM
                                                                        AND SFRSTCA1.SFRSTCA_TERM_CODE = SFRSTCA2.SFRSTCA_TERM_CODE
                                                                        AND SFRSTCA1.SFRSTCA_CRN = SFRSTCA2.SFRSTCA_CRN
                                                                        AND SFRSTCA1.SFRSTCA_SOURCE_CDE = SFRSTCA2.SFRSTCA_SOURCE_CDE
                                                                        AND SFRSTCA1.SFRSTCA_LEVL_CODE = SFRSTCA2.SFRSTCA_LEVL_CODE
                                                                        AND SFRSTCA1.SFRSTCA_ACTIVITY_DATE <=
                                                                            CASE
                                                                              WHEN substr(STVTERM2.STVTERM_CODE, 5, 2) IN ('10', '20') then STVTERM2.STVTERM_START_DATE + 15
                                                                              WHEN substr(STVTERM2.STVTERM_CODE, 5, 2) IN ('30') then STVTERM2.STVTERM_START_DATE + 5
                                                                              ELSE STVTERM2.STVTERM_START_DATE + 5
                                                                            END)
                                 HAVING sum(SFRSTCA2.SFRSTCA_CREDIT_HR) > 0)