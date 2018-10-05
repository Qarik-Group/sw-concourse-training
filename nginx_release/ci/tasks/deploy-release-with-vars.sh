#!/usr/bin/env bash
cd source-code/nginx_release

curl -LO https://unreal-snw.s3.amazonaws.com/training-bosh.pem
bosh alias-env --ca-cert training-bosh.pem -e ${BOSH_DIRECTOR} training-bosh
bosh login

bosh deploy --non-interactive manifests/manifest.yml
