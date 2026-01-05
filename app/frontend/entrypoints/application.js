import { createApp, h } from 'vue'
import { createInertiaApp } from '@inertiajs/vue3'
import '../css/application.css'

createInertiaApp({
  title: (title) => title ? `${title} - Rails Inertia Boilerplate` : 'Rails Inertia Boilerplate',
  resolve: (name) => {
    const pages = import.meta.glob('../pages/**/*.vue', { eager: true })
    const page = pages[`../pages/${name}.vue`]

    if (!page) {
      console.error(`Page not found: ${name}`)
      console.error('Available pages:', Object.keys(pages))
      throw new Error(`Page not found: ${name}`)
    }

    return page.default || page
  },
  setup({ el, App, props, plugin }) {
    createApp({ render: () => h(App, props) })
      .use(plugin)
      .mount(el)
  },
  progress: {
    color: '#4B5563',
    showSpinner: true,
  },
})
