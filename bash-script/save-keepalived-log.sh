#!/bin/sh
# Last modify on 2024/01/07
# Version 1.4

TIME=$(date)
HOSTNAME=$(hostname)

echo "$HOSTNAME $TIME Event: $1 Instance: $2 State: $3" >> /home/nms-admin/keepalived/status-keepalive.log

export server_main_backup_status="$3"
echo $server_main_backup_status > /home/nms-admin/keepalived/current-status.log
