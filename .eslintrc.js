module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: [
    '@typescript-eslint',
  ],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/eslint-recommended',
    'plugin:@typescript-eslint/recommended',
  ],
  // 0: 'off', 1: 'warn', 2: 'error'
  rules: {
    semi: 2,
  },
  parserOptions: {
    ecmaVersion: 11,
    sourceType: 'module',
  },
  env: {
    node: true,
    es2020: true,
  },
};
