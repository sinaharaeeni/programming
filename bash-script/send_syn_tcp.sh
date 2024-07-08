#!/bin/bash

# Check if hping3 is installed
if ! command -v hping3 &> /dev/null
then
    echo "hping3 could not be found, install it."
    sudo apt-get update
    sudo apt-get install -y hping3
fi

# Usage function
usage() {
    echo "Usage: $0 -i <IP> -p <port>"
    exit 1
}

# Parse command line arguments
while getopts ":i:p:" opt; do
  case $opt in
    i) IP="$OPTARG"
    ;;
    p) PORT="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
        usage
    ;;
    :) echo "Option -$OPTARG requires an argument." >&2
       usage
    ;;
  esac
done

# Check if IP and PORT are provided
if [ -z "$IP" ] || [ -z "$PORT" ]; then
    usage
fi

# Send SYN packet
echo "Sending SYN packet to $IP:$PORT"
sudo hping3 -S -p $PORT -c 100 $IP

echo "SYN packet sent. No ACK will be sent."
