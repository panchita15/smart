<template>
  <div class="gestor">
    <h3>Gestor de Errores</h3>
    <div class="resumen-estados">
      <span class="badge activo">Activos: {{ totalActivos }}</span>
      <span class="badge inactivo">Inactivos: {{ totalInactivos }}</span>
      <span class="badge pausa">Pausa: {{ totalPausa }}</span>
    </div>
    <form class="add-error-form" @submit.prevent="addError">
      <input v-model="nuevo.codigo" placeholder="Código" required />
      <input v-model="nuevo.descripcion" placeholder="Descripción" required />
      <input v-model="nuevo.solucion" placeholder="Solución" required />
      <button type="submit">Agregar</button>
    </form>
    <table>
      <thead>
        <tr>
          <th>Código</th>
          <th>Descripción</th>
          <th>Solución</th>
          <th>Asignado a</th>
          <th>Seguimiento</th>
          <th>Acción</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(error, idx) in errores" :key="error.id">
          <td>{{ error.codigo }}</td>
          <td>{{ error.descripcion }}</td>
          <td>{{ error.solucion }}</td>
          <td>
            <select v-model="error.asignado">
              <option value="">-- Seleccionar --</option>
              <option v-for="n in nombres" :key="n" :value="n">{{ n }}</option>
            </select>
          </td>
          <td>
            <button
              :class="['estado-btn', error.estado === 'ACTIVO' ? 'activo' : '']"
              @click="setEstado(error, 'ACTIVO')"
            >ACTIVO</button>
            <button
              :class="['estado-btn', error.estado === 'INACTIVO' ? 'inactivo' : '']"
              @click="setEstado(error, 'INACTIVO')"
            >INACTIVO</button>
            <button
              :class="['estado-btn', error.estado === 'PAUSA' ? 'pausa' : '']"
              @click="setEstado(error, 'PAUSA')"
            >PAUSA</button>
          </td>
          <td>
            <button class="del-btn" @click="removeError(idx)">Eliminar</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const nombres = [
  'Juan Pérez', 'Ana López', 'Pedro Ruiz', 'Carla Gómez', 'Luis Torres',
  'Sofía Díaz', 'Miguel Castro', 'Lucía Fernández', 'Mario Silva', 'Elena Ríos'
]

