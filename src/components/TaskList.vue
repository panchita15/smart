<template>
  <ul>
    <li v-for="task in tasks" :key="task.id" :class="{ completed: task.completed }">
      <label>
        <input type="checkbox" :checked="task.completed" @change="emitToggle(task.id)" />
        <span>{{ task.text }}</span>
      </label>
      <button @click="emitDelete(task.id)">Eliminar</button>
    </li>
  </ul>
</template>

<script setup>
const props = defineProps({
  tasks: { type: Array, required: true }
})
const emit = defineEmits(['toggle-task', 'delete-task'])
function emitToggle(id) {
  emit('toggle-task', id)
}
function emitDelete(id) {
  emit('delete-task', id)
}
</script>

<style scoped>
ul {
  list-style: none;
  padding: 0;
}
li {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
  gap: 8px;
}
.completed span {
  text-decoration: line-through;
  color: #888;
}
button {
  margin-left: auto;
  background: #e74c3c;
  color: white;
  border: none;
  padding: 4px 10px;
  border-radius: 4px;
  cursor: pointer;
}
button:hover {
  background: #c0392b;
}
</style>
