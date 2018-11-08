#!/usr/bin/env bash
set -x
#For the purpose of this tutorial, there are credentials being commited here.
#This is on purpose and will be covered in the security tutorial.
#The director is expected to be secured and only locally available for this lab session
#But this does not demonostrate a best practice

export BOSH_CLIENT_SECRET=<replace-me>
export BOSH_DEPLOYMENT=<replace-me-with-github-user>-nginx
export BOSH_DIRECTOR='https://10.4.1.4:25555'
export BOSH_ENVIRONMENT='training'
export BOSH_CLIENT=admin

bosh alias-env ${BOSH_ENVIRONMENT} --ca-cert cert-file/training-bosh.pem -e ${BOSH_DIRECTOR}
bosh login

cd source-code/nginx_release
bosh upload-release releases/release.gz
