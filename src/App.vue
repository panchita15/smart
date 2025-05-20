<template>
  <div :class="['app-root', theme]">
    <nav class="main-navbar-img">
      <div class="navbar-brand-img">
        SMART LINK <span>v2.5 | MINERA DEMO</span> | Asignación de Tareas y Reportabilidad
      </div>
      <div class="navbar-actions-img">
        <button class="menu-btn-img" @click="showAuthMenu = !showAuthMenu">Sesión</button>
        <div v-if="showAuthMenu" class="auth-menu-dropdown" @mouseleave="showAuthMenu = false">
          <div class="auth-modal-content">
            <div class="auth-modal-tabs">
              <button :class="{active: authTab==='login'}" @click="authTab='login'">Iniciar Sesión</button>
              <button :class="{active: authTab==='register'}" @click="authTab='register'">Registrarse</button>
              <button :class="{active: authTab==='logout'}" @click="authTab='logout'">Cerrar Sesión</button>
            </div>
            <div class="auth-modal-body">
              <Login v-if="authTab==='login'" @success="showAuthMenu = false" />
              <RegistrarUsuario v-if="authTab==='register'" @success="showAuthMenu = false" />
              <CerrarSesion v-if="authTab==='logout'" @success="showAuthMenu = false" />
            </div>
          </div>
        </div>
        <button class="admin-btn-img" @click="$router.push('/admin/dashboard')">Panel Administrador</button>
      </div>
    </nav>
    <div v-if="!isAdminRoute" class="mining-main">
      <div class="mining-dashboard-row">
        <div class="mining-dashboard-square">
          <Dashboard />
        </div>
        <div class="mining-ia-square">
          <div class="ia-title">Sugerencias IA</div>
          <transition-group name="fade" tag="ul" class="ia-suggestions">
            <li v-for="(s, i) in [currentSuggestion]" :key="i">
              <b>{{ s.q }}</b>
              <div class="ia-answer">{{ s.a }}</div>
            </li>
          </transition-group>
        </div>
      </div>
      <div class="mining-tasks-rect">
        <TaskTable />
      </div>
    </div>
    <div v-else-if="$route.name === 'InterfazGeneral'" class="interfaz-general-main">
      <div class="ia-solo-sugerencias">
        <div class="ia-title">Sugerencias IA</div>
        <transition-group name="fade" tag="ul" class="ia-suggestions">
          <li v-for="(s, i) in iaSuggestions" :key="i">
            <b>{{ s.q }}</b>
            <div class="ia-answer">{{ s.a }}</div>
          </li>
        </transition-group>
      </div>
      <div class="nn-prediction-panel">
        <div class="nn-title">Predicción de Fallas Críticas y Alertas (Redes Neuronales)</div>
        <div class="nn-prediction-content">
          <div class="nn-prediction-row">
            <span class="nn-label">Próxima falla crítica estimada:</span>
            <span class="nn-value">En 3 días (probabilidad 82%)</span>
          </div>
          <div class="nn-prediction-row">
            <span class="nn-label">Próxima alerta estimada:</span>
            <span class="nn-value">En 7 horas (probabilidad 67%)</span>
          </div>
          <div class="nn-prediction-row">
            <span class="nn-label">Tendencia de fallas:</span>
            <span class="nn-value">Estable</span>
          </div>
          <div class="nn-prediction-row">
            <span class="nn-label">Recomendación IA:</span>
            <span class="nn-value">Revisar antenas Rajant y actualizar firmware Cisco antes de 48h.</span>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="admin-layout">
      <aside class="sidebar">
        <div class="sidebar-title">Solución IA</div>	
        <nav>
          <ul>
            <li class="sidebar-static">
              Smart Link 2.5
            </li>
            <li :class="{active: $route.name==='AdminDashboard'}" @click="go('AdminDashboard')">
              <span class="icon">🏠</span> Dashboard
            </li>
            <li :class="{active: $route.name==='AdminUsuarios'}" @click="go('AdminUsuarios')">
              <span class="icon">👤</span> Gestion de Usuarios
            </li>
            <li :class="{active: $route.name==='AdminTareas'}" @click="go('AdminTareas')">
              <span class="icon">🗒️</span> Gestion de Tareas
            </li>
            <li :class="{active: $route.name==='AdminErrores'}" @click="go('AdminErrores')">
              <span class="icon" style="color:#ff5e69;">❗</span> Gestion de Errores
            </li>
            <li :class="{active: $route.name==='AdminRoles'}" @click="go('AdminRoles')">
              <span class="icon" style="color:#2ec4f1;">🛡️</span> Gestion de Roles
            </li>

          </ul>
        </nav>
      </aside>
      <main class="admin-main">
        <router-view />
      </main>
    </div>
    <ChatIA v-model:show="showChat" :suggestions="iaSuggestions.map(s => s.q)" />
    <button class="chat-fab" @click="showChat = !showChat">
      💬
    </button>
  </div>
