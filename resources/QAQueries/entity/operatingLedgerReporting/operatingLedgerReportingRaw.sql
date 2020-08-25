select FGBOPAL.FGBOPAL_FSYR_CODE as fiscalYear2Char,
  '14' as fiscalPeriodCode,
  FGBOPAL.FGBOPAL_COAS_CODE as chartOfAccountsID,
  FGBOPAL.FGBOPAL_FUND_CODE || '-' || FGBOPAL.FGBOPAL_ORGN_CODE || '-' || FGBOPAL.FGBOPAL_ACCT_CODE || '-' || FGBOPAL.FGBOPAL_PROG_CODE || '-' || FGBOPAL.FGBOPAL_ACTV_CODE || '-' || FGBOPAL.FGBOPAL_LOCN_CODE as accountingString,
  FGBOPAL.FGBOPAL_ACTIVITY_DATE as recordActivityDate,
  FTVATYP.FTVATYP_ATYP_CODE_PRED as accountTypeRaw,
  case when FGBOPAL.FGBOPAL_ACCT_CODE IN ('7651', '7652', '7653', '7701', '7940', '7170', '7171', '7172') then 'Revenue Discount'
            when FTVATYP.FTVATYP_ATYP_CODE_PRED ='50' then 'Revenue'
            when FTVATYP.FTVATYP_ATYP_CODE_PRED in ('60', '70') then 'Expense'
            end as accountType,
  nvl((select sum(FGBOPAL.FGBOPAL_14_YTD_ACTV)
  from FIMSMGR.FGBOPAL FGBOPAL1
  where ( FGBOPAL1.FGBOPAL_COAS_CODE = FGBOPAL.FGBOPAL_COAS_CODE
    and FGBOPAL1.FGBOPAL_ACCT_CODE = FGBOPAL.FGBOPAL_ACCT_CODE
    and FGBOPAL1.FGBOPAL_FUND_CODE = FGBOPAL.FGBOPAL_FUND_CODE
    and FGBOPAL1.FGBOPAL_PROG_CODE = FGBOPAL.FGBOPAL_PROG_CODE
    and FGBOPAL1.FGBOPAL_ORGN_CODE = FGBOPAL.FGBOPAL_ORGN_CODE
    and FGBOPAL1.FGBOPAL_FSYR_CODE = FGBOPAL.FGBOPAL_FSYR_CODE-1)), 0) as beginBalance,
  FGBOPAL.FGBOPAL_14_YTD_ACTV as endBalance,
  case when FTVACCT.FTVACCT_ATYP_CODE = '51' then 'Y' else null end as revTuitionAndFees,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '55'
    and FGBOPAL.FGBOPAL_PROG_CODE in ('10', '20', '40', '60')
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5250') then 'Y' else null end as revFedGrantsContractsOper,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '55'
    and FGBOPAL.FGBOPAL_PROG_CODE in ('50', '80', '90')
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5250') then 'Y' else null end as revFedGrantsContractsNOper,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '52'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5210') then 'Y' else null end as revFedApproprations,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '55'
    and FGBOPAL.FGBOPAL_PROG_CODE in ('10', '20', '40', '60')
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5505') then 'Y' else null end as revStateGrantsContractsOper,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '55'
    and FGBOPAL.FGBOPAL_PROG_CODE in ('50', '80', '90')
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5505') then 'Y' else null end as revStateGrantsContractsNOper,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '52'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5220') then 'Y' else null end as revStateApproprations,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revStateCapitalAppropriations,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '55'
    and FGBOPAL.FGBOPAL_PROG_CODE in ('10', '20', '40', '60')
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5510') then 'Y' else null end as revLocalGrantsContractsOper,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '55'
    and FGBOPAL.FGBOPAL_PROG_CODE in ('50', '80', '90')
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5510') then 'Y' else null end as revLocalGrantsContractsNOper,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '52'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5230') then 'Y' else null end as revLocalApproprations,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revLocalCapitalAppropriations,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '55'
    and FGBOPAL.FGBOPAL_PROG_CODE in ('10', '20', '40', '60')
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5520') then 'Y' else null end as revPrivGrantsContractsOper,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '55'
    and FGBOPAL.FGBOPAL_PROG_CODE in ('50', '80', '90')
    and FGBOPAL.FGBOPAL_ACCT_CODE ='5520') then 'Y' else null end as revPrivGrantsContractsNOper,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '53'
    and FGBOPAL.FGBOPAL_ACCT_CODE != '5330'
    and FGBOPAL.FGBOPAL_PROG_CODE != '30') then 'Y' else null end as revPrivGifts,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '53'
    and FGBOPAL.FGBOPAL_ACCT_CODE = '5330'
    and FGBOPAL.FGBOPAL_PROG_CODE != '30') then 'Y' else null end as revAffiliatedOrgnGifts,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '52'
    and FGBOPAL.FGBOPAL_PROG_CODE ='90') then 'Y' else null end as revAuxEnterprSalesServices,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revHospitalSalesServices,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '52'
    and FGBOPAL.FGBOPAL_PROG_CODE !='90') then 'Y' else null end as revEducActivSalesServices,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revIndependentOperations,
  case when FTVACCT.FTVACCT_ATYP_CODE = '54' then 'Y' else null end as revInvestmentIncome,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '54'
    and FGBOPAL.FGBOPAL_PROG_CODE = '30') then 'Y' else null end as revCapitalGrantsGifts,
  case when FTVACCT.FTVACCT_ATYP_CODE = '56' then 'Y' else null end as revAddToPermEndowments,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revReleasedAssets,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revPropAndNonPropTaxes,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revInterestEarnings,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revDividendEarnings,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revRealizedCapitalGains,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revOtherOper,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revOtherNOper,
  case when FTVACCT.FTVACCT_ATYP_CODE = '59' then 'Y' else null end as revOther,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '58'
    and FGBOPAL.FGBOPAL_FUND_CODE ='2158'
    and FTVFTYP.FTVFTYP_FTYP_CODE = '21') then 'Y' else null end as revFAPellGrant,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '58'
    and FGBOPAL.FGBOPAL_FUND_CODE ='2161'
    and FTVFTYP.FTVFTYP_FTYP_CODE = '21') then 'Y' else null end as revFANonPellFedGrants,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '58'
    and FGBOPAL.FGBOPAL_FUND_CODE ='2171'
    and FTVFTYP.FTVFTYP_FTYP_CODE = '21') then 'Y' else null end as revFAStateGrants,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as revFALocalGrants,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '58'
    and FGBOPAL.FGBOPAL_FUND_CODE in ('2172', '2215')
    and FTVFTYP.FTVFTYP_FTYP_CODE = '21') then 'Y' else null end as revFAInstitGrantsRestr,
  case when (FTVACCT.FTVACCT_ATYP_CODE = '58'
    and FTVFTYP.FTVFTYP_FTYP_CODE = '11') then 'Y' else null end as revFAInstitGrantsUnrestr,
  case when FTVACCT.FTVACCT_ATYP_CODE = '61' then 'Y' else null end as expSalariesWages,
  case when FTVACCT.FTVACCT_ATYP_CODE = '62' then 'Y' else null end as expBenefits,
  case when FGBOPAL.FGBOPAL_ACCT_CODE IN ('7825', '7810',  '7840', '7510') then 'Y' else null end as expCapitalConstruction,
  case when FGBOPAL.FGBOPAL_ACCT_CODE IN ('7220', '7230', '7240', '7621', '7815', '7811') then 'Y' else null end as expCapitalEquipPurch,
  case when FGBOPAL.FGBOPAL_ACCT_CODE IN ('7830', '7640') then 'Y' else null end as expCapitalLandPurch,
  case when FTVATYP.FTVATYP_ATYP_CODE = '73' and FGBOPAL.FGBOPAL_ACCT_CODE not in ('7825', '7810',  '7510', '7220', '7230', '7240', '7621', '7815', '7811', '7830', '7840', '7640', '7910', '7701', '7940', '7170', '7171', '7172', '7651', '7652', '7653') then 'Y' else null end as expCapitalOther,
  case when FGBOPAL.FGBOPAL_ACCT_CODE = '7910' then 'Y' else null end as expDepreciation,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as expInterest,
  case when FTVATYP.FTVATYP_ATYP_CODE = '72' or (FTVATYP.FTVATYP_ATYP_CODE = '71' and FGBOPAL.FGBOPAL_ACCT_CODE not in ('7825', '7810',  '7510', '7220', '7230', '7240', '7621', '7815', '7811', '7830', '7840', '7640', '7910', '7701', '7940', '7170', '7171', '7172', '7651', '7652', '7653' )) then 'Y' else null end as expOther,
  case when FGBOPAL.FGBOPAL_ACCT_CODE IN ('7651', '7652', '7653') then 'Y' else null end as discAllowTuitionFees,
  case when FGBOPAL.FGBOPAL_ACCT_CODE IN ('7701', '7940', '7170', '7171', '7172') then 'Y' else null end as discAllowAuxEnterprise,
  case when (FTVACCT.FTVACCT_ATYP_CODE = 'XX'
    and FGBOPAL.FGBOPAL_ACCT_CODE ='XXXX') then 'Y' else null end as discAllowPatientContract,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='10' then 1 else 0 end as isInstruction,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='20' then 1 else 0 end as isResearch,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='30' then 1 else 0 end as isPublicService,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='40' then 1 else 0 end as isAcademicSupport,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='50' then 1 else 0 end as isStudentServices,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='60' then 1 else 0 end as isInstitutionalSupport,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='80' then 1 else 0 end as isScholarshipFellowship,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='90' then 1 else 0 end as isAuxiliaryEnterprises,
  case when FGBOPAL.FGBOPAL_PROG_CODE in ('200100', '200300', '209900') then 1 else 0 end as isHospitalServices,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='XX' then 1 else 0 end as isIndependentOperations,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='XX' then 1 else 0 end as isOtherFunctional,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='XX' then 1 else 0 end as isAgricultureServices,
  case when FGBOPAL.FGBOPAL_ACCT_CODE = '6270' or FGBOPAL.FGBOPAL_FUND_CODE = '8220' then 1 else 0 end as isPensionGASB,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='XX' then 1 else 0 end as isOPEBRelatedGASB,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='XX' then 1 else 0 end as isStateRetireFundGASB,
  case when FTVFTYP.FTVFTYP_FTYP_CODE in ('11', '12') then 1 else 0 end as isUnrestrictedFASB,
  case when FTVFTYP.FTVFTYP_FTYP_CODE = '21' then 1 else 0 end as isRestrictedTempFASB,
  case when FTVFTYP.FTVFTYP_FTYP_CODE = '61' then 1 else 0 end as isRestrictedPermFASB,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='XX' then 1 else 0 end as isFedIncomeTaxFASB,
  case when FGBOPAL.FGBOPAL_PROG_CODE ='XX' then 1 else 0 end as isStateLocalIncomeTaxFASB
