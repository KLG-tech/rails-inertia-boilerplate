<script setup lang="ts">
import { computed, inject } from 'vue'

export type AvatarSize = 'xs' | 'sm' | 'md' | 'lg' | 'xl'
export type AvatarStatus = 'online' | 'offline' | 'busy' | 'away'

export interface AvatarProps {
  /** Image source URL */
  src?: string | null
  /** Alt text for the image */
  alt?: string
  /** Name used for generating initials fallback */
  name?: string
  /** Size of the avatar */
  size?: AvatarSize
  /** Whether to show as rounded (circle) or square */
  rounded?: boolean
  /** Status indicator */
  status?: AvatarStatus | null
  /** Whether to show a ring/border around the avatar */
  ring?: boolean
  /** Custom ring color class (defaults to white) */
  ringColor?: string
}

const props = withDefaults(defineProps<AvatarProps>(), {
  src: null,
  alt: '',
  name: '',
  size: 'md',
  rounded: true,
  status: null,
  ring: false,
  ringColor: 'ring-white',
})

// Check if avatar is in a group context
const isInGroup = inject<boolean>('avatar-group', false)

// Size configurations
const sizeClasses: Record<AvatarSize, string> = {
  xs: 'h-6 w-6',
  sm: 'h-8 w-8',
  md: 'h-10 w-10',
  lg: 'h-12 w-12',
  xl: 'h-14 w-14',
}

const textSizeClasses: Record<AvatarSize, string> = {
  xs: 'text-xs',
  sm: 'text-xs',
  md: 'text-sm',
  lg: 'text-base',
  xl: 'text-lg',
}

const statusSizeClasses: Record<AvatarSize, string> = {
  xs: 'h-1.5 w-1.5',
  sm: 'h-2 w-2',
  md: 'h-2.5 w-2.5',
  lg: 'h-3 w-3',
  xl: 'h-3.5 w-3.5',
}

const statusPositionClasses: Record<AvatarSize, string> = {
  xs: '-top-0.5 -right-0.5',
  sm: 'top-0 right-0',
  md: 'top-0 right-0',
  lg: 'top-0 right-0',
  xl: 'top-0.5 right-0.5',
}

const statusColorClasses: Record<AvatarStatus, string> = {
  online: 'bg-green-500',
  offline: 'bg-gray-400',
  busy: 'bg-red-500',
  away: 'bg-yellow-500',
}

// Generate initials from name
const initials = computed(() => {
  if (!props.name) return ''

  const names = props.name.trim().split(/\s+/)
  if (names.length === 1) {
    return names[0].charAt(0).toUpperCase()
  }
  return (names[0].charAt(0) + names[names.length - 1].charAt(0)).toUpperCase()
})

// Computed classes
const containerClasses = computed(() => {
  const classes = [
    'relative inline-block flex-shrink-0',
    sizeClasses[props.size],
  ]

  // Negative margin for group stacking
  if (isInGroup) {
    classes.push('-ml-2 first:ml-0')
  }

  return classes.join(' ')
})

const avatarClasses = computed(() => {
  const classes = [
    'inline-flex items-center justify-center overflow-hidden bg-gray-100',
    sizeClasses[props.size],
    props.rounded ? 'rounded-full' : 'rounded-md',
  ]

  if (props.ring) {
    classes.push('ring-2', props.ringColor)
  }

  return classes.join(' ')
})

const imageClasses = computed(() => {
  const classes = [
    'h-full w-full object-cover',
    props.rounded ? 'rounded-full' : 'rounded-md',
  ]

  return classes.join(' ')
})

const statusClasses = computed(() => {
  if (!props.status) return ''

  const classes = [
    'absolute block rounded-full ring-2 ring-white',
    statusSizeClasses[props.size],
    statusPositionClasses[props.size],
    statusColorClasses[props.status],
  ]

  return classes.join(' ')
})

// Image loading state
const hasImageError = defineModel<boolean>('imageError', { default: false })

function handleImageError() {
  hasImageError.value = true
}

function handleImageLoad() {
  hasImageError.value = false
}

const showImage = computed(() => props.src && !hasImageError.value)
const showInitials = computed(() => !showImage.value && initials.value)
const showPlaceholder = computed(() => !showImage.value && !initials.value)
</script>

<template>
  <span :class="containerClasses">
    <span :class="avatarClasses">
      <!-- Image -->
      <img
        v-if="showImage"
        :src="src!"
        :alt="alt || name"
        :class="imageClasses"
        @error="handleImageError"
        @load="handleImageLoad"
      />

      <!-- Initials Fallback -->
      <span
        v-else-if="showInitials"
        :class="[
          'font-medium text-gray-600 select-none',
          textSizeClasses[size],
        ]"
      >
        {{ initials }}
      </span>

      <!-- Placeholder Icon Fallback -->
      <svg
        v-else-if="showPlaceholder"
        class="h-full w-full text-gray-300"
        fill="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          d="M24 20.993V24H0v-2.996A14.977 14.977 0 0112.004 15c4.904 0 9.26 2.354 11.996 5.993zM16.002 8.999a4 4 0 11-8 0 4 4 0 018 0z"
        />
      </svg>
    </span>

    <!-- Status Indicator -->
    <span
      v-if="status"
      :class="statusClasses"
      :aria-label="`Status: ${status}`"
    />
  </span>
</template>
