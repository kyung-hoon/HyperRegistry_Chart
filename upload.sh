#!/usr/bin/env bash
set -e

REG="goharbor"
IMGS=( "nginx-photon" "harbor-portal" "harbor-core" "harbor-jobservice"
"registry-photon" "harbor-registryctl" "chartmuseum-photon" "trivy-adapter-photon"
"notary-server-photon" "notary-signer-photon" "harbor-db" "redis-photon" "harbor-exporter" )
TAG="dev"

function usage() {
  echo "[Usage]: CLI=<registry_client(default: podman)> ./upload.sh <download_directory> <target_repo>"
  echo "    ex): CLI=docker ./upload.sh ./downloads docker.io/goharbor"
}

if [ -z ${2} ];
then
  echo "[ERROR]: target registry not specified."
  usage
  exit 1
fi

CLIENT=${CLI:=podman}
SAVEDIR=${1:=downloads}
TARGETREG=${2}

function check_client() {
  if [ ! -e "$(which ${CLIENT})" ]
  then
    echo "[ERROR]: ${CLIENT} is not installed."
    usage
    exit 1
  fi
}

function check_savedir() {
  if [ ! -d $SAVEDIR ]
  then
    echo "[ERROR]: no save directory(${SAVEDIR}) found."
    usage
    exit 1
  fi
}

check_client
check_savedir

for IMG in "${IMGS[@]}"; do
  echo "Load image from ${SAVEDIR}/${IMG}_${TAG}.tar"
  ${CLIENT} load < ${SAVEDIR}/${IMG}_${TAG}.tar

  echo "Tag image ${REG}/${IMG}:${TAG} to ${TARGETREG}/${IMG}:${TAG}"
  ${CLIENT} tag ${REG}/${IMG}:${TAG} ${TARGETREG}/${IMG}:${TAG}

  echo "Push image ${TARGETREG}/${IMG}:${TAG}"
  ${CLIENT} push ${TARGETREG}/${IMG}:${TAG}
done
