#!/bin/bash

# logger levels to be used in code
LOGGER_TRACE=0
LOGGER_DEBUG=1
LOGGER_INFO=2
LOGGER_WARN=3
LOGGER_ERROR=4

# if main debug levelk not defined, default to LOGGER_ERROR
if [ "x$SCRIPTS_LOGGER_LEVEL" == "x" ]; then
    SCRIPTS_LOGGER_LEVEL=$LOGGER_INFO
fi

# logger function
function logger() {
    local level=$1;
    local message=$2;
    if [[ $level -ge $SCRIPTS_LOGGER_LEVEL ]]; then
        echo "[ $level ] - ${message}"
    fi
}

logger_with_headers() {
    local level=$1;
    logger $level "##########################################################"
    logger "$@"
    logger $level "##########################################################"
}

exec_ansible_playbook() {
    playbook="$1"
    args="$2"
    logger_with_headers $LOGGER_INFO "Running $playbook ..."
    
    if [ "x${apigw_configurator_ansible_args}" != "x" ]; then
        args="${args} ${apigw_configurator_ansible_args}"
    fi
    
    ansible-playbook $args $playbook
    exit_on_error "$?" "ansible-playbook $args $playbook"
}

exit_trap () {
  local lc="$BASH_COMMAND" rc=$?
  echo "Command [$lc] exited with code [$rc]"
}

exit_on_error() {
    exit_code=$1
    last_command=${@:2}
    if [ $exit_code -ne 0 ]; then
        logger_with_headers $LOGGER_ERROR "\"${last_command}\" command failed with exit code ${exit_code}. Exiting program!!"
        exit $exit_code
    fi
}