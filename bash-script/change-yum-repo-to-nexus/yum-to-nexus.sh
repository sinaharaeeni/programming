#!/bin/bash
# lasrt modify on 2024/07/08
# Version 1.2

mv -v nexus-repolist/* /etc/yum.repos.d/ && rm -rf nexus-repolist

for nexus_repo in $(ls /etc/yum.repos.d | grep nexus )
do {
  chmod 644 /etc/yum.repos.d/$nexus_repo
}
done

for photon_repo in $(ls /etc/yum.repos.d | grep photon )
do {
  sed -i "s|enabled=1|enabled=0|g" /etc/yum.repos.d/$photon_repo
}
done

yum clean all

yum makecache
