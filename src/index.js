const middy = require('@middy/core');
const sqsPartialBatchFailureMiddleware = require('@middy/sqs-partial-batch-failure');
const logger = require('pino')({ name: 'app' });

const { DynamoSource } = require('./dynamoClient');
const PlansRepository = require('./repository');
const PlansService = require('./service');

const config = {
    endpoint: process.env.DYNAMO_ENDPOINT,
    region: process.env.REGION ? process.env.REGION : 'eu-central-1',
    version: process.env.CODE_VERSION,
};

const dynamoOptions = { region: config.region };
if (config.endpoint) {
    dynamoOptions.endpoint = config.endpoint;
    dynamoOptions.accessKeyId = 'testing';
    dynamoOptions.secretAccessKey = 'testing';
}

const plansRepository = new PlansRepository({
    source: new DynamoSource(dynamoOptions),
    logger,
});
const plansService = new PlansService({
    plansRepository,
    logger,
});

const handleGetHttp = async (event) => {
    logger.info({ event }, 'Handling get request');
    const { planId } = event.pathParameters;
    const plan = await plansService.getPlanById(planId);
    const response = {
        statusCode: plan ? 200 : 404,
        body: JSON.stringify(plan),
    };
    logger.info({ response }, 'Response');
    return response;
};

const processRecord = async (record) => {
    const { Message } = JSON.parse(record.body);
    return plansService.createPlan(JSON.parse(Message));
};

const sqsHandler = async (event) => {
    logger.info({ event }, 'Handling SQS');
    const messagePromises = event.Records.map((record) => processRecord(record));
    return Promise.allSettled(messagePromises);
};

const handleSQS = middy(sqsHandler);
handleSQS.use(sqsPartialBatchFailureMiddleware());

module.exports = {
    handleGetHttp,
    handleSQS,
};
