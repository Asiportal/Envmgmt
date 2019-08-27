export PATH=/opt/freeware/bin:$PATH

 FREEWARE=/opt/freeware/bin
export PATH=$FREEWARE:$PATH
STAGE=/applis/asid/PHPPORTAL
PORTAL_PATH=/applis/asid/weblogic/domaineASI/servers/asidServer01/stage/Portal/Portal
LOGFILE=$STAGE/ENVVALUES.cfg

function db_data
{
#. /$APP_EXE/common/.setoraclepasswd
SCHEMA_LIVE=onln
ORACLE_PASSWD_LIVE=bancs
DB_DNAME=$1
PARAM=$2
echo "DB name : $DB_DNAME"
echo 
sqlplus -s  ${SCHEMA_LIVE}/${ORACLE_PASSWD_LIVE}@$DB_DNAME<<EOF >Db.log
set pagesize 0 feedback off verify off heading off echo off;
select '$DB_DNAME'||' '||OU_ID||' ' ||to_char(QZ_DT,'DD-MON-YY') from qz_dates where OU_ID <>'G';
EOF
cat Db.log
}

export TNS_ADMIN=/applis/asid/PHPPORTAL/

while read envname dbname Globaldate sgpdate hkgdate
do

db_data $dbname

GLOBALDATE=$(awk '{print $3}' Db.log|head -1)
GLOBALSGP=$(awk '{print $3}' Db.log|head -3|tail -1)
GLOBALHKG=$(awk '{print $3}' Db.log|head -2|tail -1)
if [[ -n $GLOBALDATE ]]
then
sed -i "s?$Globaldate?$GLOBALDATE?"   $PORTAL_PATH/test.php
sed -i "s?$Globaldate?$GLOBALDATE?"   $PORTAL_PATH/Dashboard.html
echo "$Globaldate=$GLOBALDATE" >>$LOGFILE
fi

if [[ -n $GLOBALSGP ]]
then
sed -i "s?$sgpdate?$GLOBALSGP?" $PORTAL_PATH/test.php
echo "$sgpdate=$GLOBALSGP"  >>$LOGFILE
fi
if [[ -n $GLOBALHKG ]]
then
sed -i "s?$hkgdate?$GLOBALHKG?" $PORTAL_PATH/test.php
echo "$hkgdate=$GLOBALHKG" >>$LOGFILE
fi

echo "$GLOBALDATE****"
#echo "Env name : $envname"
#db_data $dbname





#echo "========================="
done<$STAGE/db.cfg
