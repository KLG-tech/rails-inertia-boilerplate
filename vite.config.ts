import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import RubyPlugin from 'vite-plugin-ruby'
import { resolve } from 'path'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue()
  ],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'app/frontend'),
      '@components': resolve(__dirname, 'app/frontend/components'),
      '@pages': resolve(__dirname, 'app/frontend/pages'),
      '@layouts': resolve(__dirname, 'app/frontend/layouts'),
      '@ui': resolve(__dirname, 'app/frontend/ui')
    }
  }
})
