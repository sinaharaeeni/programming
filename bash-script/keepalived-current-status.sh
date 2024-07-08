#!/bin/sh
# Last modify 2024/02/21
# Version 1.3

TIME=$(date)
HOSTNAME=$(hostname)

echo "$HOSTNAME  $TIME  Event: $1 Instance: $2  State: $3" >> /home/nms-admin/keepalived/status.log

export server_main_backup_status="$3"
echo $server_main_backup_status > /home/nms-admin/keepalived/current_status.log

if [ "$3" = MASTER ]
then
docker service update --replicas=1 alarm-manager
elif [ "$3" = BACKUP ]
then
docker service update --replicas=0 alarm-manager
fi


