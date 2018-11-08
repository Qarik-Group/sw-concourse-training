#!/usr/bin/env bash

export CA_CERT_URL=https://unreal-snw.s3.amazonaws.com/training-bosh.pem
export BOSH_DEPLOYMENT=<replace-me-with-github-user>-nginx
export BOSH_DIRECTOR=https://10.200.192.0:25555/
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=<replace-me>
export BOSH_ENVIRONMENT=training-bosh

cd source-code/nginx_release

curl -LO ${CA_CERT_URL}
bosh alias-env ${BOSH_ENVIRONMENT} --ca-cert training-bosh.pem -e ${BOSH_DIRECTOR}
bosh login

bosh deploy --non-interactive manifests/manifest.yml
