/*
 * For a detailed explanation regarding each configuration property, visit:
 * https://jestjs.io/docs/en/configuration.html
 */

module.exports = {
    clearMocks: true,
    coverageProvider: 'v8',
    globalSetup: '<rootDir>/test/utils/manipulateDB.js',
    testEnvironment: 'node',
};
