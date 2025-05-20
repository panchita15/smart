<template>
  <transition name="fade">
    <div v-if="show" class="chat-ia">
      <div class="chat-header">
        <span>Asistente IA Telecom</span>
        <button class="close-btn" @click="$emit('update:show', false)">✖</button>
      </div>
      <div class="chat-body">
        <div class="suggestions">
          <div class="suggestion-title">Sugerencias:</div>
          <button v-for="(s, i) in suggestions" :key="i" @click="selectSuggestion(s)">
            {{ s }}
          </button>
        </div>
        <div class="messages">
          <div v-for="(msg, i) in messages" :key="i" :class="msg.role">
            <span>{{ msg.text }}</span>
          </div>
        </div>
      </div>
      <form class="chat-input" @submit.prevent="send">
        <input v-model="input" placeholder="Escribe tu pregunta..." autocomplete="off" />
        <button type="submit">Enviar</button>
      </form>
    </div>
  </transition>
</template>

<script setup>
import { ref, watch } from 'vue'
const props = defineProps({
  show: Boolean,
  suggestions: Array
})
const emit = defineEmits(['update:show'])

const input = ref('')
const messages = ref([
  { role: 'ia', text: '¡Hola! ¿En qué puedo ayudarte sobre telecomunicaciones o redes?' }
])

function send() {
  if (!input.value.trim()) return
  messages.value.push({ role: 'user', text: input.value })
  // Simulación de respuesta IA
  setTimeout(() => {
    messages.value.push({ role: 'ia', text: getFakeResponse(input.value) })
  }, 600)
  input.value = ''
}
function selectSuggestion(s) {
  input.value = s
  send()
}
function getFakeResponse(q) {
  // Respuestas simuladas
  if (q.toLowerCase().includes('vlan')) return 'Para configurar una VLAN en un switch Cisco, usa los comandos: vlan X, name Y, interface, switchport access vlan X.';
  if (q.toLowerCase().includes('antena')) return 'Si una antena pierde señal, revisa la alineación, alimentación y el cableado.';
  if (q.toLowerCase().includes('firmware')) return 'Para actualizar el firmware, descarga la versión oficial y sigue las instrucciones del fabricante.';
  if (q.toLowerCase().includes('interferencia')) return 'La interferencia puede deberse a otros equipos RF cercanos. Cambia de canal o aumenta la separación.';
  if (q.toLowerCase().includes('backup')) return 'Realiza backups automáticos y verifica periódicamente la integridad de los archivos.';
  if (q.toLowerCase().includes('tráfico')) return 'Puedes monitorear el tráfico de red con herramientas como Wireshark, Zabbix o SNMP.';
  if (q.toLowerCase().includes('seguridad')) return 'Usa WPA2/WPA3, contraseñas robustas y segmenta la red para mejorar la seguridad WiFi.';
  return 'Estoy aquí para ayudarte con cualquier consulta de telecomunicaciones o redes.';
}
watch(() => props.show, (v) => {
  if (v) setTimeout(() => scrollToBottom(), 100)
})
function scrollToBottom() {
  const el = document.querySelector('.chat-ia .chat-body')
  if (el) el.scrollTop = el.scrollHeight
}
</script>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity .2s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
.chat-ia {
  position: fixed;
  right: 24px;
  bottom: 90px;
  width: 340px;
  max-width: 95vw;
  background: #23284a;
  color: #fff;
  border-radius: 18px;
  box-shadow: 0 2px 16px #0005;
  z-index: 300;
  display: flex;
  flex-direction: column;
  font-size: 1em;
}
body[data-theme="light"] .chat-ia {
  background: #fff;
  color: #23284a;
}
.chat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 18px;
  border-bottom: 1px solid #38406b44;
  font-weight: bold;
  font-size: 1.1em;
}
.close-btn {
  background: none;
  border: none;
  color: inherit;
  font-size: 1.2em;
  cursor: pointer;
}
.chat-body {
  padding: 10px 18px;
  max-height: 260px;
  overflow-y: auto;
}
.suggestions {
  margin-bottom: 10px;
}
.suggestion-title {
  font-size: 0.95em;
  color: #a259fa;
  margin-bottom: 4px;
}
.suggestions button {
  background: #181c2f;
  color: #fff;
  border: none;
  border-radius: 12px;
  padding: 4px 10px;
  margin: 2px 4px 2px 0;
  cursor: pointer;
  font-size: 0.97em;
}
body[data-theme="light"] .suggestions button {
  background: #f6f8fa;
  color: #23284a;
}
.messages {
  margin-bottom: 8px;
}
.messages .user {
  text-align: right;
  margin-bottom: 4px;
}
.messages .ia {
  text-align: left;
  color: #43e97b;
  margin-bottom: 4px;
}
.chat-input {
  display: flex;
  border-top: 1px solid #38406b44;
  padding: 8px 10px;
  background: none;
}
.chat-input input {
  flex: 1;
  border: none;
  background: none;
  color: inherit;
  font-size: 1em;
  padding: 6px;
  outline: none;
}
.chat-input button {
  background: linear-gradient(90deg, #43e97b 0%, #38f9d7 100%);
  color: #23284a;
  border: none;
  border-radius: 12px;
  padding: 4px 14px;
  font-weight: bold;
  cursor: pointer;
  margin-left: 6px;
}
@media (max-width: 600px) {
  .chat-ia {
    right: 2vw;
    bottom: 70px;
    width: 98vw;
    min-width: 0;
    border-radius: 12px;
  }
}
</style>
