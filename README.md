# webmethods-apigateway-configurator

A container that can easily configure various functions of webmethods-apigateway from environment variable values passed in.

As a high level description of how it works, this container essentially uses REST calls to the SoftwareAG APIGateway Admin APIs to perform all its functions.

## Supported Configs / Actions

The following configuration items / actions are currently supported (new functions added as needed)

- apigateway availability checker (wait for apigateway to be available on target port -- NOTE: this checker is enable on all actions by default)
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
- (more can and will be added based on automation needs)

Head over to [Using/Testing the webmethods-apigateway-configurator](./testing/README.md) for a detail tutorial on how to use the configurator to apply all the supported config items.

## Build the container image

Go at the root of the project (here in this case), and run:

```bash
docker build -t softwareag-government-solutions/webmethods-apigateway-configurator:10.11-latest --build-arg BASE_IMAGE=redhat/ubi8 .
```

This should build and create a local image labelled: softwareag-government-solutions/webmethods-apigateway-configurator:10.11-latest

## Trying the configurator

Head over to [Using/Testing the webmethods-apigateway-configurator](./testing/README.md) for a detail tutorial on how to use the configurator to apply all the supported config items.

## How it's made

To build on the ansible roles already created for APIGateway, this container also uses Ansible to operate the various actions strictly via REST calls (here, no concept of remoting into the APIGateway container to update files etc...)

For the various REST calls, this project makes use of the existing Ansible roles [sagdevops-ansible-apigateway](https://github.com/SoftwareAG/sagdevops-ansible-apigateway.git) to perform all the needed REST calls to APIGateway.


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