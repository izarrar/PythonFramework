select
  STVCAMP.STVCAMP_CODE campus,
  STVCAMP.STVCAMP_ACTIVITY_DATE recordActivityDate,
  STVCAMP.STVCAMP_DESC campusDescription,
  CASE WHEN LENGTH(STVCAMP.STVCAMP_CODE) > 2 THEN 'True' ELSE 'False' END isInternational,
  '726014fe-4863-40db-81d1-b2107e150184' AS tenantId,
	'493' AS groupEntityExecutionId,
	'4c9d4198-62da-46a2-9261-327a0b6c3bd1' AS userId,
	'processed-data/726014fe-4863-40db-81d1-b2107e150184/6/2019-12-09 13:37:04' AS dataPath
from SATURN.STVCAMP STVCAMP