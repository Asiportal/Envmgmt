#!/bin/ksh


export TNS_ADMIN=/applis/asid/PHPPORTAL
SCHEMA_LIVE=onln
PASSWORD_LIVE=bancs

# Environment Variable check
ENV=$1
FLIP_DATE=$2

case $ENV in
     ASIA)     ORACLE_SID="DASIA6LI" ;;
     ASID)     ORACLE_SID="DASID6LI" ;;
     ASIM)     ORACLE_SID="DASIM6LI" ;;
     ASII)     ORACLE_SID="DASII6LI" ;;
     ASIU)     ORACLE_SID="DASIU6LI" ;;
     ASIV)     ORACLE_SID="DASIV6LI" ;;
     *)     echo "Environment is not available : $ENV"
      exit 1
esac


sqlplus -s $SCHEMA_LIVE/$PASSWORD_LIVE@$ORACLE_SID<<EOF>update.log
update qz_dates set qz_dt=to_date('$FLIP_DATE','MM/DD/YYYY');
update qz_dates_back  set qz_dt=to_date('$FLIP_DATE','MM/DD/YYYY');
commit;
EOF
cat update.log
