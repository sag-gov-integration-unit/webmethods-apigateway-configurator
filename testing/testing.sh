#!/bin/sh

exit_on_error() {
    exit_code=$1
    last_command=${@:2}
    if [ $exit_code -ne 0 ]; then
        logger_with_headers $LOGGER_ERROR "\"${last_command}\" command failed with exit code ${exit_code}. Exiting program!!"
        exit $exit_code
    fi
}

# pick the docker-compose file
dockercomposefile="$1"
if [ "x$dockercomposefile" == "x" ]; then
  dockercomposefile="docker-compose.yml"
fi

## check that dockercomposefile exists
if [ ! -f $dockercomposefile ]; then
    echo "[ERROR] $dockercomposefile does not exist."
    exit 2;
fi

DOCKER_SERVICES_IN_ORDER=`grep "config_" $dockercomposefile | sed 's/ //g' | sed 's/\://g'`
for dockersvc in $DOCKER_SERVICES_IN_ORDER
do
  echo "########################################################################"
  echo "Running ${dockersvc}..."
  docker-compose  --env-file .env -f $dockercomposefile up $dockersvc
  exit_on_error "$?" "docker-compose  --env-file .env -f $dockercomposefile up $dockersvc"
done