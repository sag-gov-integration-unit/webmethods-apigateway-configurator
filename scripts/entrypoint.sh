#!/bin/bash

exit_trap () {
  local lc="$BASH_COMMAND" rc=$?
  echo "Command [$lc] exited with code [$rc]"
}

trap exit_trap EXIT
set -e

## common
if [ -f ./common.sh ]; then
    . ./common.sh
fi

logger $LOGGER_INFO "Starting APIGateway Configurator..."

## wait for apigateway connect
if [ "${apigw_wait_connect}" == "true" ]; then
    exec_ansible_playbook wait_connect.yaml
fi

## reset_password
if [ "${apigw_changepassword_enabled}" == "true" ]; then
    exec_ansible_playbook reset_password.yaml
fi

## config_system_settings
if [ "${apigw_settings_core_configure}" == "true" ]; then
    exec_ansible_playbook config_settings.yaml
fi

## config_system_settings
if [ "${apigw_settings_lburls_configure}" == "true" ]; then
    exec_ansible_playbook config_lburls.yaml
fi

## config_ssl
if [ "${apigw_settings_ssl_configure}" == "true" ]; then
    exec_ansible_playbook config_ssl.yaml
fi

## config_saml
if [ "${apigw_settings_saml_configure}" == "true" ]; then
    exec_ansible_playbook config_saml.yaml
fi

## config_system_settings
if [ "${apigw_settings_portalgateway_configure}" == "true" ]; then
    exec_ansible_playbook config_portalgateway.yaml
fi

logger $LOGGER_INFO "APIGateway Configurator Done !!"