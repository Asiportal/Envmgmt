#!/bin/ksh
#Injecting the script for multiple Environments


#Variables

ENV=$1
V_INTERFACE=$2
V_FILENAME=$3

V_INT=$(echo $V_INTERFACE | cut -c 1-5 )
V_TYPE=$(echo $V_INTERFACE | cut -c 6-7 )
V_OU=$(echo $V_INTERFACE | cut -c 9- )

if [[ $V_TYPE == "FL" ]];then
	V_TYPE=FILE
fi

#variable is done

chmod 777 $V_FILENAME

case $ENV in
     ASIA)     sudo su asidadm -c /applis/asia/SI/bin/injectmsg $V_OU $V_TYPE $V_INT $V_FILENAME ;; 
     ASID)     sudo su asidadm -c /applis/asid/SI/bin/injectmsg $V_OU $V_TYPE $V_INT $V_FILENAME ;;
     ASIM)     sudo su asidadm -c /applis/asim/SI/bin/injectmsg $V_OU $V_TYPE $V_INT $V_FILENAME ;;
     ASII)     sudo su asidadm -c /applis/asii/SI/bin/injectmsg $V_OU $V_TYPE $V_INT $V_FILENAME ;; 
     ASIU)     sudo su asidadm -c /applis/asiu/SI/bin/injectmsg $V_OU $V_TYPE $V_INT $V_FILENAME ;;
     ASIV)     sudo su asidadm -c /applis/asiv/SI/bin/injectmsg $V_OU $V_TYPE $V_INT $V_FILENAME ;;
     *)     echo "Environment is not available : $ENV"
      exit 1
esac
