#!/bin/sh
# Version 1.2
# DWDM-NMS-1

TIME=$(date)
HOSTNAME=$(hostname)
 
export main_backup_status=$(head -n 1 /etc/sinacomsys/current-status.log)

if [ "$main_backup_status" = "MASTER" ]
then
echo "$TIME $HOSTNAME Is Master." >> /etc/sinacomsys/rsync-status.log

elif [ "$main_backup_status" = "BACKUP" ]
then
rsync -a root@192.168.100.12:/var/lib/docker/volumes/mysql_data/_data /var/lib/docker/volumes/mysql_data/
rsync -a root@192.168.100.12:/var/lib/docker/volumes/mysql_config/_data /var/lib/docker/volumes/mysql_config/
docker service update --force mysql
echo "$TIME $HOSTNAME Is Backup and copy file from NMS-2." >> /etc/sinacomsys/rsync-status.log
fi