const errores = ref([
  { id: 1, codigo: 'ERR-001', descripcion: 'Fallo de enlace principal', solucion: 'Revisar cableado y reiniciar equipo', asignado: '', estado: '' },
  { id: 2, codigo: 'ERR-002', descripcion: 'Timeout de nodo', solucion: 'Verificar conectividad y reiniciar nodo', asignado: '', estado: '' },
  { id: 3, codigo: 'ERR-003', descripcion: 'Pérdida de paquete', solucion: 'Ajustar parámetros de red y revisar interferencias', asignado: '', estado: '' },
  { id: 4, codigo: 'ERR-004', descripcion: 'Antena sin señal', solucion: 'Reorientar antena y comprobar alimentación', asignado: '', estado: '' },
  { id: 5, codigo: 'ERR-005', descripcion: 'Fallo de autenticación', solucion: 'Verificar credenciales y reiniciar sesión', asignado: '', estado: '' },
  { id: 6, codigo: 'ERR-006', descripcion: 'Firmware desactualizado', solucion: 'Actualizar firmware a la última versión', asignado: '', estado: '' },
  { id: 7, codigo: 'ERR-007', descripcion: 'Interferencia RF', solucion: 'Cambiar canal y alejar fuentes de interferencia', asignado: '', estado: '' },
  { id: 8, codigo: 'ERR-008', descripcion: 'Fallo de alimentación PoE', solucion: 'Revisar fuente PoE y reemplazar si es necesario', asignado: '', estado: '' },
  { id: 9, codigo: 'ERR-009', descripcion: 'Latencia elevada', solucion: 'Optimizar rutas y reducir tráfico innecesario', asignado: '', estado: '' },
  { id: 10, codigo: 'ERR-010', descripcion: 'Switch sin respuesta', solucion: 'Reiniciar switch y verificar configuración', asignado: '', estado: '' },
  { id: 11, codigo: 'ERR-011', descripcion: 'Fallo de backup', solucion: 'Verificar espacio y permisos en destino', asignado: '', estado: '' },
  { id: 12, codigo: 'ERR-012', descripcion: 'Desincronización de hora', solucion: 'Configurar NTP correctamente', asignado: '', estado: '' },
  { id: 13, codigo: 'ERR-013', descripcion: 'Fallo de DNS', solucion: 'Revisar servidores DNS y configuración', asignado: '', estado: '' },
  { id: 14, codigo: 'ERR-014', descripcion: 'Corte de fibra óptica', solucion: 'Reemplazar tramo dañado y limpiar conectores', asignado: '', estado: '' },
  { id: 15, codigo: 'ERR-015', descripcion: 'Fallo de autenticación WiFi', solucion: 'Actualizar contraseña y reiniciar AP', asignado: '', estado: '' },
  { id: 16, codigo: 'ERR-016', descripcion: 'CPU alta en router', solucion: 'Revisar procesos y actualizar firmware', asignado: '', estado: '' },
  { id: 17, codigo: 'ERR-017', descripcion: 'RAM insuficiente', solucion: 'Liberar recursos o ampliar memoria', asignado: '', estado: '' },
  { id: 18, codigo: 'ERR-018', descripcion: 'Fallo de disco', solucion: 'Reemplazar disco y restaurar backup', asignado: '', estado: '' },
  { id: 19, codigo: 'ERR-019', descripcion: 'Fallo de ventilador', solucion: 'Reemplazar ventilador y limpiar equipo', asignado: '', estado: '' },
  { id: 20, codigo: 'ERR-020', descripcion: 'Temperatura elevada', solucion: 'Mejorar ventilación y revisar sensores', asignado: '', estado: '' },
  { id: 21, codigo: 'ERR-021', descripcion: 'Fallo de fuente de poder', solucion: 'Reemplazar fuente y verificar voltajes', asignado: '', estado: '' },
  { id: 22, codigo: 'ERR-022', descripcion: 'Fallo de módulo SFP', solucion: 'Reemplazar módulo y limpiar conectores', asignado: '', estado: '' },
  { id: 23, codigo: 'ERR-023', descripcion: 'Fallo de enlace redundante', solucion: 'Verificar configuración y estado físico', asignado: '', estado: '' },
  { id: 24, codigo: 'ERR-024', descripcion: 'Fallo de QoS', solucion: 'Reconfigurar políticas y priorizar tráfico', asignado: '', estado: '' },
  { id: 25, codigo: 'ERR-025', descripcion: 'Fallo de NAT', solucion: 'Revisar reglas y reiniciar router', asignado: '', estado: '' },
  { id: 26, codigo: 'ERR-026', descripcion: 'Fallo de VPN', solucion: 'Verificar credenciales y configuración', asignado: '', estado: '' },
  { id: 27, codigo: 'ERR-027', descripcion: 'Fallo de SNMP', solucion: 'Revisar comunidad y permisos', asignado: '', estado: '' },
  { id: 28, codigo: 'ERR-028', descripcion: 'Fallo de logs', solucion: 'Verificar espacio y permisos de escritura', asignado: '', estado: '' },
  { id: 29, codigo: 'ERR-029', descripcion: 'Fallo de actualización', solucion: 'Reintentar actualización y revisar logs', asignado: '', estado: '' },
  { id: 30, codigo: 'ERR-030', descripcion: 'Fallo de acceso remoto', solucion: 'Verificar reglas de firewall y credenciales', asignado: '', estado: '' },
  { id: 31, codigo: 'ERR-031', descripcion: 'Fallo de backup automático', solucion: 'Revisar programación y permisos', asignado: '', estado: '' },
  { id: 32, codigo: 'ERR-032', descripcion: 'Fallo de autenticación LDAP', solucion: 'Verificar servidor y credenciales', asignado: '', estado: '' },
  { id: 33, codigo: 'ERR-033', descripcion: 'Fallo de autenticación Radius', solucion: 'Revisar configuración y servidor', asignado: '', estado: '' },
  { id: 34, codigo: 'ERR-034', descripcion: 'Fallo de autenticación TACACS', solucion: 'Verificar servidor y claves', asignado: '', estado: '' },
  { id: 35, codigo: 'ERR-035', descripcion: 'Fallo de acceso web', solucion: 'Revisar puertos y certificados', asignado: '', estado: '' },
  { id: 36, codigo: 'ERR-036', descripcion: 'Fallo de acceso SSH', solucion: 'Verificar claves y configuración', asignado: '', estado: '' },
  { id: 37, codigo: 'ERR-037', descripcion: 'Fallo de acceso Telnet', solucion: 'Habilitar servicio y revisar ACL', asignado: '', estado: '' },
  { id: 38, codigo: 'ERR-038', descripcion: 'Fallo de acceso FTP', solucion: 'Verificar usuarios y permisos', asignado: '', estado: '' },
  { id: 39, codigo: 'ERR-039', descripcion: 'Fallo de acceso SFTP', solucion: 'Revisar claves y configuración', asignado: '', estado: '' },
  { id: 40, codigo: 'ERR-040', descripcion: 'Fallo de acceso HTTP', solucion: 'Verificar puertos y firewall', asignado: '', estado: '' },
  { id: 41, codigo: 'ERR-041', descripcion: 'Fallo de acceso HTTPS', solucion: 'Actualizar certificados y revisar puertos', asignado: '', estado: '' },
  { id: 42, codigo: 'ERR-042', descripcion: 'Fallo de autenticación 802.1X', solucion: 'Verificar configuración y servidor', asignado: '', estado: '' },
  { id: 43, codigo: 'ERR-043', descripcion: 'Fallo de autenticación multifactor', solucion: 'Revisar tokens y sincronización', asignado: '', estado: '' },
  { id: 44, codigo: 'ERR-044', descripcion: 'Fallo de acceso a base de datos', solucion: 'Verificar credenciales y conexión', asignado: '', estado: '' },
  { id: 45, codigo: 'ERR-045', descripcion: 'Fallo de replicación', solucion: 'Revisar logs y sincronización', asignado: '', estado: '' },
  { id: 46, codigo: 'ERR-046', descripcion: 'Fallo de cluster', solucion: 'Verificar nodos y estado de red', asignado: '', estado: '' },
  { id: 47, codigo: 'ERR-047', descripcion: 'Fallo de balanceador', solucion: 'Revisar configuración y estado de nodos', asignado: '', estado: '' },
  { id: 48, codigo: 'ERR-048', descripcion: 'Fallo de proxy', solucion: 'Verificar reglas y acceso a internet', asignado: '', estado: '' },
  { id: 49, codigo: 'ERR-049', descripcion: 'Fallo de autenticación SAML', solucion: 'Revisar configuración y certificados', asignado: '', estado: '' },
  { id: 50, codigo: 'ERR-050', descripcion: 'Fallo de autenticación OAuth', solucion: 'Verificar tokens y configuración', asignado: '', estado: '' }
])
const nuevo = ref({ codigo: '', descripcion: '', solucion: '' })

