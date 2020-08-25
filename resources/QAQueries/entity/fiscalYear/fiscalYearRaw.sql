select FTVFSYR.FTVFSYR_COAS_CODE as chartOfAccountsId,
       case when FTVFSYR.FTVFSYR_FSYR_CODE > '50' then '19'||FTVFSYR.FTVFSYR_FSYR_CODE
            else '20' || FTVFSYR.FTVFSYR_FSYR_CODE end as fiscalYear4Char,
       FTVFSYR.FTVFSYR_FSYR_CODE as fiscalYear2Char,
       FTVFSYR.FTVFSYR_ACTIVITY_DATE as recordActivityDate,
       FTVFSPD.FTVFSPD_FSPD_CODE as fiscalPeriodCode,
       FTVFSPD.FTVFSPD_FSPD_CODE as fiscalPeriod,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'MM') as fiscalYearStartMonth,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'DD')as fiscalYearStartDay,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'MM') as fiscalYearEndMonth,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'DD') as fiscalYearEndDay,
	   1 as isIPEDSReportable
  from FIMSMGR.FTVFSYR FTVFSYR
    left join FIMSMGR.FTVFSPD FTVFSPD on FTVFSYR.FTVFSYR_COAS_CODE = FTVFSPD.FTVFSPD_COAS_CODE and FTVFSYR.FTVFSYR_FSYR_CODE = FTVFSPD.FTVFSPD_FSYR_CODE
    
union

select FTVFSYR.FTVFSYR_COAS_CODE as chartOfAccountsId,
       case when FTVFSYR.FTVFSYR_FSYR_CODE > '50' then '19'||FTVFSYR.FTVFSYR_FSYR_CODE
            else '20' || FTVFSYR.FTVFSYR_FSYR_CODE end as fiscalYear4Char,
       FTVFSYR.FTVFSYR_FSYR_CODE as fiscalYear2Char,
       FTVFSYR.FTVFSYR_ACTIVITY_DATE as recordActivityDate,
       '14' as fiscalPeriodCode,
       '14' as fiscalPeriod,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'MM') as fiscalYearStartMonth,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'DD')as fiscalYearStartDay,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'MM') as fiscalYearEndMonth,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'DD') as fiscalYearEndDay,
	   1 as isIPEDSReportable	   
  from FIMSMGR.FTVFSYR FTVFSYR
--    left join FIMSMGR.FTVFSPD FTVFSPD on FTVFSYR.FTVFSYR_COAS_CODE = FTVFSPD.FTVFSPD_COAS_CODE and FTVFSYR.FTVFSYR_FSYR_CODE = FTVFSPD.FTVFSPD_FSYR_CODE

union

select FTVFSYR.FTVFSYR_COAS_CODE as chartOfAccountsId,
       case when FTVFSYR.FTVFSYR_FSYR_CODE > '50' then '19'||FTVFSYR.FTVFSYR_FSYR_CODE
            else '20' || FTVFSYR.FTVFSYR_FSYR_CODE end as fiscalYear4Char,
       FTVFSYR.FTVFSYR_FSYR_CODE as fiscalYear2Char,
       FTVFSYR.FTVFSYR_ACTIVITY_DATE as recordActivityDate,
       '00' as fiscalPeriodCode,
       '00' as fiscalPeriod,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'MM') as fiscalYearStartMonth,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'DD')as fiscalYearStartDay,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'MM') as fiscalYearEndMonth,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'DD') as fiscalYearEndDay,
	   1 as isIPEDSReportable
  from FIMSMGR.FTVFSYR FTVFSYR
  
order by 1, 2, 5