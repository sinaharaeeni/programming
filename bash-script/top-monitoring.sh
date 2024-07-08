#!/bin/sh
# Version 1.0

TIME=$(date)
HOSTNAME=$(hostname)
UPTIME=$(uptime)
PROCTIME=$(cat /proc/uptime)
TOPHEADER=$( top -b -o +RES | head -n 10|tail -1)
TOP=$( top -b -o +RES | head -n 25|tail -15)

echo -e "==========================================================================================================================================================" >> /var/log/sinacomsys/status.log
echo -e "  Hostname  ||             Current Time            ||                                 Uptime                                ||      Proctime" >> /var/log/sinacomsys/status.log
echo -e "----------------------------------------------------------------------------------------------------------------------------------------------------------" >> /var/log/sinacomsys/status.log
echo -e "$HOSTNAME  ||  $TIME  || $UPTIME  ||  $PROCTIME" >> /var/log/sinacomsys/status.log
echo -e "----------------------------------------------------------------------------------------------------------------------------------------------------------" >> /var/log/sinacomsys/status.log
echo -e "$TOPHEADER" >> /var/log/sinacomsys/status.log
echo -e "----------------------------------------------------------------------------------------------------------------------------------------------------------" >> /var/log/sinacomsys/status.log
echo -e "$TOP" >> /var/log/sinacomsys/status.log