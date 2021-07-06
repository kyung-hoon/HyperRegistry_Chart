#!/bin/bash
set -e


REG="docker.io/tmaxcloudck"
IMGS=( "nginx-photon" "hyperregistry-portal" "harbor-core" "harbor-jobservice"
"registry-photon" "harbor-registryctl" "chartmuseum-photon" "trivy-adapter-photon"
"notary-server-photon" "notary-signer-photon" "harbor-db" "redis-photon" "harbor-exporter" )
CLIENT=${CLI:=podman}

function usage() {
  echo "[Usage]: CLI=<registry_client(default: podman)> ./download.sh <save_dir>(default: downloads)"
  echo "    ex): CLI=docker ./download.sh archive"
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

TAG=v2.2.2
SAVEDIR=${1=downloads}

check_client
check_savedir

RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

for IMG in "${IMGS[@]}"; do
  echo -e  "${BLUE}Pulling image ${REG}/${IMG}:${TAG}${NC}"
  ${CLIENT} pull "${REG}/${IMG}:${TAG}"
  ${CLIENT} save "${REG}/${IMG}:${TAG}" -o "${SAVEDIR}/${IMG}_${TAG}.tar"
  echo -e  "${RED}Saved to ${SAVEDIR}/${IMG}_${TAG}.tar${NC}"
done
