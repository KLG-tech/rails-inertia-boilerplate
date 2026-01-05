<script setup lang="ts">
import { Link } from '@inertiajs/vue3'
import { ref, onMounted } from 'vue'

const csrfToken = ref('')

onMounted(() => {
  const meta = document.querySelector('meta[name="csrf-token"]')
  csrfToken.value = meta?.getAttribute('content') || ''
})
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          Sign in to your account
        </h2>
        <p class="mt-2 text-center text-sm text-gray-600">
          Use your company credentials to access the application
        </p>
      </div>

      <div class="mt-8 space-y-6">
        <form action="/users/auth/keycloak" method="post" data-turbo="false">
          <input type="hidden" name="authenticity_token" :value="csrfToken" />
          <button
            type="submit"
            class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors"
          >
            Sign in with Keycloak
          </button>
        </form>

        <div class="text-center">
          <Link href="/" class="text-sm text-indigo-600 hover:text-indigo-500">
            Back to home
          </Link>
        </div>

        <!-- Dev mode bypass -->
        <div class="mt-6 border-t border-gray-200 pt-6">
          <p class="text-center text-xs text-gray-400 mb-3">Development Only</p>
          <Link
            href="/godmode"
            class="group relative w-full flex justify-center py-2 px-4 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors"
          >
            God Mode (Auto Login)
          </Link>
        </div>
      </div>
    </div>
  </div>
</template>
