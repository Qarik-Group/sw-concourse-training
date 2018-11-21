## Lab 8: Using Vault with Concourse
In [Lab-7](lab-7.md), we eliminated the repetitive variable settings, but all of this was dependent in some way upon environment variables that we had previously set either through our "~/.bash_profile", or through our "set_env.sh" script. There are a couple of concerns this creates:

* Credential end up being stored in your repositories which may pose a security concern.
* Credential rotation requires each user to go in and edit their individual environment files and variables and for the pipelines to be re-deployed.
* Finally, this leaves a lot of credential files laying around on your jumpbox.

The lab has a demonstration Vault instance that has been deployed which can be accessed with Vault.

### Activity
In this lab we are going to switch to ci/settings_8.yml; let's look at the changes:

```diff
diff ci/settings.yml ci/settings_8.yml
<   client_user: (( grab $BOSH_CLIENT ))
<   client_secret: (( grab $BOSH_CLIENT_SECRET ))
<   url: https://10.4.1.4:25555/
<   ca_cert: |
<     -----BEGIN CERTIFICATE-----
<     MIIE5zCCAs+gAwIBAgIBAjANBgkqhkiG9w0BAQ0FADAcMRowGAYDVQQDExFjYS5u
<     MTg3Nzg1MDU4LnNzbDAeFw0xODExMDIyMTQ5NTdaFw0yODEwMzAyMTQ5NTdaMBwx
<     GjAYBgNVBAMTEWNhLm4xODc3ODUwNTguc3NsMIICIjANBgkqhkiG9w0BAQEFAAOC
<     Ag8AMIICCgKCAgEAqTzo+nKWH26ItXjHpt2Val6D1RIpwRlcYn+IXR8ydJ1JP3Kp
<     trEfHHhfakb7Ouv3zRF0JgVGu+5HPxo+vWvyayf6ofLyOGPNnLsA1+L8kwk8CDwr
<     wntrm0NgLSuv701bR8FVUJJBMu2Fcxr1ucj4sJ/s1qWVYluUyCPJAJ8yavnB9sik
<     sJ8MBGP9BpiyAYERClbeUpMR9wFg2cZ3IM57lYVLToLiIyVR37Pk4iAAscIN2fdI
<     +MlfNgV1C33FIy9UmvYPeUFf9FukDEZcmVkoLw8PWOxX9jizFlm680XYb0B0K7xP
<     g8hJPR/nHYqc0zKn7Cpn6iq3eeQ5No2t3iQUNf4piMGht2WkbF+1LLgokYu41bko
<     /PjVMqLhy0UZqfrFghM/ucwdHyUTLN0E5U2QxtcYNA48l5xCLdIFc5mIRn/4S8Fk
<     ucv0RhlUen0tFHLPi/6qzeywnMGTJD17OQqy51bmu/9rM5lEJgHRf1v1fMjQoTtO
<     sNc5l9//JwY6AhlsCLetPxycvlUjkv8fR7aoGF03Az3LaVbttb8PRlQ+4qqGT3sC
<     C/Sxs2IRzDq1q0rHur5AhDdqjD9IwBJwsSB2P1R7D8EXn+6TB3Y3HnzZwoD7nTc4
<     izzYum206PEBhFqhumEHPzyo/QTUl4VNc5AeG5Hq8Yb0zZtUuTr27Ic0o2ECAwEA
<     AaM0MDIwEgYDVR0TAQH/BAgwBgEB/wIBATAcBgNVHREEFTATghFjYS5uMTg3Nzg1
<     MDU4LnNzbDANBgkqhkiG9w0BAQ0FAAOCAgEACvDcdcj+jJjXwb0Vn168XkQp6kqT
<     P/DtTIBIa/p/jwJKbYx42rvk0CZslS/3CwR3Nan/ddBE+oyRmqH5l1PZcv+pv/J3
<     hV/gviXX71Y8LrwT2nMzBjs44ps89ZsZoSEpVKgi+l662LxEt3LvjSjsv3TlE9Ar
<     mKpfkXZ6fLz+1BXdnvPcxfuam16E7bwel4pG5TnVkirbz1nw9G5Peq7S5SVYsqZd
<     UebdH6mXguA30dkj9tlF1TBz7RqsPCWN8160VCKynzIRPD13YtxBtwAP+IZYxEip
<     FyVZG0BOY5ATOAhjjiBNSte28fRY4koFjx5Xfiw9Gdvyz10wXalSnx4fvjHUgryO
<     6p0J+t8zUAq4qJmosDl40vy+r1qWv9JC7a45riXdD18E9XAqxJriOwUNBh41XCln
<     ntOBVWga1fejq+WdJP+E1+77C0bRQZqRnqG/OoqDn3FL7PV5i/yG2OwSMhuScf16
<     ZAZjG2DoYFlpcy2h3VZ/MPnLTUsnDQVYWEbVRYRNtTe0Y2QrULlSyxatI4V5h20R
<     SSn1tQiwixxfQyTz4psO8r9uxxgPnGFVY1gWAqWDP3TwIAslqTx5NS7Y5xEKVcm3
<     YvlVPTIm4YPba9BqNY1kf0W//QhxSOmnqUs0xDEotgMs887/YRyoJPKYZT3lTHte
<     q0Di9/oGTshOV94=
<     -----END CERTIFICATE-----
---
>   client_user: ((bosh.client))
>   client_secret: ((bosh.client_secret))
>   url: ((bosh.uri))
>   ca_cert: ((bosh.ca_cert))
```

