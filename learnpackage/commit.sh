#!/bin/bash
#
# Script to Commit the changes to git with proper commit format
#
# echo command
set -e

#Function to print usage/ help message
SCRIPT=`basename ${BASH_SOURCE[0]}`
function usage() {
  echo -e "${SCRIPT} - Commit the changes to git with proper commit format"
  echo -e \\n"Usage: ./scripts/${SCRIPT} [options]"
  echo -e \\n"Example: ./scripts/${SCRIPT} -t commit_type -j jira_ticket_number -m \"commit message description\""
  echo -e \\n"Example: ./scripts/${SCRIPT} -t fix -j 3259 -m \"commit message description\""
  echo ""
  echo "Options"
  echo "======================"
  echo "-t  commit type (eg. 'fix', 'feat', 'docs', 'refactor', 'improvement', 'revert')"
  echo "-j  Jira ticket number eg. '1234', '0000'"
  echo "-m  commit message description (e.g. 'your commit message')"
  echo "-h  help"
  echo ""
  echo "Debugging"
  echo "======================"
  echo "-d debugging turned on aka echoing commands being called"
  exit 1
}

countDown(){
  secs=${1}
  while [[ ${secs} -gt 0 ]]; do
     echo -ne "$secs\033[0K\r"
     sleep 1
     : $((secs--))
  done
}

# Account Details
JIRA_TICKET_NUMBER=
COMMIT_TYPE=
COMMIT_DESCRIPTION=

# Debugging
DEBUGGING="N"


# Parse options
while getopts :t:j:m:dh FLAG; do
  case ${FLAG} in
    t) #Organisation
      COMMIT_TYPE=$OPTARG
      ;;
    j) #Resource Group
      JIRA_TICKET_NUMBER=$OPTARG
      ;;
    m) #Space
      COMMIT_DESCRIPTION=$OPTARG
      ;;
    d) #Enable Debugging
      DEBUGGING="Y"
      ;;
    h) #Help
      usage
      ;;
    \?) #Unrecognised option
      echo -e \\n"\e[1m\e[31mError: Invalid option $OPTARG specified\e[39m"
      usage
      ;;
  esac
done

# Turn on debugging
if [[ "$DEBUGGING" == "Y" ]]; then
   echo "Enabling Debug Mode"
   set -x #echo on
fi

#Check for mandatory options
if [[ -z "$COMMIT_TYPE" ]]; then
  echo -e "Error: No commit type specified aka -t fix"\\n && usage
fi
if [[ -z "$JIRA_TICKET_NUMBER" ]]; then
  echo -e "Error: No jira ticker number specified aka -j 0000"\\n && usage
fi
if [[ -z "$COMMIT_DESCRIPTION" ]]; then
  echo -e "Error: No commit message description specified aka -m \"commit message\""\\n && usage
fi

COMMIT_MESSAGE="${COMMIT_TYPE}([AIMLCOE-${JIRA_TICKET_NUMBER}](https://AAKASH-${JIRA_TICKET_NUMBER})): ${COMMIT_DESCRIPTION}"

echo "Commit message : ${COMMIT_MESSAGE}"
read -p "Do you want to commit the changes with above commit message (y/n): " CONFIRM_COMMIT
echo $CONFIRM_COMMIT
if [[ ${CONFIRM_COMMIT} == "y"  ]]; then
  git commit -m "${COMMIT_MESSAGE}" --no-verify
fi

