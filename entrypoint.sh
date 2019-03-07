#!/bin/bash

#----------------------------------------
# Ghidra launch
#----------------------------------------

# Maximum heap memory may be changed if default is inadequate. This will generally be up to 1/4 of
# the physical memory available to the OS. Uncomment MAXMEM setting if non-default value is needed.
MAXMEM=${MAXMEM:-768M}

SCRIPT_FILE=/ghidra/ghidraRun
SCRIPT_DIR=/ghidra

# Launch Ghidra
exec "${SCRIPT_DIR}"/support/launch.sh fg Ghidra $MAXMEM "" ghidra.GhidraRun "$@"