</template>

<script setup>
import { useRoute, useRouter } from 'vue-router'
import { computed, ref, watchEffect, onMounted, onBeforeUnmount } from 'vue'
import ChatIA from './components/ChatIA.vue'
import AuthMenu from './components/auth/AuthMenu.vue'
import Dashboard from './components/Dashboard.vue'
import TaskTable from './components/TaskTable.vue'
import Login from './components/auth/Login.vue'
import RegistrarUsuario from './components/auth/RegistrarUsuario.vue'
import CerrarSesion from './components/auth/CerrarSesion.vue'

const route = useRoute()
const router = useRouter()
const isAdminRoute = computed(() => route.path.startsWith('/admin'))

function go(name) { router.push({ name }) }
function goMenu() { router.push('/') }
function logout() { router.push('/') }
function goLogin() { router.push('/login') }
function goCerrarSesion() { router.push('/cerrarsesion') }

// Theme mode
const theme = ref(localStorage.getItem('theme') || 'dark')
function toggleTheme() {
  theme.value = theme.value === 'dark' ? 'light' : 'dark'
  localStorage.setItem('theme', theme.value)
}
watchEffect(() => {
  document.body.setAttribute('data-theme', theme.value)
})

// Notificaciones
const showAlerts = ref(false)
const alerts = ref([
  { icon: '⚠️', text: 'Antena Norte sin señal' },
  { icon: '🔄', text: 'Actualización de firmware disponible' },
  { icon: '🔔', text: 'Nuevo usuario registrado' }
])

// Chat IA
const showChat = ref(false)
const iaSuggestions = [
  {
    q: '¿Cómo configuro una VLAN en un switch Cisco?',
    a: 'Entra al modo configuración, usa "vlan X", "name Y", luego asigna la VLAN a un puerto con "switchport access vlan X".'
  },
  {
    q: '¿Qué hacer si una antena Rajant pierde señal?',
    a: 'Verifica alineación, alimentación, revisa el cableado y consulta logs en el nodo Rajant.'
  },
  {
    q: '¿Cómo actualizar firmware en routers Cisco?',
    a: 'Descarga el firmware oficial, sube el archivo por TFTP/USB y usa "copy" en modo enable. Reinicia el equipo.'
  },
  {
    q: '¿Cómo detectar interferencia en enlaces inalámbricos?',
    a: 'Utiliza herramientas de espectro, cambia de canal y separa físicamente los equipos.'
  },
  {
    q: '¿Cómo hacer backup automático de configuraciones?',
    a: 'Programa scripts o usa herramientas como RANCID, Oxidized o funciones de backup en el NMS.'
  },
  {
    q: '¿Cómo monitorear el tráfico de red?',
    a: 'Emplea SNMP, NetFlow o herramientas como Zabbix, PRTG, Wireshark para analizar tráfico y detectar anomalías.'
  },
  {
    q: '¿Cómo mejorar la seguridad en redes WiFi industriales?',
    a: 'Usa WPA2/WPA3, segmenta la red, aplica listas de acceso y cambia contraseñas periódicamente.'
  },
  {
    q: '¿Qué hacer ante un error crítico en un switch?',
    a: 'Revisa logs, verifica alimentación, realiza un reinicio controlado y consulta soporte del fabricante si persiste.'
  },
  {
    q: '¿Cómo integrar Rajant con Cisco en una red minera?',
    a: 'Configura rutas estáticas, asegúrate de la compatibilidad de protocolos y monitorea la convergencia de la red.'
  },
  {
    q: '¿Cómo automatizar tareas de red en minería?',
    a: 'Utiliza Ansible, scripts Python o herramientas de gestión centralizada compatibles con tus equipos.'
  }
]
const currentSuggestionIndex = ref(0)
const currentSuggestion = computed(() => iaSuggestions[currentSuggestionIndex.value])

