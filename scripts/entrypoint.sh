#!/bin/sh

## common
if [ -f ./common.sh ]; then
    . ./common.sh
fi

logger $LOGGER_INFO "Starting APIGateway Configurator..."

if [ "${apigw_check_apigateway_connection_enabled}" == "true" ]; then
    logger $LOGGER_INFO "Running check_connect playbook"
    ansible-playbook check_connect.yaml
    exit_on_error "$?" "check_connect"
fi

## reset_password
if [ "${apigw_changepassword_enabled}" == "true" ]; then
    logger $LOGGER_INFO "Running reset_password playbook"
    ansible-playbook reset_password.yaml
    exit_on_error "$?" "reset_password"
fi

logger $LOGGER_INFO "Done!!"