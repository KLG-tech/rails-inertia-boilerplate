<script setup lang="ts">
import { Link, usePage } from '@inertiajs/vue3'
import { computed } from 'vue'

interface User {
  id: number
  email: string
  name?: string
}

interface PageProps {
  currentUser?: User
  [key: string]: unknown
}

const page = usePage<PageProps>()
const currentUser = computed(() => page.props.currentUser)
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <nav class="bg-white shadow-sm">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="flex h-16 justify-between">
          <div class="flex">
            <div class="flex flex-shrink-0 items-center">
              <Link href="/" class="text-xl font-bold text-gray-900">
                Rails Inertia
              </Link>
            </div>
            <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
              <Link
                href="/"
                class="inline-flex items-center border-b-2 border-indigo-500 px-1 pt-1 text-sm font-medium text-gray-900"
              >
                Home
              </Link>
            </div>
          </div>
          <div class="flex items-center space-x-4">
            <template v-if="currentUser">
              <span class="text-sm text-gray-700">
                {{ currentUser.name || currentUser.email }}
              </span>
              <Link
                href="/users/sign_out"
                method="delete"
                as="button"
                class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-gray-700 bg-gray-100 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors"
              >
                Sign out
              </Link>
            </template>
            <template v-else>
              <Link
                href="/users/sign_in"
                class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors"
              >
                Sign in
              </Link>
            </template>
          </div>
        </div>
      </div>
    </nav>

    <main class="flex-grow">
      <slot />
    </main>

    <footer class="bg-white border-t border-gray-200">
      <div class="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
        <p class="text-center text-sm text-gray-500">
          Built with Rails, Vite, Vue 3, and Inertia.js
        </p>
      </div>
    </footer>
  </div>
</template>