let suggestionInterval = null
onMounted(() => {
  suggestionInterval = setInterval(() => {
    currentSuggestionIndex.value = (currentSuggestionIndex.value + 1) % iaSuggestions.length
  }, 5000)
})
onBeforeUnmount(() => {
  if (suggestionInterval) clearInterval(suggestionInterval)
})

// Auth modal logic
const showAuthMenu = ref(false)
const authTab = ref('login')
</script>

<style>
/* filepath: c:\Users\dimiro\Desktop\vue-app\src\App.vue */
body, #app {
  background: #181c2f;
  color: #fff;
  min-height: 100vh;
  margin: 0;
  font-family: 'Segoe UI', Arial, sans-serif;
}
#app {
  padding: 0;
}
.app-root {
  transition: background 0.3s, color 0.3s;
}
.app-root.dark, body[data-theme="dark"] {
  background: #181c2f !important;
  color: #fff !important;
}
.app-root.light, body[data-theme="light"] {
  background: #f6f8fa !important;
  color: #23284a !important;
}
header, .admin-main, main {
  background: inherit;
  color: inherit;
}
h1.dark {
  color: #fff;
}
h1.light {
  color: #23284a;
}
.brand {
  color: #bfc9e0;
}
body[data-theme="light"] .brand,
.app-root.light .brand {
  color: #6c7a99;
}
.admin-btn, .menu-btn {
  /* ...existing code... */
  color: #fff;
}
body[data-theme="light"] .admin-btn,
.app-root.light .admin-btn,
body[data-theme="light"] .menu-btn,
.app-root.light .menu-btn {
  color: #23284a;
}
.alerts-dropdown {
  /* ...existing code... */
  color: inherit;
}
.alert-item {
  color: inherit;
}
.mode-btn {
  background: linear-gradient(90deg, #ffe066 0%, #a259fa 100%);
  color: #23284a;
  border: none;
  border-radius: 16px;
  padding: 6px 14px;
  font-weight: bold;
  cursor: pointer;
  font-size: 1.2em;
}
.notif-btn {
  background: #23284a;
  border: none;
  border-radius: 50%;
  width: 38px;
  height: 38px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  font-size: 1.3em;
  cursor: pointer;
}
.notif-dot {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 10px;
  height: 10px;
  background: #ff5e69;
  border-radius: 50%;
  border: 2px solid #fff;
}
.alerts-dropdown {
  position: absolute;
  top: 60px;
  right: 32px;
  background: #23284a;
  color: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px #0003;
  min-width: 220px;
  z-index: 100;
  padding: 8px 0;
}
body[data-theme="light"] .alerts-dropdown,
.app-root.light .alerts-dropdown {
  background: #fff;
  color: #23284a;
}
.alert-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 18px;
  border-bottom: 1px solid #38406b22;
  font-size: 1em;
}
.alert-item:last-child {
  border-bottom: none;
}
.alert-icon {
  font-size: 1.2em;
}
.admin-btn {
  background: linear-gradient(90deg, #b16cea 0%, #ff5e69 100%);
  color: #fff;
  border: none;
  border-radius: 16px;
  padding: 6px 18px;
  font-weight: bold;
  cursor: pointer;
}
.menu-btn {
  background: linear-gradient(90deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  border: none;
  border-radius: 16px;
  padding: 6px 18px;
  font-weight: bold;
  cursor: pointer;
}
main {
  margin: 0 auto;
  max-width: 1600px;
  padding: 32px 16px;
}
.admin-layout {
  display: flex;
  min-height: 100vh;
}
.sidebar {
  background: #17192b;
  min-width: 220px;
  max-width: 240px;
  padding: 32px 0 0 0;
  display: flex;
  flex-direction: column;
  align-items: stretch;
  min-height: 100vh;
}
.sidebar-title {
  font-size: 1.3rem;
  font-weight: bold;
  color: #fff;
  margin-left: 24px;
  margin-bottom: 24px;
}
.sidebar nav ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.sidebar nav ul li {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 24px;
  color: #bfc9e0;
  font-size: 1.08rem;
  border-radius: 8px 0 0 8px;
  cursor: pointer;
  margin-bottom: 4px;
  transition: background 0.2s, color 0.2s;
}
.sidebar nav ul li.active,
.sidebar nav ul li:hover {
  background: #2e4fff;
  color: #fff;
}
.sidebar nav ul li.active .icon,
.sidebar nav ul li:hover .icon {
  color: #fff !important;
}
.sidebar nav ul li .icon {
  font-size: 1.2em;
}
.admin-main {
  flex: 1;
  padding: 32px 12px;
  min-width: 0;
}
.chat-fab {
  position: fixed;
  right: 24px;
  bottom: 24px;
  background: linear-gradient(90deg, #43e97b 0%, #38f9d7 100%);
  color: #23284a;
  border: none;
  border-radius: 50%;
  width: 56px;
  height: 56px;
  font-size: 2em;
  box-shadow: 0 2px 8px #0003;
  cursor: pointer;
  z-index: 200;
  display: flex;
  align-items: center;
  justify-content: center;
}
.main-navbar-img {
  width: 100%;
  background: #232439;
  color: #fff;
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  padding: 0 0 0 32px;
  height: 56px;
  position: relative;
  z-index: 1001;
  border-top-left-radius: 12px;
  border-top-right-radius: 12px;
  box-shadow: none;
}
.navbar-brand-img {
  font-size: 1.15rem;
  font-weight: bold;
  letter-spacing: 2px;
  color: #fff;
  margin-top: 18px;
  margin-right: 24px;
}
.navbar-brand-img span {
  font-size: 0.95rem;
  color: #bfc9e0;
  font-weight: normal;
  margin-left: 6px;
  letter-spacing: 1px;
}
.navbar-title-img-wrapper {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 56px;
}
.navbar-title-img {
  text-align: center;
  font-size: 2.1rem;
  font-weight: bold;
  margin: 0;
  color: #fff;
  margin-top: 0;
  letter-spacing: 1px;
}
.navbar-actions-img {
  position: absolute;
  top: 12px;
  right: 32px;
  display: flex;
  gap: 12px;
  align-items: center;
}
.menu-btn-img {
  background: linear-gradient(90deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  border: none;
  border-radius: 16px;
  padding: 6px 18px;
  font-weight: bold;
  cursor: pointer;
  font-size: 1em;
  position: relative;
}
.auth-menu-dropdown {
  position: absolute;
  top: 48px;
  right: 120px;
  z-index: 2000;
  min-width: 350px;
  background: none;
  border: none;
}
.admin-btn-img {
  background: linear-gradient(90deg, #b16cea 0%, #2ec4f1 100%);
  color: #fff;
  border: none;
  border-radius: 16px;
  padding: 6px 18px;
  font-weight: bold;
  cursor: pointer;
  font-size: 1em;
}
.mining-main {
  max-width: 1700px;
  margin: 0 auto;
  padding: 32px 12px;
  display: flex;
  flex-direction: column;
  gap: 32px;
}
.mining-dashboard-row {
  display: flex;
  gap: 32px;
  flex-wrap: wrap;
}
.mining-dashboard-square {
  flex: 2 1 600px;
  background: #23284a;
  border-radius: 18px;
  box-shadow: 0 2px 16px #0002;
  padding: 0;
  min-width: 340px;
  min-height: 340px;
  display: flex;
  align-items: stretch;
  justify-content: stretch;
}
.mining-ia-square {
  flex: 1 1 320px;
  background: #181c2f;
  border-radius: 18px;
  box-shadow: 0 2px 16px #0002;
  padding: 24px 18px;
  min-width: 260px;
  min-height: 340px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: flex-start;
}
.ia-title {
  font-size: 1.2rem;
  font-weight: bold;
  color: #a259fa;
  margin-bottom: 12px;
}
.ia-suggestions {
  list-style: disc inside;
  color: #fff;
  padding-left: 0;
  margin: 0;
}
.ia-suggestions li {
  margin-bottom: 10px;
  font-size: 1.05em;
  color: #bfc9e0;
}
.mining-tasks-rect {
  background: #23284a;
  border-radius: 18px;
  box-shadow: 0 2px 16px #0002;
  padding: 24px 12px;
  min-height: 320px;
  margin-top: 0;
}
.interfaz-general-main {
  max-width: 1100px;
  margin: 0 auto;
  padding: 40px 12px 32px 12px;
  display: flex;
  flex-direction: column;
  gap: 38px;
  align-items: center;
}
.ia-solo-sugerencias {
  width: 100%;
  background: #23284a;
  border-radius: 18px;
  box-shadow: 0 2px 16px #0002;
  padding: 32px 24px;
  margin-bottom: 18px;
}
.ia-title {
  font-size: 1.3rem;
  font-weight: bold;
  color: #a259fa;
  margin-bottom: 18px;
}
.ia-suggestions {
  list-style: disc inside;
  color: #fff;
  padding-left: 0;
  margin: 0;
}
.ia-suggestions li {
  margin-bottom: 18px;
  font-size: 1.08em;
  color: #bfc9e0;
}
.ia-answer {
  color: #43e97b;
  font-size: 0.99em;
  margin-top: 4px;
  margin-bottom: 2px;
}
.nn-prediction-panel {
  width: 100%;
  background: #181c2f;
  border-radius: 18px;
  box-shadow: 0 2px 16px #0005;
  padding: 32px 24px;
  margin-top: 0;
}
.nn-title {
  font-size: 1.18rem;
  font-weight: bold;
  color: #ffe066;
  margin-bottom: 18px;
}
.nn-prediction-content {
  display: flex;
  flex-direction: column;
  gap: 14px;
}
.nn-prediction-row {
  display: flex;
  gap: 18px;
  align-items: center;
  font-size: 1.08em;
}
.nn-label {
  color: #bfc9e0;
  min-width: 220px;
  font-weight: 500;
}
.nn-value {
  color: #2ec4f1;
  font-weight: bold;
}
@media (max-width: 900px) {
  .admin-layout {
    flex-direction: column;
  }
  .sidebar {
    flex-direction: row;
    min-width: 0;
    max-width: 100vw;
    padding: 0;
    overflow-x: auto;
    height: auto;
    min-height: 0;
    border-radius: 0 0 12px 12px;
  }
  .sidebar-title {
    display: none;
  }
  .sidebar nav ul {
    display: flex;
    flex-direction: row;
    gap: 0;
  }
  .sidebar nav ul li {
    border-radius: 0;
    padding: 12px 10px;
    font-size: 0.98rem;
    margin-bottom: 0;
    min-width: 90px;
    justify-content: center;
  }
  .admin-main {
    padding: 16px 2px;
  }
  .chat-fab {
    right: 12px;
    bottom: 12px;
    width: 48px;
    height: 48px;
    font-size: 1.5em;
  }
  .main-navbar-img {
    flex-direction: column;
    height: auto;
    padding: 8px 0 0 8px;
  }
  .navbar-title-img-wrapper {
    justify-content: flex-start;
    height: auto;
  }
  .navbar-title-img {
    font-size: 1.2rem;
    margin-top: 2px;
    text-align: left;
  }
  .navbar-actions-img {
    position: static;
    margin: 8px 0 0 0;
    justify-content: flex-end;
  }
  .auth-menu-dropdown {
    right: 0;
    top: 48px;
  }
}
@media (max-width: 600px) {
  header, main, .admin-main {
    padding-left: 4px;
    padding-right: 4px;
  }
  .sidebar nav ul li {
    min-width: 20px;
    font-size: 0.92rem;
    padding: 10px 4px;
  }
}

.auth-menu-dropdown {
  position: absolute;
  top: 48px;
  right: 120px;
  z-index: 2000;
  min-width: 350px;
  background: none;
  border: none;
}
.auth-modal-content {
  background: #23284a;
  border-radius: 16px;
  box-shadow: 0 2px 16px #0005;
  padding: 0;
  min-width: 350px;
  min-height: 380px;
  max-width: 400px;
  width: 100%;
  display: flex;
  flex-direction: column;
}
.auth-modal-tabs {
  display: flex;
  background: #181c2f;
  border-top-left-radius: 16px;
  border-top-right-radius: 16px;
  overflow: hidden;
}
.auth-modal-tabs button {
  flex: 1;
  background: none;
  border: none;
  color: #bfc9e0;
  font-weight: bold;
  font-size: 1.08em;
  padding: 14px 0;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}
.auth-modal-tabs button.active,
.auth-modal-tabs button:hover {
  background: #2e4fff;
  color: #fff;
}
.auth-modal-body {
  padding: 18px 18px 8px 18px;
  background: #23284a;
  border-bottom-left-radius: 16px;
  border-bottom-right-radius: 16px;
  min-height: 300px;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}
.fade-enter-active, .fade-leave-active { transition: opacity .4s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
.ia-answer {
  color: #43e97b;
  font-size: 0.98em;
  margin-top: 4px;
  margin-bottom: 2px;
}
.sidebar nav ul li.sidebar-static {
  color: #fff;
  font-weight: bold;
  font-size: 1.13rem;
  cursor: default;
  background: none !important;
  padding-left: 24px;
  pointer-events: none;
  border-radius: 0;
  margin-bottom: 8px;
  display: block;
}
</style>