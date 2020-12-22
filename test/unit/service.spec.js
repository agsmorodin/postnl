const PlansService = require('../../src/service');

const logger = {
    info: jest.fn(),
    error: jest.fn(),
};

class PlansRepository {
    constructor() {
        this.store = new Map();
    }

    createPlan(plan) {
        this.store.set(plan.planId, plan);
    }

    getPlanById(planId) {
        return this.store.get(planId);
    }
}

describe('Plans service', () => {
    test('Should add a new plan', async () => {
        const plansService = new PlansService({
            plansRepository: new PlansRepository(),
            logger,
        });

        const plan = await plansService.createPlan({ planId: 1, content: 'somecontent' });

        expect(plan).toEqual({ planId: 1, content: 'somecontent' });
    });

    test('Should return a plan by id', async () => {
        const plansService = new PlansService({
            plansRepository: new PlansRepository(),
            logger,
        });

        await plansService.createPlan({ planId: 1, content: 'somecontent' });
        const plan = await plansService.getPlanById(1);

        expect(plan).toEqual({ planId: 1, content: 'somecontent' });
    });
});
