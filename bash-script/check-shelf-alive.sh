#!/bin/bash
# For check shelf alive with ping
# Last modify 2024/06/15
Version=1.1

# Show file version
if [[ $1 == "-v" || $1 == "--version" ]]; then
    echo "Version $Version"
    exit 0
fi

dead_hosts=""

for oct3 in {10..91}; do
  for oct4 in {1..28}; do
      ip="192.168.$oct3.$oct4"
      if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
          echo "$ip is alive"
      else
          dead_hosts+=" $ip"
      fi
  done
done

echo "Dead hosts:$dead_hosts"
