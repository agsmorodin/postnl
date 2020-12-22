class PlansService {
    constructor({ plansRepository, logger }) {
        this.plansRepository = plansRepository;
        this.logger = logger;
    }

    async getPlanById(planId) {
        return this.plansRepository.getPlanById(planId);
    }

    async createPlan(plan) {
        await this.plansRepository.createPlan(plan);
        return this.getPlanById(plan.planId);
    }
}

module.exports = PlansService;
