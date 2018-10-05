#!/usr/bin/env bash

export BOSH_DEPLOYMENT=dave-nginx
export BOSH_DIRECTOR=https://10.200.192.0:25555/
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=agile-defense
export BOSH_ENVIRONMENT=training-bosh

cd source-code/nginx_release

curl -LO https://unreal-snw.s3.amazonaws.com/training-bosh.pem
bosh alias-env --ca-cert training-bosh.pem -e ${BOSH_DIRECTOR} training-bosh
bosh login

bosh deploy --non-interactive manifests/manifest.yml