A couple things to call out here:

* We eliminated the big ugly CI certificate from our pipeline manifest which eliminates the formatting hassles.
* We replaced the `spruce` "grab" statements like `(( grab $BOSH_CLIENT ))` with `((bosh.client))`. This latter syntax tells Concourse to connect to its configured [credential manager](https://concourse-ci.org/creds.html), and substitute the appropriate value. ***NOTE:*** *the* ***lack of spacing*** *around "bosh.client" matters; with spaces concourse will interpret this as a string and won't lookup the value.*

* Now we need to set these four Concourse variables (client, client_secret, uri, and ca_cert) in the credential manager. For the lab we've installed [HashiCorp Vault](https://learn.hashicorp.com/vault/) along with [S&W Safe](https://github.com/starkandwayne/safe) which provides some handly CLI helpers.

	```bash
	safe set concourse/${CONCOURSE_TEAM_NAME}/bosh uri=https://10.4.1.4:25555/
	safe set concourse/${CONCOURSE_TEAM_NAME}/bosh client=${BOSH_CLIENT}
	safe set concourse/${CONCOURSE_TEAM_NAME}/bosh client_secret=${BOSH_CLIENT_SECRET}
	safe set concourse/${CONCOURSE_TEAM_NAME}/bosh ca_cert@${HOME}/.ssh/director_ca.pem
	```
	
    In `vault` the settings above would need to be done as a single command since Vault key writes are done as an overwrite. The `safe` CLI supports that pattern, but also adds an "upsert" behavior that allows for cumulative additions to a key. *Note:* The key here is actually "concourse/${CONCOURSE_TEAM_NAME}/bosh".
    
* Let's read back our settings:

    ```bash
    safe read concourse/${CONCOURSE_TEAM_NAME}/bosh
    ```

* Merge your changes into the pipeline manifest
 
	```bash
	spruce merge --prune release  ci/settings_8.yml ci/lab8.yml > ci/pipeline.yml
	```

* Commit and push your codebase changes

	```bash
	git commit -am 'changes for lab 8'
	```

* Once again we set the pipeline 

	```bash
	fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
	```

Review the pipeline and note that there are no longer any credentials that will get stored in our repository. You'll also note that the pipeline itself is much cleaner and more readable now.

---

Congratulations on completing lesson 8; this now concludes our guided labs. For additional resources, and unguided challenges you can test yourself against see our [extras](./extras.md).