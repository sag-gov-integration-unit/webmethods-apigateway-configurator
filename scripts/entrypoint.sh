#!/bin/sh

## common
if [ -f common.sh ]; then
    . common.sh
fi

logger $LOGGER_INFO "Starting APIGateway Configurator..."

## change password
if [ "${apigw_changepassword_enabled}" == "true" ]; then
    logger $LOGGER_INFO "Running change password playbook"
    ansible-playbook apply_resetpwd.yaml
    exit_on_error "$?" "change password"
fi

logger $LOGGER_INFO "Done!!"