/*
 ** TailwindCSS Configuration File
 **
 ** Docs: https://tailwindcss.com/docs/configuration
 ** Default: https://github.com/tailwindcss/tailwindcss/blob/master/stubs/defaultConfig.stub.js
 */
module.exports = {
  theme: {
    extend: {
      colors: {
        gold: "var(--gold)",
        silver: "var(--silver)",
        gray: {
          100: "#f5f5f5",
          200: "#eeeeee",
          300: "#e0e0e0",
          400: "#bdbdbd",
          500: "#9e9e9e",
          600: "#757575",
          700: "#616161",
          800: "#424242",
          900: "#212121",
          1000: "#111111",
        },
      },
      spacing: {
        96: "24rem",
        144: "36rem",
        192: "48rem",
      },
      fontFamily: {
        sans: ["Livvic", "sans-serif"],
        serif: ["Cardo", "serif"],
      },
    },
    container: {
      center: true,
      padding: {
        default: "1.25rem",
        sm: "2rem",
      },
    },
  },
  variants: {},
  plugins: [],
  purge: {
    // Learn more on https://tailwindcss.com/docs/controlling-file-size/#removing-unused-css
    enabled: process.env.NODE_ENV === "production",
    content: [
      "components/**/*.vue",
      "layouts/**/*.vue",
      "pages/**/*.vue",
      "plugins/**/*.js",
      "nuxt.config.js",
    ],
  },
  experimental: {
    applyComplexClasses: true,
  },
};
