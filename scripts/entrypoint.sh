#!/bin/bash

# set -e

## common
if [ -f ./common.sh ]; then
    . ./common.sh
fi

logger_with_headers $LOGGER_INFO "Starting APIGateway Configurator..."

if [ $# -gt 0 ]; then
    echo "Arguments supplied...running raw ansible playbook command"
    ansible-playbook "$@"
    exit_on_error "$?" "ansible-playbook $@"
else
    ## wait for apigateway connect - always first!
    if [ "${wait_connect,,}" == "true" ]; then
        exec_ansible_playbook wait_connect.yaml
    fi

    ## update_password
    if [ "${changepassword_enabled,,}" == "true" ]; then
        exec_ansible_playbook update_password.yaml
    fi

    ## config_system_settings
    if [ "${settings_core_configure,,}" == "true" ]; then
        exec_ansible_playbook config_settings.yaml
    fi

    ## config_destinations_settings
    if [ "${settings_event_destination_configure,,}" == "true" ]; then
        exec_ansible_playbook config_event_destinations.yaml
    fi

    ## config_lb urls
    if [ "${settings_lburls_configure,,}" == "true" ]; then
        exec_ansible_playbook config_lburls.yaml
    fi

    ## config_keystores
    if [ "${settings_keystores_configure,,}" == "true" ]; then
        exec_ansible_playbook config_keystores.yaml
    fi

    ## config_truststores
    if [ "${settings_truststores_configure,,}" == "true" ]; then
        exec_ansible_playbook config_truststores.yaml
    fi

    ## config_ssl inbound / outbound messages
    if [ "${settings_ssl_inbound_outbound_configure,,}" == "true" ]; then
        exec_ansible_playbook config_ssl_inout_connections.yaml
    fi

    ## local auth settings
    if [ "${settings_localauth_configure,,}" == "true" ]; then
        exec_ansible_playbook config_localauth.yaml
    fi

    ## promotion_stages
    if [ "${settings_promotions_stages_configure,,}" == "true" ]; then
        exec_ansible_playbook config_promotion_stages.yaml
    fi

    ## config portal gateways
    if [ "${settings_portalgateway_configure,,}" == "true" ]; then
        exec_ansible_playbook config_portalgateway.yaml
    fi

    ## config_ldap
    if [ "${settings_ldap_configure,,}" == "true" ]; then
        exec_ansible_playbook config_ldap.yaml
    fi

    ## config_saml
    if [ "${settings_saml_configure,,}" == "true" ]; then
        exec_ansible_playbook config_saml.yaml
    fi

    ## config users
    if [ "${settings_users_configure,,}" == "true" ]; then
        exec_ansible_playbook config_users.yaml
    fi

    ## config user groups
    if [ "${settings_usergroups_configure,,}" == "true" ]; then
        exec_ansible_playbook config_usergroups.yaml
    fi

    ## config roles
    if [ "${settings_userroles_configure,,}" == "true" ]; then
        exec_ansible_playbook config_userroles.yaml
    fi

    ## config ports
    if [ "${settings_ports_configure,,}" == "true" ]; then
        exec_ansible_playbook config_ports.yaml
    fi

    ## import archives
    if [ "${data_archives_import,,}" == "true" ]; then
        exec_ansible_playbook import_archives.yaml
    fi

    ## aliases
    if [ "${data_aliases_configure,,}" == "true" ]; then
        exec_ansible_playbook config_aliases.yaml
    fi

    ## apis
    if [ "${data_apis_configure,,}" == "true" ]; then
        exec_ansible_playbook config_apis.yaml
    fi

    if [ "${data_apis_status_update,,}" == "true" ]; then
        exec_ansible_playbook activate_apis.yaml
    fi

    ## plans
    if [ "${data_plans_configure,,}" == "true" ]; then
        exec_ansible_playbook config_plans.yaml
    fi

    ## packages
    if [ "${data_packages_configure,,}" == "true" ]; then
        exec_ansible_playbook config_packages.yaml
    fi

    if [ "${data_packages_status_update,,}" == "true" ]; then
        exec_ansible_playbook activate_packages.yaml
    fi

    ## applications
    if [ "${data_applications_configure,,}" == "true" ]; then
        exec_ansible_playbook config_applications.yaml
    fi

    if [ "${data_applications_status_update,,}" == "true" ]; then
        exec_ansible_playbook activate_applications.yaml
    fi

    ## activate/deactivate apis --> TODO
    # if [ "${data_apis_status_update,,}" == "true" ]; then
    #     exec_ansible_playbook activate_apis.yaml
    # fi

    ## publish apis (must happen before packages)
    if [ "${data_apis_publish,,}" == "true" ]; then
        exec_ansible_playbook publish_apis.yaml
    fi

    ## publish packages
    if [ "${data_packages_publish,,}" == "true" ]; then
        exec_ansible_playbook publish_packages.yaml
    fi
fi

logger_with_headers $LOGGER_INFO "APIGateway Configurator Done !!"
exit 0