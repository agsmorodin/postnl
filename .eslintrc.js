module.exports = {
    extends: [
        'airbnb-base',
    ],
    rules: {
        'no-unused-vars': ['error', {argsIgnorePattern: 'next'}],
        'no-restricted-syntax': ['error', 'ForInStatement', 'LabeledStatement', 'WithStatement'],
        indent: [2, 4],
        'linebreak-style': 0,
        'max-len': ['error', { code: 140 }],
        'class-methods-use-this': 0,
        'no-plusplus': 'off',
        'max-classes-per-file': 'off',
    },
    env: {
        node: true,
        jest: true,
    },
};
