select FGVGLP0.FISCAL_YEAR as fiscalYear2Char,
FGVGLP0.FISCAL_PERIOD as fiscalPeriodCode,
FGVGLP0.CHART_CODE as chartOfAccountsID,
FGVGLP0.FUND_CODE || '-' || null || '-' || FGVGLP0.ACCOUNT_CODE || '-' || null || '-' || null || '-' || null as accountingString,
FGVGLP0.EFFECTIVE_DATE as recordActivityDate,
case when FGVGLP0.ACCOUNT_TYPE_1 = '10' THEN 'Liability'
WHEN FGVGLP0.ACCOUNT_TYPE_1 = '20' THEN 'Asset'
ELSE '' END accountType,
FGVGLP0.BEGIN_BALANCE as beginBalance,
FGVGLP0.END_BALANCE as endBalance,
case when FGVGLP0.ACCOUNT_TYPE_2 in ('11', '13') then 'Y' else null end as assetCurrent,
case when FGVGLP0.ACCOUNT_CODE = '1420' then 'Y' else null end as assetCapitalLand,
case when FGVGLP0.ACCOUNT_CODE = 'XXXX' then 'Y' else null end as assetCapitalInfrastructure,
case when FGVGLP0.ACCOUNT_CODE = '1740' then 'Y' else null end as assetCapitalBuildings,
case when FGVGLP0.ACCOUNT_CODE = '1460' then 'Y' else null end as assetCapitalEquipment,
case when FGVGLP0.ACCOUNT_CODE = '1410' then 'Y' else null end as assetCapitalConstruction,
case when FGVGLP0.ACCOUNT_CODE = 'XXXX' then 'Y' else null end as assetCapitalIntangibleAsset,
case when FGVGLP0.ACCOUNT_CODE = '1430' then 'Y' else null end as assetCapitalOther,
case when FGVGLP0.ACCOUNT_TYPE_2 = '16' then 'Y' else null end as assetNoncurrentOther,
case when FGVGLP0.ACCOUNT_TYPE_2 = '12' then 'Y' else null end as deferredOutflow,
case when FGVGLP0.ACCOUNT_TYPE_2 = '24' then 'Y' else null end as liabCurrentLongtermDebt,
case when FGVGLP0.ACCOUNT_TYPE_2 = '21' then 'Y' else null end as liabCurrentOther,
case when FGVGLP0.ACCOUNT_TYPE_2 = '25' then 'Y' else null end as liabNoncurrentLongtermDebt,
case when FGVGLP0.ACCOUNT_TYPE_2 = '22' then 'Y' else null end as liabNoncurrentOther,
case when FGVGLP0.ACCOUNT_TYPE_2 = '23' then 'Y' else null end as deferredInflow,
case when FGVGLP0.ACCOUNT_CODE = '1730' then 'Y' else null end as accumDepreciation,
null as accumAmmortization,
case when (FGVGLP0.ACCOUNT_TYPE_1 = '20' and FGVGLP0.FUND_TYPE_1 in ('90', '30')) then 'True' else 'False' end as isCapitalRelatedDebt,
case when (FGVGLP0.FUND_TYPE_1 = '20' and FGVGLP0.ACCOUNT_TYPE_2 = '11') then 'True' else 'False' end as isRestrictedExpendOrTemp,
case when (FGVGLP0.FUND_TYPE_1 = '20' and FGVGLP0.ACCOUNT_TYPE_2 != '11') then 'True' else 'False' end as isRestrictedNonExpendOrPerm,
case when FGVGLP0.FUND_TYPE_1 = '10' then 'True' else 'False' end as isUnrestricted,
case when FGVGLP0.FUND_TYPE_1 = '60' then 'True' else 'False' end as isEndowment,
case when FGVGLP0.ACCOUNT_CODE = '2119' then 'True' else 'False' end as isPensionGASB,
case when FGVGLP0.ACCOUNT_CODE in ('2126', '2127') then 'True' else 'False' end as isOPEBRelatedGASB,
case when FGVGLP0.ACCOUNT_TYPE_2 = '11' and FGVGLP0.FUND_TYPE_1 = '10' then 'True' else 'False' end as isSinkingOrDebtServFundGASB,
case when FGVGLP0.ACCOUNT_CODE = '1210' then 'True' else 'False' end as isBondFundGASB,
case when FGVGLP0.ACCOUNT_CODE != '1210' then 'True' else 'False' end as isNonBondFundGASB,
case when FGVGLP0.ACCOUNT_TYPE_2 in ('11', '12') then 'True' else 'False' end as isCashOrSecurityAssetGASB,
FGVGLP0.ACCOUNT_TYPE_1 as accountTypeRaw,
'37ae73e1-cbb3-4250-bfc2-54343450f1af' as tenantId,
    '40' AS groupEntityExecutionId,
'09469017-73fe-4421-a352-d76d42e8f89f' as userId,
'processed-data/37ae73e1-cbb3-4250-bfc2-54343450f1af/25/2019-11-07 16:19:04' AS dataPath
from BANINST1.FGVGLP0 FGVGLP0
where FGVGLP0.ACCOUNT_TYPE_1 in ('10', '20')
order by 3,
1,
2,
4
