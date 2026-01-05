<script setup lang="ts">
import { computed } from 'vue'
import { XMarkIcon } from '@heroicons/vue/20/solid'

export type BadgeVariant = 'gray' | 'red' | 'yellow' | 'green' | 'blue' | 'indigo' | 'purple' | 'pink'
export type BadgeSize = 'sm' | 'md' | 'lg'

export interface BadgeProps {
  /**
   * The color variant of the badge
   * @default 'gray'
   */
  variant?: BadgeVariant
  /**
   * The size of the badge
   * @default 'md'
   */
  size?: BadgeSize
  /**
   * Whether to show a dot indicator before the text
   * @default false
   */
  dot?: boolean
  /**
   * Whether the badge can be removed (shows X button)
   * @default false
   */
  removable?: boolean
  /**
   * Whether to use pill shape (fully rounded) or rounded corners
   * @default true
   */
  pill?: boolean
}

const props = withDefaults(defineProps<BadgeProps>(), {
  variant: 'gray',
  size: 'md',
  dot: false,
  removable: false,
  pill: true,
})

const emit = defineEmits<{
  /**
   * Emitted when the remove button is clicked
   */
  remove: []
}>()

// Variant styles following Tailwind UI badge patterns
const variantClasses: Record<BadgeVariant, string> = {
  gray: 'bg-gray-50 text-gray-600 ring-gray-500/10',
  red: 'bg-red-50 text-red-700 ring-red-600/10',
  yellow: 'bg-yellow-50 text-yellow-800 ring-yellow-600/20',
  green: 'bg-green-50 text-green-700 ring-green-600/20',
  blue: 'bg-blue-50 text-blue-700 ring-blue-700/10',
  indigo: 'bg-indigo-50 text-indigo-700 ring-indigo-700/10',
  purple: 'bg-purple-50 text-purple-700 ring-purple-700/10',
  pink: 'bg-pink-50 text-pink-700 ring-pink-700/10',
}

// Dot color styles
const dotClasses: Record<BadgeVariant, string> = {
  gray: 'fill-gray-400',
  red: 'fill-red-500',
  yellow: 'fill-yellow-500',
  green: 'fill-green-500',
  blue: 'fill-blue-500',
  indigo: 'fill-indigo-500',
  purple: 'fill-purple-500',
  pink: 'fill-pink-500',
}

// Remove button hover styles
const removeButtonClasses: Record<BadgeVariant, string> = {
  gray: 'hover:bg-gray-500/20',
  red: 'hover:bg-red-600/20',
  yellow: 'hover:bg-yellow-600/20',
  green: 'hover:bg-green-600/20',
  blue: 'hover:bg-blue-600/20',
  indigo: 'hover:bg-indigo-600/20',
  purple: 'hover:bg-purple-600/20',
  pink: 'hover:bg-pink-600/20',
}

// Size styles
const sizeClasses: Record<BadgeSize, string> = {
  sm: 'px-1.5 py-0.5 text-xs',
  md: 'px-2 py-1 text-xs',
  lg: 'px-2.5 py-1.5 text-sm',
}

// Dot size styles
const dotSizeClasses: Record<BadgeSize, string> = {
  sm: 'h-1 w-1',
  md: 'h-1.5 w-1.5',
  lg: 'h-2 w-2',
}

// Remove button size styles
const removeButtonSizeClasses: Record<BadgeSize, string> = {
  sm: '-mr-0.5 ml-0.5 h-3 w-3',
  md: '-mr-1 ml-0.5 h-3.5 w-3.5',
  lg: '-mr-1 ml-1 h-4 w-4',
}

const badgeClasses = computed(() => [
  'inline-flex items-center font-medium ring-1 ring-inset',
  variantClasses[props.variant],
  sizeClasses[props.size],
  props.pill ? 'rounded-full' : 'rounded-md',
])

const dotClass = computed(() => [
  dotSizeClasses[props.size],
  dotClasses[props.variant],
])

const removeButtonClass = computed(() => [
  'group relative rounded-sm cursor-pointer',
  removeButtonSizeClasses[props.size],
  removeButtonClasses[props.variant],
])

function handleRemove() {
  emit('remove')
}
</script>

<template>
  <span :class="badgeClasses">
    <!-- Dot indicator -->
    <svg
      v-if="dot"
      :class="['mr-1.5', ...dotClass]"
      viewBox="0 0 6 6"
      aria-hidden="true"
    >
      <circle cx="3" cy="3" r="3" />
    </svg>

    <!-- Badge content -->
    <slot />

    <!-- Remove button -->
    <button
      v-if="removable"
      type="button"
      :class="removeButtonClass"
      aria-label="Remove"
      @click="handleRemove"
    >
      <span class="sr-only">Remove</span>
      <XMarkIcon class="h-full w-full" aria-hidden="true" />
    </button>
  </span>
</template>
