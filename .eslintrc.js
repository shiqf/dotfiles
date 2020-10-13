module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: [
    '@typescript-eslint',
  ],
  extends: [
    'eslint:recommanded',
    'plugin:@typescript-eslint/eslint:recommanded',
    'plugin:@typescript-eslint/recommanded',
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
