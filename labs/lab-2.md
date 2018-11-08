## Lab 2: Building Our first Tasks
* Open `ci/tasks/upload-release.sh`
* Edit the following environment variables with the values found in the supplied creds.yml or with the values supplied by your proctor.

  ```bash
  export CA_CERT_URL=<S3_object_URL>
  export BOSH_CLIENT_SECRET=<bosh password>
  export BOSH_DEPLOYMENT=<deployment name>
  export BOSH_DIRECTOR=<bosh director url>
  export BOSH_ENVIRONMENT=<bosh director ip>
  export BOSH_CLIENT=<bosh user>
  ```

  The rest of the task should look familiar if you've been through the BOSH training course. We need to actually make sure our pipeline knows how to access this release.

### Add the task to the pipeline yml
Have a look at ci/lab2.yml, and we'll merge those changes in to your pipeline

```bash 
spruce merge --prune github --prune release  ci/settings.yml ci/lab2.yml > ci/pipeline.yml
```

### Commit your release and push it back up to your Github fork

```bash
git commit -am 'updated release task'
git push
```

### Update the pipeline
Every time we make a chance to our pipeline we'll need to reset the pipeline

```bash
fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
```

Run the pipeline in the Web-UI and when it succeeds move on to [Lab-3](lab-3.md)
