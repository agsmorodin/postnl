## Architecture
see architecture.png

## Infrastructure
terraform directory

## Pipeline
AWS CloudBuild, see buildspec.yml

## How to deploy to aws environment
push changes to master

## How to run tests locally
```
docker-compose up
npm run test
```

## Performance testing
For performance analytics X-Ray is used during data ingestion.
How to ingest data:
```shell script
cd loadTestig
npm i
```
in index.js, set MESSAGES_TO_GENERATE to a number of plans you want to ingest,
prepare x-ray injestor, download from  https://docs.aws.amazon.com/xray/latest/devguide/xray-daemon.html#xray-daemon-running
```shell script
./xray_mac  -o -n eu-central-1
```  
run verify.js to see current number of plans
```
AWS_XRAY_DEBUG_MODE=true node verify.js
```
run the ingestor
```
AWS_XRAY_DEBUG_MODE=true node push.js
```
run verify.js to see new number of plans in DB
```
AWS_XRAY_DEBUG_MODE=true node verify.js
```

## Monitoring
SLO have to be defined for two different endpoints:  for data ingestion and data retrieval.

Data ingestion:
* p95 latency (how quickly plan gets ingested into DB): x-ray could be used to calculate this metric
* p95 500 errors: this metric could be collected from SNS and SQS. 

Data retrieval:
* p95 latency (how quickly the plan could be retrieved): we can collect metric directly from ApiGateway
* p95 500 errors: this metric could be collected from ApiGateway as well.

## TODO
1. trigger pipeline on push to any branch, run tests, terraform validation
2. semantic versioning, right now package version is simply a pipeline build number
3. multi-region if necessary
4. introduce dev environment, deploy infra and app to dev,  run 'e2e' tests, then deploy to 'prod'
5. fix x-ray for SQS-lambda integration
6. alerts based on cloudwatch (integration with PD?)
7. create a separate terraform setup for CodeBuild, it's created manually right now because of chicken and egg problem
8. describe api contracts in swagger
