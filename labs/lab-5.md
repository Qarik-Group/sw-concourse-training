## Lab 5: Using a Certificate file with Concourse
* Open ci/tasks/upload-release-supplied-cert.sh
* Edit the following environment variables with the values found in the supplied creds.yml or with the values supplied by your proctor.

  ```bash
  export BOSH_CLIENT_SECRET=<bosh password>
  export BOSH_DEPLOYMENT=<deployment name>
  export BOSH_DIRECTOR=<bosh director url>
  export BOSH_ENVIRONMENT=<bosh director ip>
  export BOSH_CLIENT=<bosh user>
  ```

* Open ci/tasks/deploy-relese-supplied-cert.sh
* Edit the following environment variables with the values used above.

  ```bash
  export BOSH_CLIENT_SECRET=<bosh password>
  export BOSH_DEPLOYMENT=<deployment name>
  export BOSH_DIRECTOR=<bosh director url>
  export BOSH_ENVIRONMENT=<bosh director ip>
  export BOSH_CLIENT=<bosh user>
  ```
 
#### Activity
This time, we are going to supply the certificate from a remote resource. To do this, we are going to add a resource_type using an external library, that allows us to create a file from a remote resource. Let's look at how this changes the manifest:

```bash
diff ci/lab4.yml ci/lab5.yml
7a8
>   - get: cert-file
17a19
>         - name: cert-file
24a27
>   - get: cert-file
34a38,45
>         - name: cert-file
>
> resource_types:
>   - name: file-url
>     type: docker-image
>     source:
>       repository: pivotalservices/concourse-curl-resource
>       tag: latest
41a53,57
> - name: cert-file
>   type: file-url
>   source:
>     url: https://unreal-snw.s3.amazonaws.com/training-bosh.pem
>     filename: training-bosh.pem
```

We can see how this is used in our script by comparing the old upload and deploy scripts with the new ones:

```bash
diff ci/tasks/upload-release.sh ci/tasks/upload-release-supplied-cert.sh
8d7
< export CA_CERT_URL=https://unreal-snw.s3.amazonaws.com/training-bosh.pem
15,19c14
< cd source-code/nginx_release
<
< curl -LO ${CA_CERT_URL}
< bosh alias-env ${BOSH_ENVIRONMENT} --ca-cert training-bosh.pem -e ${BOSH_DIRECTOR}
<
---
> bosh alias-env ${BOSH_ENVIRONMENT} --ca-cert cert-file/training-bosh.pem -e ${BOSH_DIRECTOR}
21a17
> cd source-code/nginx_release
```

* Let's go ahead and generate our pipeline manifest.
  
	```bash
	spruce merge --prune release  ci/settings.yml ci/lab5.yml > ci/pipeline.yml
	```


- Commit your release and push it back up to your Github fork

	```bash
	git commit -am 'updated release task'
	git push
	```

* Once again we set the pipeline 

	```bash
	fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
	```

Run the pipeline in the Web-UI and when it succeeds move on to [Lab-6](lab-6.md)