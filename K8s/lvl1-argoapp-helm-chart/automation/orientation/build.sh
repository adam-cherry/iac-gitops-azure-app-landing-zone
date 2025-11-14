#!/bin/bash
set -xe

#env

LOGS="$(helm package charts/aproject-k8s-core-platform --debug 2>&1)"
PACKAGE=$(echo "$LOGS" | sed -e "s@.*$(pwd)@$(pwd)@g")

helm registry login --username "${EXT_ARTIFACTORY_USERNAME}" --password "${EXT_ARTIFACTORY_PASSWORD}" docker--swxt--demo.ext-repo-eu.aprojecttraffic.com
helm push ${PACKAGE} oci://docker--swxt--demo.ext-repo-eu.aprojecttraffic.com

echo -n "$PACKAGE" > build.package
