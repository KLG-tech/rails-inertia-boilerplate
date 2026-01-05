<script setup lang="ts">
import AppLayout from '@layouts/App.vue'
import { RocketLaunchIcon, CubeIcon, BoltIcon } from '@heroicons/vue/24/outline'

defineProps<{
  message?: string
}>()

const features = [
  {
    name: 'Rails 8.1',
    description: 'The latest version of Ruby on Rails with all the modern features.',
    icon: CubeIcon,
  },
  {
    name: 'Vue 3 + Inertia.js',
    description: 'Build reactive frontends without the complexity of a full SPA.',
    icon: RocketLaunchIcon,
  },
  {
    name: 'Vite',
    description: 'Lightning-fast HMR and optimized production builds.',
    icon: BoltIcon,
  },
]
</script>

<template>
  <AppLayout>
    <div class="py-12">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="text-center">
          <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl md:text-6xl">
            Welcome to
            <span class="text-indigo-600">Rails Inertia</span>
          </h1>
          <p class="mx-auto mt-3 max-w-md text-base text-gray-500 sm:text-lg md:mt-5 md:max-w-3xl md:text-xl">
            {{ message || 'A modern Rails boilerplate with Vue 3 and Inertia.js' }}
          </p>
        </div>

        <div class="mt-16">
          <h2 class="text-center text-2xl font-bold text-gray-900">Features</h2>
          <div class="mt-8 grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
            <div
              v-for="feature in features"
              :key="feature.name"
              class="relative rounded-lg border border-gray-200 bg-white p-6 shadow-sm hover:shadow-md transition-shadow"
            >
              <div class="flex items-center">
                <div class="flex h-12 w-12 items-center justify-center rounded-md bg-indigo-500 text-white">
                  <component :is="feature.icon" class="h-6 w-6" aria-hidden="true" />
                </div>
                <h3 class="ml-4 text-lg font-medium text-gray-900">{{ feature.name }}</h3>
              </div>
              <p class="mt-4 text-base text-gray-500">{{ feature.description }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>
