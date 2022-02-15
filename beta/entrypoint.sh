#!/bin/bash

set -e

if [ "$1" = 'server' ]; then
  shift
  # Add users
  GHIDRA_USERS=${GHIDRA_USERS:-admin}
  GHIDRA_IP=${GHIDRA_IP:-0.0.0.0}
  
  if [ -e "/repos/users" ]; then
    SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
    IFS=$'\n'      # Change IFS to newline char
    existing_users=$(cut -d ':' -f 1 /repos/users) #get list of existing users
    IFS=$SAVEIFS   # Restore original IFS
  else
    existing_users=()
  fi
  if [[ ! -z "${GHIDRA_USERS}" ]]; then
    mkdir -p /repos/~admin
    for user in ${GHIDRA_USERS}; do
      if [[ ! ${existing_users} =~ ${user} ]]; then
        echo "Adding user: ${user}"
        echo "-add ${user}" >> /repos/~admin/adm.cmd
      fi
    done
    for user in ${existing_users}; do
      if [[ ! ${GHIDRA_USERS} =~ ${user} ]]; then
        echo "Removing user: ${user}"
        echo "-remove ${user}" >> /repos/~admin/adm.cmd
      fi
    done
  fi
  #----------------------------------------
  # Ghidra Server launch
  #----------------------------------------
  exec "/ghidra/server/ghidraSvr" console

elif [ "$1" = 'client' ]; then
  shift
  #----------------------------------------
  # Ghidra launch
  #----------------------------------------
  SCRIPT_DIR=/ghidra
  SCRIPT_FILE=/ghidra/ghidraRun
  # Maximum heap memory may be changed if default is inadequate. This will generally be up to 1/4 of
  # the physical memory available to the OS. Uncomment MAXMEM setting if non-default value is needed.
  MAXMEM=${MAXMEM:-768M}
  # Launch Ghidra
  exec "${SCRIPT_DIR}"/support/launch.sh fg Ghidra $MAXMEM "" ghidra.GhidraRun "$@"
fi

exec "$@"
