## Lab 6: Passing Credentials with Concourse
Up until now we've set credentials and environment specific configuration within the code repository itself by editing "ci/tasks/upload-release.sh" (and its descendants). In addition to the obvious problem of including credentials in a codebase, this ties the codebase to a single environment, and you may need to set the same variables across several different files.

In this exercise, we'll move all of these to our pipeline manifest.

#### Activity
* Let's start by looking at the newest version of the upload script:

	```bash
	#!/usr/bin/env bash
	set -x
	#For the purpose of this tutorial, there are credentials being commited here.
	#This is on purpose and will be covered in the security tutorial.
	#The director is expected to be secured and only locally available for this lab session
	#But this does not demonostrate a best practice
	
	cd source-code/nginx_release
	bosh upload-release releases/release.gz
	```
	
	For a point of reference, the original version was "ci/tasks/upload-release.sh".
	
* If you review the changes to the manifest from the prior lab you'll notice several changes:
	* The elements associated with `cert-file` are no longer needed and have been removed. In the place of that file we are passing an environment variable of "BOSH\_CA\_CERT".
	* We are now setting the following environment variables as part of the manifest:
		* BOSH\_DEPLOYMENT
		* BOSH\_CLIENT
		* BOSH\_CLIENT\_SECRET
		* BOSH\_ENVIRONMENT
		* BOSH\_CA\_CERT
	* The shell script file we are calling is now named "...-release-with-vars.sh"
	* We've removed the "resource-types" section which gave us access to the cURL concourse resource and removed the "cert-file" resource definition that was using it.
* Go ahead and replace the BOSH environemnt variables with the settings used for previous labs.
	* There are 5 variables to replace, each appearing in the manifest twice (we'll simplify this further in a future exercise).
	* "BOSH\_ENVIRONMENT" is **no longer** *"training"* will now be set to the URL of the "BOSH\_DIRECTOR".
	* Be careful to get the indentation of the "BOSH\_CA\_CERT" correct so that the YAML syntax remains valid.

* Let's merge our manifest

	```bash
	spruce merge --prune release  ci/settings.yml ci/lab6.yml > ci/pipeline.yml
	```

* Commit our code

	```bash
	git commit -am 'updating codebase for lab 6'
	git push
	```

* and finally, we set the pipeline

	```bash
	fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
	```

If we did everything correct, our pipeline should once again look a lot more like it did at the end of Lab-4:

![Lab-6 Concourse Pipeline](./images/lab6_pipeline_Concourse.png)

Once the pipeline runs successfully we can talk about DRYing up our variables in [Lab-7](lab-7.md)