function setEstado(error, estado) {
  error.estado = estado
}
function addError() {
  if (nuevo.value.codigo && nuevo.value.descripcion && nuevo.value.solucion) {
    errores.value.push({
      id: Date.now(),
      codigo: nuevo.value.codigo,
      descripcion: nuevo.value.descripcion,
      solucion: nuevo.value.solucion,
      asignado: '',
      estado: ''
    })
    nuevo.value.codigo = ''
    nuevo.value.descripcion = ''
    nuevo.value.solucion = ''
  }
}
function removeError(idx) {
  errores.value.splice(idx, 1)
}

const totalActivos = computed(() => errores.value.filter(e => e.estado === 'ACTIVO').length)
const totalInactivos = computed(() => errores.value.filter(e => e.estado === 'INACTIVO').length)
const totalPausa = computed(() => errores.value.filter(e => e.estado === 'PAUSA').length)
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
.badge.pausa {
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
select {
  border-radius: 8px;
  padding: 2px 8px;
  background: #181c2f;
  color: #fff;
  border: 1px solid #38406b;
}
.estado-btn {
  border: none;
  border-radius: 8px;
  padding: 4px 10px;
  margin-right: 4px;
  font-weight: bold;
  cursor: pointer;
  background: #38406b;
  color: #fff;
  transition: background 0.2s, color 0.2s;
}
.estado-btn.activo {
  background: #43e97b;
  color: #23284a;
}
.estado-btn.inactivo {
  background: #ff5e69;
  color: #fff;
}
.estado-btn.pausa {
  background: #ffe066;
  color: #23284a;
}
.estado-btn:last-child {
  margin-right: 0;
}
.add-error-form {
  display: flex;
  gap: 8px;
  margin-bottom: 14px;
  flex-wrap: wrap;
}
.add-error-form input {
  border-radius: 8px;
  padding: 4px 10px;
  background: #181c2f;
  color: #fff;
  border: 1px solid #38406b;
}
.add-error-form button {
  background: #43e97b;
  color: #23284a;
  border: none;
  border-radius: 8px;
  padding: 4px 14px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.2s;
}
.add-error-form button:hover {
  background: #38f9d7;
}
.del-btn {
  background: #ff5e69;
  color: #fff;
  border: none;
  border-radius: 8px;
  padding: 4px 10px;
  font-weight: bold;
  cursor: pointer;
  margin-left: 2px;
  transition: background 0.2s;
}
.del-btn:hover {
  background: #b16cea;
}
@media (max-width: 900px) {
  .gestor {
    padding: 8px;
    font-size: 0.95em;
  }
  table, th, td {
    font-size: 0.95em;
  }
}
</style>
