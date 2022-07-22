#!/bin/sh

## common
if [ -f ./common.sh ]; then
    . ./common.sh
fi

logger $LOGGER_INFO "Starting APIGateway Configurator..."

## wait for apigateway connect
if [ "${apigw_wait_connect}" == "true" ]; then
    logger $LOGGER_INFO "Running wait_connect playbook"
    ansible-playbook wait_connect.yaml
    exit_on_error "$?" "wait_connect"
fi

## reset_password
if [ "${apigw_changepassword_enabled}" == "true" ]; then
    logger $LOGGER_INFO "Running reset_password playbook"
    ansible-playbook reset_password.yaml
    exit_on_error "$?" "reset_password"
fi

## config_system_settings
if [ "${apigw_settings_core_configure}" == "true" ]; then
    logger $LOGGER_INFO "Running config_settings playbook"
    ansible-playbook config_settings.yaml
    exit_on_error "$?" "config_settings"
fi

## config_ssl
if [ "${apigw_settings_ssl_configure}" == "true" ]; then
    logger $LOGGER_INFO "Running config_ssl playbook"
    ansible-playbook config_ssl.yaml
    exit_on_error "$?" "config_ssl"
fi

## config_saml
if [ "${apigw_settings_saml_configure}" == "true" ]; then
    logger $LOGGER_INFO "Running config_saml playbook"
    ansible-playbook config_saml.yaml
    exit_on_error "$?" "config_saml"
fi

logger $LOGGER_INFO "Done!!"