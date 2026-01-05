<script setup lang="ts">
import { computed } from 'vue'
import {
  Dialog,
  DialogPanel,
  DialogTitle,
  DialogDescription,
  TransitionRoot,
  TransitionChild,
} from '@headlessui/vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'

type ModalSize = 'sm' | 'md' | 'lg' | 'xl' | 'full'

interface Props {
  modelValue: boolean
  title?: string
  description?: string
  size?: ModalSize
  closeOnBackdrop?: boolean
  closeOnEscape?: boolean
  showCloseButton?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  title: undefined,
  description: undefined,
  size: 'md',
  closeOnBackdrop: true,
  closeOnEscape: true,
  showCloseButton: true,
})

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
}>()

const isOpen = computed({
  get: () => props.modelValue,
  set: (value: boolean) => emit('update:modelValue', value),
})

const close = () => {
  isOpen.value = false
}

const handleBackdropClick = () => {
  if (props.closeOnBackdrop) {
    close()
  }
}

const sizeClasses: Record<ModalSize, string> = {
  sm: 'sm:max-w-sm',
  md: 'sm:max-w-md',
  lg: 'sm:max-w-lg',
  xl: 'sm:max-w-xl',
  full: 'sm:max-w-full sm:m-4',
}

const panelClasses = computed(() => {
  return [
    'w-full transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all',
    sizeClasses[props.size],
  ]
})
</script>

<template>
  <TransitionRoot appear :show="isOpen" as="template">
    <Dialog
      as="div"
      class="relative z-50"
      @close="closeOnEscape ? close() : undefined"
    >
      <!-- Backdrop -->
      <TransitionChild
        as="template"
        enter="ease-out duration-300"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="ease-in duration-200"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div
          class="fixed inset-0 bg-gray-500/75 transition-opacity"
          aria-hidden="true"
        />
      </TransitionChild>

      <!-- Modal container -->
      <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
        <div
          class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0"
          @click.self="handleBackdropClick"
        >
          <TransitionChild
            as="template"
            enter="ease-out duration-300"
            enter-from="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
            enter-to="opacity-100 translate-y-0 sm:scale-100"
            leave="ease-in duration-200"
            leave-from="opacity-100 translate-y-0 sm:scale-100"
            leave-to="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          >
            <DialogPanel :class="panelClasses">
              <!-- Header -->
              <div
                v-if="title || showCloseButton"
                class="flex items-start justify-between border-b border-gray-200 px-4 py-4 sm:px-6"
              >
                <div>
                  <DialogTitle
                    v-if="title"
                    as="h3"
                    class="text-lg font-semibold leading-6 text-gray-900"
                  >
                    {{ title }}
                  </DialogTitle>
                  <DialogDescription
                    v-if="description"
                    class="mt-1 text-sm text-gray-500"
                  >
                    {{ description }}
                  </DialogDescription>
                </div>
                <button
                  v-if="showCloseButton"
                  type="button"
                  class="ml-4 rounded-md bg-white text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                  @click="close"
                >
                  <span class="sr-only">Close</span>
                  <XMarkIcon class="h-6 w-6" aria-hidden="true" />
                </button>
              </div>

              <!-- Content -->
              <div class="px-4 py-4 sm:px-6">
                <slot />
              </div>

              <!-- Footer -->
              <div
                v-if="$slots.footer"
                class="border-t border-gray-200 bg-gray-50 px-4 py-4 sm:px-6"
              >
                <slot name="footer" />
              </div>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>
