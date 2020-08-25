SELECT * FROM (select NBRPOSH.NBRPOSH_POSN position,
       NBRPOSH.NBRPOSH_ACTIVITY_DATE recordActivityDate,
       NBRPOSH.NBRPOSH_TITLE positionDescription,       
       case when NBRPOSH.NBRPOSH_ACTIVITY_DATE = (select max(NBRPOSH2.NBRPOSH_ACTIVITY_DATE)
                                                    from POSNCTL.NBRPOSH NBRPOSH2
                                                   where NBRPOSH2.NBRPOSH_POSN = NBRPOSH.NBRPOSH_POSN) then NBBPOSN.NBBPOSN_BEGIN_DATE else null end startDate,
       case when NBRPOSH.NBRPOSH_ACTIVITY_DATE = (select max(NBRPOSH2.NBRPOSH_ACTIVITY_DATE)
                                                    from POSNCTL.NBRPOSH NBRPOSH2
                                                   where NBRPOSH2.NBRPOSH_POSN = NBRPOSH.NBRPOSH_POSN) then NBBPOSN.NBBPOSN_END_DATE else null end endDate, 
       NBRPOSH.NBRPOSH_PCLS_CODE positionClass,
       NTRPCLS.NTRPCLS_DESC positionClassDescription,
       NBRPOSH.NBRPOSH_PGRP_CODE positionGroup,
       (select PTRPGRP.PTRPGRP_DESC
        from PAYROLL.PTRPGRP PTRPGRP
        where NBRPOSH.NBRPOSH_PGRP_CODE = PTRPGRP.PTRPGRP_CODE) positionGroupDescription,
       NTRPCLS.NTRPCLS_ESKL_CODE skillClass,
       (select PTVESKL.PTVESKL_DESC
        from PAYROLL.PTVESKL PTVESKL
        where NTRPCLS.NTRPCLS_ESKL_CODE = PTVESKL.PTVESKL_CODE
        and PTVESKL.PTVESKL_EMPR_IND = 'H') skillClassDescription,
       CASE WHEN (case when NBRPOSH.NBRPOSH_ACTIVITY_DATE = (select max(NBRPOSH2.NBRPOSH_ACTIVITY_DATE)
                                                    from POSNCTL.NBRPOSH NBRPOSH2
                                                   where NBRPOSH2.NBRPOSH_POSN = NBRPOSH.NBRPOSH_POSN) then NBBPOSN.NBBPOSN_STATUS else null end) = 'I' THEN 'Inactive'
			WHEN (case when NBRPOSH.NBRPOSH_ACTIVITY_DATE = (select max(NBRPOSH2.NBRPOSH_ACTIVITY_DATE)
                                                    from POSNCTL.NBRPOSH NBRPOSH2
                                                   where NBRPOSH2.NBRPOSH_POSN = NBRPOSH.NBRPOSH_POSN) then NBBPOSN.NBBPOSN_STATUS else null end) = 'A' THEN 'Active'
			WHEN (case when NBRPOSH.NBRPOSH_ACTIVITY_DATE = (select max(NBRPOSH2.NBRPOSH_ACTIVITY_DATE)
                                                    from POSNCTL.NBRPOSH NBRPOSH2
                                                   where NBRPOSH2.NBRPOSH_POSN = NBRPOSH.NBRPOSH_POSN) then NBBPOSN.NBBPOSN_STATUS else null end) = 'C' THEN 'Cancelled'
												   ELSE '' END positionStatus,
--positionStatus enum values Active, Inactive, Cancelled, Frozen
		CASE WHEN NBRPOSH.NBRPOSH_ECIP_CODE = '1' THEN 'Other Full Time'
			WHEN NBRPOSH.NBRPOSH_ECIP_CODE = '6' THEN 'Unreported'
			WHEN NBRPOSH.NBRPOSH_ECIP_CODE = 'null' THEN 'Part Time'
			ELSE '' END federalEmploymentCategory,
       NBRPOSH.NBRPOSH_TABLE defaultSalaryTable,
       NBRPOSH.NBRPOSH_GRADE defaultSalaryGrade,
       NBRPOSH.NBRPOSH_STEP defaultSalaryStep,
       NBRPOSH.NBRPOSH_ECLS_CODE defaultEmployeeClass,
       PTRECLS.PTRECLS_SHORT_DESC defaultEmployeeClassDesc,
       NBRPOSH.NBRPOSH_APPT_PCT defaultAppointmentPercent,
       case when NBRPOSH.NBRPOSH_ACTIVITY_DATE = (select max(NBRPOSH2.NBRPOSH_ACTIVITY_DATE)
                                                    from POSNCTL.NBRPOSH NBRPOSH2
                                                   where NBRPOSH2.NBRPOSH_POSN = NBRPOSH.NBRPOSH_POSN) then NBBPOSN.NBBPOSN_COAS_CODE else null end chartOfAccountsId,
       'True' isIPEDSReportable,
	   case when NBRPOSH.NBRPOSH_ACTIVITY_DATE = (select max(NBRPOSH2.NBRPOSH_ACTIVITY_DATE)
                                                    from POSNCTL.NBRPOSH NBRPOSH2
                                                   where NBRPOSH2.NBRPOSH_POSN = NBRPOSH.NBRPOSH_POSN) then NBBPOSN.NBBPOSN_STATUS else null end positionStatusRaw,
		NBRPOSH.NBRPOSH_ECIP_CODE federalEmploymentCategoryRaw,
		  'fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4' as tenantId,
    	'284' AS groupEntityExecutionId,
	'65354417-dff9-40cf-ad8d-e7eb5c0b77ad' as userId,
	'processed-data/fa748ab4-a958-11e9-a2a3-2a2ae2dbcce4/17/2019-12-17 14:39:59' AS dataPath
from POSNCTL.NBRPOSH NBRPOSH
left join POSNCTL.NBBPOSN NBBPOSN on NBRPOSH.NBRPOSH_POSN = NBBPOSN.NBBPOSN_POSN
left join POSNCTL.NTRPCLS NTRPCLS on NBRPOSH.NBRPOSH_PCLS_CODE = NTRPCLS.NTRPCLS_CODE
left join PAYROLL.PTRECLS PTRECLS on NBRPOSH.NBRPOSH_ECLS_CODE = PTRECLS.PTRECLS_CODE)
where defaultSalaryTable !='NA'
