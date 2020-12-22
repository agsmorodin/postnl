const AWSXRay = require('aws-xray-sdk');
const AWS = require('aws-sdk');
const { v4: uuidv4 } = require('uuid');

const MESSAGES_TO_GENERATE = 1000000;
const BATCH = 10;
AWS.config.update({ region: 'eu-central-1' });
AWSXRay.setStreamingThreshold(0);
const segment = new AWSXRay.Segment('Sns message');
const ns = AWSXRay.getNamespace();

async function publishToSNS() {
    const TopicArn = 'arn:aws:sns:eu-central-1:188397741724:execution-plans-topic';
    const sns = AWSXRay.captureAWSClient(new AWS.SNS());

    let i = 0;
    while (i < MESSAGES_TO_GENERATE) {
        console.log('step', i);
        const snsRequests = [];
        for (let j = 0; j < BATCH; j++) {
            const message = {
                planId: uuidv4(),
                customerId: 123123123,
                address: 'Dam Square',
                events: ['started', 'processing', 'delivered', 'failed'],
                orders: [
                    { orderId: 1, operatorId: 13 },
                    { orderId: 2, operatorId: 15 },
                ],
            };

            const params = {
                TopicArn,
                Message: JSON.stringify(message),
            };
            snsRequests.push(sns.publish(params).promise());
            i++;
        }
        const result = await Promise.all(snsRequests);
        console.log('result', result);
    }
}

ns.run(async () => {
    AWSXRay.setSegment(segment);
    await publishToSNS();
    segment.close();
});
