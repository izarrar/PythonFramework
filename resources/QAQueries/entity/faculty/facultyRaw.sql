SELECT PERAPPT.PERAPPT_PIDM personID,
       PERAPPT.PERAPPT_ACTIVITY_DATE recordActivityDate,
       PERAPPT.PERAPPT_DECISION appointmentDecisionRaw, --A - Accepted, N - Not Accepted      
       PERAPPT.PERAPPT_DECISION_DATE appointmentDecisionDate,
       PERAPPT.PERAPPT_BEGIN_DATE appointmentStartDate,
       PERAPPT.PERAPPT_END_DATE appointmentEndDate,
       nvl(PERRANK.PERRANK_RANK_CODE, case when UPPER(PERBFAC_ACADEMIC_TITLE) like '%ADJUNCT%' then 4
                                            when UPPER(PERBFAC_ACADEMIC_TITLE) like '%ASSISTANT%' then 3
                                            when UPPER(PERBFAC_ACADEMIC_TITLE) like '%ASST%' then 3
                                            when UPPER(PERBFAC_ACADEMIC_TITLE) like '%ASSOC%' then 2
                                            when UPPER(PERBFAC_ACADEMIC_TITLE) like '%INSTRUCTOR%' then 4
                                            when UPPER(PERBFAC_ACADEMIC_TITLE) like '%LECTURER%' then 5
                                            when UPPER(PERBFAC_ACADEMIC_TITLE) like '%PROFESSOR%' then 1 else 6 end) facultyRankRaw, --values are 1 - Professor, 2 - Associate Professor, 3 - Assistant Professor, 4 - Instructor, 5 - Lecturer, 6 - Not Assigned
       PERBFAC.PERBFAC_PRIMARY_ACTIVITY primaryActivityRaw, --Administrative,Instructional,Research.
       PERAPPT.PERAPPT_TENURE_CODE tenureStatusRaw, --values are T - Tenure, O - On Track, I - Ineligible, N - Not tenured
       PERAPPT.PERAPPT_TENURE_EFF_DATE tenureEffectiveDate, 
       PERAPPT.PERAPPT_TENURE_REV_DATE tenureReviewDate,
       PERAPPT.PERAPPT_NON_TENURE_CONTRACT nonTenureContractLengthRaw --Valid values are M - Multi-year, A - Annual, L - Less than annual.
FROM PAYROLL.PERAPPT PERAPPT
left join PAYROLL.PERRANK PERRANK on PERAPPT.PERAPPT_PIDM = PERRANK.PERRANK_PIDM and PERRANK.PERRANK_BEGIN_DATE = (SELECT MAX(PERRANK2.PERRANK_BEGIN_DATE)
                                                                                                                    FROM PAYROLL.PERRANK PERRANK2
                                                                                                                    WHERE PERRANK2.PERRANK_PIDM = PERRANK.PERRANK_PIDM
                                                                                                                    AND PERRANK2.PERRANK_BEGIN_DATE <= PERAPPT.PERAPPT_BEGIN_DATE)
left join PAYROLL.PERBFAC PERBFAC on PERAPPT.PERAPPT_PIDM = PERBFAC.PERBFAC_PIDM
order by 1