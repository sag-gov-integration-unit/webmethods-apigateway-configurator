# Developing the configurator

## link to ansible roles

ln -s <LOCAL_PATH>/sagdevops-ansible-apigateway sagdevops-ansible-apigateway
ln -s <LOCAL_PATH>/sagdevops-ansible-common sagdevops-ansible-common
ln -s <LOCAL_PATH>/sagdevops-ansible-developer-portal sagdevops-ansible-developer-portal

## Starting the DEV stack

if not already done, start the product stack with:

```
docker-compose --env-file .env -f docker-compose-apimgt.yml up -d
```

## All-in-one: Apply all system configs and all sample data in 1 batch

```bash
docker-compose --env-file .env -f dev/docker-compose-allinone.yml up -d
```

## Running Tests: all configs one by one

The tests will automatically run all the docker-compose services which names start with "config_" (essentially all the relevant test services)

```bash
sh run_tests.sh dev/docker-compose.yml
```

IF you want to run ONLY the "allinone" services:

```bash
sh run_tests.sh dev/docker-compose-allinone.yml
```