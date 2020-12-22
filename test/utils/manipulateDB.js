const AWS = require('aws-sdk');

AWS.config.update({
    region: 'eu-central-1',
    endpoint: 'http://localhost:8000',
});

const dynamodb = new AWS.DynamoDB();
const documentClient = new AWS.DynamoDB.DocumentClient();
const tableName = 'execution-plans';

const params = {
    TableName: tableName,
    KeySchema: [
        { AttributeName: 'planId', KeyType: 'HASH' },
    ],
    AttributeDefinitions: [
        { AttributeName: 'planId', AttributeType: 'S' },
    ],
    ProvisionedThroughput: {
        ReadCapacityUnits: 10,
        WriteCapacityUnits: 10,
    },
};

const addItem = async (Item) => {
    const params = {
        TableName: tableName,
        Item,
    };
    await documentClient.put(params).promise();
};

const createTable = async () => {
    let exists = false;
    try {
        exists = await dynamodb.describeTable({ TableName: tableName }).promise();
    } catch (err) {
        if (err.name !== 'ResourceNotFoundException') {
            throw err;
        }
    }

    if (exists) {
        await dynamodb.deleteTable({ TableName: tableName }).promise();
    }

    try {
        await dynamodb.describeTable({ TableName: tableName }).promise();
    } catch (err) {
        console.log('does not exist!');
    }

    try {
        await dynamodb.createTable(params).promise();
        console.log('Created table successfully!');
    } catch (err) {
        console.error('Error JSON:', JSON.stringify(err, null, 2));
    }
};

module.exports = createTable;
module.exports.addItem = addItem;
