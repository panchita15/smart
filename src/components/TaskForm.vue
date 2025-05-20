<template>
  <form @submit.prevent="submitTask">
    <input v-model="task" placeholder="Nueva tarea" required />
    <button type="submit">Agregar</button>
  </form>
</template>

<script setup>
import { ref } from 'vue'
const emit = defineEmits(['add-task'])
const task = ref('')

function submitTask() {
  if (task.value.trim()) {
    emit('add-task', task.value.trim())
    task.value = ''
  }
}
</script>

<style scoped>
form {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
}
input {
  flex: 1;
  padding: 6px;
}
button {
  padding: 6px 12px;
}
</style>
