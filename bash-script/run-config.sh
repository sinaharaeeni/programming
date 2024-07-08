#!/bin/bash
# last modify on 2023/10/24
# Version 4.6

error_message() {
echo "----------------------------------"
echo "This script build for PhotonOS or Ubuntu. "
echo "First argument: Hostname."
echo "Second argument: IP Address."
echo "Third argument: Gateway Address."
echo "Fourth argument: NTP Address."
echo "Example: ./run-config VM-Test 192.168.3.27/20 192.168.1.1 192.168.1.2"
echo "----------------------------------"
exit 0
};

# check and verify input environment
## check enter hostname
if [ -z "$1" ]
then
error_message;
else
HOST_NAME=$1;
fi

## check enter ip address
if [ -z "$2" ]
then
error_message;
else
IP_ADDRESS=$2;
fi

## check enter gateway address
if [ -z "$3" ]
then
error_message;
else
GATEWAY_ADDRESS=$3;
fi

## check enter ntp server
if [ -z "$4" ]
then
error_message;
else
NTP_ADDRESS=$4;
fi

# add static dns
echo 192.168.5.61 repo.sinacomsys.local >> /etc/hosts
echo 192.168.5.54 nfs.sinacomsys.local >> /etc/hosts

# check os distribution
## change on photon os
if (uname -rv | grep -E 'photon') ; then {

### change default yum repository
cp -r configuration-file/yum-nexus/* /etc/yum.repos.d/
sed -i "s|enabled=1|enabled=0|g" /etc/yum.repos.d/photon-*

### install and update package
yum clean all && yum update -y && tdnf update
yum install -y \
apache-maven \
audit \
cronie \
curl \
fail2ban \
htop \
iotop \
iperf \
iproute2 \
iptraf-ng \
jq \
keepalived \
man-pages \
nano \
netkit-telnet \
net-snmp \
net-snmp-perl \
nmap \
ntp \
openjdk11 \
openjdk11-src \
python3 \
python3-pexpect \
python3-pip \
rsync \
tar \
tcpdump \
tmux \
traceroute \
tree \
unzip \
wget \
wireshark

# Remove a package and its automatic dependencies
yum autoremove -y

### change default name
sed -i "s|PhotonOS|$HOST_NAME|g" /etc/hosts

### change ip address and gateway
sed -i "s|192.168.3.27/20|$IP_ADDRESS|g" /etc/systemd/network/88-static-en.network
sed -i "s|192.168.3.70|$GATEWAY_ADDRESS|g" /etc/systemd/network/88-static-en.network
systemctl restart systemd-networkd

## change on ubuntu
} elif (uname -rv | grep -E 'Ubuntu') ; then {

### change default apt repository
cp /etc/apt/sources.list /etc/apt/sources.list.org
sed -i "s|http://archive.ubuntu.com/ubuntu|http://repo.sinacomsys.local:9099/repository/apt-hosted/|g" /etc/apt/sources.list
sed -i "s|http://us.archive.ubuntu.com/ubuntu|http://repo.sinacomsys.local:9099/repository/apt-hosted/|g" /etc/apt/sources.list
sed -i "s|http://ir.archive.ubuntu.com/ubuntu|http://repo.sinacomsys.local:9099/repository/apt-hosted/|g" /etc/apt/sources.list

### install and update package
apt clean all && apt update && apt upgrade -y
apt install -y \
docker.io \
htop \
iotop \
iperf \
keepalived \
nfs-common \
nmap \
ntp \
progress \
pv \
pip \
python3 \
python3-pexpect \
python3-pip \
rsync \
tar \
traceroute \
tcpdump \
tmux \
traceroute \
tree \
wget \
wireshark

# Remove a package and its automatic dependencies
apt autoremove -y

### change default name
sed -i "s|ubuntu|$HOST_NAME|g" /etc/hosts

### change ip address and gateway
sed -i "s|192.168.3.28/20|$IP_ADDRESS|g" /etc/netplan/00-installer-config.yaml
sed -i "s|192.168.3.70|$GATEWAY_ADDRESS|g" /etc/netplan/00-installer-config.yaml
systemctl sudo netplan apply

}
else
error_message;
fi

# reload daemon
systemctl daemon-reload

# cleanup vm with cloud-init
cloud-init clean

### allow root user to ssh
sed -i "s|#Port 22|Port 22|g" /etc/ssh/sshd_config
sed -i "s|#PermitRootLogin prohibit-password|PermitRootLogin yes|g" /etc/ssh/sshd_config
sed -i "s|PermitRootLogin no|PermitRootLogin yes|g" /etc/ssh/sshd_config
if [[ $(sshd -t) -eq 0 ]]; then
    systemctl restart sshd.service
fi

# change default hostname
hostnamectl set-hostname $HOST_NAME

# change default timezone
timedatectl set-timezone "Asia/Tehran"

# enable ntp client
timedatectl set-ntp true
## change ntp server address
sed -i "s|#NTP=|NTP=$NTP_ADDRESS|g" /etc/systemd/timesyncd.conf
## restart ntp service
systemctl restart systemd-timesyncd

# copy keepalived config and restart service
cp -r configuration-file/keepalived.conf /etc/keepalived/
systemctl restart keepalived.service

# copy script in sinacomsys folder
mkdir -p /etc/sinacomsys/
cp -r script/ /etc/sinacomsys/
chmod +x /etc/sinacomsys/save-keepalived-log.sh

# config firewall
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -p vrrp -j ACCEPT
iptables -A INPUT -p tcp --dport 2375 -j ACCEPT
iptables -A INPUT -p tcp --dport 2376 -j ACCEPT
iptables -A INPUT -p tcp --dport 2377 -j ACCEPT
iptables -A INPUT -p tcp --dport 7946 -j ACCEPT
iptables -A INPUT -p udp --dport 7946 -j ACCEPT
iptables -A INPUT -p udp --dport 4789 -j ACCEPT
iptables-save > /etc/systemd/scripts/ip4save

# change default python repository to nexus
pip config --global set global.index-url http://repo.sinacomsys.local:9099/repository/pypi-group/simple/
pip config --global set global.trusted-host repo.sinacomsys.local

# disable swap
swapoff -a

# copy docker daemon
mkdir -p /etc/docker/
cp -r configuration-file/daemon.json /etc/docker/

# start docker service
systemctl start docker.service

# enable docker service
systemctl enable docker.service
systemctl enable docker.socket

# remove defualt docker network
docker network rm docker_gwbridge | true

# create docker network
docker network create --subnet 10.203.0.0/24 --opt com.docker.network.bridge.name=docker_gwbridge --opt com.docker.network.bridge.enable_icc=false docker_gwbridge

# create docker volume
docker volume create portainer_data
docker volume create dwdm_mysql_config
docker volume create dwdm_prometheus_config

# copy mysql config
cp -r configuration-file/my.cnf /var/lib/docker/volumes/dwdm_mysql_config/_data/
chown root:root /var/lib/docker/volumes/dwdm_mysql_config/_data/my.cnf
cp -r configuration-file/prometheus.yml /var/lib/docker/volumes/dwdm_prometheus_config/_data/
chown root:root /var/lib/docker/volumes/dwdm_prometheus_config/_data/prometheus.yml

# config docker swarm
docker swarm leave --force
docker swarm init

# create docker monitoring network
docker network create sina-monitoring-network --driver overlay

# create portainer service
docker service create \
--name portainer \
--publish published=9094,target=8000 \
--publish published=9095,target=9443  \
--mount type=volume,source=portainer_data,destination=/data \
--mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock \
--limit-cpu "1" \
--limit-memory "1G" \
repo.sinacomsys.local:8082/general/portainer/portainer-ee:2.19.4

# Portainer Business Edition license key: 2-b0J7zhmwjsS0IkJjo9dK+pjPBZyvfsfFuKrK3bE+B9ieoMjf/HZ/4loYvSi5MoBV8H1MMA2b/Vc=

# docker stack deploy --compose-file dwdm-nms_v-2.5.yml --orchestrator swarm --prune --resolve-image changed --with-registry-auth dwdm

echo " Creating report ..."
date >> report.txt
echo "===========================================================================================" >> report.txt
hostname >> report.txt
echo "===========================================================================================" >> report.txt
lsmem >> report.txt
echo "===========================================================================================" >> report.txt
lscpu >> report.txt
echo "===========================================================================================" >> report.txt
lsblk >> report.txt
echo "===========================================================================================" >> report.txt
docker images >> report.txt
echo "===========================================================================================" >> report.txt
docker service ls >> report.txt
echo "===========================================================================================" >> report.txt
