# notes to build and publish the chart to the public repo

mkdir -p ./build/

helm package -u -d build/ webmethods-apigateway-configurator/

helm repo index --merge ${WEBMETHODS_HELMCHART_HOME}/docs/index.yaml ./build/

echo "Copying new index and updated packages to the final repo location"
cp -f build/index.yaml ${WEBMETHODS_HELMCHART_HOME}/docs/
cp -f build/*.tgz ${WEBMETHODS_HELMCHART_HOME}/docs/