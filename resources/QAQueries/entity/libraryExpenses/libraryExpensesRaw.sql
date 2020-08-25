Select 'ML' as branchID,
       FGBOPAL.FGBOPAL_FSYR_CODE as fiscalYear2Char,
       FGBOPAL.FGBOPAL_COAS_CODE as chartOfAccountsID,
       FGBOPAL.FGBOPAL_ACTIVITY_DATE as recordActivityDate,
       FGBOPAL.FGBOPAL_FUND_CODE || '-' || FGBOPAL.FGBOPAL_ORGN_CODE || '-' || FGBOPAL.FGBOPAL_ACCT_CODE || '-' || FGBOPAL.FGBOPAL_PROG_CODE || '-' || FGBOPAL.FGBOPAL_ACTV_CODE || '-' || FGBOPAL.FGBOPAL_LOCN_CODE as accountingString,
       nvl((select sum(FGBOPAL.FGBOPAL_14_YTD_ACTV)
                from FIMSMGR.FGBOPAL FGBOPAL1
               where ( FGBOPAL1.FGBOPAL_COAS_CODE = FGBOPAL.FGBOPAL_COAS_CODE
                       and FGBOPAL1.FGBOPAL_ACCT_CODE = FGBOPAL.FGBOPAL_ACCT_CODE
                       and FGBOPAL1.FGBOPAL_FUND_CODE = FGBOPAL.FGBOPAL_FUND_CODE
                       and FGBOPAL1.FGBOPAL_PROG_CODE = FGBOPAL.FGBOPAL_PROG_CODE
                       and FGBOPAL1.FGBOPAL_ORGN_CODE = FGBOPAL.FGBOPAL_ORGN_CODE
                       and FGBOPAL1.FGBOPAL_FSYR_CODE = FGBOPAL.FGBOPAL_FSYR_CODE-1)), 0) as beginBalance,
       FGBOPAL.FGBOPAL_14_YTD_ACTV as endBalance,
       case when FTVATYP.FTVATYP_ATYP_CODE_PRED in ('60', '70')
            and FTVFUND.FTVFUND_FUND_CODE = '21124'
            and FTVACCT.FTVACCT_ACCT_CODE = '7210'
            then 'Y' else null end as libSalariesAndWages,
       case when FTVATYP.FTVATYP_ATYP_CODE_PRED in ('60', '70')
            and FTVFUND.FTVFUND_FUND_CODE = '21124'
            and FTVACCT.FTVACCT_ACCT_CODE = '6112'
            then 'Y' else null end as libFringeBenefits,
       case when FTVATYP.FTVATYP_ATYP_CODE_PRED in ('60', '70')
            and FTVFUND.FTVFUND_FUND_CODE = '6310' then 'Y' else null end as libOneTimeMaterials,
       case when FTVATYP.FTVATYP_ATYP_CODE_PRED in ('60', '70')
            and FTVFUND.FTVFUND_FUND_CODE = '21124'
            and FTVACCT.FTVACCT_ACCT_CODE not in ('6112', '7210')
            then 'Y' else null end as libServicesSubscriptions,
       case when FTVATYP.FTVATYP_ATYP_CODE_PRED in ('60', '70')
            and FTVACCT.FTVACCT_ACCT_CODE = '7210'
            and FTVFUND.FTVFUND_FUND_CODE = '2013' then 'Y' else null end as libOtherMaterialsServices,
       case when FTVATYP.FTVATYP_ATYP_CODE_PRED in ('60', '70')
            and FTVFUND.FTVFUND_FUND_CODE = '2315' then 'Y' else null end as libPreservationOps,
       case when FTVATYP.FTVATYP_ATYP_CODE_PRED in ('60', '70')
            and FTVACCT.FTVACCT_ACCT_CODE = '7215'
            and FTVFUND.FTVFUND_FUND_CODE = '2013' then 'Y' else null end as libOtherOpsMaintenance
from ( ( (FIMSMGR.FGBOPAL FGBOPAL inner join FIMSMGR.FTVACCT FTVACCT on (FGBOPAL.FGBOPAL_COAS_CODE = FTVACCT.FTVACCT_COAS_CODE) and (FGBOPAL.FGBOPAL_ACCT_CODE = FTVACCT.FTVACCT_ACCT_CODE) ) inner join FIMSMGR.FTVATYP FTVATYP on (FTVACCT.FTVACCT_COAS_CODE = FTVATYP.FTVATYP_COAS_CODE) and (FTVACCT.FTVACCT_ATYP_CODE = FTVATYP.FTVATYP_ATYP_CODE) ) inner join FIMSMGR.FTVFUND FTVFUND on (FGBOPAL.FGBOPAL_COAS_CODE = FTVFUND.FTVFUND_COAS_CODE) and (FGBOPAL.FGBOPAL_FUND_CODE = FTVFUND.FTVFUND_FUND_CODE) ) inner join FIMSMGR.FTVFTYP FTVFTYP on (FTVFUND.FTVFUND_COAS_CODE = FTVFTYP.FTVFTYP_COAS_CODE) and (FTVFUND.FTVFUND_FTYP_CODE = FTVFTYP.FTVFTYP_FTYP_CODE)
 where
       FTVACCT.FTVACCT_DATA_ENTRY_IND = 'Y'
       and FTVACCT.FTVACCT_STATUS_IND = 'A'
       and FTVACCT.FTVACCT_NCHG_DATE >sysdate
       and FTVATYP.FTVATYP_STATUS_IND = 'A'
       and FTVATYP.FTVATYP_NCHG_DATE >sysdate
       and FTVFUND.FTVFUND_STATUS_IND = 'A'
       and FTVFUND.FTVFUND_DATA_ENTRY_IND = 'Y'
       and FTVFUND.FTVFUND_NCHG_DATE > sysdate
       and FTVFTYP.FTVFTYP_STATUS_IND = 'A'
       and FTVFTYP.FTVFTYP_NCHG_DATE >sysdate
       and FTVATYP.FTVATYP_ATYP_CODE_PRED in ('60', '70')
       and FTVFUND.FTVFUND_FUND_CODE in ('94103', '6310', '21124', '6315', '2315', '2013')
order by 3,
          1,
          2,
          4