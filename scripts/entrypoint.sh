#!/bin/bash

# set -e

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

## config_keystores
if [ "${apigw_settings_keystores_configure}" == "true" ]; then
    exec_ansible_playbook config_keystores.yaml
fi

## config_truststores
if [ "${apigw_settings_truststores_configure}" == "true" ]; then
    exec_ansible_playbook config_truststores.yaml
fi

## config_ssl inbound / outbound messages
if [ "${apigw_settings_ssl_inbound_outbound_configure}" == "true" ]; then
    exec_ansible_playbook config_ssl_inout_connections.yaml
fi

## promotion_stages
if [ "${apigw_data_promotions_stages_configure}" == "true" ]; then
    exec_ansible_playbook config_promotion_stages.yaml
fi

## config portal gateways
if [ "${apigw_settings_portalgateway_configure}" == "true" ]; then
    exec_ansible_playbook config_portalgateway.yaml
fi

## config_ldap
if [ "${apigw_settings_ldap_configure}" == "true" ]; then
    exec_ansible_playbook config_ldap.yaml
fi

## config_saml
if [ "${apigw_settings_saml_configure}" == "true" ]; then
    exec_ansible_playbook config_saml.yaml
fi

## config users
if [ "${apigw_settings_users_configure}" == "true" ]; then
    exec_ansible_playbook config_users.yaml
fi

## config user groups
if [ "${apigw_settings_usergroups_configure}" == "true" ]; then
    exec_ansible_playbook config_usergroups.yaml
fi

## config roles
if [ "${apigw_settings_userroles_configure}" == "true" ]; then
    exec_ansible_playbook config_userroles.yaml
fi

## config ports
if [ "${apigw_settings_ports_configure}" == "true" ]; then
    exec_ansible_playbook config_ports.yaml
fi

## import archives
if [ "${apigw_data_archives_import}" == "true" ]; then
    exec_ansible_playbook import_archives.yaml
fi

## aliases
if [ "${apigw_data_aliases_configure}" == "true" ]; then
    exec_ansible_playbook config_aliases.yaml
fi

## plans
if [ "${apigw_data_plans_configure}" == "true" ]; then
    exec_ansible_playbook config_plans.yaml
fi

## packages
if [ "${apigw_data_packages_configure}" == "true" ]; then
    exec_ansible_playbook config_packages.yaml
fi

if [ "${apigw_data_packages_status_update}" == "true" ]; then
    exec_ansible_playbook activate_packages.yaml
fi

## applications
if [ "${apigw_data_applications_configure}" == "true" ]; then
    exec_ansible_playbook config_applications.yaml
fi

if [ "${apigw_data_applications_status_update}" == "true" ]; then
    exec_ansible_playbook activate_applications.yaml
fi

## activate/deactivate apis --> TODO
# if [ "${apigw_data_apis_status_update}" == "true" ]; then
#     exec_ansible_playbook activate_apis.yaml
# fi

## publish packages
if [ "${apigw_data_packages_publish}" == "true" ]; then
    exec_ansible_playbook publish_packages.yaml
fi

## publish apis
if [ "${apigw_data_apis_publish}" == "true" ]; then
    exec_ansible_playbook publish_apis.yaml
fi

logger_with_headers $LOGGER_INFO "APIGateway Configurator Done !!"
exit 0