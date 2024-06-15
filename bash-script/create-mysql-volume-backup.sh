#!/bin/bash
# Create automatic backup of MySQL volume to tar file
# Last modify 2024/06/15
Version=1.3

# Show file version
if [[ $1 == "-v" || $1 == "--version" ]]; then
    echo "Version $Version"
    exit 0
fi

TIME=$(date)
HOSTNAME=$(hostname)
filename_mysql_config="${HOSTNAME}_mysql-config_`date +%Y`-`date +%m`-`date +%d`_`date +%H`-`date +%M`-`date +%S`.tar";
filename_mysql_data="${HOSTNAME}_mysql-data_`date +%Y`-`date +%m`-`date +%d`_`date +%H`-`date +%M`-`date +%S`.tar";

mkdir -p /root/Backup_MySQL
tar -cvf /root/Backup_MySQL/$filename_mysql_config /var/lib/docker/volumes/mysql_config/_data 
tar -cvf /root/Backup_MySQL/$filename_mysql_data /var/lib/docker/volumes/mysql_data/_data
echo "Bakcup" $HOSTNAME_$TIME "Done!"
