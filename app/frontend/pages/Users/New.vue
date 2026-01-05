<script setup lang="ts">
import { computed, watch } from 'vue'
import { Link, useForm } from '@inertiajs/vue3'
import DashboardLayout from '@layouts/DashboardLayout.vue'
import { Button, Input, Card, Alert } from '@ui'
import { ArrowLeftIcon } from '@heroicons/vue/24/outline'

interface Props {
  roles: string[]
  errors?: Record<string, string[]>
}

const props = withDefaults(defineProps<Props>(), {
  roles: () => [],
  errors: () => ({}),
})

const form = useForm({
  name: '',
  email: '',
  roles: [] as string[],
})

// Combine form errors with server-side errors
const nameError = computed(() => {
  if (form.errors.name) return form.errors.name
  if (props.errors?.name) return props.errors.name.join(', ')
  return undefined
})

const emailError = computed(() => {
  if (form.errors.email) return form.errors.email
  if (props.errors?.email) return props.errors.email.join(', ')
  return undefined
})

const rolesError = computed(() => {
  if (form.errors.roles) return form.errors.roles
  if (props.errors?.roles) return props.errors.roles.join(', ')
  return undefined
})

// Check if there are any server-side errors
const hasServerErrors = computed(() => {
  return props.errors && Object.keys(props.errors).length > 0
})

// Get all error messages for the alert
const serverErrorMessages = computed(() => {
  if (!props.errors) return []
  return Object.entries(props.errors).flatMap(([field, messages]) =>
    messages.map(msg => `${field}: ${msg}`)
  )
})

function toggleRole(role: string) {
  const index = form.roles.indexOf(role)
  if (index === -1) {
    form.roles.push(role)
  } else {
    form.roles.splice(index, 1)
  }
}

function isRoleSelected(role: string): boolean {
  return form.roles.includes(role)
}

function handleSubmit() {
  form.post('/users', {
    preserveScroll: true,
  })
}
</script>

<template>
  <DashboardLayout>
    <div class="max-w-2xl mx-auto">
      <!-- Page header -->
      <div class="mb-8">
        <div class="flex items-center gap-4">
          <Link
            href="/users"
            class="inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500"
          >
            <span class="sr-only">Go back</span>
            <ArrowLeftIcon class="h-5 w-5" aria-hidden="true" />
          </Link>
          <div>
            <h1 class="text-2xl font-semibold text-gray-900">Create User</h1>
            <p class="mt-1 text-sm text-gray-500">
              Add a new user to the system.
            </p>
          </div>
        </div>
      </div>

      <!-- Server-side error alert -->
      <Alert
        v-if="hasServerErrors"
        variant="error"
        title="There were errors with your submission"
        class="mb-6"
      >
        <ul class="list-disc list-inside space-y-1">
          <li v-for="(message, index) in serverErrorMessages" :key="index">
            {{ message }}
          </li>
        </ul>
      </Alert>

      <!-- Form card -->
      <Card>
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <!-- Name field -->
          <Input
            v-model="form.name"
            label="Name"
            name="name"
            type="text"
            placeholder="Enter user's full name"
            :error="nameError"
            :disabled="form.processing"
          />

          <!-- Email field -->
          <Input
            v-model="form.email"
            label="Email"
            name="email"
            type="email"
            placeholder="user@example.com"
            required
            :error="emailError"
            :disabled="form.processing"
          />

          <!-- Roles field -->
          <div>
            <label class="block text-sm font-medium leading-6 text-gray-900">
              Roles
            </label>
            <p class="mt-1 text-sm text-gray-500">
              Select the roles to assign to this user.
            </p>
            <div class="mt-3 space-y-3">
              <div
                v-for="role in props.roles"
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
                <div class="ml-3 text-sm leading-6">
                  <label
                    :for="`role-${role}`"
                    class="font-medium text-gray-900 capitalize"
                    :class="{ 'cursor-not-allowed opacity-50': form.processing }"
                  >
                    {{ role }}
                  </label>
                </div>
              </div>
            </div>
            <p
              v-if="rolesError"
              class="mt-2 text-sm text-red-600"
              role="alert"
            >
              {{ rolesError }}
            </p>
          </div>

          <!-- Form actions -->
          <div class="flex items-center justify-end gap-3 pt-4 border-t border-gray-200">
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
              Create User
            </Button>
          </div>
        </form>
      </Card>
    </div>
  </DashboardLayout>
</template>
