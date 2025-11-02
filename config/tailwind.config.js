const { execSync } = require('child_process')
const defaultTheme = require('tailwindcss/defaultTheme')
const activeAdminPath = execSync('bundle show activeadmin', { encoding: 'utf-8' }).trim()
module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    `${activeAdminPath}/vendor/javascript/flowbite.js`,
    `${activeAdminPath}/plugin.js`,
    `${activeAdminPath}/app/views/**/*.{arb,erb,html,rb}`,
    './app/admin/**/*.{arb,erb,html,rb}',
    './app/views/active_admin/**/*.{arb,erb,html,rb}',
    './app/views/admin/**/*.{arb,erb,html,rb}',
    './app/views/layouts/active_admin*.{erb,html}',
    './app/javascript/**/*.js',
    './engines/**/app/views/**/*.{arb,erb,html,rb}',
    './engines/**/app/javascript/**/*.js',
    './engines/**/app/admin/**/*.{arb,erb,html,rb}',
    './config/initializers/active_admin_ext.rb'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  darkMode: "selector",
  plugins: [
    require(`${activeAdminPath}/plugin.js`)
  ]
}
