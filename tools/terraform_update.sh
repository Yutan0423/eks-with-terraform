#! /bin/bash

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
VERSION="${tfupdate release latest hashicorp/terraform}"

tfupdate terraform  --recursive --version ${VERSION} "${ROOT_DIR}/env"

find ${ROOT_DIR}/env -name ".terraform-version" -print0 \
  | xargs -0 -I {} sh -c "echo ${VERSION} > {}"