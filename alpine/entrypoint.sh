#!/bin/bash

set -e

if [ "$1" = 'server' ]; then
  shift
  # Add users
  GHIDRA_IP=${GHIDRA_IP:-0.0.0.0}
  echo "GHIDRA_IP: $GHIDRA_IP"
  GHIDRA_USERS=${GHIDRA_USERS:-admin}
  if [ ! -e "/repos/users" ] && [ ! -z "${GHIDRA_USERS}" ]; then
    # Ghidra 12.2+ only processes queued admin commands named seq<16 hex digits>.cmd
    mkdir -p /repos/~admin
    for user in ${GHIDRA_USERS}; do
      echo "Adding user: ${user}"
      echo "-add ${user}" >> /repos/~admin/seq0000000000000001.cmd
    done
  fi
  # Ghidra 12.2+ only accepts network connections when a server keystore is configured
  if [ -n "${GHIDRA_KEYSTORE}" ]; then
    if [ ! -r "${GHIDRA_KEYSTORE}" ]; then
      echo "ERROR: GHIDRA_KEYSTORE=${GHIDRA_KEYSTORE} is not a readable file;" \
        "mount the keystore into the container" >&2
      exit 1
    fi
    if [ -z "${GHIDRA_KEYSTORE_PASSWORD}" ]; then
      echo "ERROR: GHIDRA_KEYSTORE is set but GHIDRA_KEYSTORE_PASSWORD is empty" >&2
      exit 1
    fi
    echo "GHIDRA_KEYSTORE: $GHIDRA_KEYSTORE"
    sed -i -E 's/^#(wrapper\.java\.additional\.[0-9]+=-Dghidra\.(keystore|password)=)/\1/' \
      /ghidra/server/server.conf
  else
    echo "WARNING: GHIDRA_KEYSTORE is not set; the server will only listen on the container's" >&2
    echo "         loopback interface and GHIDRA_IP is ignored (see README)" >&2
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