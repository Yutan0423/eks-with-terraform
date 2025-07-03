#! /bin/bash

# ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
VERSION=$(tfupdate release latest hashicorp/terraform-provider-aws)

tfupdate provider aws  --recursive --version ${VERSION} "../env"

tfupdate lock --recursive \
  --platform "linux_amd64" \
  --platform "darwin_amd64" \
  "../env"