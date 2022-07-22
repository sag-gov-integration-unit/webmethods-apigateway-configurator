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

logger_with_headers $LOGGER_INFO "Starting APIGateway Configurator..."

## wait for apigateway connect - always first!
if [ "${apigw_wait_connect}" == "true" ]; then
    exec_ansible_playbook wait_connect.yaml
fi

## update_password
if [ "${apigw_changepassword_enabled}" == "true" ]; then
    exec_ansible_playbook update_password.yaml
fi

## config_system_settings
if [ "${apigw_settings_core_configure}" == "true" ]; then
    exec_ansible_playbook config_settings.yaml
fi

## config_lb urls
if [ "${apigw_settings_lburls_configure}" == "true" ]; then
    exec_ansible_playbook config_lburls.yaml
fi

## config_keystores / truststore
if [ "${apigw_settings_keystore_configure}" == "true" ]; then
    exec_ansible_playbook config_keystores.yaml
fi

if [ "${apigw_settings_truststore_configure}" == "true" ]; then
    exec_ansible_playbook config_truststores.yaml
fi

## config_ssl
if [ "${apigw_settings_ssl_inbound_outbound_configure}" == "true" ]; then
    exec_ansible_playbook config_ssl_inout_connections.yaml
fi

if [ "${apigw_settings_ssl_runtimeport_configure}" == "true" ]; then
    exec_ansible_playbook config_ssl_port.yaml
fi

## config_saml
if [ "${apigw_settings_saml_configure}" == "true" ]; then
    exec_ansible_playbook config_saml.yaml
fi

## config portal gateways
if [ "${apigw_settings_portalgateway_configure}" == "true" ]; then
    exec_ansible_playbook config_portalgateway.yaml
fi

## import archives
if [ "${apigw_data_archives_import}" == "true" ]; then
    exec_ansible_playbook import_archives.yaml
fi

logger_with_headers $LOGGER_INFO "APIGateway Configurator Done !!"
exit 0