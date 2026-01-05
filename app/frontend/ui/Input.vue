<script setup lang="ts">
import { computed, useAttrs } from 'vue'

export type InputType = 'text' | 'email' | 'password' | 'number' | 'tel' | 'url'

export interface InputProps {
  /** Unique identifier for the input. Auto-generated if not provided. */
  id?: string
  /** Input label text */
  label?: string
  /** Whether the field is required */
  required?: boolean
  /** Placeholder text */
  placeholder?: string
  /** Input type */
  type?: InputType
  /** Model value for v-model binding */
  modelValue?: string | number
  /** Error message to display */
  error?: string
  /** Helper text displayed below the input */
  helperText?: string
  /** Whether the input is disabled */
  disabled?: boolean
  /** Input name attribute */
  name?: string
}

const props = withDefaults(defineProps<InputProps>(), {
  type: 'text',
  required: false,
  disabled: false,
})

const emit = defineEmits<{
  'update:modelValue': [value: string | number]
}>()

const attrs = useAttrs()

// Generate a unique ID if not provided
const inputId = computed(() => props.id || `input-${Math.random().toString(36).substring(2, 9)}`)
const errorId = computed(() => `${inputId.value}-error`)
const helperId = computed(() => `${inputId.value}-helper`)

// Compute aria-describedby based on error and helper text
const ariaDescribedBy = computed(() => {
  const ids: string[] = []
  if (props.error) ids.push(errorId.value)
  if (props.helperText && !props.error) ids.push(helperId.value)
  return ids.length > 0 ? ids.join(' ') : undefined
})

// Input classes based on state
const inputClasses = computed(() => {
  const base = [
    'block w-full rounded-md border-0 py-1.5 shadow-sm ring-1 ring-inset',
    'focus:ring-2 focus:ring-inset sm:text-sm sm:leading-6',
    'placeholder:text-gray-400',
  ]

  if (props.disabled) {
    base.push('bg-gray-50 text-gray-500 cursor-not-allowed ring-gray-200')
  } else if (props.error) {
    base.push(
      'text-red-900 ring-red-300 focus:ring-red-500',
      'pr-10' // Space for error icon
    )
  } else {
    base.push('text-gray-900 ring-gray-300 focus:ring-indigo-600')
  }

  return base.join(' ')
})

// Wrapper classes for leading/trailing content
const hasLeading = computed(() => !!attrs['leading'] || !!attrs['leadingIcon'])
const hasTrailing = computed(() => !!attrs['trailing'] || !!attrs['trailingIcon'] || props.error)

const wrapperClasses = computed(() => {
  const classes = ['relative rounded-md shadow-sm']
  return classes.join(' ')
})

function handleInput(event: Event) {
  const target = event.target as HTMLInputElement
  const value = props.type === 'number' ? Number(target.value) : target.value
  emit('update:modelValue', value)
}
</script>

<template>
  <div>
    <!-- Label -->
    <label
      v-if="label"
      :for="inputId"
      class="block text-sm font-medium leading-6 text-gray-900"
    >
      {{ label }}
      <span v-if="required" class="text-red-500 ml-0.5" aria-hidden="true">*</span>
      <span v-if="required" class="sr-only">(required)</span>
    </label>

    <!-- Input wrapper -->
    <div :class="[wrapperClasses, label ? 'mt-2' : '']">
      <!-- Leading addon/icon slot -->
      <div
        v-if="$slots.leading"
        class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3"
      >
        <slot name="leading" />
      </div>

      <!-- Leading inline addon slot -->
      <div
        v-if="$slots.leadingAddon"
        class="absolute inset-y-0 left-0 flex items-center"
      >
        <span
          class="flex select-none items-center pl-3 text-gray-500 sm:text-sm"
        >
          <slot name="leadingAddon" />
        </span>
      </div>

      <!-- Input element -->
      <input
        :id="inputId"
        :type="type"
        :name="name"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :required="required"
        :aria-invalid="error ? 'true' : undefined"
        :aria-describedby="ariaDescribedBy"
        :class="[
          inputClasses,
          $slots.leading ? 'pl-10' : '',
          $slots.leadingAddon ? 'pl-16' : '',
          $slots.trailing ? 'pr-10' : '',
          $slots.trailingAddon ? 'pr-16' : '',
          error && !$slots.trailing ? 'pr-10' : '',
        ]"
        @input="handleInput"
      />

      <!-- Error icon (shown when there's an error and no trailing slot) -->
      <div
        v-if="error && !$slots.trailing && !$slots.trailingAddon"
        class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3"
      >
        <svg
          class="h-5 w-5 text-red-500"
          viewBox="0 0 20 20"
          fill="currentColor"
          aria-hidden="true"
        >
          <path
            fill-rule="evenodd"
            d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 0110 5zm0 10a1 1 0 100-2 1 1 0 000 2z"
            clip-rule="evenodd"
          />
        </svg>
      </div>

      <!-- Trailing icon slot -->
      <div
        v-if="$slots.trailing"
        class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3"
      >
        <slot name="trailing" />
      </div>

      <!-- Trailing inline addon slot -->
      <div
        v-if="$slots.trailingAddon"
        class="absolute inset-y-0 right-0 flex items-center"
      >
        <span
          class="flex select-none items-center pr-3 text-gray-500 sm:text-sm"
        >
          <slot name="trailingAddon" />
        </span>
      </div>
    </div>

    <!-- Error message -->
    <p
      v-if="error"
      :id="errorId"
      class="mt-2 text-sm text-red-600"
      role="alert"
    >
      {{ error }}
    </p>

    <!-- Helper text (only shown when no error) -->
    <p
      v-else-if="helperText"
      :id="helperId"
      class="mt-2 text-sm text-gray-500"
    >
      {{ helperText }}
    </p>
  </div>
</template>
