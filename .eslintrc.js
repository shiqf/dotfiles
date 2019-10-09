module.exports = {
  parser: '@typescript-eslint/parser',
  plugins: [
    '@typescript-eslint',
    // 'typescript',
  ],
  env: {
    browser: true,
    node: true,
    es6: true,
  },
  // extends: 'eslint-config-alloy',
  globals: {
    Atomics: 'readonly',
    SharedArrayBuffer: 'readonly',
  },
  parserOptions: {
    ecmaVersion: 2017,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  rules: {
    semi: 'error',
    eqeqeq: [ 2, 'always', { null: 'ignore' } ],
    'no-undef': 'error',
    'no-unused-vars': 1,
    'typescript/no-unused-vars': 1,
    'typescript/class-name-casing': 2,
  },
};
