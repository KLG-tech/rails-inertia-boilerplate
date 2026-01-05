<script setup lang="ts">
interface Props {
  padding?: 'none' | 'sm' | 'md' | 'lg'
  border?: boolean
  shadow?: boolean
  hover?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  padding: 'md',
  border: true,
  shadow: true,
  hover: false,
})

const paddingClasses: Record<string, string> = {
  none: '',
  sm: 'p-3',
  md: 'p-4 sm:p-6',
  lg: 'p-6 sm:p-8',
}

const slots = defineSlots<{
  default?: () => unknown
  header?: () => unknown
  footer?: () => unknown
}>()
</script>

<template>
  <div
    class="rounded-lg bg-white"
    :class="[
      border ? 'border border-gray-200' : '',
      shadow ? 'shadow-sm' : '',
      hover ? 'transition-shadow hover:shadow-md' : '',
    ]"
  >
    <div
      v-if="slots.header"
      class="border-b border-gray-200 px-4 py-4 sm:px-6"
    >
      <slot name="header" />
    </div>

    <div :class="paddingClasses[props.padding]">
      <slot />
    </div>

    <div
      v-if="slots.footer"
      class="border-t border-gray-200 px-4 py-4 sm:px-6"
    >
      <slot name="footer" />
    </div>
  </div>
</template>
