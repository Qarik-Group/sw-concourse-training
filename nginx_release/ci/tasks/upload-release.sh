#!/usr/bin/env bash
set -x
#For the purpose of this tutorial, there are credentials being commited here.
#This is on purpose and will be covered in the security tutorial.
#The director is expected to be secured and only locally available for this lab session
#But this does not demonostrate a best practice

export CA_CERT_URL=https://unreal-snw.s3.amazonaws.com/training-bosh.pem
export BOSH_DIRECTOR='https://10.4.1.4:25555'
export BOSH_ENVIRONMENT='training'
export BOSH_DEPLOYMENT=${GITHUB_USERNAME}-nginx
# ** uncomment below as needed
# export BOSH_CLIENT=admin
# export BOSH_CLIENT_SECRET=<replace-me>

cd source-code/nginx_release

curl -LO ${CA_CERT_URL}
bosh alias-env ${BOSH_ENVIRONMENT} --ca-cert training-bosh.pem -e ${BOSH_DIRECTOR} training-bosh

bosh login

bosh upload-release releases/release.gz
