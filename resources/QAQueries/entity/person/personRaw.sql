select * from (SELECT
  SPBPERS.SPBPERS_PIDM personId,
  SPBPERS.SPBPERS_ACTIVITY_DATE recordActivityDate,
  SPRIDEN.SPRIDEN_FIRST_NAME firstName,
  SPRIDEN.SPRIDEN_LAST_NAME lastName,
  SPRIDEN.SPRIDEN_MI middleName,
  SPBPERS.SPBPERS_NAME_SUFFIX suffix,
  SPBPERS.SPBPERS_DEAD_DATE deathDate,
  SPBPERS.SPBPERS_BIRTH_DATE birthDate,
  SPBPERS.SPBPERS_ETHN_CODE ethnicityRaw,
  
  CASE WHEN SPBPERS.SPBPERS_ETHN_CDE = '2' THEN 1 ELSE 0 END isHispanic,
  
  CASE WHEN (SELECT COUNT(GORRACE.GORRACE_RRAC_CODE)
               FROM GENERAL.GORPRAC GORPRAC
               INNER JOIN GENERAL.GORRACE GORRACE ON GORPRAC.GORPRAC_RACE_CDE = GORRACE.GORRACE_RACE_CDE
               AND GORRACE.GORRACE_RRAC_CODE IS NOT NULL
              WHERE GORPRAC.GORPRAC_PIDM = SPBPERS.SPBPERS_PIDM) > 1 THEN 1 ELSE 0 END isMultipleRaces,
  
  SPBPERS.SPBPERS_SEX genderRaw,
  SPRADDR.SPRADDR_STREET_LINE1 address1, 
  SPRADDR.SPRADDR_STREET_LINE2 address2,
  SPRADDR.SPRADDR_STREET_LINE3 address3,
  SPRADDR.SPRADDR_CITY city,
  SPRADDR.SPRADDR_STAT_CODE state,
  SPRADDR.SPRADDR_ZIP zipcode,
  
  (SELECT STVNATN.STVNATN_NATION
   FROM SATURN.STVNATN STVNATN
   WHERE STVNATN.STVNATN_CODE = SPRADDR.SPRADDR_NATN_CODE) nation,
  
  CASE
    WHEN SPRADDR.SPRADDR_CNTY_CODE = '059' THEN 'IN_DISTRICT'
    WHEN SPRADDR.SPRADDR_STAT_CODE = 'CA' THEN 'IN_STATE'
    ELSE 'OUT_STATE'
  END residencyRaw,
  
  (SELECT
    REPLACE(SPRTELE_CTRY_CODE_PHONE, ' ','') || ' ' || REPLACE(SPRTELE_PHONE_AREA, ' ','') || '-' || SUBSTR(REPLACE(SPRTELE_PHONE_NUMBER, ' ',''), 1, 3)|| '-' || SUBSTR(REPLACE(SPRTELE_PHONE_NUMBER, ' ',''), 4, 10) || ' ' || SPRTELE_PHONE_EXT PHONE
  FROM SATURN.SPRTELE SPRTELE
  WHERE SPRTELE.SPRTELE_PIDM = SPBPERS.SPBPERS_PIDM
    AND SPRTELE.SPRTELE_TELE_CODE = 'PR'
    AND NVL(SPRTELE.SPRTELE_STATUS_IND, 'X') != 'I' 
    AND SPRTELE.SPRTELE_PRIMARY_IND = 'Y' 
    AND SPRTELE.SPRTELE_SEQNO = (SELECT MAX(SPRTELE1.SPRTELE_SEQNO)
                                 FROM SATURN.SPRTELE SPRTELE1
                                 WHERE SPRTELE1.SPRTELE_PIDM = SPRTELE.SPRTELE_PIDM
                                 AND SPRTELE1.SPRTELE_TELE_CODE = 'PR'
                                 AND NVL(SPRTELE1.SPRTELE_STATUS_IND, 'X') != 'I' 
                                 AND SPRTELE1.SPRTELE_PRIMARY_IND = 'Y') ) phone,
  
    (SELECT GOREMAL.GOREMAL_EMAIL_ADDRESS
     FROM GENERAL.GOREMAL GOREMAL
     WHERE GOREMAL.GOREMAL_PIDM = SPBPERS.SPBPERS_PIDM
     AND GOREMAL.GOREMAL_STATUS_IND = 'A'
     AND GOREMAL.GOREMAL_PREFERRED_IND = 'Y') email,
     
  SUBSTR(SPBPERS.SPBPERS_SSN, 6, 4) lastFourSsn,
  
  SPBPERS.SPBPERS_MRTL_CODE maritalStatusRaw,
  0 isMilitary, --This is defined differently across institutions and their data practices. 
  CASE WHEN SPBPERS.SPBPERS_VERA_IND IS NOT NULL THEN 1 ELSE 0 END isVeteran,
  CASE WHEN NVL(SPBPERS.SPBPERS_CONFID_IND, 'N') = 'Y' THEN 1 ELSE 0 END isConfidential,
  CASE WHEN (SELECT 1
             FROM SATURN.SPBPERS SPBPERS
             INNER JOIN GENERAL.GORVISA GORVISA 
              ON GORVISA.GORVISA_PIDM = SPBPERS.SPBPERS_PIDM
              AND GORVISA.GORVISA_VISA_START_DATE <= SPBPERS.SPBPERS_ACTIVITY_DATE
              AND GORVISA.GORVISA_VISA_EXPIRE_DATE >= SPBPERS.SPBPERS_ACTIVITY_DATE
             INNER JOIN SATURN.STVVTYP STVVTYP 
              ON STVVTYP.STVVTYP_CODE = GORVISA.GORVISA_VTYP_CODE
              AND STVVTYP.STVVTYP_NON_RES_IND = 'Y') = 1 THEN 1 ELSE 0 END isInternational

FROM SATURN.SPBPERS SPBPERS
INNER JOIN SATURN.SPRIDEN SPRIDEN
  ON SPRIDEN.SPRIDEN_PIDM = SPBPERS.SPBPERS_PIDM 
  AND SPRIDEN.SPRIDEN_CHANGE_IND IS NULL
LEFT JOIN SATURN.SPRADDR SPRADDR
  ON SPRADDR.SPRADDR_PIDM = SPBPERS.SPBPERS_PIDM 
  AND NVL(SPRADDR.SPRADDR_STATUS_IND, 'X') != 'I'
  AND SPRADDR.SPRADDR_ATYP_CODE = 'MA' 
  AND SPRADDR.SPRADDR_SEQNO = (SELECT MAX(SPRADDR1.SPRADDR_SEQNO)
                               FROM SATURN.SPRADDR SPRADDR1
                               WHERE SPRADDR1.SPRADDR_PIDM = SPBPERS.SPBPERS_PIDM
                                 AND NVL(SPRADDR1.SPRADDR_STATUS_IND, 'X') != 'I'
                                 AND SPRADDR1.SPRADDR_ATYP_CODE = 'MA'))
                                 where zipcode NOT IN ('N/A','NA')