# Developing the configurator

## link to ansible roles

ln -s <LOCAL_PATH>/sagdevops-ansible-apigateway sagdevops-ansible-apigateway
ln -s <LOCAL_PATH>/sagdevops-ansible-common sagdevops-ansible-common
ln -s <LOCAL_PATH>/sagdevops-ansible-developer-portal sagdevops-ansible-developer-portal

## Starting the DEV stack

docker-compose  --env-file .env -f dev/docker-compose.yml up -d apigateway devportal elasticsearch

## All-in-one: Apply all system configs and all sample data in 1 batch

```bash
docker-compose  --env-file .env -f dev/docker-compose.yml up -d config_settings_allinone config_data_allinone
```

## TESTING all configs one by one

```bash
sh testing.sh dev/docker-compose.yml
```
