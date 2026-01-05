<script setup lang="ts">
import { computed, ref } from 'vue'
import { Link, router } from '@inertiajs/vue3'
import DashboardLayout from '@layouts/DashboardLayout.vue'
import { Button, Badge, Avatar, Card } from '@ui'
import { ArrowLeftIcon, PencilIcon, TrashIcon } from '@heroicons/vue/24/outline'

interface User {
  id: number
  name: string | null
  email: string
  avatar_url: string | null
  provider: string | null
  created_at: string
  updated_at: string
  roles: string[]
}

interface Props {
  user: User
}

const props = defineProps<Props>()

const isDeleting = ref(false)

const displayName = computed(() => props.user.name || props.user.email)

const formattedCreatedAt = computed(() => {
  return new Date(props.user.created_at).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
})

const formattedUpdatedAt = computed(() => {
  return new Date(props.user.updated_at).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
})

const providerLabel = computed(() => {
  if (!props.user.provider) return null

  const providers: Record<string, string> = {
    google_oauth2: 'Google',
    github: 'GitHub',
    facebook: 'Facebook',
    twitter: 'Twitter',
    apple: 'Apple',
  }

  return providers[props.user.provider] || props.user.provider
})

const roleVariants: Record<string, 'gray' | 'red' | 'yellow' | 'green' | 'blue' | 'indigo' | 'purple' | 'pink'> = {
  admin: 'red',
  moderator: 'yellow',
  user: 'gray',
  editor: 'blue',
  viewer: 'green',
}

function getRoleVariant(role: string) {
  return roleVariants[role.toLowerCase()] || 'gray'
}

function handleDelete() {
  const confirmed = window.confirm(
    `Are you sure you want to delete ${displayName.value}? This action cannot be undone.`
  )

  if (confirmed) {
    isDeleting.value = true
    router.delete(`/users/${props.user.id}`, {
      onFinish: () => {
        isDeleting.value = false
      },
    })
  }
}
</script>

<template>
  <DashboardLayout>
    <!-- Page Header -->
    <div class="mb-8">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-4">
          <Link
            href="/users"
            class="inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          >
            <ArrowLeftIcon class="h-5 w-5" aria-hidden="true" />
            <span class="sr-only">Back to users</span>
          </Link>
          <div>
            <h1 class="text-2xl font-semibold text-gray-900">User Details</h1>
            <p class="mt-1 text-sm text-gray-500">
              View and manage user information
            </p>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="flex items-center gap-3">
          <Button
            variant="secondary"
            :href="`/users/${user.id}/edit`"
          >
            <template #icon-left>
              <PencilIcon class="h-5 w-5" />
            </template>
            Edit
          </Button>
          <Button
            variant="danger"
            :loading="isDeleting"
            :disabled="isDeleting"
            @click="handleDelete"
          >
            <template #icon-left>
              <TrashIcon class="h-5 w-5" />
            </template>
            Delete
          </Button>
        </div>
      </div>
    </div>

    <!-- User Profile Card -->
    <Card padding="lg">
      <div class="flex flex-col items-center sm:flex-row sm:items-start gap-6">
        <!-- Large Avatar -->
        <div class="flex-shrink-0">
          <Avatar
            :src="user.avatar_url"
            :name="displayName"
            :alt="`${displayName}'s avatar`"
            size="xl"
            ring
            ring-color="ring-gray-200"
          />
        </div>

        <!-- User Information -->
        <div class="flex-1 text-center sm:text-left">
          <!-- Name and Email -->
          <div>
            <h2 class="text-xl font-semibold text-gray-900">
              {{ displayName }}
            </h2>
            <p v-if="user.name" class="mt-1 text-sm text-gray-500">
              {{ user.email }}
            </p>
          </div>

          <!-- Roles -->
          <div v-if="user.roles.length > 0" class="mt-4">
            <div class="flex flex-wrap items-center justify-center sm:justify-start gap-2">
              <Badge
                v-for="role in user.roles"
                :key="role"
                :variant="getRoleVariant(role)"
                size="md"
              >
                {{ role }}
              </Badge>
            </div>
          </div>

          <!-- Provider Badge -->
          <div v-if="providerLabel" class="mt-4">
            <div class="inline-flex items-center gap-2 rounded-md bg-gray-50 px-3 py-1.5 text-sm text-gray-600">
              <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12.545,10.239v3.821h5.445c-0.712,2.315-2.647,3.972-5.445,3.972c-3.332,0-6.033-2.701-6.033-6.032s2.701-6.032,6.033-6.032c1.498,0,2.866,0.549,3.921,1.453l2.814-2.814C17.503,2.988,15.139,2,12.545,2C7.021,2,2.543,6.477,2.543,12s4.478,10,10.002,10c8.396,0,10.249-7.85,9.426-11.748L12.545,10.239z" />
              </svg>
              <span>Signed in with {{ providerLabel }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Divider -->
      <div class="mt-8 border-t border-gray-200" />

      <!-- Metadata -->
      <dl class="mt-6 grid grid-cols-1 gap-x-6 gap-y-4 sm:grid-cols-2">
        <div>
          <dt class="text-sm font-medium text-gray-500">User ID</dt>
          <dd class="mt-1 text-sm text-gray-900 font-mono">{{ user.id }}</dd>
        </div>
        <div>
          <dt class="text-sm font-medium text-gray-500">Email Address</dt>
          <dd class="mt-1 text-sm text-gray-900">{{ user.email }}</dd>
        </div>
        <div>
          <dt class="text-sm font-medium text-gray-500">Created</dt>
          <dd class="mt-1 text-sm text-gray-900">{{ formattedCreatedAt }}</dd>
        </div>
        <div>
          <dt class="text-sm font-medium text-gray-500">Last Updated</dt>
          <dd class="mt-1 text-sm text-gray-900">{{ formattedUpdatedAt }}</dd>
        </div>
      </dl>
    </Card>
  </DashboardLayout>
</template>
