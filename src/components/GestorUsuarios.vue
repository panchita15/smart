<template>
  <div class="gestor">
    <h3>Gestor de Usuarios</h3>
    <div class="resumen-estados">
      <span class="badge activo">Activos: {{ totalActivos }}</span>
      <span class="badge inactivo">Inactivos: {{ totalInactivos }}</span>
      <span class="badge ausente">Ausentes: {{ totalAusentes }}</span>
    </div>
    <table>
      <thead>
        <tr>
          <th>Nombre</th>
          <th>Rol</th>
          <th>Correo</th>
          <th>Estado</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.email">
          <td>{{ user.name }}</td>
          <td>{{ user.role }}</td>
          <td>{{ user.email }}</td>
          <td>
            <span :class="'user-status ' + user.estado.toLowerCase()">
              {{ user.estado }}
            </span>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const users = ref([
  { name: 'Juan Pérez', role: 'Técnico', email: 'juan@demo.com', estado: 'Activo' },
  { name: 'Ana López', role: 'Supervisor', email: 'ana@demo.com', estado: 'Activo' },
  { name: 'Pedro Ruiz', role: 'Técnico', email: 'pedro@demo.com', estado: 'Inactivo' },
  { name: 'Carla Gómez', role: 'Administrador', email: 'carla@demo.com', estado: 'Activo' },
  { name: 'Luis Torres', role: 'Técnico', email: 'luis@demo.com', estado: 'Ausente' },
  { name: 'Sofía Díaz', role: 'Supervisor', email: 'sofia@demo.com', estado: 'Activo' },
  { name: 'Miguel Castro', role: 'Técnico', email: 'miguel@demo.com', estado: 'Inactivo' },
  { name: 'Lucía Fernández', role: 'Técnico', email: 'lucia@demo.com', estado: 'Activo' },
  { name: 'Mario Silva', role: 'Técnico', email: 'mario@demo.com', estado: 'Ausente' },
  { name: 'Elena Ríos', role: 'Supervisor', email: 'elena@demo.com', estado: 'Activo' },
  { name: 'Jorge Méndez', role: 'Técnico', email: 'jorge@demo.com', estado: 'Activo' },
  { name: 'Paula Vega', role: 'Técnico', email: 'paula@demo.com', estado: 'Inactivo' },
  { name: 'Andrés Soto', role: 'Técnico', email: 'andres@demo.com', estado: 'Activo' },
  { name: 'Valeria León', role: 'Supervisor', email: 'valeria@demo.com', estado: 'Ausente' },
  { name: 'Ricardo Peña', role: 'Técnico', email: 'ricardo@demo.com', estado: 'Activo' },
  { name: 'Camila Ortiz', role: 'Técnico', email: 'camila@demo.com', estado: 'Inactivo' },
  { name: 'Gabriel Ramos', role: 'Técnico', email: 'gabriel@demo.com', estado: 'Activo' },
  { name: 'Natalia Paredes', role: 'Supervisor', email: 'natalia@demo.com', estado: 'Activo' },
  { name: 'Felipe Molina', role: 'Técnico', email: 'felipe@demo.com', estado: 'Ausente' },
  { name: 'Daniela Soto', role: 'Técnico', email: 'daniela@demo.com', estado: 'Activo' }
])

const totalActivos = computed(() => users.value.filter(u => u.estado === 'Activo').length)
const totalInactivos = computed(() => users.value.filter(u => u.estado === 'Inactivo').length)
const totalAusentes = computed(() => users.value.filter(u => u.estado === 'Ausente').length)
</script>

<style scoped>
.gestor {
  background: #23284a;
  border-radius: 12px;
  padding: 18px;
  margin-bottom: 18px;
  min-width: 320px;
  box-shadow: 0 2px 8px #0002;
  overflow-x: auto;
}
.gestor h3 {
  color: #fff;
  margin-bottom: 8px;
}
.resumen-estados {
  display: flex;
  gap: 12px;
  margin-bottom: 12px;
}
.badge {
  display: inline-block;
  padding: 4px 14px;
  border-radius: 16px;
  font-weight: bold;
  font-size: 1em;
}
.badge.activo {
  background: #43e97b;
  color: #23284a;
}
.badge.inactivo {
  background: #ff5e69;
  color: #fff;
}
.badge.ausente {
  background: #ffe066;
  color: #23284a;
}
table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: #23284a;
  color: #fff;
  border-radius: 12px;
  overflow: hidden;
  margin-bottom: 8px;
  font-size: 0.98em;
}
th, td {
  padding: 8px 6px;
  text-align: left;
}
th {
  background: #23284a;
  color: #bfc9e0;
  font-weight: 600;
  border-bottom: 2px solid #38406b;
}
tr:not(:last-child) td {
  border-bottom: 1px solid #38406b;
}
.user-status {
  border-radius: 8px;
  padding: 2px 10px;
  font-weight: bold;
  display: inline-block;
}
.user-status.activo {
  background: #43e97b;
  color: #23284a;
}
.user-status.inactivo {
  background: #ff5e69;
  color: #fff;
}
.user-status.ausente {
  background: #ffe066;
  color: #23284a;
}
</style>
