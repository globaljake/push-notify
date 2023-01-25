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
      animation: {
        "fade-in": "fade-in 200ms ease-out 1 both",
        "fade-out": "fade-out 200ms ease-out 1 both",
        "fade-up": "fade-up 200ms ease-out 1 both",
        "fade-down": "fade-down 200ms ease-out 1 both",
        "enter-up": "enter-up 200ms ease-out 1 both",
        "exit-down": "exit-down 200ms ease-out 1 both",
        "enter-up-full": "enter-up-full 200ms ease-out 1 both",
        "exit-down-full": "exit-down-full 200ms ease-out 1 both",
      },
      fontFamily: {
        sans: ["Clash Display", ...defaultTheme.fontFamily.sans],
      },
      keyframes: {
        "fade-in": { "0%": { opacity: 0 }, "100%": { opacity: 1 } },
        "fade-out": { "0%": { opacity: 1 }, "100%": { opacity: 0 } },
        "fade-up": {
          "0%": { opacity: 0, transform: "translate3d(0, 2rem, 0);" },
          "100%": { opacity: 1, transform: "translate3d(0, 0, 0);" },
        },
        "fade-down": {
          "0%": { opacity: 1, transform: "translate3d(0, 0, 0);" },
          "100%": { opacity: 0, transform: "translate3d(0, 2rem, 0);" },
        },
        "enter-up": {
          "0%": { transform: "translate3d(0, 2rem, 0);" },
          "100%": { transform: "translate3d(0, 0, 0);" },
        },
        "exit-down": {
          "0%": { transform: "translate3d(0, 0, 0);" },
          "100%": { transform: "translate3d(0, 2rem, 0);" },
        },
        "enter-up-full": {
          "0%": { transform: "translate3d(0, 100%, 0);" },
          "100%": { transform: "translate3d(0, 0, 0);" },
        },
        "exit-down-full": {
          "0%": { transform: "translate3d(0, 0, 0);" },
          "100%": { transform: "translate3d(0, 100%, 0);" },
        },
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
