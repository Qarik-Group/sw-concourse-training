#!/usr/bin/env bash
set -x
#For the purpose of this tutorial, there are credentials being commited here.
#This is on purpose and will be covered in the security tutorial.
#The director is expected to be secured and only locally available for this lab session
#But this does not demonostrate a best practice

export BOSH_DEPLOYMENT=${GITHUB_USERNAME}-nginx
export BOSH_DIRECTOR=$(bosh int ~/creds.yml --path /bosh_url)
export BOSH_ENVIRONMENT=training
# ** uncomment below as needed
# export BOSH_CLIENT=admin
# export BOSH_CLIENT_SECRET=<replace-me>

cd source-code/nginx_release

curl -LO https://unreal-snw.s3.amazonaws.com/training-bosh.pem
bosh alias-env --ca-cert training-bosh.pem -e ${BOSH_DIRECTOR} training-bosh

bosh login

bosh upload-release releases/release.gz
