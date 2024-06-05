import ping3
import re

def get_os_from_ttl(ttl):
    if ttl >= 128:
        return "Windows"
    elif ttl >= 64:
        return "Linux/Unix"
    elif ttl >= 255:
        return "Cisco/Network device"
    else:
        return "Unknown"

def detect_os(ip_addresses):
    os_results = {}
    for ip in ip_addresses:
        try:
            ttl = ping3.ping(ip, unit='ms', timeout=2)
            if ttl is not None:
                # Parse the TTL from the ping response
                # This might vary depending on your implementation and the library details
                # Here, we assume the 'ttl' directly gives us the required TTL value
                os_type = get_os_from_ttl(ttl)
                os_results[ip] = os_type
            else:
                os_results[ip] = "No response"
        except Exception as e:
            os_results[ip] = f"Error: {str(e)}"
    return os_results

if __name__ == "__main__":
    ip_list = [
        "8.8.8.8",  # Example IPs
        "8.8.4.4",
        "192.168.1.1",
        "192.168.1.2",
        # Add more IP addresses as needed
    ]

    os_detected = detect_os(ip_list)
    for ip, os_type in os_detected.items():
        print(f"IP: {ip}, OS: {os_type}")
