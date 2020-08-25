select FTVFSYR.FTVFSYR_COAS_CODE as chartOfAccountsId,
       case when FTVFSYR.FTVFSYR_FSYR_CODE > '50' then '19'||FTVFSYR.FTVFSYR_FSYR_CODE
            else '20' || FTVFSYR.FTVFSYR_FSYR_CODE end as fiscalYear4Char,
       FTVFSYR.FTVFSYR_FSYR_CODE as fiscalYear2Char,
       FTVFSYR.FTVFSYR_ACTIVITY_DATE as recordActivityDate,
       FTVFSPD.FTVFSPD_FSPD_CODE as fiscalPeriodCode,
       CASE
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '10' THEN '10th Month'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '11' THEN '11th Month'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '12' THEN 'Year End'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '04' THEN '4th Month'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '08' THEN '8th Month'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '09' THEN '9th Month'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '07' THEN '7th Month'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '01' THEN 'Year Begin'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '02' THEN '2nd Month'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '03' THEN '3rd Month'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '05' THEN '5th Month'
        WHEN FTVFSPD.FTVFSPD_FSPD_CODE = '06' THEN '6th Month'
        ELSE '' END fiscalPeriod,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'MM') as fiscalYearStartMonth,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'DD')as fiscalYearStartDay,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'MM') as fiscalYearEndMonth,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'DD') as fiscalYearEndDay,
	   FTVFSPD.FTVFSPD_FSPD_CODE as fiscalPeriodRaw,
       'fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4' as tenantId,
           '362' AS groupEntityExecutionId,
       '65354417-dff9-40cf-ad8d-e7eb5c0b77ad' as userId,
       'processed-data/fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4/24/2019-12-20 08:23:52' AS dataPath
  from FIMSMGR.FTVFSYR FTVFSYR
    left join FIMSMGR.FTVFSPD FTVFSPD on FTVFSYR.FTVFSYR_COAS_CODE = FTVFSPD.FTVFSPD_COAS_CODE and FTVFSYR.FTVFSYR_FSYR_CODE = FTVFSPD.FTVFSPD_FSYR_CODE
    
union

select FTVFSYR.FTVFSYR_COAS_CODE as chartOfAccountsId,
       case when FTVFSYR.FTVFSYR_FSYR_CODE > '50' then '19'||FTVFSYR.FTVFSYR_FSYR_CODE
            else '20' || FTVFSYR.FTVFSYR_FSYR_CODE end as fiscalYear4Char,
       FTVFSYR.FTVFSYR_FSYR_CODE as fiscalYear2Char,
       FTVFSYR.FTVFSYR_ACTIVITY_DATE as recordActivityDate,
       '14' as fiscalPeriodCode,
       '' as fiscalPeriod,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'MM') as fiscalYearStartMonth,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'DD')as fiscalYearStartDay,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'MM') as fiscalYearEndMonth,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'DD') as fiscalYearEndDay,
	   '14' as fiscalPeriodRaw,
       'fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4' as tenantId,
           '362' AS groupEntityExecutionId,
       '65354417-dff9-40cf-ad8d-e7eb5c0b77ad' as userId,
       'processed-data/fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4/24/2019-12-20 08:23:52' AS dataPath
  from FIMSMGR.FTVFSYR FTVFSYR
  -- left join FIMSMGR.FTVFSPD FTVFSPD on FTVFSYR.FTVFSYR_COAS_CODE = FTVFSPD.FTVFSPD_COAS_CODE and FTVFSYR.FTVFSYR_FSYR_CODE = FTVFSPD.FTVFSPD_FSYR_CODE

union

select FTVFSYR.FTVFSYR_COAS_CODE as chartOfAccountsId,
       case when FTVFSYR.FTVFSYR_FSYR_CODE > '50' then '19'||FTVFSYR.FTVFSYR_FSYR_CODE
            else '20' || FTVFSYR.FTVFSYR_FSYR_CODE end as fiscalYear4Char,
       FTVFSYR.FTVFSYR_FSYR_CODE as fiscalYear2Char,
       FTVFSYR.FTVFSYR_ACTIVITY_DATE as recordActivityDate,
	   '00' as fiscalPeriodCode,
       '' as fiscalPeriod,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'MM') as fiscalYearStartMonth,
       to_char(FTVFSYR.FTVFSYR_START_DATE, 'DD')as fiscalYearStartDay,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'MM') as fiscalYearEndMonth,
       to_char(FTVFSYR.FTVFSYR_END_DATE, 'DD') as fiscalYearEndDay,
	   '00' as fiscalPeriodRaw,
       'fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4' as tenantId,
           '362' AS groupEntityExecutionId,
       '65354417-dff9-40cf-ad8d-e7eb5c0b77ad' as userId,
       'processed-data/fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4/24/2019-12-20 08:23:52' AS dataPath
  from FIMSMGR.FTVFSYR FTVFSYR
  
order by 1, 2, 5
