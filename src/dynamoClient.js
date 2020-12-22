const AWS = require('aws-sdk');

exports.DynamoSource = class DynamoSource {
    constructor(options) {
        this.client = new AWS.DynamoDB.DocumentClient(options);
        this.dynamoDB = new AWS.DynamoDB(options);
    }

    getOne(params) {
        return this.client.get(params).promise();
    }

    create(params) {
        return this.client.put(params).promise();
    }

    updateOne(params) {
        return this.client.update(params).promise();
    }

    describeTable(params) {
        return this.dynamoDB.describeTable(params).promise();
    }
};
