#!/usr/bin/env bash

# NO WARRANTY. THIS DEFENSE INNOVATION UNIT MATERIAL MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING,
# BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE
# OF THE MATERIAL. THE DEFENSE INNOVATION UNIT DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM
# PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.

function main {
  local SCRIPT_ABS_PATH="$( cd -- "$(/bin/dirname "$0")" > /dev/null 2>&1 ; /bin/pwd -P )"
  local SOURCE_ABS_PATH=${1:-${SCRIPT_ABS_PATH}/.env}
  local TARGET_ABS_PATH=${2:-${SCRIPT_ABS_PATH}/.env.make}

  # Configure this shell environment with .env; pass-through default variable resolutions provided by host environment
  source <(/bin/grep -vE "^$|^\s*#" ${SOURCE_ABS_PATH} | /bin/sed 's/^/export /')

  # - Retain a list of the specific .env variable declarations
  ENV_VARS=($(/bin/grep -vE "^$|^\s*#" ${SOURCE_ABS_PATH} | /bin/sed 's/^\(.*\)=.*$/\1/'))

  # Create intermediate environmental make under 'include' := specification
  /bin/echo "# Procedurally Generated Makefile Execution Environmental Variables" > ${TARGET_ABS_PATH}
  /bin/echo "#  - source: ${SOURCE_ABS_PATH}" >> ${TARGET_ABS_PATH}
  /bin/echo "#  - target: ${TARGET_ABS_PATH}" >> ${TARGET_ABS_PATH}
  /bin/echo "" >> ${TARGET_ABS_PATH}
  for ENV_VAR in "${ENV_VARS[@]}"
  do
    /bin/echo "export ${ENV_VAR}:=${!ENV_VAR}" >> ${TARGET_ABS_PATH}
  done

}

main "$@"