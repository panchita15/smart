<template>
  <div class="gestor">
    <h3>Gestor de Roles y Usuarios</h3>
    <div class="roles-section">
      <form @submit.prevent="addRole">
        <input v-model="nuevoRol" placeholder="Nuevo rol" />
        <button type="submit">Agregar Rol</button>
        <button type="button" @click="undoRole" :disabled="!lastRoleAction">Deshacer</button>
      </form>
      <ul>
        <li v-for="(r, i) in roles" :key="r">
          <b>{{ r }}</b>
          <button class="del-btn" @click="removeRole(i)">Eliminar</button>
        </li>
      </ul>
    </div>
    <div class="usuarios-section">
      <form @submit.prevent="addUser">
        <input v-model="nuevoUsuario.nombre" placeholder="Nombre" required />
        <input v-model="nuevoUsuario.email" placeholder="Correo" required type="email" />
        <select v-model="nuevoUsuario.rol" required>
          <option disabled value="">Rol</option>
          <option v-for="r in roles" :key="r" :value="r">{{ r }}</option>
        </select>
        <button type="submit">Crear Usuario</button>
        <button type="button" @click="undoUser" :disabled="!lastUserAction">Deshacer</button>
      </form>
      <table>
        <thead>
          <tr>
            <th>Nombre</th>
            <th>Correo</th>
            <th>Rol</th>
            <th>Acción</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(u, i) in usuarios" :key="u.email">
            <td>{{ u.nombre }}</td>
            <td>{{ u.email }}</td>
            <td>{{ u.rol }}</td>
            <td>
              <button class="del-btn" @click="removeUser(i)">Eliminar</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const roles = ref(['Trabajador', 'Invitado', 'Administrador', 'Programador'])
const nuevoRol = ref('')
const lastRoleAction = ref(null)

function addRole() {
  const r = nuevoRol.value.trim()
  if (r && !roles.value.includes(r)) {
    roles.value.push(r)
    lastRoleAction.value = { type: 'add', value: r }
    nuevoRol.value = ''
  }
}
function removeRole(idx) {
  lastRoleAction.value = { type: 'remove', value: roles.value[idx], idx }
  roles.value.splice(idx, 1)
}
function undoRole() {
  if (!lastRoleAction.value) return
  if (lastRoleAction.value.type === 'add') {
    roles.value = roles.value.filter(r => r !== lastRoleAction.value.value)
  } else if (lastRoleAction.value.type === 'remove') {
    roles.value.splice(lastRoleAction.value.idx, 0, lastRoleAction.value.value)
  }
  lastRoleAction.value = null
}

const usuarios = ref([
  { nombre: 'Juan Pérez', email: 'juan@demo.com', rol: 'Trabajador' },
  { nombre: 'Ana López', email: 'ana@demo.com', rol: 'Administrador' }
])
const nuevoUsuario = ref({ nombre: '', email: '', rol: '' })
const lastUserAction = ref(null)

function addUser() {
  if (
    nuevoUsuario.value.nombre.trim() &&
    nuevoUsuario.value.email.trim() &&
    nuevoUsuario.value.rol
  ) {
    usuarios.value.push({ ...nuevoUsuario.value })
    lastUserAction.value = { type: 'add', value: { ...nuevoUsuario.value } }
    nuevoUsuario.value.nombre = ''
    nuevoUsuario.value.email = ''
    nuevoUsuario.value.rol = ''
  }
}
function removeUser(idx) {
  lastUserAction.value = { type: 'remove', value: usuarios.value[idx], idx }
  usuarios.value.splice(idx, 1)
}
function undoUser() {
  if (!lastUserAction.value) return
  if (lastUserAction.value.type === 'add') {
    usuarios.value = usuarios.value.filter(
      u => u.email !== lastUserAction.value.value.email
    )
  } else if (lastUserAction.value.type === 'remove') {
    usuarios.value.splice(lastUserAction.value.idx, 0, lastUserAction.value.value)
  }
  lastUserAction.value = null
}
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
.roles-section, .usuarios-section {
  margin-bottom: 18px;
}
form {
  display: flex;
  gap: 8px;
  margin-bottom: 12px;
  flex-wrap: wrap;
}
input, select {
  border-radius: 8px;
  padding: 4px 10px;
  background: #181c2f;
  color: #fff;
  border: 1px solid #38406b;
}
button {
  background: #43e97b;
  color: #23284a;
  border: none;
  border-radius: 8px;
  padding: 4px 14px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.2s;
}
button:hover {
  background: #38f9d7;
}
.del-btn {
  background: #ff5e69;
  color: #fff;
  margin-left: 8px;
  padding: 4px 10px;
}
.del-btn:hover {
  background: #b16cea;
}
ul {
  padding-left: 18px;
}
li {
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 8px;
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
</style>
