# Developing the configurator

## link to ansible roles

ln -s <LOCAL_PATH>/sagdevops-ansible-apigateway sagdevops-ansible-apigateway
ln -s <LOCAL_PATH>/sagdevops-ansible-common sagdevops-ansible-common
ln -s <LOCAL_PATH>/sagdevops-ansible-developer-portal sagdevops-ansible-developer-portal

## Use DEV compose

docker-compose  --env-file .env -f dev/docker-compose.yml up -d apigateway devportal elasticsearch config_changepassword

## All-in-one: Apply all system configs and all sample data in 1 batch

```bash
docker-compose  --env-file .env -f dev/docker-compose.yml up -d config_allinone_system_settings config_allinone_data
```