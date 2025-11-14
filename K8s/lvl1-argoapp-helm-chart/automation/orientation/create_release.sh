#!/bin/bash
read -e -p "Please make sure that this repo is pristine and what you want to release before continuing."
CURRENT="$(git for-each-ref --format="%(refname)" --sort=-creatordate --count=1 refs/tags | cut -d / -f 3)"

set -xe
read -e -p "Which K8S chart version to release? " CHART_VERSION
read -e -p "Which app version to release? " APP_VERSION

read -e -i "${CHART_VERSION}-${APP_VERSION}" -p "Which tag to use? " CURRENT

git checkout -b release_${CURRENT}

sed -e "s/^version: .*/version: ${CHART_VERSION}/g" -i charts/aproject-k8s-core-platform/Chart.yaml
sed -e "s/^appVersion: .*/appVersion: \"${APP_VERSION}\"/g" -i charts/aproject-k8s-core-platform/Chart.yaml

git commit -m "Release ${CURRENT}" -a --allow-empty

git tag ${CURRENT}
git checkout main

git branch -D release_${CURRENT}
read -e -p "Please check everything and push when okay. Use: git push origin ${CURRENT}"
