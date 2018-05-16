module.exports = {
  "parserOptions": {
    "ecmaVersion": 7,
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true
    }
  },
  "env": {
    "browser": true,
    "commonjs": true,
    "es6": true,
    "jquery": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended"
  ],
  "plugins": ["react"],
  "rules": {
    "indent": [
      "error",
      2
    ],
    "linebreak-style": [
      "error",
      "unix"
    ],
    "semi": [
      "error",
      "never"
    ],
    "react/jsx-uses-react": "error",
    "react/jsx-uses-vars": "error",
  }
}
