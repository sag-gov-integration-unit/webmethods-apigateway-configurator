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
        echo "[ $level ] - MSG: ${message}"
    fi
}

logger_with_headers() {
    local level=$1;
    logger $level "##########################################################"
    logger "$@"
    logger $level "##########################################################"
}

exec_ansible_playbook() {
    local playbook=$1
    local args=""
    logger_with_headers $LOGGER_INFO "Running $playbook ..."
    
    if [ "${apigw_configurator_debug}" == "true" ]; then
        args="${args} -vvv"
    fi
    
    if [ "x${apigw_configurator_ansible_args}" != "x" ]; then
        args="${args} ${apigw_configurator_ansible_args}"
    fi
    
    ansible-playbook $args $playbook
}

exit_on_error() {
    exit_code=$1
    last_command=${@:2}
    if [ $exit_code -ne 0 ]; then
        >&2 echo "\"${last_command}\" command failed with exit code ${exit_code}. Exiting program!!"
        exit $exit_code
    fi
}