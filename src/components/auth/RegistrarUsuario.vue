<template>
  <div class="login-bg">
    <div class="login-card">
      <h2>Crear Cuenta</h2>
      <form @submit.prevent="register">
        <input v-model="nombre" placeholder="Nombre completo" required />
        <input v-model="email" type="email" placeholder="Correo electrónico" required />
        <input v-model="password" type="password" placeholder="Contraseña" required />
        <input v-model="confirmar" type="password" placeholder="Confirmar contraseña" required />
        <button type="submit">Registrarse</button>
      </form>
      <div class="login-links">
        <router-link to="/login">¿Ya tienes cuenta? Inicia sesión</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
const router = useRouter()
const nombre = ref('')
const email = ref('')
const password = ref('')
const confirmar = ref('')

function register() {
  if (nombre.value && email.value && password.value && confirmar.value && password.value === confirmar.value) {
    router.push('/login')
  }
}
</script>

<style scoped>
.login-bg {
  min-height: 30vh;
  background: #161726;
  display: flex;
  align-items: center;
  justify-content: center;
}
.login-card {
  background: #1a1b2e;
  color: #fff;
  border-radius: 18px;
  box-shadow: 0 2px 16px #0005;
  padding: 36px 32px 28px 32px;
  max-width: 400px;
  width: 100%;
  margin: 32px 0;
  text-align: center;
}
h2 {
  font-size: 2.1rem;
  font-weight: bold;
  margin-bottom: 28px;
  color: #fff;
  letter-spacing: 1px;
}
form {
  display: flex;
  flex-direction: column;
  gap: 0;
}
input {
  background: #18192b;
  border: 1px solid #bfc9e0;
  color: #fff;
  border-radius: 7px;
  padding: 12px 14px;
  margin-bottom: 10px;
  font-size: 1.08em;
  outline: none;
  transition: border 0.2s;
}
input:focus {
  border: 1.5px solid #2e4fff;
}
button {
  background: #2563fa;
  color: #fff;
  border: none;
  border-radius: 7px;
  padding: 12px 0;
  font-size: 1.08em;
  font-weight: bold;
  margin-top: 8px;
  margin-bottom: 10px;
  cursor: pointer;
  transition: background 0.2s;
}
button:hover {
  background: #1b48b2;
}
.login-links {
  display: flex;
  justify-content: center;
  margin-top: 10px;
  font-size: 0.98em;
}
.login-links a {
  color: #2e4fff;
  text-decoration: none;
  transition: color 0.2s;
}
.login-links a:hover {
  text-decoration: underline;
  color: #a259fa;
}
</style>
