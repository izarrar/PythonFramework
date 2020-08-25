Select * from (select NBRJOBS.NBRJOBS_PIDM personId,
       NBRJOBS.NBRJOBS_ACTIVITY_DATE recordActivityDate,
       NBRJOBS.NBRJOBS_SUFF suffix,
       NBRBJOB.NBRBJOB_BEGIN_DATE assignmentStartDate,
       NBRBJOB.NBRBJOB_END_DATE assignmentEndDate,
       NBRJOBS.NBRJOBS_POSN position,
       NBRJOBS.NBRJOBS_DESC assignmentDescription,
       CASE
        WHEN NBRBJOB.NBRBJOB_CONTRACT_TYPE = 'O' THEN 'Overload'
        WHEN NBRBJOB.NBRBJOB_CONTRACT_TYPE = 'P' THEN 'Primary'
        WHEN NBRBJOB.NBRBJOB_CONTRACT_TYPE = 'S' THEN 'Secondary'
        ELSE '' END assignmentType,
       CASE
        WHEN NBRJOBS.NBRJOBS_STATUS = 'A' THEN 'Active'
        WHEN NBRJOBS.NBRJOBS_STATUS = 'T' THEN 'Terminated'
        WHEN NBRJOBS.NBRJOBS_STATUS IN ('P','L','F','B') THEN 'On Leave'
        ELSE '' END assignmentStatus,
       nvl(NBRJOBS.NBRJOBS_ECLS_CODE, NBRPOSH.NBRPOSH_ECLS_CODE) employeeClass,
       nvl(PTRECLS.PTRECLS_SHORT_DESC, (select PTRECLS2.PTRECLS_SHORT_DESC
                                          from PAYROLL.PTRECLS PTRECLS2
                                         where PTRECLS2.PTRECLS_CODE = nvl(NBRJOBS.NBRJOBS_ECLS_CODE, NBRPOSH.NBRPOSH_ECLS_CODE))) employeeClassDesc,
        NBRJOBS.NBRJOBS_EMPR_CODE employerCode,
       nvl(NBRJOBS.NBRJOBS_SAL_GRADE, NBRPOSH.NBRPOSH_GRADE) salaryGrade,
       nvl(NBRJOBS.NBRJOBS_SAL_STEP, NBRPOSH.NBRPOSH_STEP) salaryStep,
case when NBRJOBS.NBRJOBS_ANN_SALARY is null then
        case when PEBEMPL.PEBEMPL_EGRP_CODE = 'UNIO' then 25000.00
           when PEBEMPL.PEBEMPL_EGRP_CODE = 'ADMN' then 62000.00
           when PEBEMPL.PEBEMPL_EGRP_CODE = 'FAC' then 63500.00
           when PEBEMPL.PEBEMPL_EGRP_CODE = 'R' then 51250.00
           when PEBEMPL.PEBEMPL_EGRP_CODE = 'SEC' then 21200.00
           when PEBEMPL.PEBEMPL_EGRP_CODE = 'S/C' then 31625.00
           when PEBEMPL.PEBEMPL_EGRP_CODE = 'BECL' then 41900.00
           when PEBEMPL.PEBEMPL_EGRP_CODE = 'STU' then 21000.00
           when PEBEMPL.PEBEMPL_EGRP_CODE = 'ASSP' then 65250.00
           when PEBEMPL.PEBEMPL_EGRP_CODE like 'P%' then 37000.00
           when PEBEMPL.PEBEMPL_EGRP_CODE in ('C', 'MAIN') then 39500.00 else 102350 end
          else NBRJOBS.NBRJOBS_ANN_SALARY end annualSalary,
       nvl(NBRJOBS.NBRJOBS_APPT_PCT, NBRPOSH.NBRPOSH_APPT_PCT) appointmentPercent,
       NBRJOBS.NBRJOBS_FTE fte,
       NBRJOBS.NBRJOBS_PICT_CODE payScheduleCode,
       case when NBRPOSH.NBRPOSH_PGRP_CODE != 'Z002' and NBRPOSH.NBRPOSH_PGRP_CODE IN ('S009', 'FAC3', 'FAC2') then 'True'
            else 'False' end isFaculty,
       case when NBRJOBS.NBRJOBS_ECLS_CODE IN ('18', '27', 'HT', 'SS') then 'True'
            when NBRPOSH.NBRPOSH_PGRP_CODE = 'Z001' then 'True' else 'False' end isUndergradStudent,
       case when NBRJOBS.NBRJOBS_ECLS_CODE IN ('21') then 'True' else 'False' end isWorkStudy,
       case when NBRJOBS.NBRJOBS_ECLS_CODE IN ('T1', 'TE', 'ST') then 'True'
            when NBRPOSH.NBRPOSH_PGRP_CODE = 'TMP1' then 'True' else 'False' end isTempOrSeasonal,
       CASE
       WHEN (case when NBRJOBS.NBRJOBS_ECLS_CODE IN ('HC','28','16','13','12','11','PL','DW') then 'P'
             when NBRPOSH.NBRPOSH_PCLS_CODE IN ('PS002', 'FAD04', 'FAD03', 'FAD01') then 'P'
             when PEBEMPL_INTERNAL_FT_PT_IND = 'P' then 'P'
             when PEBEMPL_INTERNAL_FT_PT_IND = 'O' then 'O'
             when NBRPOSH.NBRPOSH_ECIP_CODE = '7' then 'O'
             else 'F' end ) = 'F' THEN 'Full Time'
       WHEN (case when NBRJOBS.NBRJOBS_ECLS_CODE IN ('HC','28','16','13','12','11','PL','DW') then 'P'
             when NBRPOSH.NBRPOSH_PCLS_CODE IN ('PS002', 'FAD04', 'FAD03', 'FAD01') then 'P'
             when PEBEMPL_INTERNAL_FT_PT_IND = 'P' then 'P'
             when PEBEMPL_INTERNAL_FT_PT_IND = 'O' then 'O'
             when NBRPOSH.NBRPOSH_ECIP_CODE = '7' then 'O'
             else 'F' end ) = 'O' THEN 'Other'
       WHEN (case when NBRJOBS.NBRJOBS_ECLS_CODE IN ('HC','28','16','13','12','11','PL','DW') then 'P'
             when NBRPOSH.NBRPOSH_PCLS_CODE IN ('PS002', 'FAD04', 'FAD03', 'FAD01') then 'P'
             when PEBEMPL_INTERNAL_FT_PT_IND = 'P' then 'P'
             when PEBEMPL_INTERNAL_FT_PT_IND = 'O' then 'O'
             when NBRPOSH.NBRPOSH_ECIP_CODE = '7' then 'O'
             else 'F' end ) = 'P' THEN 'Part Time'
       ELSE '' END fullOrPartTimeStatus,
       CASE WHEN (nvl(NBRJOBS.NBRJOBS_SAL_TABLE, NBRPOSH.NBRPOSH_TABLE)) = 'NA' THEN ''
       ELSE (nvl(NBRJOBS.NBRJOBS_SAL_TABLE, NBRPOSH.NBRPOSH_TABLE)) END salaryTable,
        case when NBRBJOB.NBRBJOB_IPEDS_REPT_IND = 'Y' then 'True' else 'False' end isIPEDSReportable,
        NBRBJOB.NBRBJOB_CONTRACT_TYPE assignmentTypeRaw,
         NBRJOBS.NBRJOBS_STATUS assignmentStatusRaw,case when NBRJOBS.NBRJOBS_ECLS_CODE IN ('HC','28','16','13','12','11','PL','DW') then 'P'
             when NBRPOSH.NBRPOSH_PCLS_CODE IN ('PS002', 'FAD04', 'FAD03', 'FAD01') then 'P'
             when PEBEMPL_INTERNAL_FT_PT_IND = 'P' then 'P'
             when PEBEMPL_INTERNAL_FT_PT_IND = 'O' then 'O'
             when NBRPOSH.NBRPOSH_ECIP_CODE = '7' then 'O'
             else 'F' end fullOrPartTimeStatusRaw,
             '37ae73e1-cbb3-4250-bfc2-54343450f1af' as tenantId,
    	'770' AS groupEntityExecutionId,
	'09469017-73fe-4421-a352-d76d42e8f89f' as userId,
	'processed-data/37ae73e1-cbb3-4250-bfc2-54343450f1af/16/2019-12-18 19:51:56' AS dataPath
from POSNCTL.NBRJOBS NBRJOBS
inner join POSNCTL.NBRBJOB NBRBJOB on NBRJOBS.NBRJOBS_PIDM = NBRBJOB.NBRBJOB_PIDM and NBRJOBS.NBRJOBS_POSN = NBRBJOB.NBRBJOB_POSN and NBRJOBS.NBRJOBS_SUFF = NBRBJOB.NBRBJOB_SUFF
inner join POSNCTL.NBRPOSH NBRPOSH on NBRJOBS.NBRJOBS_POSN = NBRPOSH.NBRPOSH_POSN
       and NBRPOSH.NBRPOSH_CHANGE_DATE_TIME = (SELECT MAX(NBRPOSH2.NBRPOSH_CHANGE_DATE_TIME)
                                                 FROM POSNCTL.NBRPOSH NBRPOSH2
                                                WHERE NBRPOSH2.NBRPOSH_POSN = NBRPOSH.NBRPOSH_POSN
                                                  and TRUNC(NBRPOSH2.NBRPOSH_CHANGE_DATE_TIME) <= TRUNC(NBRJOBS.NBRJOBS_EFFECTIVE_DATE))
left join POSNCTL.NTRPCLS NTRPCLS on NBRPOSH.NBRPOSH_PCLS_CODE = NTRPCLS.NTRPCLS_CODE
left join PAYROLL.PTRECLS PTRECLS on NBRJOBS.NBRJOBS_ECLS_CODE = PTRECLS.PTRECLS_CODE
left join PAYROLL.PEBEMPL PEBEMPL on NBRJOBS.NBRJOBS_PIDM = PEBEMPL.PEBEMPL_PIDM
order by 1) where fte != 0.167