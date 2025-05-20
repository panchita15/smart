<template>
  <div class="auth-container">
    <h2>¿Deseas cerrar sesión?</h2>
    <button @click="logout">Cerrar Sesión</button>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
const router = useRouter()
function logout() {
  // Simulación de logout
  router.push('/login')
}
</script>

<style scoped>
.auth-container {
  background: #23284a;
  color: #fff;
  max-width: 350px;
  margin: 60px auto;
  padding: 32px 24px;
  border-radius: 16px;
  box-shadow: 0 2px 16px #0003;
  text-align: center;
}
button {
  background: #ff5e69;
  color: #fff;
  border: none;
  border-radius: 8px;
  padding: 8px 24px;
  font-weight: bold;
  cursor: pointer;
  margin-top: 18px;
}
button:hover {
  background: #b16cea;
}
</style>
