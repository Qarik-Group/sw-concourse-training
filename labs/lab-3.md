## Lab 3: Add a Deploy Task to the release
* Open ci/tasks/upload-release.sh
* Edit the following environment variables with the values found in the supplied creds.yml or with the values supplied by your proctor.

  ```bash
  export CA_CERT_URL=<S3_object_URL>
  export BOSH_CLIENT_SECRET=<bosh password>
  export BOSH_DEPLOYMENT=<deployment name>
  export BOSH_DIRECTOR=<bosh director url>
  export BOSH_ENVIRONMENT=<bosh director ip>
  export BOSH_CLIENT=<bosh user>
  ```
### Deploy the Release

### Preparing your release for deployment
In the BOSH Training session we learned to create a BOSH release. Here that release has been provided in a
working state.  We'll want to create that release again here and push it back to your fork of this repository.

- Have a look at `manifests/nginx-release.yml`, and we'll merge those changes in to your bosh release

	```bash 
	spruce merge ci/settings.yml manifests/nginx-release.yml > manifests/manifest.yml
	```

- Have a look at `ci/lab3.yml` and we'll merge those in to your pipeline

	```bash
	spruce merge --prune github --prune release  ci/settings.yml ci/lab3.yml > ci/pipeline.yml
	```

- Once again we set the pipeline 

	```bash
	fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
	```
	
- At this point, a stemcell might need to be uploaded to complete the deploy-release concourse job.

Run the pipeline in the Web-UI and when it succeeds move on to [Lab-4](lab-4.md)
