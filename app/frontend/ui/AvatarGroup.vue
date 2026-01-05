<script setup lang="ts">
import { provide, computed } from 'vue'
import type { AvatarSize } from './Avatar.vue'

export interface AvatarGroupProps {
  /** Maximum number of avatars to show before showing overflow count */
  max?: number
  /** Size applied to all avatars in the group */
  size?: AvatarSize
  /** Total count of items (for calculating overflow) */
  total?: number
  /** Direction of stacking */
  direction?: 'left' | 'right'
}

const props = withDefaults(defineProps<AvatarGroupProps>(), {
  max: undefined,
  size: 'md',
  total: undefined,
  direction: 'left',
})

// Provide context to child Avatar components
provide('avatar-group', true)
provide('avatar-group-size', props.size)

const slots = defineSlots<{
  default(): any
}>()

// Size configurations for overflow indicator
const sizeClasses: Record<AvatarSize, string> = {
  xs: 'h-6 w-6',
  sm: 'h-8 w-8',
  md: 'h-10 w-10',
  lg: 'h-12 w-12',
  xl: 'h-14 w-14',
}

const textSizeClasses: Record<AvatarSize, string> = {
  xs: 'text-[10px]',
  sm: 'text-xs',
  md: 'text-xs',
  lg: 'text-sm',
  xl: 'text-base',
}

const containerClasses = computed(() => {
  const classes = ['flex items-center isolate']

  if (props.direction === 'right') {
    classes.push('flex-row-reverse')
  }

  return classes.join(' ')
})

const overflowClasses = computed(() => {
  const classes = [
    'relative inline-flex items-center justify-center rounded-full bg-gray-100 ring-2 ring-white font-medium text-gray-600',
    sizeClasses[props.size],
    textSizeClasses[props.size],
    '-ml-2',
  ]

  return classes.join(' ')
})
</script>

<template>
  <div :class="containerClasses">
    <slot />

    <!-- Overflow indicator -->
    <span
      v-if="max !== undefined && total !== undefined && total > max"
      :class="overflowClasses"
    >
      +{{ total - max }}
    </span>
  </div>
</template>
