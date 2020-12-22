const joi = require('joi');
const { enums } = require('./enums');

const { EventTypes } = enums;

exports.planDocument = joi.object().keys({
    planId: joi.string().required(),
    customerId: joi.number().required(),
    address: joi.string().required(),
    events: joi.array()
        .items(joi.string().valid(
            EventTypes.started,
            EventTypes.processing,
            EventTypes.delivered,
            EventTypes.failed,
        )),
    orders: joi.array()
        .items(joi.object().keys({
            orderId: joi.number().required(),
            operatorId: joi.number().required(),
        })),
});