from ( ( (FIMSMGR.FGBOPAL FGBOPAL inner join FIMSMGR.FTVACCT FTVACCT on (FGBOPAL.FGBOPAL_COAS_CODE = FTVACCT.FTVACCT_COAS_CODE) and (FGBOPAL.FGBOPAL_ACCT_CODE = FTVACCT.FTVACCT_ACCT_CODE) ) inner join FIMSMGR.FTVATYP FTVATYP on (FTVACCT.FTVACCT_COAS_CODE = FTVATYP.FTVATYP_COAS_CODE) and (FTVACCT.FTVACCT_ATYP_CODE = FTVATYP.FTVATYP_ATYP_CODE) ) inner join FIMSMGR.FTVFUND FTVFUND on (FGBOPAL.FGBOPAL_COAS_CODE = FTVFUND.FTVFUND_COAS_CODE) and (FGBOPAL.FGBOPAL_FUND_CODE = FTVFUND.FTVFUND_FUND_CODE) ) inner join FIMSMGR.FTVFTYP FTVFTYP on (FTVFUND.FTVFUND_COAS_CODE = FTVFTYP.FTVFTYP_COAS_CODE) and (FTVFUND.FTVFUND_FTYP_CODE = FTVFTYP.FTVFTYP_FTYP_CODE)
where --FGBOPAL.FGBOPAL_FSYR_CODE = '02'
       --and FGBOPAL.FGBOPAL_COAS_CODE = 'B'
       --and
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
  and FTVATYP.FTVATYP_ATYP_CODE_PRED in ('50', '60', '70')
order by 3,
          1,
          2,
          4