select
  SARADAP.SARADAP_PIDM personId,
  SARADAP.SARADAP_ACTIVITY_DATE recordActivityDate,
  SARADAP.SARADAP_TERM_CODE_ENTRY termCodeApplied,
  SARADAP.SARADAP_APST_CODE applicationStatusRaw,
  SARADAP.SARADAP_APPL_DATE applyDate,
  SARADAP.SARADAP_LEVL_CODE studentLevelRaw,
  SARADAP.SARADAP_STYP_CODE studentTypeRaw,
  SARAPPD.SARAPPD_APDC_CODE admissionDecisionRaw,
  SARADAP.SARADAP_APPL_NO applicationNumber,
  SARADAP.SARADAP_ADMT_CODE admissionTypeRaw,
  1 isIPEDSReportable
 from SATURN.SARADAP SARADAP
 left join SATURN.SARAPPD SARAPPD on SARADAP.SARADAP_PIDM = SARAPPD.SARAPPD_PIDM
    and SARADAP.SARADAP_TERM_CODE_ENTRY = SARAPPD.SARAPPD_TERM_CODE_ENTRY
    and SARADAP.SARADAP_APPL_NO = SARAPPD.SARAPPD_APPL_NO