// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import { createApp } from 'vue'

// Simple Vue component
const App = {
  data() {
    return {
      message: 'Hello Vue.js from Rails!'
    }
  },
  template: `
    <div class="p-6 bg-blue-100 rounded-lg">
      <h2 class="text-2xl font-bold text-blue-800 mb-4">{{ message }}</h2>
      <button @click="message = 'Vue.js is working!'" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
        Click me!
      </button>
    </div>
  `
}

// Mount Vue app when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  const app = createApp(App)
  app.mount('#app')
})
