 FREEWARE=/opt/freeware/bin
export PATH=$FREEWARE:$PATH
PORTAL_PATH=/applis/asid/weblogic/domaineASI/servers/asidServer01/stage/Portal/Portal
#PORTAL_PATH=/applis/asid/PHPPORTAL
STAGE=/applis/asid/PHPPORTAL
LOGFILE=$STAGE/ENVVALUES.cfg
while read user sgpvalue hkgvalue
do
SGSGP=`ps -fu $user |grep "intraexec.sh.*runBatchDriver.sh " |grep "GSOCGSGSGP" |awk '{print $11 }'|sort -n |tr "\n" ","`
HKHKG=`ps -fu $user |grep "intraexec.sh.*runBatchDriver.sh " |grep "GSOCGHKHKG" |awk '{print $11 }'|sort -n |tr "\n" ","`
#PORTAL_PATH=/applis/asid/weblogic/domaineASI/servers/asidServer01/stage/Portal/Portal
#STAGE=/applis/asid/PHPPORTAL

if  [[ -z $SGSGP ]]
then
STAT=SINOT_RUNNING
SGSGP="INTRA_NOT_STARTED"

#sed -e "s?$sgpvalue?$STAT?" $PORTAL_PATH/test.php >$STAGE/test.php1
sed -i "s?$STAT?$sgpvalue?" $PORTAL_PATH/test.php 
echo "$sgpvalue=$SGSGP" >>$LOGFILE
else
sed -i "s?$sgpvalue?$SGSGP?" $PORTAL_PATH/test.php 
echo "$sgpvalue=$SGSGP" >>$LOGFILE
fi

if  [[ -z $HKHKG ]]
then
STAT=SINOT_RUNNING
HKHKG="INTRA_NOT_STARTED"
#sed -e "s?$hkgvalue??$STAT?" $PORTAL_PATH/test.php 
sed -i "s?$STAT?$hkgvalue?" $PORTAL_PATH/test.php 
echo "$hkgvalue=$HKHKG"  >>$LOGFILE
else
sed -i "s?$hkgvalue?$HKHKG?" $PORTAL_PATH/test.php 
echo "$hkgvalue=$HKHKG"  >>$LOGFILE
fi

#done<$PORTAL_PATH/INTRA.txt
done</applis/asid/PHPPORTAL/INTRA.txt

