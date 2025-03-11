/** @type {import('tailwindcss').Config} */

module.exports = {
  content: [
    "./src/**/*.{html,js}",
    "./node_modules/react-tailwindcss-datepicker/dist/index.esm.{js,ts}",
  ],
  theme: {
    extend: {
      fontFamily : {
        sans: ['Poppins', 'sans-serif'], 
      }
    },
  },
  plugins: [],
}

