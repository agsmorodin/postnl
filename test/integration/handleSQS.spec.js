const { handleSQS } = require('../../src/index');
const sqsOnePlanEvent = require('../mocks/events/sqsOnePlanEvent.json');
const sqsTwoPlansEvent = require('../mocks/events/sqsTwoPlansEvent.json');
const sqsTwoPlansOneInvalidEvent = require('../mocks/events/sqsTwoPlansOneInvalidEvent.json');

jest.mock('@middy/sqs-partial-batch-failure', () => jest.fn(() => ({
    before: (handler, next) => next(),
})));

describe('handleSQS', () => {
    test('Should add a new plan when receives one plan in a batch', async () => {
        const response = await handleSQS(sqsOnePlanEvent);
        expect(response).toEqual([{
            status: 'fulfilled',
            value: {
                address: 'Dam Square',
                customerId: 123123123,
                events: ['started', 'processing', 'delivered', 'failed'],
                orders: [
                    { operatorId: 13, orderId: 1 },
                    { operatorId: 15, orderId: 2 },
                ],
                planId: '3d8a6df6-e091-41de-a673-73d7925b52a2',
            },
        }]);
    });

    test('Should add two plans when receives two plans in a batch', async () => {
        const response = await handleSQS(sqsTwoPlansEvent);
        expect(response).toEqual([{
            status: 'fulfilled',
            value: {
                address: 'Dam Square',
                customerId: 11111,
                events: ['started', 'processing', 'delivered', 'failed'],
                orders: [
                    { operatorId: 13, orderId: 1 },
                    { operatorId: 15, orderId: 2 },
                ],
                planId: 'ad3b15b7-9ad3-453b-b15b-109529249bcf',
            },
        },
        {
            status: 'fulfilled',
            value: {
                address: 'De Nieuwmarkt',
                customerId: 22222,
                events: ['started', 'processing', 'delivered', 'failed'],
                orders: [
                    { operatorId: 14, orderId: 5 },
                    { operatorId: 16, orderId: 7 },
                ],
                planId: '2c4714f9-bfea-4e1c-9b4c-df53b3f09926',
            },
        }]);
    });

    test('Should add one plan out of two when receives one invalid plan in a batch', async () => {
        const [firstPlanResult, secondPlanResult] = await handleSQS(sqsTwoPlansOneInvalidEvent);

        expect(firstPlanResult.status).toEqual('rejected');
        expect(firstPlanResult.reason.message).toEqual('child "customerId" fails because ["customerId" is required]');
        expect(secondPlanResult).toEqual({
            status: 'fulfilled',
            value: {
                address: 'De Nieuwmarkt',
                customerId: 22222,
                events: ['started', 'processing', 'delivered', 'failed'],
                orders: [
                    { operatorId: 14, orderId: 5 },
                    { operatorId: 16, orderId: 7 },
                ],
                planId: '222222-bfea-4e1c-9b4c-22222222',
            },
        });
    });
});
