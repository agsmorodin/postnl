'use strict';
console.log('Loading hello world function');

exports.handler = async (event) => {
    console.log('version', 1);
    console.log("request: " + JSON.stringify(event));
    const { planId } = event.pathParameters;
    let responseCode = 200;
    console.log('planId', planId);

    let responseBody = {
        planId,
    };

    let response = {
        statusCode: responseCode,
        body: JSON.stringify(responseBody)
    };
    console.log("response: " + JSON.stringify(response))
    return response;
};
