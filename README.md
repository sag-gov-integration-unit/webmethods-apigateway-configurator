# webmethods-apigateway-configurator

A container that can easily configure various functions of webmethods-apigateway from environment variable values passed in.

Docs in progress...

### Supported Configs / Actions

The following configuration items / actions are currently supported (new functions added as needed)

- update admin password
- set/update  extended settings
- set/update  external loadbalancer urls
- set/update  cert stores (keystore, truststore)
- set/update  ports (different types - http, https, internal, external)
- set/update  developer portal destination
- set/update  promotion stages
- set/update  SAML configs
- set/update  LDAP configs
- create/update users
- create/update groups (and assign the users)
- create/update teams (and assign the groups)
- import apigateway archive
- set/update aliases (different types)
- set/update api plans
- set/update api packages (and link to plans)
- set/update api applications (and link to apis)
- publish apis to developer portal
- publish api packages to developer portal
- activate/deactivate apis
- activate/deactivate applications
- activate/deactivate packages
- (more can be added based on needs)

Head over to [How to use](./testing/README.md) for a simple tutorial on how to use this 

## Build the image manually

docker build -t softwareag-government-solutions/webmethods-apigateway-configurator:10.11-latest --build-arg BASE_IMAGE=redhat/ubi8 .
