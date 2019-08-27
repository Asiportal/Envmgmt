export PATH=/opt/freeware/bin:$PATH

PORTAL_PATH=/applis/asid/weblogic/domaineASI/servers/asidServer01/stage/Portal/Portal
STAGE=/applis/asid/PHPPORTAL
cd $STAGE
LOGFILE=$STAGE/ENVVALUES.cfg
rm -f $LOGFILE
rm -f test.php
cd $PORTAL_PATH
rm -f test.php Dashboard.html
cd $STAGE
cp test.php_ORIG $STAGE/test.php
cp Dashboard.php_ORIG  $PORTAL_PATH/Dashboard.html
cp test.php_ORIG  $PORTAL_PATH/test.html
cp add.html index.php Login.html $PORTAL_PATH
nohup sh $STAGE/DB.sh >Nohup_db.log &
nohup sh $STAGE/INTRACHEK.sh nohyo_INTRACHEK.log &

while read env olversion batversion siversion admserver admserstat mangserver server sgfl sgmq hkfl hkmq bgjob batlog xxx latestrel envstate
do

cd /applis/$env/weblogic/domaineASI

#ONL_VER=$(awk -F"=" '{print $1 }' BancsOnline.version)
ONL_VER=$(cat BancsOnline.version)
sed -i "s@$olversion@$ONL_VER@" $STAGE/test.php
echo "$olversion=$ONL_VER "  >>$LOGFILE
sed -i "s@$olversion@$ONL_VER@" $PORTAL_PATH/Dashboard.html
cd /applis/$env/Batch
BAT_VER=$(cat BancsBatches.version)
sed -i "s@$batversion@$BAT_VER@" $STAGE/test.php
echo "$batversion=$BAT_VER"  >>$LOGFILE
cd /applis/$env/SI 
SI_VER=$(cat BancsSI.version | cut -c 33-)
sed -i "s@$siversion@$SI_VER@" $STAGE/test.php 
echo "$siversion=$SI_VER"  >>$LOGFILE

#ls -ltr  $ONLNHOME/BancsOnline.version $BATCHHOME/BancsBatches.version $SIHOME/BancsSI.version |awk '{print $9}' |tail -1 | awk '{print "cat",$1 }' | sh |cut -c 4- 
Latest_release=$(ls -ltRr  /applis/$env/weblogic/domaineASI/BancsOnline.version /applis/$env/Batch/BancsBatches.version /applis/$env/SI/BancsSI.version |tail -1 | awk '{print "cat",$9 }' | sh |awk -F"=" '{print $NF }')

echo "$latestrel:$Latest_release" >$STAGE/envdab.log
sed -i "s@$latestrel@$Latest_release@" $PORTAL_PATH/Dashboard.html
echo "$latestrel=$Latest_release" >>$LOGFILE
cd /applis/$env/weblogic/domaineASI/logs
ADM_SER=$(grep "<BEA-000365>" $admserstat |tail -1 |awk '{print $NF }' |tr -d ".>")

#ADM_STAT=(basename $admserstat .out )
#ADM_PRC_CNT=$( ps -fu $env"adm" |grep weblogic |grep $ADM_STAT |wc -l )
#ADM_SER="RUNNING"
#if [[ $ADM_PRC_CNT == "0" ]]
#then
#ADM_SER="FAIL"
#fi 

sed -i "s@$admserver@$ADM_SER@" $STAGE/test.php
echo "$admserver=$ADM_SER" >>$LOGFILE
cd /applis/$env/weblogic/domaineASI/logs
#MANG_SER=$(grep state $server |tail -1 |cut -c 100-106)
#MANG_SER=$(grep "<BEA-000365>" $server |tail -1 |awk '{print $NF }' |tr -d ".>")
MANG_SER=$(ps -fu $env"adm"|grep "weblogic" |grep $env"Server01" |awk '{print  $2 }')



if [[ -z $MANG_SER ]]
then
ISTAT=NOTRUNNING
echo "$mangserver=$ISTAT" >>$LOGFILE
else
ISTAT=RUNNING
echo "$mangserver=$ISTAT" >>$LOGFILE
#ENVSTATE=$(grep "<BEA-000365>" $server |tail -1 |awk '{print $NF }' |tr -d ".>")
sed -i "s@$mangserver@$MANG_SER@" $STAGE/test.php
#echo "$mangserver=$MANG_SER" >>$LOGFILE
fi
cd /applis/$env/SI/tmp
SGSGPFL=$(cat eaiapp_SGSGPFL.pid)
SGSGPMQ=$(cat eaiapp_SGSGPMQ.pid)
HKHKGFL=$(cat eaiapp_HKHKGFL.pid)
HKHKGMQ=$(cat eaiapp_HKHKGMQ.pid)

