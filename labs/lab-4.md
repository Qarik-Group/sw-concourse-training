## Lab 4: Split upload and deploy into multiple jobs and add a trigger


```bash
spruce merge --prune release  ci/settings.yml ci/lab4.yml > ci/pipeline.yml
```

Once again we set the pipeline 
```bash
fly -t training set-pipeline -c ci/pipeline.yml -p ${GITHUB_USERNAME}-pipeline
```
