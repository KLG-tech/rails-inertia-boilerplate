<script setup lang="ts">
import { ref } from 'vue'
import { Link } from '@inertiajs/vue3'
import {
  Alert,
  Avatar,
  AvatarGroup,
  Badge,
  Button,
  Card,
  Input,
  Modal,
  Select,
} from '@ui'
import {
  HomeIcon,
  PlusIcon,
  ArrowRightIcon,
  TrashIcon,
  PencilIcon,
  MagnifyingGlassIcon,
  EnvelopeIcon,
  LockClosedIcon,
  CurrencyDollarIcon,
} from '@heroicons/vue/24/outline'

// Modal state
const isModalOpen = ref(false)
const modalSize = ref<'sm' | 'md' | 'lg' | 'xl' | 'full'>('md')

// Form states
const inputText = ref('')
const inputEmail = ref('')
const inputPassword = ref('')
const inputError = ref('test@example')
const inputDisabled = ref('Disabled value')
const inputWithIcon = ref('')
const inputPrice = ref('')

const selectValue = ref('')
const selectOptions = [
  { value: 'option1', label: 'Option 1' },
  { value: 'option2', label: 'Option 2' },
  { value: 'option3', label: 'Option 3' },
  { value: 'disabled', label: 'Disabled Option', disabled: true },
]

// Alert dismiss
const showDismissibleAlert = ref(true)

// Loading button
const isLoading = ref(false)
const handleLoadingClick = () => {
  isLoading.value = true
  setTimeout(() => {
    isLoading.value = false
  }, 2000)
}

const openModal = (size: 'sm' | 'md' | 'lg' | 'xl' | 'full') => {
  modalSize.value = size
  isModalOpen.value = true
}
</script>

