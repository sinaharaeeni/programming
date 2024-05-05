#!/bin/bash
# Last modify 2024/05/05
# Version 2.1
# With this script can create script file

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

# Define enviorment
ScriptName="$1"
CreateDate="`date +%Y`/`date +%m`/`date +%d`";
Version="1.0"

# Create file and put template
touch $ScriptName.sh
echo "#!/bin/bash" > $ScriptName.sh
echo "# Created on: $CreateDate" >> $ScriptName.sh
echo "# Last modify: 0/0/0" >> $ScriptName.sh
echo "# Description: " >> $ScriptName.sh
echo "# Version: $Version " >> $ScriptName.sh

# Change execute permision for created file
chmod +x $ScriptName.sh

# Verify created file
if ls $ScriptName.sh ; then
    echo -e "${GREEN}Script $ScriptName.sh created successfully. ${RESET}"
    exit 0
    else
    echo -e "${RED}Problem! ${RESET}"
    exit 1
fi