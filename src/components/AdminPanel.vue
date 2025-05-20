<template>
  <div class="admin-panel">
    <div class="admin-panel-header">
      <button class="add-user-btn" @click="goRegistrar" title="Registrar usuario">
        <span>➕</span>
      </button>
    </div>
    <Dashboard />
  </div>
</template>

<script setup>
import Dashboard from './Dashboard.vue'
import { useRouter } from 'vue-router'
const router = useRouter()
</script>

<style scoped>
.admin-panel {
  background: #23284a;
  border-radius: 18px;
  padding: 32px 12px;
  box-shadow: 0 2px 16px #0002;
  color: #fff;
  max-width: 1620px;
  margin: 32px auto;
}
.admin-panel-header {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 12px;
}
.add-user-btn {
  background: #43e97b;
  color: #23284a;
  border: none;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  font-size: 1.5em;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 2px 8px #0003;
  transition: background 0.2s;
}
.add-user-btn:hover {
  background: #38f9d7;
}
</style>
