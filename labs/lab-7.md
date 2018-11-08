## Lab 6: Using Vault with Concourse

```bash
spruce merge --prune release  ci/settings.yml ci/lab6.yml > ci/pipeline.yml
```

Once again we set the pipeline 
```bash
fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
```
