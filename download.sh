#!/usr/bin/env bash
set +e

REG="docker.io/goharbor"
IMGS=( "nginx-photon" "harbor-portal" "harbor-core" "harbor-jobservice"
"registry-photon" "harbor-registryctl" "chartmuseum-photon" "trivy-adapter-photon"
"notary-server-photon" "notary-signer-photon" "harbor-db" "redis-photon" "harbor-exporter" )
TAG="dev"
SAVEDIR="downloads"
CLIENT=${CLI:=podman}

function check_client() {
  if [ ! -e "$(which ${CLIENT})" ]
  then
    echo "${CLIENT} is not installed."
    exit 1
  fi
}

function check_savedir() {
  if [ ! -e $SAVEDIR ]
  then
    echo "no save directory found. create new one... "
    mkdir $SAVEDIR
  fi
}

check_client
check_savedir

for IMG in "${IMGS[@]}"; do
  echo "Pulling image ${REG}/${IMG}:${TAG}"
  ${CLIENT} pull ${REG}/${IMG}:${TAG}
  echo "Save image to ${SAVEDIR}/${IMG}:${TAG}.tar"
  ${CLIENT} save ${REG}/${IMG}:${TAG} -o ${SAVEDIR}/${IMG}:${TAG}.tar
done
