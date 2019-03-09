#!/bin/bash

set -e

if [ "$1" = 'server' ]; then
  shift
  APP_NAME="ghidraSvr"
  APP_LONG_NAME="Ghidra Server"
  MODULE_DIR="Ghidra/Features/GhidraServer"
  WRAPPER_NAME=yajsw-stable-12.12
  SERVICE_NAME=org.rzo.yajsw.$APP_NAME

  # Production Environment
  SCRIPT_DIR=/ghidra/server
  GHIDRA_HOME=/ghidra
  WRAPPER_CONF=/ghidra/server/server.conf
  WRAPPER_HOME="${GHIDRA_HOME}/${MODULE_DIR}/data/${WRAPPER_NAME}"
  OS_DIR="${GHIDRA_HOME}/${MODULE_DIR}/os/linux64"
  CLASSPATH_FRAG="${GHIDRA_HOME}/${MODULE_DIR}/data/classpath.frag"
  LS_CPATH="${GHIDRA_HOME}/support/LaunchSupport.jar"

  if [ ! -d "${WRAPPER_HOME}" ]; then
	  echo "${WRAPPER_HOME} not found" | tee -a "${GHIDRA_HOME}/wrapper.log"
	  exit 1
  fi

  # Get the java that will be used to launch GhidraServer
  JAVA_HOME=$(java -cp "${LS_CPATH}" LaunchSupport "${GHIDRA_HOME}" -java_home)
  if [ ! $? -eq 0 ]; then
	echo "Failed to find a supported Java runtime.  Please refer to the Ghidra Installation Guide's Troubleshooting   section." | tee -a $GHIDRA_HOME/wrapper.log
	  exit 1
  fi
  JAVA_CMD="${JAVA_HOME}/bin/java"

  # Add users
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
  java="${JAVA_CMD}"
  ghidra_home="${GHIDRA_HOME}"
  classpath_frag="${CLASSPATH_FRAG}"
  os_dir="${OS_DIR}"
  # echo "${JAVA_CMD}" -jar "${WRAPPER_HOME}/wrapper.jar" -t "${WRAPPER_CONF}"
  ls -lah /ghidra/server/server.conf
  exec "${JAVA_CMD}" -jar "${WRAPPER_HOME}/wrapper.jar" -t /ghidra/server/server.conf

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