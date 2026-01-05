<script setup lang="ts">
import { computed, useSlots } from 'vue'
import { Link } from '@inertiajs/vue3'

export type ButtonVariant = 'primary' | 'secondary' | 'outline' | 'danger' | 'ghost'
export type ButtonSize = 'xs' | 'sm' | 'md' | 'lg' | 'xl'

export interface ButtonProps {
  /** Button style variant */
  variant?: ButtonVariant
  /** Button size */
  size?: ButtonSize
  /** HTML button type attribute */
  type?: 'button' | 'submit' | 'reset'
  /** Shows loading spinner and disables button */
  loading?: boolean
  /** Disables the button */
  disabled?: boolean
  /** Makes button full width */
  fullWidth?: boolean
  /** URL for Inertia Link - renders as link instead of button */
  href?: string
  /** Inertia Link method */
  method?: 'get' | 'post' | 'put' | 'patch' | 'delete'
  /** Preserve scroll position on navigation */
  preserveScroll?: boolean
  /** Preserve state on navigation */
  preserveState?: boolean
}

const props = withDefaults(defineProps<ButtonProps>(), {
  variant: 'primary',
  size: 'md',
  type: 'button',
  loading: false,
  disabled: false,
  fullWidth: false,
  method: 'get',
  preserveScroll: false,
  preserveState: false,
})

const emit = defineEmits<{
  click: [event: MouseEvent]
}>()

const slots = useSlots()

const isDisabled = computed(() => props.disabled || props.loading)
const isLink = computed(() => !!props.href)

const hasLeftIcon = computed(() => !!slots['icon-left'])
const hasRightIcon = computed(() => !!slots['icon-right'])

// Base classes that apply to all buttons
const baseClasses = [
  'inline-flex',
  'items-center',
  'justify-center',
  'font-semibold',
  'rounded-md',
  'transition-all',
  'duration-150',
  'focus:outline-none',
  'focus-visible:ring-2',
  'focus-visible:ring-offset-2',
]

// Variant-specific classes
const variantClasses: Record<ButtonVariant, string[]> = {
  primary: [
    'bg-indigo-600',
    'text-white',
    'shadow-sm',
    'hover:bg-indigo-500',
    'focus-visible:ring-indigo-600',
    'disabled:bg-indigo-400',
  ],
  secondary: [
    'bg-white',
    'text-gray-900',
    'shadow-sm',
    'ring-1',
    'ring-inset',
    'ring-gray-300',
    'hover:bg-gray-50',
    'focus-visible:ring-indigo-600',
    'disabled:bg-gray-100',
    'disabled:text-gray-400',
  ],
  outline: [
    'bg-transparent',
    'text-indigo-600',
    'ring-1',
    'ring-inset',
    'ring-indigo-600',
    'hover:bg-indigo-50',
    'focus-visible:ring-indigo-600',
    'disabled:text-indigo-300',
    'disabled:ring-indigo-300',
  ],
  danger: [
    'bg-red-600',
    'text-white',
    'shadow-sm',
    'hover:bg-red-500',
    'focus-visible:ring-red-600',
    'disabled:bg-red-400',
  ],
  ghost: [
    'bg-transparent',
    'text-gray-700',
    'hover:bg-gray-100',
    'hover:text-gray-900',
    'focus-visible:ring-gray-500',
    'disabled:text-gray-400',
    'disabled:hover:bg-transparent',
  ],
}

// Size-specific classes
const sizeClasses: Record<ButtonSize, string[]> = {
  xs: ['text-xs', 'px-2', 'py-1', 'gap-1'],
  sm: ['text-sm', 'px-2.5', 'py-1.5', 'gap-1.5'],
  md: ['text-sm', 'px-3', 'py-2', 'gap-2'],
  lg: ['text-base', 'px-4', 'py-2.5', 'gap-2'],
  xl: ['text-base', 'px-5', 'py-3', 'gap-2.5'],
}

// Icon size classes based on button size
const iconSizeClasses: Record<ButtonSize, string> = {
  xs: 'h-3.5 w-3.5',
  sm: 'h-4 w-4',
  md: 'h-5 w-5',
  lg: 'h-5 w-5',
  xl: 'h-6 w-6',
}

// Spinner size classes based on button size
const spinnerSizeClasses: Record<ButtonSize, string> = {
  xs: 'h-3 w-3',
  sm: 'h-3.5 w-3.5',
  md: 'h-4 w-4',
  lg: 'h-5 w-5',
  xl: 'h-5 w-5',
}

const buttonClasses = computed(() => {
  const classes = [
    ...baseClasses,
    ...variantClasses[props.variant],
    ...sizeClasses[props.size],
  ]

  if (props.fullWidth) {
    classes.push('w-full')
  }

  if (isDisabled.value) {
    classes.push('cursor-not-allowed')
  }

  return classes.join(' ')
})

const iconClasses = computed(() => iconSizeClasses[props.size])
const spinnerClasses = computed(() => spinnerSizeClasses[props.size])

function handleClick(event: MouseEvent) {
  if (isDisabled.value) {
    event.preventDefault()
    return
  }
  emit('click', event)
}
</script>

<template>
  <component
    :is="isLink ? Link : 'button'"
    :href="isLink ? href : undefined"
    :method="isLink ? method : undefined"
    :preserve-scroll="isLink ? preserveScroll : undefined"
    :preserve-state="isLink ? preserveState : undefined"
    :type="!isLink ? type : undefined"
    :disabled="!isLink && isDisabled"
    :aria-disabled="isDisabled"
    :aria-busy="loading"
    :class="buttonClasses"
    @click="handleClick"
  >
    <!-- Loading spinner -->
    <svg
      v-if="loading"
      :class="[spinnerClasses, 'animate-spin']"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      aria-hidden="true"
    >
      <circle
        class="opacity-25"
        cx="12"
        cy="12"
        r="10"
        stroke="currentColor"
        stroke-width="4"
      />
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      />
    </svg>

    <!-- Left icon slot -->
    <span
      v-if="hasLeftIcon && !loading"
      :class="iconClasses"
      aria-hidden="true"
    >
      <slot name="icon-left" />
    </span>

    <!-- Default slot for button text -->
    <span :class="{ 'sr-only': loading && !$slots.default }">
      <slot />
    </span>

    <!-- Right icon slot -->
    <span
      v-if="hasRightIcon"
      :class="iconClasses"
      aria-hidden="true"
    >
      <slot name="icon-right" />
    </span>
  </component>
</template>
