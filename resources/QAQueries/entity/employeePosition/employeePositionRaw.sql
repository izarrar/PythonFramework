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
       --NBRPOSH.NBRPOSH_ESOC_CODE standardOccupationalCategory,
case when NBRPOSH.NBRPOSH_ESOC_CODE is null then
        case when NTRPCLS.NTRPCLS_ESKL_CODE = '10' then '11-0000'
           when NTRPCLS.NTRPCLS_ESKL_CODE = '20' then '25-1000'
           when NTRPCLS.NTRPCLS_ESKL_CODE = '30' then '13-0000'
           when NTRPCLS.NTRPCLS_ESKL_CODE = '40' then '15-0000'
           when NTRPCLS.NTRPCLS_ESKL_CODE = '50' then '43-0000'
           when NTRPCLS.NTRPCLS_ESKL_CODE = '60' then '21-0000'
           when NTRPCLS.NTRPCLS_ESKL_CODE = '70' then '31-0000'
           when NTRPCLS.NTRPCLS_ESKL_CODE = '80' then '25-2000'           
           when NTRPCLS.NTRPCLS_ESKL_CODE = '90' then '51-0000' 
           when NTRPCLS.NTRPCLS_ESKL_CODE = 'AO' then '41-0000'end
          else NBRPOSH.NBRPOSH_ESOC_CODE end ESOC,
       case when NBRPOSH.NBRPOSH_ACTIVITY_DATE = (select max(NBRPOSH2.NBRPOSH_ACTIVITY_DATE)
                                                    from POSNCTL.NBRPOSH NBRPOSH2
                                                   where NBRPOSH2.NBRPOSH_POSN = NBRPOSH.NBRPOSH_POSN) then NBBPOSN.NBBPOSN_STATUS else null end positionStatus,
--positionStatus enum values Active, Inactive, Cancelled, Frozen
       NBRPOSH.NBRPOSH_ECIP_CODE federalEmploymentCategory,
       NBRPOSH.NBRPOSH_TABLE defaultSalaryTable,
       NBRPOSH.NBRPOSH_GRADE defaultSalaryGrade,
       NBRPOSH.NBRPOSH_STEP defaultSalaryStep,
       NBRPOSH.NBRPOSH_ECLS_CODE defaultEmployeeClass,
       PTRECLS.PTRECLS_SHORT_DESC defaultEmployeeClassDesc,
       NBRPOSH.NBRPOSH_APPT_PCT defaultAppointmentPercent,
       case when NBRPOSH.NBRPOSH_ACTIVITY_DATE = (select max(NBRPOSH2.NBRPOSH_ACTIVITY_DATE)
                                                    from POSNCTL.NBRPOSH NBRPOSH2
                                                   where NBRPOSH2.NBRPOSH_POSN = NBRPOSH.NBRPOSH_POSN) then NBBPOSN.NBBPOSN_COAS_CODE else null end chartOfAccountsId,
       1 isIPEDSReportable  --boolean
from POSNCTL.NBRPOSH NBRPOSH
left join POSNCTL.NBBPOSN NBBPOSN on NBRPOSH.NBRPOSH_POSN = NBBPOSN.NBBPOSN_POSN
left join POSNCTL.NTRPCLS NTRPCLS on NBRPOSH.NBRPOSH_PCLS_CODE = NTRPCLS.NTRPCLS_CODE
left join PAYROLL.PTRECLS PTRECLS on NBRPOSH.NBRPOSH_ECLS_CODE = PTRECLS.PTRECLS_CODE)
where defaultSalaryTable !='NA'