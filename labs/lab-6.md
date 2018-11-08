## Lab 6: Passing Credentials with Concourse
Up until now we've set credentials and environment specific configuration within the code repository itself by editing "ci/tasks/upload-release.sh". In addition to the obvious problem of including credentials in a codebase, this ties the codebase to a single environment, and you may need to set the same variables across several different files.

In this exercise, we'll move these to our manifest.

#### Activity

```bash
spruce merge --prune release  ci/settings.yml ci/lab6.yml > ci/pipeline.yml
```

Once again we set the pipeline 
```bash
fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
```
