select SIRASGN.SIRASGN_PIDM personId,
SIRASGN.SIRASGN_ACTIVITY_DATE recordActivityDate,
SIRASGN.SIRASGN_TERM_CODE termCode,
SIRASGN.SIRASGN_CRN crn,
SIRASGN.SIRASGN_PERCENT_RESPONSE instructorPercent
from SATURN.SIRASGN SIRASGN
ORDER BY 1, 3