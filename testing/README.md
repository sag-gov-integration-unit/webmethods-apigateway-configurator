# webmethods-apigateway-configurator -- testing

## start base components

docker-compose -f docker-compose.yml --env-file .env_sag up -d apigateway devportal elasticsearch config_changepassword

## configure load balancer urls

docker-compose -f docker-compose.yml --env-file .env_sag up config_loadbalancerurls

## etc...

Docs TODO...
