#!/bin/sh

exit_on_error() {
    exit_code=$1
    last_command=${@:2}
    if [ $exit_code -ne 0 ]; then
        echo "\"${last_command}\" command failed with exit code ${exit_code}. Exiting program!!"
        exit $exit_code
    fi
}

# pick the docker-compose file
dockercomposefile="$1"
allinone="$2"
if [ "x$dockercomposefile" == "x" ]; then
  dockercomposefile="docker-compose.yml"
fi

## check that dockercomposefile exists
if [ ! -f $dockercomposefile ]; then
    echo "[ERROR] $dockercomposefile does not exist."
    exit 2;
fi

DOCKER_SERVICES_IN_ORDER_CMD="grep 'config_' $dockercomposefile | sed 's/ //g' | sed 's/\://g'"
if [ "$allinone" == "allinone=only" ]; then
  DOCKER_SERVICES_IN_ORDER_CMD="$DOCKER_SERVICES_IN_ORDER_CMD | grep allinone"
elif [ "$allinone" == "allinone=rm" ]; then
  DOCKER_SERVICES_IN_ORDER_CMD="$DOCKER_SERVICES_IN_ORDER_CMD | grep -v allinone"
fi

echo "########################################################################"
echo "Finding all the test services by running: $DOCKER_SERVICES_IN_ORDER_CMD"
DOCKER_SERVICES_IN_ORDER=$(eval $DOCKER_SERVICES_IN_ORDER_CMD)
echo ">> Results: $DOCKER_SERVICES_IN_ORDER"
echo "########################################################################"
for dockersvc in $DOCKER_SERVICES_IN_ORDER
do
  echo "################ Running ${dockersvc}...#########################"
  echo 
  docker compose  --env-file .env -f $dockercomposefile run -T $dockersvc
  exit_on_error "$?" "Service $dockersvc in compose file $dockercomposefile failed..."
done

echo "Done with success!!"
exit 0;