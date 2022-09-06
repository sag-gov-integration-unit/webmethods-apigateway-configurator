# Using/Testing the webmethods-apigateway-configurator

I have prepared most actions into a simple docker-compose file to:
 - Demonstrate how to use
 - Verify behavior
 - Act as a rudimental (but accurate) documentation

The images used in this testing are the official SoftwareAG images for [Software AG API Gateway](https://hub.docker.com/r/softwareag/apigateway-trial) and [Developper Portal](https://hub.docker.com/r/softwareag/devportal) so this should be a breeze to try.

## Build the container image

Go at the root of the project, and run:

```bash
docker build -t softwareag-government-solutions/webmethods-apigateway-configurator:10.11-latest --build-arg BASE_IMAGE=redhat/ubi8 .
```

This should build a local image labelled: softwareag-government-solutions/webmethods-apigateway-configurator:10.11-latest

## Start default SoftwareAG API management stack

Here, we're pulling the default container images by SoftwareAG from DockerHub, ie.
IMAGE_APIGATEWAY=softwareag/apigateway-trial
IMAGE_DEVPORTAL=softwareag/devportal

Check the [.env](./.env) for more details on that.

```bash
docker-compose up -d apigateway devportal elasticsearch
```

Wait for the stack to come up...once loaded, the UIs shoudl be available:
- APIGateway: http://localhost:9072/
- Developer Portal: http://localhost:8083/portal/

You can login to each of these with default passwords etc... and nothing is configured at this point.

## All-in-one: Apply all system configs and all sample data in 1 batch

Here we're applying it all in 1 single configurator batch...which could be the possible way to do it in an automated environment.

```bash
docker-compose up config_allinone_system_settings config_allinone_data
```

## Manual apply: execute each system configs one at a time

#### update admin password

```bash
docker-compose up config_changepassword
```

#### configure load balancer urls

```bash
docker-compose up config_loadbalancerurls
```

#### configure core settings (watt, extended)

```bash
docker-compose up config_coresettings
```

#### configure keystores / truststores

```bash
docker-compose up config_keystores config_truststores
```

#### configure in/out ssl connections

```bash
docker-compose up config_ssl_inbound_outbound_connections
```

#### configure additional ports (including matching with custom certs for SSL ports)

```bash
docker-compose up config_ports
```

#### configure promotion stages

```bash
docker-compose up config_promotion_stages
```

#### configure developer portal connectivity

```bash
docker-compose up config_portalgateway
```

#### configure users

```bash
docker-compose up config_users
```

#### configure user groups

```bash
docker-compose up config_usergroups
```

#### configure teams (user roles)

```bash
docker-compose up config_userroles
```

#### configure saml

```bash
docker-compose up config_saml
```

## Manual apply: execute each data items configs one at a time

#### import archives

```bash
docker-compose up config_import_archives
```

#### configure aliases

```bash
docker-compose up config_aliases
```

#### configure plans

```bash
docker-compose up config_plans
```

#### configure packages

```bash
docker-compose up config_packages
```

#### activate/deactivate packages

De-activate:

```bash
docker-compose up config_packages_deactivate
```

Activate:

```bash
docker-compose up config_packages_activate
```

#### configure applications

```bash
docker-compose up config_applications
```

#### activate/deactivate applications

De-activate:

```bash
docker-compose up config_applications_deactivate
```

Activate:

```bash
docker-compose up config_applications_activate
```

#### publish apis to dev portal

```bash
docker-compose up publish_apis
```

#### publish packages to dev portal

```bash
docker-compose up publish_packages
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