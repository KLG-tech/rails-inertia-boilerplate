<script setup lang="ts">
import { computed, useId } from 'vue'

export interface SelectOption {
  value: string | number
  label: string
  disabled?: boolean
}

export interface Props {
  /** Array of options to display in the select */
  options: SelectOption[]
  /** The v-model value */
  modelValue?: string | number | null
  /** Label text displayed above the select */
  label?: string
  /** Placeholder text for the default empty option */
  placeholder?: string
  /** Helper text displayed below the select */
  helperText?: string
  /** Error message displayed below the select (takes precedence over helperText) */
  error?: string
  /** Whether the field is required */
  required?: boolean
  /** Whether the select is disabled */
  disabled?: boolean
  /** Name attribute for the select element */
  name?: string
  /** ID attribute for the select element (auto-generated if not provided) */
  id?: string
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: null,
  label: undefined,
  placeholder: undefined,
  helperText: undefined,
  error: undefined,
  required: false,
  disabled: false,
  name: undefined,
  id: undefined,
})

const emit = defineEmits<{
  'update:modelValue': [value: string | number | null]
  change: [value: string | number | null]
  blur: [event: FocusEvent]
  focus: [event: FocusEvent]
}>()

const autoId = useId()
const selectId = computed(() => props.id ?? `select-${autoId}`)
const helperId = computed(() => `${selectId.value}-helper`)
const errorId = computed(() => `${selectId.value}-error`)

const hasError = computed(() => Boolean(props.error))

const describedBy = computed(() => {
  const ids: string[] = []
  if (hasError.value) {
    ids.push(errorId.value)
  } else if (props.helperText) {
    ids.push(helperId.value)
  }
  return ids.length > 0 ? ids.join(' ') : undefined
})

const selectClasses = computed(() => {
  const baseClasses = [
    'block w-full rounded-md border-0 py-1.5 pl-3 pr-10',
    'text-gray-900 ring-1 ring-inset',
    'focus:ring-2 focus:ring-inset',
    'sm:text-sm sm:leading-6',
    'appearance-none bg-white',
    'bg-[url("data:image/svg+xml,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 fill=%27none%27 viewBox=%270 0 20 20%27%3e%3cpath stroke=%27%236b7280%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27 stroke-width=%271.5%27 d=%27M6 8l4 4 4-4%27/%3e%3c/svg%3e")] bg-[length:1.25rem_1.25rem] bg-[right_0.5rem_center] bg-no-repeat',
  ]

  if (props.disabled) {
    baseClasses.push(
      'cursor-not-allowed bg-gray-50 text-gray-500 ring-gray-200'
    )
  } else if (hasError.value) {
    baseClasses.push(
      'ring-red-300 text-red-900 placeholder:text-red-300',
      'focus:ring-red-500'
    )
  } else {
    baseClasses.push(
      'ring-gray-300 placeholder:text-gray-400',
      'focus:ring-indigo-600'
    )
  }

  return baseClasses.join(' ')
})

function handleChange(event: Event) {
  const target = event.target as HTMLSelectElement
  const rawValue = target.value

  // Convert back to number if the original options use numbers
  let value: string | number | null = rawValue

  if (rawValue === '') {
    value = null
  } else {
    const numericOption = props.options.find(
      (opt) => typeof opt.value === 'number' && String(opt.value) === rawValue
    )
    if (numericOption) {
      value = Number(rawValue)
    }
  }

  emit('update:modelValue', value)
  emit('change', value)
}

function handleBlur(event: FocusEvent) {
  emit('blur', event)
}

function handleFocus(event: FocusEvent) {
  emit('focus', event)
}
</script>

<template>
  <div>
    <!-- Label -->
    <label
      v-if="label"
      :for="selectId"
      class="block text-sm font-medium leading-6 text-gray-900"
    >
      {{ label }}
      <span v-if="required" class="text-red-500 ml-0.5" aria-hidden="true">*</span>
      <span v-if="required" class="sr-only">(required)</span>
    </label>

    <!-- Select wrapper -->
    <div :class="{ 'mt-2': label }">
      <select
        :id="selectId"
        :name="name"
        :value="modelValue ?? ''"
        :disabled="disabled"
        :required="required"
        :aria-invalid="hasError"
        :aria-describedby="describedBy"
        :class="selectClasses"
        @change="handleChange"
        @blur="handleBlur"
        @focus="handleFocus"
      >
        <!-- Placeholder option -->
        <option v-if="placeholder" value="" disabled>
          {{ placeholder }}
        </option>

        <!-- Options -->
        <option
          v-for="option in options"
          :key="option.value"
          :value="option.value"
          :disabled="option.disabled"
        >
          {{ option.label }}
        </option>
      </select>
    </div>

    <!-- Error message -->
    <p
      v-if="hasError"
      :id="errorId"
      class="mt-2 text-sm text-red-600"
      role="alert"
    >
      {{ error }}
    </p>

    <!-- Helper text (only shown when there's no error) -->
    <p
      v-else-if="helperText"
      :id="helperId"
      class="mt-2 text-sm text-gray-500"
    >
      {{ helperText }}
    </p>
  </div>
</template>
