const AWS = require('aws-sdk');

const documentClient = new AWS.DynamoDB.DocumentClient( { region: 'eu-central-1' });
const TABLE_NAME = 'execution-plans';

const scanTable = async (tableName) => {
    const params = {
        TableName: tableName,
    };

    const scanResults = [];
    let items;
    do {
        items = await documentClient.scan(params).promise();
        items.Items.forEach((item) => scanResults.push(item));
        params.ExclusiveStartKey = items.LastEvaluatedKey;
    } while (typeof items.LastEvaluatedKey !== 'undefined');

    return scanResults;
};

(async () => {
    const result = await scanTable(TABLE_NAME);
    console.log('number of records', result.length);
})();
