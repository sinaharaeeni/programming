# OS Detection from TTL Values

This Python script detects the operating system of devices based on the Time-To-Live (TTL) values from a list of IP addresses.

## Prerequisites

- Python 3.x
- `ping3` library

## Installation

1. Clone the repository or download the script.

2. Install the required Python package:
    ```bash
    pip install ping3
    ```

## Usage

1. Edit the `detect_os.py` script to include the list of IP addresses you want to check.

2. Run the script:
    ```bash
    python3 detect_os.py
    ```

3. The script will output the detected operating system for each IP address.

## Script Explanation

- **`get_os_from_ttl(ttl)`**: Determines the OS based on the TTL value.
- **`detect_os(ip_addresses)`**: Sends a ping to each IP address, retrieves the TTL value, and infers the OS.
- **`ping3.ping(ip)`**: Sends a ping request to the specified IP address.

### Example

Here is an example output for a list of IP addresses:

```plaintext
IP: 8.8.8.8, OS: Linux/Unix
IP: 8.8.4.4, OS: Linux/Unix
