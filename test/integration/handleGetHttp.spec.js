const { handleGetHttp } = require('../../src/index');
const getPlanEvent = require('../mocks/events/getPlanEvent');
const getPlanEventNotFound = require('../mocks/events/getPlanEventNotFound.json');
const { addItem } = require('../utils/manipulateDB');
const validPlan = require('../mocks/vaildPlan.json');

describe('handleGetHttp', () => {
    test('Should return a plan if exists', async () => {
        await addItem(validPlan);
        const response = await handleGetHttp(getPlanEvent);
        expect(response).toEqual({
            body: JSON.stringify(validPlan),
            statusCode: 200,
        });
    });

    test('Should return 404 if such plan does not exist', async () => {
        const response = await handleGetHttp(getPlanEventNotFound);
        expect(response).toEqual({
            body: 'null',
            statusCode: 404,
        });
    });
});
