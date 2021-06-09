#!/usr/bin/env bash
set -e

REG="docker.io/goharbor"
IMGS=( "nginx-photon" "harbor-portal" "harbor-core" "harbor-jobservice"
"registry-photon" "harbor-registryctl" "chartmuseum-photon" "trivy-adapter-photon"
"notary-server-photon" "notary-signer-photon" "harbor-db" "redis-photon" "harbor-exporter" )
CLIENT=${CLI:=podman}

function usage() {
  echo "[Usage]: CLI=<registry_client(default: podman)> ./download.sh <tag>(default: dev) <save_dir>(default: downloads)"
  echo "    ex): CLI=docker ./download.sh v2.2.2 archive"
}

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

if [ -z ${1} ];
then
  echo "[ERROR]: tag not specified."
  usage
  exit 1
fi

TAG=${1:=dev}
SAVEDIR=${2:=downloads}

check_client
check_savedir

for IMG in "${IMGS[@]}"; do
  echo "Pulling image ${REG}/${IMG}:${TAG}"
  ${CLIENT} pull "${REG}/${IMG}:${TAG}"
  echo "Save image to ${SAVEDIR}/${IMG}_${TAG}.tar"
  ${CLIENT} save "${REG}/${IMG}:${TAG}" -o "${SAVEDIR}/${IMG}_${TAG}.tar"
done
