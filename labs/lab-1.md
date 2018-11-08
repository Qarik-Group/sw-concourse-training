## Lab 1: Setup your Environment

### How to setup this lab

* Fork this repository in to your own github account
* Clone your fork of this repository locally

	```bash
	git clone git@github.com:$GITHUB_USERNAME/sw-concourse-training.git
	```

* Edit the `nginx_release/ci/settings.yml` file to set your github username. These settings will be interpolated in to other files throughout the tutorial and save you some typing
This is also a common pattern used in managing more complicated pipelines

* rename `set_env.sh.example` to set_env.sh and fill in the information it asks for and then source the file

	```bash
	  # These variables are fixed values that typically won't change
	  export CONCOURSE_TEAM_NAME=${USER}
	  export CONCOURSE_USERNAME=admin
	  # These variables are provided by your instructor
	  export CONCOURSE_PIPELINE_URL=
	  export GITHUB_USERNAME=
	
	  export CONCOURSE_PASSWORD=
	```

* Source the file in to your shell.

	```bash
	source set_env.sh 
	```

### Create Your First Release
- Create your release
  
	```bash
	cd nginx_release
	mkdir releases
	bosh create-release --force --name=${GITHUB_USERNAME}-nginx --tarball releases/release.gz --timestamp-version 
	```

	You should now have a BOSH Release in the releases of this project

- Commit your release and push it back up to your Github fork

	```bash
	git commit -am 'updated release for deployment'
	git push
	```

- To install the `fly` command, visit <CONCOURSE_URL> and get the URL from the lower right. On a shared lab-provided jumpbox the `fly` command will be pre-installed for you.

- Targeting your concourse Pipeline

	```bash
	fly --target training   login --concourse-url $CONCOURSE_PIPELINE_URL -k  -n $CONCOURSE_TEAM_NAME  -u $CONCOURSE_USERNAME -p $CONCOURSE_PASSWORD
	```
  
    Have a look at `ci/lab1.yml`.
    
- Now we'll merge those changes in to your pipeline

	```bash 
	spruce merge ci/settings.yml ci/lab1.yml > ci/pipeline.yml
	fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
	```

### Login to the concourse WEB UI
* Visit the pipeline URL https://<<CONCOURSE_URL>>
* Log In with provided credentials
* Find your pipeline on the Left of the interface
* New pipelines start in a paused state, you can now run your pipeline

### Unpause your Concourse Pipeline
To unpause your pipeline you'll run the command:

```bash
fly -t training unpause-pipeline -p ${GITHUB_USERNAME}-pipeline
```

Now click the (+) symbol in the Web UI, if you've done everything correctly the pipeline should process successfully. Once the pipeline turns green you can move on to [Lab-2](lab-2.md).