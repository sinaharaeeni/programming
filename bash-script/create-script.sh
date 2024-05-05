#!/bin/bash
# with this script can create script

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Check if a filename is provided as an argument
if [ $# -eq 0 ]; then
    echo -e "${RED}Usage: $0 <script name> ${RESET}"
    exit 1
fi

# Define script name from input
ScriptName="$1"

# Create file and put template
touch $ScriptName.sh
echo "#!/bin/bash" > $ScriptName.sh

if ls $ScriptName.sh ; then
    echo -e "${GREEN}Script $ScriptName.sh created successfully. ${RESET}"
    exit 0
    else
    echo -e "${RED}Problem! ${RESET}"
    exit 1
fi