<script setup lang="ts">
import { ref, computed } from 'vue'
import { Link, router, usePage } from '@inertiajs/vue3'
import DashboardLayout from '@layouts/DashboardLayout.vue'
import { Button, Badge, Avatar, Alert, Modal } from '@ui'
import { PlusIcon, EyeIcon, PencilIcon, TrashIcon } from '@heroicons/vue/24/outline'

interface User {
  id: number
  name: string | null
  email: string
  avatar_url: string | null
  created_at: string
  roles: string[]
}

interface Flash {
  notice?: string
  alert?: string
}

interface PageProps {
  flash: Flash
  [key: string]: unknown
}

const props = defineProps<{
  users: User[]
}>()

const page = usePage<PageProps>()

const flash = computed(() => page.props.flash)

// Delete confirmation modal state
const showDeleteModal = ref(false)
const userToDelete = ref<User | null>(null)
const isDeleting = ref(false)

function openDeleteModal(user: User) {
  userToDelete.value = user
  showDeleteModal.value = true
}

function closeDeleteModal() {
  showDeleteModal.value = false
  userToDelete.value = null
}

function confirmDelete() {
  if (!userToDelete.value) return

  isDeleting.value = true
  router.delete(`/users/${userToDelete.value.id}`, {
    preserveScroll: true,
    onSuccess: () => {
      closeDeleteModal()
    },
    onFinish: () => {
      isDeleting.value = false
    },
  })
}

function formatDate(dateString: string): string {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  }).format(date)
}

function getRoleBadgeVariant(role: string): 'red' | 'blue' | 'gray' {
  switch (role.toLowerCase()) {
    case 'admin':
      return 'red'
    case 'user':
      return 'blue'
    default:
      return 'gray'
  }
}
</script>

<template>
  <DashboardLayout>
    <!-- Page Header -->
    <div class="sm:flex sm:items-center sm:justify-between">
      <div>
        <h1 class="text-2xl font-semibold text-gray-900">Users</h1>
        <p class="mt-2 text-sm text-gray-700">
          A list of all users in your account including their name, email, roles, and creation date.
        </p>
      </div>
      <div class="mt-4 sm:ml-16 sm:mt-0 sm:flex-none">
        <Button href="/users/new">
          <template #icon-left>
            <PlusIcon class="h-5 w-5" />
          </template>
          Add User
        </Button>
      </div>
    </div>

    <!-- Flash Messages -->
    <div v-if="flash.notice || flash.alert" class="mt-6 space-y-4">
      <Alert
        v-if="flash.notice"
        variant="success"
        :message="flash.notice"
        dismissible
      />
      <Alert
        v-if="flash.alert"
        variant="error"
        :message="flash.alert"
        dismissible
      />
    </div>

    <!-- Users Table -->
    <div class="mt-8 flow-root">
      <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
          <!-- Empty State -->
          <div
            v-if="users.length === 0"
            class="rounded-lg border-2 border-dashed border-gray-300 p-12 text-center"
          >
            <svg
              class="mx-auto h-12 w-12 text-gray-400"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              aria-hidden="true"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="1.5"
                d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0112 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 016 18.719m12 0a5.971 5.971 0 00-.941-3.197m0 0A5.995 5.995 0 0012 12.75a5.995 5.995 0 00-5.058 2.772m0 0a3 3 0 00-4.681 2.72 8.986 8.986 0 003.74.477m.94-3.197a5.971 5.971 0 00-.94 3.197M15 6.75a3 3 0 11-6 0 3 3 0 016 0zm6 3a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0zm-13.5 0a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0z"
              />
            </svg>
            <h3 class="mt-2 text-sm font-semibold text-gray-900">No users</h3>
            <p class="mt-1 text-sm text-gray-500">Get started by creating a new user.</p>
            <div class="mt-6">
              <Button href="/users/new" size="sm">
                <template #icon-left>
                  <PlusIcon class="h-5 w-5" />
                </template>
                Add User
              </Button>
            </div>
          </div>

          <!-- Users Table -->
          <div v-else class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 sm:rounded-lg">
            <table class="min-w-full divide-y divide-gray-300">
              <thead class="bg-gray-50">
                <tr>
                  <th
                    scope="col"
                    class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6"
                  >
                    User
                  </th>
                  <th
                    scope="col"
                    class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Email
                  </th>
                  <th
                    scope="col"
                    class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Roles
                  </th>
                  <th
                    scope="col"
                    class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Created At
                  </th>
                  <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
                    <span class="sr-only">Actions</span>
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200 bg-white">
                <tr v-for="user in users" :key="user.id">
                  <td class="whitespace-nowrap py-4 pl-4 pr-3 sm:pl-6">
                    <div class="flex items-center">
                      <Avatar
                        :src="user.avatar_url"
                        :name="user.name || user.email"
                        size="sm"
                      />
                      <div class="ml-4">
                        <div class="font-medium text-gray-900">
                          {{ user.name || 'No name' }}
                        </div>
                      </div>
                    </div>
                  </td>
                  <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                    {{ user.email }}
                  </td>
                  <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                    <div class="flex flex-wrap gap-1">
                      <Badge
                        v-for="role in user.roles"
                        :key="role"
                        :variant="getRoleBadgeVariant(role)"
                        size="sm"
                      >
                        {{ role }}
                      </Badge>
                      <span v-if="user.roles.length === 0" class="text-gray-400">
                        No roles
                      </span>
                    </div>
                  </td>
                  <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                    {{ formatDate(user.created_at) }}
                  </td>
                  <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                    <div class="flex items-center justify-end gap-2">
                      <Link
                        :href="`/users/${user.id}`"
                        class="text-gray-600 hover:text-gray-900"
                        title="View"
                      >
                        <EyeIcon class="h-5 w-5" />
                        <span class="sr-only">View {{ user.name || user.email }}</span>
                      </Link>
                      <Link
                        :href="`/users/${user.id}/edit`"
                        class="text-indigo-600 hover:text-indigo-900"
                        title="Edit"
                      >
                        <PencilIcon class="h-5 w-5" />
                        <span class="sr-only">Edit {{ user.name || user.email }}</span>
                      </Link>
                      <button
                        type="button"
                        class="text-red-600 hover:text-red-900"
                        title="Delete"
                        @click="openDeleteModal(user)"
                      >
                        <TrashIcon class="h-5 w-5" />
                        <span class="sr-only">Delete {{ user.name || user.email }}</span>
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <Modal
      v-model="showDeleteModal"
      title="Delete User"
      size="sm"
    >
      <p class="text-sm text-gray-500">
        Are you sure you want to delete
        <span class="font-medium text-gray-900">
          {{ userToDelete?.name || userToDelete?.email }}
        </span>?
        This action cannot be undone.
      </p>

      <template #footer>
        <div class="flex justify-end gap-3">
          <Button
            variant="secondary"
            :disabled="isDeleting"
            @click="closeDeleteModal"
          >
            Cancel
          </Button>
          <Button
            variant="danger"
            :loading="isDeleting"
            @click="confirmDelete"
          >
            Delete
          </Button>
        </div>
      </template>
    </Modal>
  </DashboardLayout>
</template>
