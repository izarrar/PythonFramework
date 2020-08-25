Select * from (SELECT
	SORTEST.SORTEST_PIDM personId,
	TO_CHAR(CAST(SORTEST.SORTEST_ACTIVITY_DATE AS TIMESTAMP WITH TIME ZONE), 'MM/DD/YYYY HH24:MI:SS') AS recordActivityDate,
	SORTEST.SORTEST_TEST_SCORE testScore,
	CASE
	WHEN SORTEST.SORTEST_TESC_CODE IN ('COMR','APRC') THEN 'SAT Evidence-Based Reading and Writing'
	WHEN SORTEST.SORTEST_TESC_CODE IN ('MATH', 'WR') THEN 'SAT Math'
	WHEN SORTEST.SORTEST_TESC_CODE IN ('P11','E11') THEN 'ACT Composite'
	WHEN SORTEST.SORTEST_TESC_CODE IN ('G22','IMUN') THEN 'ACT English'
	WHEN SORTEST.SORTEST_TESC_CODE IN ('PS','ASSE') THEN 'ACT Math'
	ELSE '' END testScoreType,
	TO_CHAR(CAST(SORTEST.SORTEST_TEST_DATE AS TIMESTAMP WITH TIME ZONE), 'MM/DD/YYYY HH24:MI:SS') AS testDate,
	SORTEST.SORTEST_TESC_CODE testScoreTypeRaw,
		'fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4' as tenantId,
    	'319' AS groupEntityExecutionId,
	'65354417-dff9-40cf-ad8d-e7eb5c0b77ad' as userId,
	'processed-data/fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4/22/2019-12-19 06:48:24' AS dataPath
FROM
	SATURN.SORTEST SORTEST
ORDER BY
	SORTEST.SORTEST_PIDM,
	SORTEST.SORTEST_ACTIVITY_DATE)
	where testDate not in ('03/10/1000 00:00:00', '02/14/0011 00:00:00')
