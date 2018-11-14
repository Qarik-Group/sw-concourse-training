## Lab 7: DRYing up the Variables (DRY => Do not Repeat Yourself)

During the last exercise we moved the Environment variables used by the deployment to our pipeline manifest so they could be referenced by each job. The obvious problem here is that we had to set each variable for each job, so if one thing changes you may need to change it in multiple places. For a larger deployment this makes managing these variables painful and error prone. Let's DRY things up a bit.

### Sprucing things Up
Up until this point we've been using `spruce merge` to prune and join the lab yaml file with a settings yaml. If you haven't looked at "settings.yml" yet, now would be a good time to do that.

```yaml
---
meta:
  name:   (( concat release.name "-demo" ))
  target: training
  url:    https://pipes.starkandwayne.com
  pipeline: (( grab meta.name ))

release:
  name: (( concat github.username "-nginx" ))

github:
  username: (( grab $GITHUB_USERNAME ))
  branch: master
  repository: (( concat "https://github.com/" github.username "/sw-concourse-training.git" ))
```

Throughout the file you'll notice special directives encapsulated by a double parenthesis `(( ... ))`. Let's explore some of these:

```bash
(( grab $GITHUB_USERNAME ))
```

This sets the github.username to the value of the local Environmment variable GITHUB\_USERNAME which was set in [Lab-1](lab-1.md) using the set\_env.sh script.

```bash
(( concat github.username "-nginx" ))
```

This sets the release.name to the github/username attribute set in the YAML by `(( grab $GITHUB_USERNAME ))` and concatenated with "-nginx".

```bash
(( concat release.name "-demo" ))
```

This will set the value of meta.name to release.name concatenated with "-demo".

If your github username were "arthurdent" you might have a fondness for [Vogon poetry](https://h2g2.com/edited_entry/A150076) and the `spruce merge` of "settings.yml" would be:

```yaml
---
meta:
  name:   arthurdent-nginx-demo
  target: training
  url:    https://pipes.starkandwayne.com
  pipeline: arthurdent-nginx-demo

release:
  name: arthurdent-nginx

github:
  username: arthurdent
  branch: master
  repository: https://github.com/arthurdent/sw-concourse-training.git
```

### Activity

The "ci/lab7.yml" file has had all those params we manually set before redefined using the following variables.

* bosh.deployment
* bosh.client_user
* bosh.client_secret
* bosh.url
* bosh.ca_cert

Edit the settings.yml to define these variables; where possible, use the Spruce syntax, to grab variables from other settings that exist in the YAML or that have been set as environment variables. Three of the variables can be set based on existing settings or environment variables, two will be written directly as strings.

There is more than one correct solution; one possible approach can be found below (hardcoded strings will vary):

<details><summary>Solution</summary>

```yaml
bosh:
  deployment: (( grab release.name ))
  client_user: (( grab $BOSH_CLIENT ))
  client_secret: (( grab $BOSH_CLIENT_SECRET ))
  url: https://10.4.1.4:25555/
  ca_cert: |
    -----BEGIN CERTIFICATE-----
    MIIE5zCCAs+gAwIBAgIBAjANBgkqhkiG9w0BAQ0FADAcMRowGAYDVQQDExFjYS5u
    MTg3Nzg1MDU4LnNzbDAeFw0xODExMDIyMTQ5NTdaFw0yODEwMzAyMTQ5NTdaMBwx
    GjAYBgNVBAMTEWNhLm4xODc3ODUwNTguc3NsMIICIjANBgkqhkiG9w0BAQEFAAOC
    Ag8AMIICCgKCAgEAqTzo+nKWH26ItXjHpt2Val6D1RIpwRlcYn+IXR8ydJ1JP3Kp
    trEfHHhfakb7Ouv3zRF0JgVGu+5HPxo+vWvyayf6ofLyOGPNnLsA1+L8kwk8CDwr
    wntrm0NgLSuv701bR8FVUJJBMu2Fcxr1ucj4sJ/s1qWVYluUyCPJAJ8yavnB9sik
    sJ8MBGP9BpiyAYERClbeUpMR9wFg2cZ3IM57lYVLToLiIyVR37Pk4iAAscIN2fdI
    +MlfNgV1C33FIy9UmvYPeUFf9FukDEZcmVkoLw8PWOxX9jizFlm680XYb0B0K7xP
    g8hJPR/nHYqc0zKn7Cpn6iq3eeQ5No2t3iQUNf4piMGht2WkbF+1LLgokYu41bko
    /PjVMqLhy0UZqfrFghM/ucwdHyUTLN0E5U2QxtcYNA48l5xCLdIFc5mIRn/4S8Fk
    ucv0RhlUen0tFHLPi/6qzeywnMGTJD17OQqy51bmu/9rM5lEJgHRf1v1fMjQoTtO
    sNc5l9//JwY6AhlsCLetPxycvlUjkv8fR7aoGF03Az3LaVbttb8PRlQ+4qqGT3sC
    C/Sxs2IRzDq1q0rHur5AhDdqjD9IwBJwsSB2P1R7D8EXn+6TB3Y3HnzZwoD7nTc4
    izzYum206PEBhFqhumEHPzyo/QTUl4VNc5AeG5Hq8Yb0zZtUuTr27Ic0o2ECAwEA
    AaM0MDIwEgYDVR0TAQH/BAgwBgEB/wIBATAcBgNVHREEFTATghFjYS5uMTg3Nzg1
    MDU4LnNzbDANBgkqhkiG9w0BAQ0FAAOCAgEACvDcdcj+jJjXwb0Vn168XkQp6kqT
    P/DtTIBIa/p/jwJKbYx42rvk0CZslS/3CwR3Nan/ddBE+oyRmqH5l1PZcv+pv/J3
    hV/gviXX71Y8LrwT2nMzBjs44ps89ZsZoSEpVKgi+l662LxEt3LvjSjsv3TlE9Ar
    mKpfkXZ6fLz+1BXdnvPcxfuam16E7bwel4pG5TnVkirbz1nw9G5Peq7S5SVYsqZd
    UebdH6mXguA30dkj9tlF1TBz7RqsPCWN8160VCKynzIRPD13YtxBtwAP+IZYxEip
    FyVZG0BOY5ATOAhjjiBNSte28fRY4koFjx5Xfiw9Gdvyz10wXalSnx4fvjHUgryO
    6p0J+t8zUAq4qJmosDl40vy+r1qWv9JC7a45riXdD18E9XAqxJriOwUNBh41XCln
    ntOBVWga1fejq+WdJP+E1+77C0bRQZqRnqG/OoqDn3FL7PV5i/yG2OwSMhuScf16
    ZAZjG2DoYFlpcy2h3VZ/MPnLTUsnDQVYWEbVRYRNtTe0Y2QrULlSyxatI4V5h20R
    SSn1tQiwixxfQyTz4psO8r9uxxgPnGFVY1gWAqWDP3TwIAslqTx5NS7Y5xEKVcm3
    YvlVPTIm4YPba9BqNY1kf0W//QhxSOmnqUs0xDEotgMs887/YRyoJPKYZT3lTHte
    q0Di9/oGTshOV94=
    -----END CERTIFICATE-----
```

</details>

Ok, let's do a merge and see if everything worked as expected.

```bash
spruce merge --prune release  ci/settings.yml ci/lab7.yml > ci/pipeline.yml
```

Now we'll commit and push our changes

```bash
git commit -am 'updating codebase for lab 7'
git push
```

Once again we set the pipeline 
```bash
fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
```

Wait for your pipeline to process and ensure everything works as expected; then you can move on to [Lab-8](lab-8.md).