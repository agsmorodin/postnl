const { get, isObject } = require('lodash');
const joi = require('joi');

const planDefinitions = require('./plans.def');

class PlansRepository {
    constructor({ source, logger }) {
        this.source = source;
        this.logger = logger;
        this.Table = {
            name: 'execution-plans',
            columns: {
                planId: 'planId',
                customerId: 'customerId',
                address: 'address',
                events: 'events',
                orders: 'orders',
            },
        };
    }

    parsePlanItem(item) {
        const { columns } = this.Table;
        if (item) {
            return {
                planId: get(item, columns.planId),
                customerId: get(item, columns.customerId),
                address: get(item, columns.address),
                events: get(item, columns.events),
                orders: get(item, columns.orders),
            };
        }
        return null;
    }

    async getPlanById(planId) {
        const dynamoParams = {
            TableName: this.Table.name,
            Key: {
                planId,
            },
        };

        this.logger.info(
            { dynamodbCall: dynamoParams },
            `${this.Table.name}.getOne(dynamoParams)`,
        );

        const dynamoResult = await this.source.getOne(dynamoParams);
        this.logger.info(
            { dynamodbResult: dynamoResult },
            `${this.Table.name}.getOne(dynamoParams) => dynamoResult`,
        );
        return this.parsePlanItem(get(dynamoResult, 'Item'));
    }

    async createPlan(plan) {
        const { error: err } = joi.validate(plan, planDefinitions.planDocument, { allowUnknown: true });
        if (isObject(err)) {
            this.logger.error({ err }, 'Invalid plan schema');
            throw new Error(get(err, 'message'));
        }

        const dynamoParams = {
            Item: plan,
            TableName: this.Table.name,
        };

        this.logger.info({
            dynamodbCall: dynamoParams,
        }, `${this.Table.name}.create(dynamoParams)`);

        return this.source.create(dynamoParams);
    }
}

module.exports = PlansRepository;
