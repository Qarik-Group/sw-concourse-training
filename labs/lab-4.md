## Lab 4: Split upload and deploy into multiple jobs and add a trigger

#### Setup
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

* Open ci/tasks/deploy-relese.sh
* Edit the following environment variables with the values used above.

  ```bash
  export CA_CERT_URL=<S3_object_URL>
  export BOSH_CLIENT_SECRET=<bosh password>
  export BOSH_DEPLOYMENT=<deployment name>
  export BOSH_DIRECTOR=<bosh director url>
  export BOSH_ENVIRONMENT=<bosh director ip>
  export BOSH_CLIENT=<bosh user>
  ```

#### Activity
* Let's compare ci/lab3.yml to ci/lab4.yml and discuss the changes:

	```bash
	diff ci/lab3.yml ci/lab4.yml
	17a18,24
	> - name: job-deploy-release
	>   public: true
	>   plan:
	>   - get: source-code
	>     trigger: true
	>     passed: [job-upload-release]
	>     params: { depth: 1 }
	```

* Great, now we'll update our pipeline manifest with the lab4 changes. 

	```bash
	spruce merge --prune release  ci/settings.yml ci/lab4.yml > ci/pipeline.yml
	```

* Commit your release and push it back to Github
	```bash
	git commit -am 'split upload and deploy into multiple jobs'
	git push
	```

* Once again we set the pipeline 

	```bash
	fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
	```

Watch the Web-UI, within 30 seconds to a minute the trigger should pickup the changes applied to the git-repo and automatically process your pipeline. Once this processes, and turns green you can move on to [Lab-5](lab-5.md).