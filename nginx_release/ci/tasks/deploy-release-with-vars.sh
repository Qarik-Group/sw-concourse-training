#!/usr/bin/env bash
cd source-code/nginx_release
bosh deploy --non-interactive manifests/manifest.yml
