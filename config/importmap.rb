# Pin npm packages by running ./bin/importmap

pin 'application'
if Rails.env.production?
  pin 'vue', to: 'https://ga.jspm.io/npm:vue@3.5.18/dist/vue.esm-browser.prod.js'
else
  pin 'vue', to: 'https://ga.jspm.io/npm:vue@3.5.18/dist/vue.esm-browser.js'
end
pin_all_from 'app/javascript/components', under: 'components'
