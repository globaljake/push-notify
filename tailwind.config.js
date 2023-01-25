const defaultTheme = require("tailwindcss/defaultTheme");
module.exports = {
  purge: [
    "./src/**/*.html",
    "./src/**/*.elm",
    "./vendor/**/*.elm",
    "./src/**/*.js",
    "./vendor/**/*.js",
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      fontFamily: {
        sans: ["Clash Display", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
