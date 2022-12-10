import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import FullReload from 'vite-plugin-full-reload'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    FullReload(['app/views/**/*.erb', 'config/routes.rb'], {delay: 500}),
    vue()
  ],
})
