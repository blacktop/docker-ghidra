#!/bin/bash

set -e

if [ "$1" = 'server' ]; then
  shift
  # Add users
  GHIDRA_IP=${GHIDRA_IP:-0.0.0.0}
  echo "GHIDRA_IP: $GHIDRA_IP"
  GHIDRA_USERS=${GHIDRA_USERS:-admin}
  if [ ! -e "/repos/users" ] && [ ! -z "${GHIDRA_USERS}" ]; then
    mkdir -p /repos/~admin
    for user in ${GHIDRA_USERS}; do
      echo "Adding user: ${user}"
      echo "-add ${user}" >> /repos/~admin/adm.cmd
    done
  fi
  #----------------------------------------
  # Ghidra Server launch
  #----------------------------------------
  exec env GHIDRA_IP=${GHIDRA_IP} "/ghidra/server/ghidraSvr" console

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
  exec "${SCRIPT_DIR}"/support/launch.sh fg jre Ghidra $MAXMEM "" ghidra.GhidraRun "$@"
fi

exec "$@"