<script setup lang="ts">
import { computed, useSlots } from 'vue'
import {
  InformationCircleIcon,
  CheckCircleIcon,
  ExclamationTriangleIcon,
  XCircleIcon,
  XMarkIcon,
} from '@heroicons/vue/20/solid'
import type { Component, FunctionalComponent } from 'vue'

type AlertVariant = 'info' | 'success' | 'warning' | 'error'

interface Props {
  variant?: AlertVariant
  title?: string
  message?: string
  dismissible?: boolean
  icon?: Component | FunctionalComponent | null
  showIcon?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'info',
  title: undefined,
  message: undefined,
  dismissible: false,
  icon: undefined,
  showIcon: true,
})

const emit = defineEmits<{
  dismiss: []
}>()

const slots = useSlots()

const variantConfig = computed(() => {
  const configs: Record<
    AlertVariant,
    {
      containerClass: string
      iconClass: string
      titleClass: string
      messageClass: string
      dismissButtonClass: string
      icon: Component | FunctionalComponent
    }
  > = {
    info: {
      containerClass: 'bg-blue-50 border-blue-200',
      iconClass: 'text-blue-400',
      titleClass: 'text-blue-800',
      messageClass: 'text-blue-700',
      dismissButtonClass:
        'bg-blue-50 text-blue-500 hover:bg-blue-100 focus:ring-blue-600 focus:ring-offset-blue-50',
      icon: InformationCircleIcon,
    },
    success: {
      containerClass: 'bg-green-50 border-green-200',
      iconClass: 'text-green-400',
      titleClass: 'text-green-800',
      messageClass: 'text-green-700',
      dismissButtonClass:
        'bg-green-50 text-green-500 hover:bg-green-100 focus:ring-green-600 focus:ring-offset-green-50',
      icon: CheckCircleIcon,
    },
    warning: {
      containerClass: 'bg-yellow-50 border-yellow-200',
      iconClass: 'text-yellow-400',
      titleClass: 'text-yellow-800',
      messageClass: 'text-yellow-700',
      dismissButtonClass:
        'bg-yellow-50 text-yellow-500 hover:bg-yellow-100 focus:ring-yellow-600 focus:ring-offset-yellow-50',
      icon: ExclamationTriangleIcon,
    },
    error: {
      containerClass: 'bg-red-50 border-red-200',
      iconClass: 'text-red-400',
      titleClass: 'text-red-800',
      messageClass: 'text-red-700',
      dismissButtonClass:
        'bg-red-50 text-red-500 hover:bg-red-100 focus:ring-red-600 focus:ring-offset-red-50',
      icon: XCircleIcon,
    },
  }

  return configs[props.variant]
})

const currentIcon = computed(() => {
  if (props.icon === null) return null
  if (props.icon !== undefined) return props.icon
  return variantConfig.value.icon
})

const ariaRole = computed(() => {
  return props.variant === 'error' || props.variant === 'warning' ? 'alert' : 'status'
})

const hasActions = computed(() => !!slots.actions)

function handleDismiss() {
  emit('dismiss')
}
</script>

<template>
  <div
    :class="[
      'rounded-md border p-4',
      variantConfig.containerClass,
    ]"
    :role="ariaRole"
    aria-live="polite"
  >
    <div class="flex">
      <!-- Icon -->
      <div
        v-if="showIcon && currentIcon"
        class="flex-shrink-0"
      >
        <component
          :is="currentIcon"
          :class="['h-5 w-5', variantConfig.iconClass]"
          aria-hidden="true"
        />
      </div>

      <!-- Content -->
      <div :class="['flex-1', showIcon && currentIcon ? 'ml-3' : '']">
        <div class="flex items-start justify-between">
          <div class="flex-1">
            <!-- Title -->
            <h3
              v-if="title"
              :class="['text-sm font-medium', variantConfig.titleClass]"
            >
              {{ title }}
            </h3>

            <!-- Message -->
            <div
              :class="[
                'text-sm',
                variantConfig.messageClass,
                title ? 'mt-2' : '',
              ]"
            >
              <slot>{{ message }}</slot>
            </div>

            <!-- Actions slot -->
            <div
              v-if="hasActions"
              class="mt-4"
            >
              <div class="-mx-2 -my-1.5 flex gap-3">
                <slot name="actions" />
              </div>
            </div>
          </div>

          <!-- Dismiss button -->
          <div
            v-if="dismissible"
            class="ml-auto pl-3"
          >
            <div class="-mx-1.5 -my-1.5">
              <button
                type="button"
                :class="[
                  'inline-flex rounded-md p-1.5 focus:outline-none focus:ring-2 focus:ring-offset-2',
                  variantConfig.dismissButtonClass,
                ]"
                @click="handleDismiss"
              >
                <span class="sr-only">Dismiss</span>
                <XMarkIcon
                  class="h-5 w-5"
                  aria-hidden="true"
                />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
