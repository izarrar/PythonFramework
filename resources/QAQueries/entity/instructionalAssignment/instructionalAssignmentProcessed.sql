select SIRASGN.SIRASGN_PIDM personId,
       SIRASGN.SIRASGN_ACTIVITY_DATE recordActivityDate,
       SIRASGN.SIRASGN_TERM_CODE termCode,
       SIRASGN.SIRASGN_CRN crn,
       SIRASGN.SIRASGN_PERCENT_RESPONSE instructorPercent,
       '37ae73e1-cbb3-4250-bfc2-54343450f1af' AS tenantId,
     '67' AS groupEntityExecutionId,
     '09469017-73fe-4421-a352-d76d42e8f89f' AS userId,
     'processed-data/37ae73e1-cbb3-4250-bfc2-54343450f1af/19/2019-11-11 15:02:05' AS dataPath
from SATURN.SIRASGN SIRASGN
ORDER BY 1, 3
