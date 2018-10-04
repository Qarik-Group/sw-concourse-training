# Concourse Training Labs
Support release and pipeline templates for Stark &amp; Wayne Concourse training single day Session.

This training session build off of the two day BOSH course.  The goal of the training is to deploy and
upgrade the Hello World bosh release that is deployed in that session.


##Lab 1: Setup your Environment
### How to setup this lab
* You'll need several environment parameters (provided by instructor in a proctored session)
  * CONCOURSE_TEAM_NAME
  * CONCOURSE_PIPELINE_URL
  * GITHUB_USERNAME
  * CONCOURSE_USERNAME
  * CONCOURSE_PASSWORD

* Fork this repository in to your own github account
* Clone your fork of this repository locally
  * `git clone git@github.com/$GITHUB_USERNAME/concourse-training.git`
  * Edit the nginx_release/ci/settings.yml file

###Create your release
  ```bash
  cd nginx_release
  bosh create-release --force --tarball tarball.gz
  ```
  You should now have a BOSH Release in the root of this project

### Commit your release and push it back up to your Github fork
```bash
git commit -am 'updated release for deployment'
git push
```
fly -t concourse-tutorial set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline

### Installing the `fly` Command
Visit <CONCOURE_URL> and get the URL from the lower right

### Targeting your concourse Pipeline
```
fly --target concourse-tutorial   login --concourse-url $CONCOURSE_PIPELINE_URL -k  -n $CONCOURSE_TEAM_NAME  -u $CONCOURSE_USERNAME -p $CONCOURSE_PASSWORD
```

```bash
  fly -t concourse-tutorial set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
```

### Login to the concourse WEB UI
* Visit the pipeline URL http://<<CONCOURSE_URL>>
* Log In with provided credentials
* Find your pipeline on the Left of the interface
* New pipelines start in a paused state, you can now run your pipeline

## Lab 2: Building Our first Tasks
* Open ci/tasks/upload-release.sh
* Add the following environment variables, provided by the course proctor

```bash
  export BOSH_DEPLOYMENT=<deployment name>
  export BOSH_DIRECTOR=<bosh director url>
  export BOSH_ENVIRONMENT=<bosh director ip>
  export BOSH_CLIENT=<bosh user>
  export BOSH_CLIENT_SECRET=<bosh password>
```
The rest of the task should look familiar if you've been through the BOSH training course
But we need to actually make sure our pipeline knows how to access this release.

### Add the task to the pipeline yml
Have a look at ci/nginx-pipeline-with-task.yml, and we'll merge those changes in to your pipeline
`spruce merge --prune github --prune release  ci/settings.yml ci/lab2.yml > ci/pipeline.yml`

### Update the pipeline
* `fly -t concourse-tutorial set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline`

## Lab 3: Add a Deploy Task to the release
* Open ci/tasks/upload-release.sh
* Add the following environment variables, provided by the course proctor

```bash
  export BOSH_DEPLOYMENT=<deployment name>
  export BOSH_DIRECTOR=<bosh director url>
  export BOSH_ENVIRONMENT=<bosh director ip>
  export BOSH_CLIENT=<bosh user>
  export BOSH_CLIENT_SECRET=<bosh password>
```
### Deploy the Release

### Preparing your release for deployment
In the BOSH Training session we learned to create a BOSH release. Here that release has been provided in a
working state.  We'll want to create that release again here and push it back to your fork of this repository.

* `spruce merge ci/settings.yml mainfests/nginx-release.yml > manifests/manifest.yml`
* `spruce merge --prune github --prune release  ci/settings.yml ci/lab3.yml > ci/pipeline.yml`
* `fly -t concourse-tutorial set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline`



### Extra Credit
* Refactor the upload-release task to move the training-bosh.pem file in to a file
or s3 resource
* Update the pipeline to trigger on commit to the BOSH repo
* Point out as many security problems as you can in this release
