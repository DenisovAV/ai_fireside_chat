import js from "@eslint/js";
import tsEslint from "@typescript-eslint/eslint-plugin";
import tsParser from "@typescript-eslint/parser";

export default [
  js.configs.recommended,
  {
    files: ["**/*.ts", "**/*.js"],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        ecmaVersion: 2017,
        sourceType: "module",
      },
    },
    plugins: {
      "@typescript-eslint": tsEslint,
    },
    rules: {
      "no-restricted-globals": ["error", "name", "length"],
      "prefer-arrow-callback": "error",
      "quotes": ["error", "double", {"allowTemplateLiterals": true}],
      "max-len": ["error", {"code": 120}],
    },
  },
];