# Using/Testing the webmethods-apigateway-configurator

I have prepared most actions into a simple docker-compose file to:
 - Demonstrate how to use
 - Verify behavior
 - Act as a rudimental (but accurate) documentation

The images used in this testing are the official SoftwareAG images for [Software AG API Gateway](https://hub.docker.com/r/softwareag/apigateway-trial) and [Developper Portal](https://hub.docker.com/r/softwareag/devportal) so this should be a breeze to try.

## start base components

docker-compose -f docker-compose.yml --env-file .env_sag up -d apigateway devportal elasticsearch config_changepassword

## system configs

### configure core settings (watt, extended)

docker-compose -f docker-compose.yml --env-file .env_sag up config_coresettings

### configure load balancer urls

docker-compose -f docker-compose.yml --env-file .env_sag up config_loadbalancerurls

### configure portal connectivity

docker-compose -f docker-compose.yml --env-file .env_sag up config_portalgateway

### configure keystores / truststores

docker-compose -f docker-compose.yml --env-file .env_sag up config_keystore config_truststore

### configure in/out connections

docker-compose -f docker-compose.yml --env-file .env_sag up config_ssl_inbound_outbound_connections

### configure saml

docker-compose -f docker-compose.yml --env-file .env_sag up config_saml


## data items

### import archives

docker-compose -f docker-compose.yml --env-file .env_sag up config_import_archives

### configure aliases

docker-compose -f docker-compose.yml --env-file .env_sag up config_aliases

### configure plans

docker-compose -f docker-compose.yml --env-file .env_sag up config_plans

### configure packages

docker-compose -f docker-compose.yml --env-file .env_sag up config_packages

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