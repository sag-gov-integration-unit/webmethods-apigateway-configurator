# Using/Testing the webmethods-apigateway-configurator

I have prepared most actions into a simple docker-compose file to:
 - Demonstrate how to use
 - Verify behavior
 - Act as a rudimental (but accurate) documentation

The product images used in this testing are the official SoftwareAG images for [Software AG API Gateway](https://hub.docker.com/r/softwareag/apigateway-trial) and [Developper Portal](https://hub.docker.com/r/softwareag/devportal) so this should be a breeze to try.

## Create a default docker network

In order to run different compose files without having to recreate the base product stack, let's create an external network that we'll use in different compose:

```
docker network create -d bridge apimgt
```

## Start default SoftwareAG API management stack

```bash
docker-compose --env-file .env -f docker-compose-apimgt.yml up -d
```

Wait for the stack to come up...once loaded, the UIs shoudl be available:
- APIGateway: http://localhost:9072/
- Developer Portal: http://localhost:8083/portal/

You can login to each of these with default passwords etc... and nothing is configured at this point.

## All-in-one: Apply all system configs and all sample data in 1 batch

Here we're applying it all in 1 single configurator batch...which could be the possible way to do it in an automated environment.

```bash
docker-compose --env-file .env -f docker-compose-allinone.yml up -d
```

## Running Tests: all configs one by one

The tests will automatically run all the docker-compose services which names start with "config_" (essentially all the relevant test services)

```bash
sh run_tests.sh docker-compose.yml
```

IF you want to run ONLY the "allinone" services:

```bash
sh run_tests.sh docker-compose-allinone.yml
```

## Manual apply: execute each system configs one at a time

#### update admin password

```bash
docker-compose run config_settings_changepassword
```

#### configure load balancer urls

```bash
docker-compose run config_settings_loadbalancerurls
```

#### configure core settings (watt, extended)

```bash
docker-compose run config_settings_coresettings
```

#### configure keystores / truststores

```bash
docker-compose run config_settings_keystores config_settings_truststores
```

#### configure in/out ssl connections

```bash
docker-compose run config_settings_ssl_inbound_outbound_connections
```

#### configure additional ports (including matching with custom certs for SSL ports)

```bash
docker-compose run config_settings_ports
```

#### configure promotion stages

```bash
docker-compose run config_settings_promotion_stages
```

#### configure developer portal connectivity

```bash
docker-compose run config_settings_portalgateway
```

#### configure local auth server settings

```bash
docker-compose run config_settings_localauth
```

#### configure users

```bash
docker-compose run config_settings_users
```

#### configure user groups

```bash
docker-compose run config_settings_usergroups
```

#### configure teams (user roles)

```bash
docker-compose run config_settings_userroles
```

#### configure saml

```bash
docker-compose run config_settings_saml
```

## Manual apply: execute each data items configs one at a time

#### import archives

```bash
docker-compose run config_data_import_archives
```

#### configure aliases

```bash
docker-compose run config_data_aliases
```

#### configure existing aliases

```bash
docker-compose run config_data_aliases_existing
```

#### configure apis

```bash
docker-compose run config_data_apis
```

#### activate/deactivate apis

De-activate:

```bash
docker-compose run config_data_apis_deactivate
```

Activate:

```bash
docker-compose run config_data_apis_activate
```

#### configure plans

```bash
docker-compose run config_data_plans
```

#### configure packages

```bash
docker-compose run config_data_packages
```

#### activate/deactivate packages

De-activate:

```bash
docker-compose run config_data_packages_deactivate
```

Activate:

```bash
docker-compose run config_data_packages_activate
```

#### configure applications

```bash
docker-compose run config_data_applications
```

#### activate/deactivate applications

De-activate:

```bash
docker-compose run config_data_applications_deactivate
```

Activate:

```bash
docker-compose run config_data_applications_activate
```

#### publish apis to dev portal

```bash
docker-compose run config_data_publish_apis
```

#### publish packages to dev portal

```bash
docker-compose run config_data_publish_packages
```

## Clean up

```bash
docker-compose down -v
```

Authors
--------------------------------------------

Fabien Sanglier
- Emails: [@Software AG](mailto:fabien.sanglier@softwareag.com) // [@Software AG Government Solutions](mailto:fabien.sanglier@softwareaggov.com)
- Github: 
  - [Fabien Sanglier](https://github.com/lanimall)
  - [Fabien Sanglier @ SoftwareAG Government Solutions](https://github.com/fabien-sanglier-saggs)

Licensing - Apache-2.0
--------------------------------------------

This project is Licensed under the Apache License, Version 2.0 (the "License");
You may not use this project except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.