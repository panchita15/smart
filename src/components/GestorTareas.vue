<template>
  <div class="gestor">
    <h3>Gestor de Tareas</h3>
    <form class="add-task-form" @submit.prevent="addTask">
      <input v-model="nuevo.titulo" placeholder="Título" required />
      <select v-model="nuevo.estado" required>
        <option disabled value="">Estado</option>
        <option>Pendiente</option>
        <option>En Proceso</option>
        <option>Finalizada</option>
      </select>
      <input v-model="nuevo.asignado" placeholder="Asignado a" required />
      <select v-model="nuevo.nivel" required>
        <option disabled value="">Nivel</option>
        <option value="Info">Info</option>
        <option value="Debug">Debug</option>
        <option value="Warning">Warning</option>
        <option value="Error">Error</option>
        <option value="Critical">Critical</option>
      </select>
      <button type="submit">+</button>
    </form>
    <ul>
      <li v-for="t in tareas" :key="t.id">
        <b>{{ t.titulo }}</b> - {{ t.estado }} - {{ t.asignado }}
        <span :class="'nivel-alerta ' + t.nivel.toLowerCase()">{{ t.nivel }}</span>
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const tareas = ref([
  { id: 1, titulo: 'Revisar antena', estado: 'Pendiente', asignado: 'Juan', nivel: 'Warning' },
  { id: 2, titulo: 'Actualizar router', estado: 'En Proceso', asignado: 'Ana', nivel: 'Info' },
  { id: 3, titulo: 'Cambiar batería', estado: 'Finalizada', asignado: 'Pedro', nivel: 'Critical' }
])
const nuevo = ref({ titulo: '', estado: '', asignado: '', nivel: '' })

function addTask() {
  if (nuevo.value.titulo && nuevo.value.estado && nuevo.value.asignado && nuevo.value.nivel) {
    tareas.value.push({
      id: Date.now(),
      titulo: nuevo.value.titulo,
      estado: nuevo.value.estado,
      asignado: nuevo.value.asignado,
      nivel: nuevo.value.nivel
    })
    nuevo.value.titulo = ''
    nuevo.value.estado = ''
    nuevo.value.asignado = ''
    nuevo.value.nivel = ''
  }
}
</script>

<style scoped>
.gestor {
  background: #23284a;
  border-radius: 12px;
  padding: 18px;
  margin-bottom: 18px;
  min-width: 320px;
  flex: 1 1 350px;
  box-shadow: 0 2px 8px #0002;
}
.gestor h3 {
  color: #fff;
  margin-bottom: 8px;
}
.add-task-form {
  display: flex;
  gap: 8px;
  margin-bottom: 12px;
  flex-wrap: wrap;
}
.add-task-form input,
.add-task-form select {
  border-radius: 8px;
  padding: 4px 10px;
  background: #181c2f;
  color: #fff;
  border: 1px solid #38406b;
}
.add-task-form button {
  background: #43e97b;
  color: #23284a;
  border: none;
  border-radius: 8px;
  padding: 4px 14px;
  font-weight: bold;
  cursor: pointer;
  font-size: 1.2em;
  transition: background 0.2s;
}
.add-task-form button:hover {
  background: #38f9d7;
}
ul {
  padding-left: 18px;
}
li {
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.nivel-alerta {
  margin-left: 8px;
  padding: 2px 10px;
  border-radius: 8px;
  font-weight: bold;
  font-size: 0.95em;
  display: inline-block;
}
.nivel-alerta.info {
  background: #2ec4f1;
  color: #23284a;
}
.nivel-alerta.debug {
  background: #bfc9e0;
  color: #23284a;
}
.nivel-alerta.warning {
  background: #ffe066;
  color: #23284a;
}
.nivel-alerta.error {
  background: #ff5e69;
  color: #fff;
}
.nivel-alerta.critical {
  background: #a259fa;
  color: #fff;
}
</style>