if [[ -f eaiapp_SGSGPFL.pid  ]] || [[ -f eaiapp_SGSGPMQ.pid  ]] || [[ -f eaiapp_HKHKGFL.pid  ]] || [[ -f eaiapp_HKHKGMQ.pid  ]]
#then

#if [[ -n $(ps -fu $USER |grep "$SGSGPFL" |grep -v grep) ]] || [[ -n $(ps -fu $USER |grep "$SGSGPMQ"|grep -v grep) ]] || [[ -n $(ps -fu $USER |grep "$HKHKGFL"|grep -v grep) ]] || [[ -n $(ps -fu $USER |grep "$HKHKGMQ"|grep -v grep) ]]
       then
        STAT=RUNNING
#sed -i "s@$sgfl@$STAT@" "s@$sgmq@$STAT@" "s@$hkfl@$STAT@" "s@$hkmq@$STAT@" $STAGE/test.php

#echo "sed -i "s@$sgfl@$STAT@" $STAGE/test.php"
#echo "sed -i "s@$sgmq@$STAT@" $STAGE/test.php"
#echo "sed -i "s@$hkfl@$STAT@" $STAGE/test.php"
#echo "sed -i "s@$hkfl@$STAT@" $STAGE/test.php"

sed -i "s@$sgfl@$STAT@" $STAGE/test.php
sed -i "s@$sgmq@$STAT@" $STAGE/test.php
sed -i "s@$hkfl@$STAT@" $STAGE/test.php
sed -i "s@$hkmq@$STAT@" $STAGE/test.php
echo "$sgfl=$STAT" >>$LOGFILE
echo "$sgmq=$STAT" >>$LOGFILE
echo "$hkfl=$STAT"  >>$LOGFILE
echo "$hkmq=$STAT"  >>$LOGFILE 
else
STAT="NOT_RUNNING"
sed -i "s@$sgfl@$STAT@" $STAGE/test.php
sed -i "s@$sgmq@$STAT@" $STAGE/test.php
sed -i "s@$hkfl@$STAT@" $STAGE/test.php
sed -i "s@$hkmq@$STAT@" $STAGE/test.php
echo "$sgfl=$STAT" >>$LOGFILE
echo "$sgmq=$STAT" >>$LOGFILE
echo "$hkfl=$STAT"  >>$LOGFILE
echo "$hkmq=$STAT"  >>$LOGFILE

#fi
fi
cd /applis/$env/Batch/tmp
BGJOB=$(cat BACKGROUNDJOB.pid)
if [[ -f BACKGROUNDJOB.pid  ]]
then
STAT=RUNNING
#echo "sed -i "s@$bgjob@$STAT@" $STAGE/test.php   $env"
sed -i "s@$bgjob@$STAT@" $STAGE/test.php
echo "$bgjob=$STAT" >>$LOGFILE
else
STAT="NOT_RUNNING"
sed -i "s@$bgjob@$STAT@" $STAGE/test.php
echo "$bgjob=$STAT" >>$LOGFILE
fi


cd /applis/$env/Batch/logs
BATLOGS=$(cat BatchMonitorLog_`date +%d%m%Y`.log)
#echo "$(cat BatchMonitorLog_`date +%d%m%Y`.log)"
if [[ -f BatchMonitorLog_`date +%d%m%Y`.log  ]]
then
#echo "sed -i "s@$batlog@$STAT@" $STAGE/test.php   $env"
sed -i "s@$batlog@$BATLOGS@" $STAGE/test.php
#echo "$batlog=$BATLOGS" >>$LOGFILE
fi

FSCHECK=$(df -k  /applis/$env | grep / | awk '{ print $5}' | sed 's/%//g')
echo "$env=$FSCHECK" >>$LOGFILE


done</applis/asid/PHPPORTAL/simple.cfg

cd /applis/asid/PHPPORTAL
#cp test.sh /applis/asid/weblogic/domaineASI/servers/asidServer01/stage/Portal/Portal/
#sh $STAGE/INTRACHEK.sh
cd /applis/asid/PHPPORTAL
#sh $STAGE/DB.sh

/opt/freeware/bin/sed -i "s/#//g" $LOGFILE
