<template>
  <div class="auth-dropdown-menu">
    <router-link
      class="auth-item"
      to="/login"
      @click="closeMenu"
    >Iniciar Sesión</router-link>
    <router-link
      class="auth-item"
      to="/registrar"
      @click="closeMenu"
    >Registrarse</router-link>
    <router-link
      class="auth-item"
      to="/cerrarsesion"
      @click="closeMenu"
    >Cerrar Sesión</router-link>
  </div>
</template>

<script setup>
const emit = defineEmits(['close'])
function closeMenu() {
  emit('close')
}
</script>

<style scoped>
.auth-dropdown-menu {
  background: #23284a;
  color: #fff;
  min-width: 180px;
  border-radius: 12px;
  box-shadow: 0 2px 12px #0004;
  padding: 8px 0;
  position: absolute;
  top: 48px;
  right: 0;
  z-index: 1000;
  display: flex;
  flex-direction: column;
}
.auth-item {
  padding: 10px 24px;
  color: #fff;
  text-decoration: none;
  font-size: 1.08em;
  transition: background 0.2s, color 0.2s;
}
.auth-item:hover {
  background: #2e4fff;
  color: #fff;
}
</style>
