#!/bin/bash

TERRAFORM_VERSION="1.12.2"
AWS_PROVIDER_VERSION="6.0.0"
AWS_PROFILE="admin"
BUCKET_SUFFIX="eks-with-terraform"

STAGE=$1 # modules, usecases, dev, stg, prd, ...
MODULE_NAME=$2

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
BACKEND_BUCKET_NAME="${STAGE}-tfstate-${BUCKET_SUFFIX}"

if [ $# -ne 2 ]; then
  echo "Usage: $0 <stage> <module_name>"
  exit 1
fi

if [ "${STAGE}" = "modules" ] || [ "${STAGE}" = "usecases" ]; then
  MODULE_FLG=1
  WDIR=${ROOT_DIR}/${STAGE}/${MODULE_NAME}
  VERSION_OPERATOR="<="
else
  MODULE_FLG=0
  WDIR=${ROOT_DIR}/env/${STAGE}/${MODULE_NAME}
  VERSION_OPERATOR=""
fi

mkdir -p ${WDIR}
cd ${WDIR} || exit 1

cat <<EOF > terraform.tf
terraform {
  required_version = "${VERSION_OPERATOR}${TERRAFORM_VERSION}"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${VERSION_OPERATOR}${AWS_PROVIDER_VERSION}"
    }
  }
}
EOF

if [ "${MODULE_FLG}" -ne 1 ]; then
  cat <<EOF > .terraform-version
${TERRAFORM_VERSION}
EOF

  cat <<EOF > backend.tf
terraform {
  backend "s3" {
    bucket = "${BACKEND_BUCKET_NAME}"
    key    = "${MODULE_NAME}/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
EOF

  cat <<EOF > providers.tf
provider "aws" {
  profile = "${AWS_PROFILE}"
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Terraform = "true"
      Stage     = "${STAGE}"
      Module    = "${MODULE_NAME}"
    }
  }
}
provider "aws" {
  profile = "${AWS_PROFILE}"
  region = "us-east-1"
  alias = "us_east_1"
  default_tags {
    tags = {
      Terraform = "true"
      Stage     = "${STAGE}"
      Module    = "${MODULE_NAME}"
    }
  }
}
EOF
fi

touch main.tf
touch outputs.tf
## touch locals.tf
## touch data.tf

if [ "${MODULE_FLG}" = "1" ]; then
  touch variables.tf
fi

echo "Initialized Terraform project in ${WDIR}"