<template>
  <div class="min-h-screen bg-gray-100">
    <!-- Header -->
    <div class="bg-white shadow">
      <div class="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-3xl font-bold tracking-tight text-gray-900">UI Kit Preview</h1>
            <p class="mt-1 text-sm text-gray-500">Tailwind UI styled components for Rails Inertia Boilerplate</p>
          </div>
          <Link href="/" class="text-sm text-indigo-600 hover:text-indigo-500">
            &larr; Back to Home
          </Link>
        </div>
      </div>
    </div>

    <div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8 space-y-12">
      <!-- Buttons Section -->
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Buttons</h2>
        <Card>
          <div class="space-y-6">
            <!-- Variants -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">Variants</h3>
              <div class="flex flex-wrap gap-3">
                <Button variant="primary">Primary</Button>
                <Button variant="secondary">Secondary</Button>
                <Button variant="outline">Outline</Button>
                <Button variant="danger">Danger</Button>
                <Button variant="ghost">Ghost</Button>
              </div>
            </div>

            <!-- Sizes -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">Sizes</h3>
              <div class="flex flex-wrap items-center gap-3">
                <Button size="xs">Extra Small</Button>
                <Button size="sm">Small</Button>
                <Button size="md">Medium</Button>
                <Button size="lg">Large</Button>
                <Button size="xl">Extra Large</Button>
              </div>
            </div>

            <!-- With Icons -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">With Icons</h3>
              <div class="flex flex-wrap gap-3">
                <Button variant="primary">
                  <template #icon-left>
                    <PlusIcon class="h-5 w-5" />
                  </template>
                  Add Item
                </Button>
                <Button variant="secondary">
                  Continue
                  <template #icon-right>
                    <ArrowRightIcon class="h-5 w-5" />
                  </template>
                </Button>
                <Button variant="danger">
                  <template #icon-left>
                    <TrashIcon class="h-5 w-5" />
                  </template>
                  Delete
                </Button>
              </div>
            </div>

            <!-- States -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">States</h3>
              <div class="flex flex-wrap gap-3">
                <Button :loading="isLoading" @click="handleLoadingClick">
                  {{ isLoading ? 'Loading...' : 'Click to Load' }}
                </Button>
                <Button disabled>Disabled</Button>
                <Button variant="outline" disabled>Disabled Outline</Button>
              </div>
            </div>

            <!-- Full Width -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">Full Width</h3>
              <Button variant="primary" full-width>Full Width Button</Button>
            </div>

            <!-- As Link -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">As Inertia Link</h3>
              <div class="flex flex-wrap gap-3">
                <Button href="/" variant="secondary">
                  <template #icon-left>
                    <HomeIcon class="h-5 w-5" />
                  </template>
                  Go Home
                </Button>
              </div>
            </div>
          </div>
        </Card>
      </section>

      <!-- Inputs Section -->
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Inputs</h2>
        <Card>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Input
              v-model="inputText"
              label="Text Input"
              placeholder="Enter some text"
              helper-text="This is a helper text"
            />
            <Input
              v-model="inputEmail"
              label="Email Input"
              type="email"
              placeholder="you@example.com"
              required
            />
            <Input
              v-model="inputPassword"
              label="Password Input"
              type="password"
              placeholder="Enter password"
            />
            <Input
              v-model="inputError"
              label="With Error"
              type="email"
              error="Please enter a valid email address"
            />
            <Input
              v-model="inputDisabled"
              label="Disabled Input"
              disabled
            />
            <Input
              v-model="inputWithIcon"
              label="With Leading Icon"
              placeholder="Search..."
            >
              <template #leading>
                <MagnifyingGlassIcon class="h-5 w-5 text-gray-400" />
              </template>
            </Input>
            <Input
              v-model="inputEmail"
              label="With Leading Addon"
              placeholder="you@example.com"
            >
              <template #leadingAddon>
                <EnvelopeIcon class="h-5 w-5 text-gray-400" />
              </template>
            </Input>
            <Input
              v-model="inputPrice"
              label="With Trailing Addon"
              type="number"
              placeholder="0.00"
            >
              <template #trailingAddon>USD</template>
            </Input>
          </div>
        </Card>
      </section>

      <!-- Select Section -->
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Select</h2>
        <Card>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Select
              v-model="selectValue"
              :options="selectOptions"
              label="Basic Select"
              placeholder="Choose an option"
            />
            <Select
              v-model="selectValue"
              :options="selectOptions"
              label="Required Select"
              placeholder="Choose an option"
              required
              helper-text="This field is required"
            />
            <Select
              v-model="selectValue"
              :options="selectOptions"
              label="With Error"
              placeholder="Choose an option"
              error="Please select an option"
            />
            <Select
              v-model="selectValue"
              :options="selectOptions"
              label="Disabled Select"
              placeholder="Choose an option"
              disabled
            />
          </div>
        </Card>
      </section>

      <!-- Badges Section -->
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Badges</h2>
        <Card>
          <div class="space-y-6">
            <!-- Variants -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">Variants</h3>
              <div class="flex flex-wrap gap-2">
                <Badge variant="gray">Gray</Badge>
                <Badge variant="red">Red</Badge>
                <Badge variant="yellow">Yellow</Badge>
                <Badge variant="green">Green</Badge>
                <Badge variant="blue">Blue</Badge>
                <Badge variant="indigo">Indigo</Badge>
                <Badge variant="purple">Purple</Badge>
                <Badge variant="pink">Pink</Badge>
              </div>
            </div>

            <!-- Sizes -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">Sizes</h3>
              <div class="flex flex-wrap items-center gap-2">
                <Badge size="sm">Small</Badge>
                <Badge size="md">Medium</Badge>
                <Badge size="lg">Large</Badge>
              </div>
            </div>

            <!-- With Dot -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">With Dot Indicator</h3>
              <div class="flex flex-wrap gap-2">
                <Badge variant="green" dot>Online</Badge>
                <Badge variant="yellow" dot>Away</Badge>
                <Badge variant="red" dot>Busy</Badge>
                <Badge variant="gray" dot>Offline</Badge>
              </div>
            </div>

            <!-- Removable -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">Removable</h3>
              <div class="flex flex-wrap gap-2">
                <Badge variant="blue" removable>Removable</Badge>
                <Badge variant="indigo" removable>Click X</Badge>
                <Badge variant="purple" removable>To Remove</Badge>
              </div>
            </div>

            <!-- Rounded -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">Rounded Corners</h3>
              <div class="flex flex-wrap gap-2">
                <Badge variant="indigo" :pill="false">Rounded</Badge>
                <Badge variant="green" :pill="false">Corners</Badge>
              </div>
            </div>
          </div>
        </Card>
      </section>

      <!-- Alerts Section -->
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Alerts</h2>
        <Card padding="none">
          <div class="space-y-4 p-6">
            <Alert variant="info" title="Information" message="This is an informational alert message." />
            <Alert variant="success" title="Success" message="Your changes have been saved successfully." />
            <Alert variant="warning" title="Warning" message="Please review your input before proceeding." />
            <Alert variant="error" title="Error" message="There was a problem processing your request." />

            <Alert
              v-if="showDismissibleAlert"
              variant="info"
              title="Dismissible Alert"
              message="Click the X button to dismiss this alert."
              dismissible
              @dismiss="showDismissibleAlert = false"
            />
            <Button v-else size="sm" variant="outline" @click="showDismissibleAlert = true">
              Show Dismissible Alert
            </Button>

            <Alert variant="error" title="With Actions">
              <p>There were 2 errors with your submission.</p>
              <ul class="mt-2 list-disc list-inside text-sm">
                <li>Email is required</li>
                <li>Password must be at least 8 characters</li>
              </ul>
              <template #actions>
                <button class="rounded-md bg-red-50 px-2 py-1.5 text-sm font-medium text-red-800 hover:bg-red-100">
                  View details
                </button>
              </template>
            </Alert>
          </div>
        </Card>
      </section>

      <!-- Cards Section -->
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Cards</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <Card>
            <h3 class="text-lg font-medium text-gray-900">Basic Card</h3>
            <p class="mt-2 text-sm text-gray-500">This is a basic card with default styling.</p>
          </Card>

          <Card>
            <template #header>
              <h3 class="text-lg font-medium text-gray-900">With Header</h3>
            </template>
            <p class="text-sm text-gray-500">Card content goes here.</p>
          </Card>

          <Card>
            <template #header>
              <h3 class="text-lg font-medium text-gray-900">With Footer</h3>
            </template>
            <p class="text-sm text-gray-500">Card content goes here.</p>
            <template #footer>
              <div class="flex justify-end gap-2">
                <Button size="sm" variant="outline">Cancel</Button>
                <Button size="sm">Save</Button>
              </div>
            </template>
          </Card>

          <Card hover>
            <h3 class="text-lg font-medium text-gray-900">Hoverable Card</h3>
            <p class="mt-2 text-sm text-gray-500">Hover over this card to see the effect.</p>
          </Card>

          <Card :border="false" :shadow="false" class="bg-gray-50">
            <h3 class="text-lg font-medium text-gray-900">Flat Card</h3>
            <p class="mt-2 text-sm text-gray-500">No border or shadow.</p>
          </Card>

          <Card padding="lg">
            <h3 class="text-lg font-medium text-gray-900">Large Padding</h3>
            <p class="mt-2 text-sm text-gray-500">This card has larger padding.</p>
          </Card>
        </div>
      </section>

      <!-- Avatars Section -->
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Avatars</h2>
        <Card>
          <div class="space-y-6">
            <!-- Sizes -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">Sizes</h3>
              <div class="flex items-center gap-4">
                <Avatar name="John Doe" size="xs" />
                <Avatar name="John Doe" size="sm" />
                <Avatar name="John Doe" size="md" />
                <Avatar name="John Doe" size="lg" />
                <Avatar name="John Doe" size="xl" />
              </div>
            </div>

            <!-- With Status -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">With Status Indicator</h3>
              <div class="flex items-center gap-4">
                <Avatar name="Online User" status="online" />
                <Avatar name="Away User" status="away" />
                <Avatar name="Busy User" status="busy" />
                <Avatar name="Offline User" status="offline" />
              </div>
            </div>

            <!-- Shapes -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">Shapes</h3>
              <div class="flex items-center gap-4">
                <Avatar name="Round Avatar" />
                <Avatar name="Square Avatar" :rounded="false" />
              </div>
            </div>

            <!-- With Ring -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">With Ring</h3>
              <div class="flex items-center gap-4">
                <Avatar name="Ring Avatar" ring />
                <Avatar name="Ring Square" ring :rounded="false" />
              </div>
            </div>

            <!-- Avatar Group -->
            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-3">Avatar Group</h3>
              <AvatarGroup>
                <Avatar name="Alice Johnson" ring ring-color="white" />
                <Avatar name="Bob Smith" ring ring-color="white" />
                <Avatar name="Carol White" ring ring-color="white" />
                <Avatar name="David Brown" ring ring-color="white" />
              </AvatarGroup>
            </div>
          </div>
        </Card>
      </section>

      <!-- Modals Section -->
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Modals</h2>
        <Card>
          <div class="flex flex-wrap gap-3">
            <Button variant="outline" @click="openModal('sm')">Small Modal</Button>
            <Button variant="outline" @click="openModal('md')">Medium Modal</Button>
            <Button variant="outline" @click="openModal('lg')">Large Modal</Button>
            <Button variant="outline" @click="openModal('xl')">XL Modal</Button>
            <Button variant="outline" @click="openModal('full')">Full Modal</Button>
          </div>
        </Card>

        <Modal
          v-model="isModalOpen"
          :size="modalSize"
          title="Example Modal"
          description="This is a description of the modal content."
        >
          <div class="space-y-4">
            <p class="text-sm text-gray-500">
              This is the modal body content. You can put any content here including forms,
              text, images, or other components.
            </p>
            <Input
              v-model="inputText"
              label="Example Input"
              placeholder="Type something..."
            />
          </div>

          <template #footer>
            <div class="flex justify-end gap-3">
              <Button variant="outline" @click="isModalOpen = false">Cancel</Button>
              <Button @click="isModalOpen = false">Confirm</Button>
            </div>
          </template>
        </Modal>
      </section>

      <!-- Usage Example Section -->
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Usage</h2>
        <Card>
          <div class="prose prose-sm max-w-none">
            <h3 class="text-lg font-medium text-gray-900">Import Components</h3>
            <pre class="bg-gray-900 text-gray-100 rounded-lg p-4 overflow-x-auto text-sm"><code>&lt;script setup lang="ts"&gt;
import { Button, Input, Card, Alert, Modal, Badge, Avatar } from '@ui'
&lt;/script&gt;

&lt;template&gt;
  &lt;Button variant="primary"&gt;Click me&lt;/Button&gt;
  &lt;Input v-model="email" label="Email" type="email" /&gt;
  &lt;Badge variant="green" dot&gt;Active&lt;/Badge&gt;
&lt;/template&gt;</code></pre>
          </div>
        </Card>
      </section>
    </div>
  </div>
</template>
