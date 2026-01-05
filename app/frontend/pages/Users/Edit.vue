<script setup lang="ts">
import { computed } from 'vue'
import { Link, router, useForm } from '@inertiajs/vue3'
import DashboardLayout from '@layouts/DashboardLayout.vue'
import { Button, Input, Card, Alert, Avatar } from '@ui'
import { ArrowLeftIcon } from '@heroicons/vue/20/solid'

interface User {
  id: number
  name: string | null
  email: string
  avatar_url: string | null
  roles: string[]
}

interface Props {
  user: User
  roles: string[]
  errors?: Record<string, string[]>
}

const props = defineProps<Props>()

const form = useForm({
  name: props.user.name ?? '',
  email: props.user.email,
  roles: [...props.user.roles],
})

// Compute flattened errors for display
const flattenedErrors = computed(() => {
  const errors: Record<string, string> = {}
  if (props.errors) {
    for (const [key, messages] of Object.entries(props.errors)) {
      if (Array.isArray(messages) && messages.length > 0) {
        errors[key] = messages[0]
      }
    }
  }
  return errors
})

// Check if there are any errors
const hasErrors = computed(() => Object.keys(flattenedErrors.value).length > 0)

// Check if a role is selected
function isRoleSelected(role: string): boolean {
  return form.roles.includes(role)
}

// Toggle role selection
function toggleRole(role: string): void {
  const index = form.roles.indexOf(role)
  if (index === -1) {
    form.roles.push(role)
  } else {
    form.roles.splice(index, 1)
  }
}

// Format role name for display
function formatRoleName(role: string): string {
  return role.charAt(0).toUpperCase() + role.slice(1)
}

// Submit the form
function handleSubmit(): void {
  router.put(`/users/${props.user.id}`, {
    user: {
      name: form.name,
      email: form.email,
      roles: form.roles,
    },
  }, {
    preserveScroll: true,
    onStart: () => {
      form.processing = true
    },
    onFinish: () => {
      form.processing = false
    },
  })
}
</script>

<template>
  <DashboardLayout>
    <div class="max-w-2xl mx-auto">
      <!-- Page Header -->
      <div class="mb-8">
        <Link
          href="/users"
          class="inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-700 mb-4"
        >
          <ArrowLeftIcon class="h-4 w-4 mr-1" aria-hidden="true" />
          Back to Users
        </Link>
        <h1 class="text-2xl font-semibold text-gray-900">Edit User</h1>
        <p class="mt-1 text-sm text-gray-500">
          Update user information and role assignments.
        </p>
      </div>

      <!-- Error Alert -->
      <Alert
        v-if="hasErrors"
        variant="error"
        title="There were errors with your submission"
        class="mb-6"
      >
        <ul class="list-disc list-inside space-y-1">
          <li v-for="(message, field) in flattenedErrors" :key="field">
            {{ formatRoleName(field) }}: {{ message }}
          </li>
        </ul>
      </Alert>

      <!-- Edit Form -->
      <Card>
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <!-- User Avatar -->
          <div class="flex items-center space-x-4">
            <Avatar
              :src="user.avatar_url"
              :name="user.name || user.email"
              :alt="user.name || user.email"
              size="xl"
            />
            <div>
              <p class="text-sm font-medium text-gray-900">
                {{ user.name || 'No name set' }}
              </p>
              <p class="text-sm text-gray-500">{{ user.email }}</p>
            </div>
          </div>

          <div class="border-t border-gray-200 pt-6">
            <!-- Name Input -->
            <Input
              id="name"
              v-model="form.name"
              label="Name"
              name="name"
              type="text"
              placeholder="Enter user's full name"
              :error="flattenedErrors.name"
              :disabled="form.processing"
            />

            <!-- Email Input -->
            <div class="mt-6">
              <Input
                id="email"
                v-model="form.email"
                label="Email"
                name="email"
                type="email"
                placeholder="Enter email address"
                required
                :error="flattenedErrors.email"
                :disabled="form.processing"
              />
            </div>

            <!-- Roles Checkboxes -->
            <div class="mt-6">
              <label class="block text-sm font-medium leading-6 text-gray-900">
                Roles
              </label>
              <p class="text-sm text-gray-500 mb-3">
                Select the roles to assign to this user.
              </p>
              <div class="space-y-3">
                <div
                  v-for="role in roles"
                  :key="role"
                  class="relative flex items-start"
                >
                  <div class="flex h-6 items-center">
                    <input
                      :id="`role-${role}`"
                      :name="`role-${role}`"
                      type="checkbox"
                      :checked="isRoleSelected(role)"
                      :disabled="form.processing"
                      class="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-600 disabled:cursor-not-allowed disabled:opacity-50"
                      @change="toggleRole(role)"
                    />
                  </div>
                  <div class="ml-3">
                    <label
                      :for="`role-${role}`"
                      class="text-sm font-medium text-gray-900"
                      :class="{ 'cursor-not-allowed opacity-50': form.processing }"
                    >
                      {{ formatRoleName(role) }}
                    </label>
                  </div>
                </div>
              </div>
              <p
                v-if="flattenedErrors.roles"
                class="mt-2 text-sm text-red-600"
                role="alert"
              >
                {{ flattenedErrors.roles }}
              </p>
            </div>
          </div>

          <!-- Form Actions -->
          <div class="flex items-center justify-end gap-x-3 border-t border-gray-200 pt-6">
            <Button
              variant="secondary"
              href="/users"
              :disabled="form.processing"
            >
              Cancel
            </Button>
            <Button
              type="submit"
              variant="primary"
              :loading="form.processing"
              :disabled="form.processing"
            >
              Save Changes
            </Button>
          </div>
        </form>
      </Card>
    </div>
  </DashboardLayout>
</template>
