#!/bin/sh

set -e

if [ -z "$INPUT_PASSWORD" ] &&  [ -z "$INPUT_TOKEN" ]
then
  echo "Set the PASSWORD or TOKEN input."
  exit 1
fi

if [ -z "$INPUT_PACKAGE_REPOSITORY" ]
then
  echo "Set the PACKAGE_REPOSITORTY input."
  exit 1
fi


if [ -z "$INPUT_REGISTRY" ]
then
  INPUT_REGISTRY="docker.pkg.github.com"
fi

if [ -z "$INPUT_APP_NAME" ]
then
  INPUT_APP_NAME=${GITHUB_REPOSITORY#*/}
fi

if [ -z "$INPUT_USERNAME" ]
then
  INPUT_USERNAME=${GITHUB_ACTOR}
fi

INPUT_USERNAME=$(echo $INPUT_USERNAME | tr '[:upper:]' '[:lower:]')
APP_VERSION=${GITHUB_SHA:0:12}
package="${INPUT_REGISTRY}/${INPUT_USERNAME}/${INPUT_PACKAGE_REPOSITORY}/${INPUT_APP_NAME}"

docker build --tag "${package}:${APP_VERSION}" --tag "${package}:latest" ./

if [ $INPUT_TOKEN ]
then
  docker login ${INPUT_REGISTRY} --username ${INPUT_USERNAME} -p ${INPUT_TOKEN}
fi
if [ $INPUT_PASSWORD ]
then
  echo ${INPUT_PASSWORD} | docker login ${INPUT_REGISTRY} --username ${INPUT_USERNAME} --password-stdin
fi


docker push "${package}:${APP_VERSION}"
docker push "${package}:latest"

docker logout ${INPUT_REGISTRY}
