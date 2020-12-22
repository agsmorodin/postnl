const { omit } = require('lodash');
const PlansRepository = require('../../src/repository');
const validPlan = require('../mocks/vaildPlan.json');

const logger = {
    info: jest.fn(),
    error: jest.fn(),
};

class DynamoSource {
    constructor() {
        this.store = new Map();
    }

    create({ Item: item }) {
        this.store.set(item.planId, item);
    }

    getOne({ Key: { planId } }) {
        return {
            Item: this.store.get(planId),
        };
    }
}

describe('Plans repository', () => {
    test('Should add a new plan', async () => {
        const plansRepository = new PlansRepository({
            source: new DynamoSource(),
            logger,
        });

        await plansRepository.createPlan(validPlan);
        const plan = await plansRepository.getPlanById(validPlan.planId);
        expect(plan).toEqual(validPlan);
    });

    test.each([
        'planId',
        'customerId',
        'address',
        'events',
        'orders',
    ])('Should throw an error if %s field does not exist in the plan', async (field) => {
        const plansRepository = new PlansRepository({
            source: new DynamoSource(),
            logger,
        });

        const invalidPlan = omit(validPlan, field);
        try {
            await plansRepository.createPlan(invalidPlan);
        } catch (e) {
            expect(e.message).toEqual(`child "${field}" fails because ["${field}" is required]`);
        }
    });
});
