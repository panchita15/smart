<template>
  <div class="task-table-container">
    <div class="resumen-estados">
      <span class="badge pendiente">Pendientes: {{ totalPendiente }}</span>
      <span class="badge enproceso">En Proceso: {{ totalEnProceso }}</span>
      <span class="badge finalizada">Finalizadas: {{ totalFinalizada }}</span>
    </div>
    <div class="filters">
      <div class="filter-buttons">
        <button
          v-for="f in filters"
          :key="f"
          :class="{ active: filter === f }"
          @click="filter = f"
        >{{ f }}</button>
      </div>
      <div class="assigned-filter">
        <label>Asignado a:</label>
        <select v-model="assigned">
          <option value="Todos">Todos</option>
          <option v-for="a in assignedList" :key="a" :value="a">{{ a }}</option>
        </select>
      </div>
    </div>
    <div class="table-responsive">
      <table>
        <thead>
          <tr>
            <th>Tarea</th>
            <th>Equipo</th>
            <th>Estado</th>
            <th>Asignado a</th>
            <th>Alerta (Código)</th>
            <th>Creado</th>
            <th>Finalizada</th>
            <th>Comentario</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="task in filteredTasks" :key="task.id">
            <td data-label="Tarea">{{ task.text }}</td>
            <td data-label="Equipo">{{ task.equipo }}</td>
            <td data-label="Estado">
              <span :class="'status-badge ' + statusClass(task.estado)">
                {{ task.estado }}
              </span>
              <select v-model="task.estado" class="status-select">
                <option v-for="s in statusOptions" :key="s" :value="s">{{ s }}</option>
              </select>
            </td>
            <td data-label="Asignado a">{{ task.asignado }}</td>
            <td data-label="Alerta (Código)">
              <span class="alert-title">{{ task.alerta }}</span>
              <span class="alert-code">({{ task.codigo }})</span>
            </td>
            <td data-label="Creado">{{ task.creado }}</td>
            <td data-label="Finalizada">{{ task.finalizada || '-' }}</td>
            <td data-label="Comentario">
              <div>{{ task.comentario }}</div>
              <input v-model="task.nuevoComentario" placeholder="Nuevo comentario" class="comment-input"/>
              <button class="add-comment" @click="addComment(task)">+</button>
            </td>
            <td>
              <button class="delete-btn" @click="deleteTask(task.id)">✖</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const filters = ['Todas', 'Pendiente', 'En Proceso', 'Finalizada']
const filter = ref('Todas')
const assigned = ref('Todos')

const statusOptions = ['Pendiente', 'En Proceso', 'Finalizada']

const assignedList = [
  'Juan', 'Ana', 'Pedro', 'Luis', 'Carla', 'Sofía', 'Miguel', 'Lucía'
]

const tasks = ref([
  {
    id: 1,
    text: 'Revisar antena principal',
    equipo: 'Antena Norte',
    estado: 'Pendiente',
    asignado: 'Juan',
    alerta: 'Sin señal',
    codigo: 'T-001',
    creado: '2024-06-01',
    finalizada: '',
    comentario: 'Verificar cableado',
    nuevoComentario: ''
  },
  {
    id: 2,
    text: 'Actualizar firmware router',
    equipo: 'Router Central',
    estado: 'En Proceso',
    asignado: 'Ana',
    alerta: 'Actualización',
    codigo: 'T-002',
    creado: '2024-06-02',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 3,
    text: 'Cambiar batería UPS',
    equipo: 'UPS Sala Servidores',
    estado: 'Pendiente',
    asignado: 'Pedro',
    alerta: 'Batería baja',
    codigo: 'T-003',
    creado: '2024-06-03',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 4,
    text: 'Configurar VLAN nueva',
    equipo: 'Switch Planta',
    estado: 'Finalizada',
    asignado: 'Luis',
    alerta: 'Red',
    codigo: 'T-004',
    creado: '2024-06-01',
    finalizada: '2024-06-04',
    comentario: 'Configuración exitosa',
    nuevoComentario: ''
  },
  {
    id: 5,
    text: 'Reemplazar módulo SFP',
    equipo: 'Switch Oficina',
    estado: 'Pendiente',
    asignado: 'Carla',
    alerta: 'Sin enlace',
    codigo: 'T-005',
    creado: '2024-06-02',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 6,
    text: 'Verificar fibra óptica',
    equipo: 'Enlace Planta-Oficina',
    estado: 'En Proceso',
    asignado: 'Sofía',
    alerta: 'Pérdida de señal',
    codigo: 'T-006',
    creado: '2024-06-03',
    finalizada: '',
    comentario: 'Posible daño físico',
    nuevoComentario: ''
  },
  {
    id: 7,
    text: 'Actualizar credenciales WiFi',
    equipo: 'AP Zona 1',
    estado: 'Pendiente',
    asignado: 'Miguel',
    alerta: 'Seguridad',
    codigo: 'T-007',
    creado: '2024-06-04',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 8,
    text: 'Revisar backup automático',
    equipo: 'Servidor Central',
    estado: 'Finalizada',
    asignado: 'Lucía',
    alerta: 'Backup',
    codigo: 'T-008',
    creado: '2024-06-01',
    finalizada: '2024-06-05',
    comentario: 'Backup funcionando',
    nuevoComentario: ''
  },
  {
    id: 9,
    text: 'Instalar nuevo punto de red',
    equipo: 'Oficina 3',
    estado: 'Pendiente',
    asignado: 'Juan',
    alerta: 'Expansión',
    codigo: 'T-009',
    creado: '2024-06-05',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 10,
    text: 'Revisar interferencia RF',
    equipo: 'Antena Sur',
    estado: 'En Proceso',
    asignado: 'Ana',
    alerta: 'Interferencia',
    codigo: 'T-010',
    creado: '2024-06-06',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 11,
    text: 'Actualizar software PBX',
    equipo: 'PBX Central',
    estado: 'Pendiente',
    asignado: 'Pedro',
    alerta: 'Actualización',
    codigo: 'T-011',
    creado: '2024-06-07',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 12,
    text: 'Reemplazar patch cord dañado',
    equipo: 'Rack Planta',
    estado: 'Finalizada',
    asignado: 'Luis',
    alerta: 'Cableado',
    codigo: 'T-012',
    creado: '2024-06-02',
    finalizada: '2024-06-07',
    comentario: 'Cable cambiado',
    nuevoComentario: ''
  },
  {
    id: 13,
    text: 'Verificar logs firewall',
    equipo: 'Firewall Perimetral',
    estado: 'Pendiente',
    asignado: 'Carla',
    alerta: 'Seguridad',
    codigo: 'T-013',
    creado: '2024-06-08',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 14,
    text: 'Configurar QoS para VoIP',
    equipo: 'Router Central',
    estado: 'En Proceso',
    asignado: 'Sofía',
    alerta: 'Calidad de servicio',
    codigo: 'T-014',
    creado: '2024-06-09',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 15,
    text: 'Revisar consumo de ancho de banda',
    equipo: 'Switch Planta',
    estado: 'Pendiente',
    asignado: 'Miguel',
    alerta: 'Monitoreo',
    codigo: 'T-015',
    creado: '2024-06-10',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 16,
    text: 'Actualizar firmware AP',
    equipo: 'AP Zona 2',
    estado: 'Finalizada',
    asignado: 'Lucía',
    alerta: 'Actualización',
    codigo: 'T-016',
    creado: '2024-06-03',
    finalizada: '2024-06-10',
    comentario: 'Firmware actualizado',
    nuevoComentario: ''
  },
  {
    id: 17,
    text: 'Revisar alimentación PoE',
    equipo: 'Switch Oficina',
    estado: 'Pendiente',
    asignado: 'Juan',
    alerta: 'Alimentación',
    codigo: 'T-017',
    creado: '2024-06-11',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 18,
    text: 'Verificar redundancia de enlaces',
    equipo: 'Enlace Planta-Oficina',
    estado: 'En Proceso',
    asignado: 'Ana',
    alerta: 'Redundancia',
    codigo: 'T-018',
    creado: '2024-06-12',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 19,
    text: 'Reemplazar fuente de poder',
    equipo: 'Servidor Central',
    estado: 'Pendiente',
    asignado: 'Pedro',
    alerta: 'Fuente dañada',
    codigo: 'T-019',
    creado: '2024-06-13',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 20,
    text: 'Configurar acceso remoto seguro',
    equipo: 'Firewall Perimetral',
    estado: 'Finalizada',
    asignado: 'Luis',
    alerta: 'VPN',
    codigo: 'T-020',
    creado: '2024-06-04',
    finalizada: '2024-06-13',
    comentario: 'VPN configurada',
    nuevoComentario: ''
  },
  {
    id: 21,
    text: 'Revisar logs de llamadas',
    equipo: 'PBX Central',
    estado: 'Pendiente',
    asignado: 'Carla',
    alerta: 'Monitoreo',
    codigo: 'T-021',
    creado: '2024-06-14',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 22,
    text: 'Actualizar reglas de firewall',
    equipo: 'Firewall Perimetral',
    estado: 'En Proceso',
    asignado: 'Sofía',
    alerta: 'Seguridad',
    codigo: 'T-022',
    creado: '2024-06-15',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 23,
    text: 'Reemplazar switch dañado',
    equipo: 'Switch Planta',
    estado: 'Pendiente',
    asignado: 'Miguel',
    alerta: 'Fallo hardware',
    codigo: 'T-023',
    creado: '2024-06-16',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 24,
    text: 'Verificar cobertura WiFi',
    equipo: 'AP Zona 3',
    estado: 'Finalizada',
    asignado: 'Lucía',
    alerta: 'Cobertura',
    codigo: 'T-024',
    creado: '2024-06-05',
    finalizada: '2024-06-16',
    comentario: 'Cobertura óptima',
    nuevoComentario: ''
  },
  {
    id: 25,
    text: 'Revisar latencia de red',
    equipo: 'Switch Oficina',
    estado: 'Pendiente',
    asignado: 'Juan',
    alerta: 'Latencia',
    codigo: 'T-025',
    creado: '2024-06-17',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 26,
    text: 'Actualizar software de monitoreo',
    equipo: 'Servidor Central',
    estado: 'En Proceso',
    asignado: 'Ana',
    alerta: 'Actualización',
    codigo: 'T-026',
    creado: '2024-06-18',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 27,
    text: 'Revisar logs de acceso',
    equipo: 'Firewall Perimetral',
    estado: 'Pendiente',
    asignado: 'Pedro',
    alerta: 'Seguridad',
    codigo: 'T-027',
    creado: '2024-06-19',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 28,
    text: 'Configurar SNMP',
    equipo: 'Switch Planta',
    estado: 'Finalizada',
    asignado: 'Luis',
    alerta: 'Monitoreo',
    codigo: 'T-028',
    creado: '2024-06-06',
    finalizada: '2024-06-19',
    comentario: 'SNMP activo',
    nuevoComentario: ''
  },
  {
    id: 29,
    text: 'Reemplazar antena backup',
    equipo: 'Antena Backup',
    estado: 'Pendiente',
    asignado: 'Carla',
    alerta: 'Fallo hardware',
    codigo: 'T-029',
    creado: '2024-06-20',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 30,
    text: 'Verificar logs de errores',
    equipo: 'Servidor Central',
    estado: 'En Proceso',
    asignado: 'Sofía',
    alerta: 'Errores',
    codigo: 'T-030',
    creado: '2024-06-21',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 31,
    text: 'Actualizar firmware switch',
    equipo: 'Switch Oficina',
    estado: 'Pendiente',
    asignado: 'Miguel',
    alerta: 'Actualización',
    codigo: 'T-031',
    creado: '2024-06-22',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 32,
    text: 'Revisar backup de PBX',
    equipo: 'PBX Central',
    estado: 'Finalizada',
    asignado: 'Lucía',
    alerta: 'Backup',
    codigo: 'T-032',
    creado: '2024-06-07',
    finalizada: '2024-06-22',
    comentario: 'Backup correcto',
    nuevoComentario: ''
  },
  {
    id: 33,
    text: 'Verificar logs de SNMP',
    equipo: 'Switch Planta',
    estado: 'Pendiente',
    asignado: 'Juan',
    alerta: 'Monitoreo',
    codigo: 'T-033',
    creado: '2024-06-23',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 34,
    text: 'Reemplazar AP dañado',
    equipo: 'AP Zona 4',
    estado: 'En Proceso',
    asignado: 'Ana',
    alerta: 'Fallo hardware',
    codigo: 'T-034',
    creado: '2024-06-24',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 35,
    text: 'Actualizar reglas NAT',
    equipo: 'Firewall Perimetral',
    estado: 'Pendiente',
    asignado: 'Pedro',
    alerta: 'Red',
    codigo: 'T-035',
    creado: '2024-06-25',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 36,
    text: 'Verificar logs de eventos',
    equipo: 'Servidor Central',
    estado: 'Finalizada',
    asignado: 'Luis',
    alerta: 'Monitoreo',
    codigo: 'T-036',
    creado: '2024-06-08',
    finalizada: '2024-06-25',
    comentario: 'Sin eventos críticos',
    nuevoComentario: ''
  },
  {
    id: 37,
    text: 'Revisar consumo PoE',
    equipo: 'Switch Planta',
    estado: 'Pendiente',
    asignado: 'Carla',
    alerta: 'Alimentación',
    codigo: 'T-037',
    creado: '2024-06-26',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 38,
    text: 'Actualizar firmware firewall',
    equipo: 'Firewall Perimetral',
    estado: 'En Proceso',
    asignado: 'Sofía',
    alerta: 'Actualización',
    codigo: 'T-038',
    creado: '2024-06-27',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 39,
    text: 'Revisar logs de backup',
    equipo: 'Servidor Central',
    estado: 'Pendiente',
    asignado: 'Miguel',
    alerta: 'Backup',
    codigo: 'T-039',
    creado: '2024-06-28',
    finalizada: '',
    comentario: '',
    nuevoComentario: ''
  },
  {
    id: 40,
    text: 'Verificar configuración de puertos',
    equipo: 'Switch Oficina',
    estado: 'Finalizada',
    asignado: 'Lucía',
    alerta: 'Red',
    codigo: 'T-040',
    creado: '2024-06-09',
    finalizada: '2024-06-28',
    comentario: 'Puertos configurados',
    nuevoComentario: ''
  }
])

const filteredTasks = computed(() => {
  let result = tasks.value
  if (filter.value !== 'Todas') {
    result = result.filter(t => t.estado === filter.value)
  }
  if (assigned.value !== 'Todos') {
    result = result.filter(t => t.asignado === assigned.value)
  }
  return result
})

const totalPendiente = computed(() => tasks.value.filter(t => t.estado === 'Pendiente').length)
const totalEnProceso = computed(() => tasks.value.filter(t => t.estado === 'En Proceso').length)
const totalFinalizada = computed(() => tasks.value.filter(t => t.estado === 'Finalizada').length)

function statusClass(estado) {
  if (estado === 'Pendiente') return 'pending'
  if (estado === 'En Proceso') return 'inprogress'
  if (estado === 'Finalizada') return 'done'
  return ''
}

function addComment(task) {
  if (task.nuevoComentario && task.nuevoComentario.trim()) {
    task.comentario = task.comentario
      ? task.comentario + ' | ' + task.nuevoComentario.trim()
      : task.nuevoComentario.trim()
    task.nuevoComentario = ''
  }
}

function deleteTask(id) {
  tasks.value = tasks.value.filter(t => t.id !== id)
}
</script>

<style scoped>
.task-table-container {
  background: #23284a;
  border-radius: 18px;
  padding: 24px;
  box-shadow: 0 2px 16px #0002;
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
.badge.pendiente {
  background: #ff5e69;
  color: #fff;
}
.badge.enproceso {
  background: #fbcf33;
  color: #23284a;
}
.badge.finalizada {
  background: #43e97b;
  color: #23284a;
}
.filters {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 18px;
  flex-wrap: wrap;
  gap: 12px;
}
.filter-buttons button {
  background: #23284a;
  color: #bfc9e0;
  border: 1px solid #38406b;
  border-radius: 16px;
  padding: 6px 18px;
  margin-right: 8px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}
.filter-buttons button.active,
.filter-buttons button:hover {
  background: linear-gradient(90deg, #b16cea 0%, #ff5e69 100%);
  color: #fff;
}
.assigned-filter label {
  margin-right: 8px;
  color: #bfc9e0;
}
.assigned-filter select {
  background: #23284a;
  color: #fff;
  border: 1px solid #38406b;
  border-radius: 8px;
  padding: 4px 10px;
}
.table-responsive {
  width: 100%;
  overflow-x: auto;
}
table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: #23284a;
  color: #fff;
  border-radius: 12px;
  overflow: hidden;
  min-width: 900px;
}
th, td {
  padding: 10px 8px;
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
.status-badge {
  display: inline-block;
  padding: 2px 10px;
  border-radius: 12px;
  font-size: 0.95em;
  font-weight: bold;
  margin-right: 8px;
}
.status-badge.pending {
  background: #ff5e69;
  color: #fff;
}
.status-badge.inprogress {
  background: #fbcf33;
  color: #23284a;
}
.status-badge.done {
  background: #43e97b;
  color: #23284a;
}
.status-select {
  margin-left: 4px;
  background: #181c2f;
  color: #fff;
  border: 1px solid #38406b;
  border-radius: 8px;
  padding: 2px 8px;
}
.alert-title {
  color: #ff5e69;
  font-weight: bold;
}
.alert-code {
  color: #bfc9e0;
  font-size: 0.95em;
  margin-left: 2px;
}
.comment-input {
  margin-top: 4px;
  width: 90%;
  background: #181c2f;
  color: #fff;
  border: 1px solid #38406b;
  border-radius: 8px;
  padding: 2px 8px;
}
.add-comment {
  background: #43e97b;
  color: #23284a;
  border: none;
  border-radius: 8px;
  padding: 2px 8px;
  margin-left: 4px;
  cursor: pointer;
  font-weight: bold;
}
.add-comment:hover {
  background: #38f9d7;
}
.delete-btn {
  background: #ff5e69;
  color: #fff;
  border: none;
  border-radius: 8px;
  padding: 4px 10px;
  cursor: pointer;
  font-size: 1.1em;
}
.delete-btn:hover {
  background: #b16cea;
}
@media (max-width: 900px) {
  .task-table-container {
    padding: 8px;
  }
  table, th, td {
    font-size: 0.95em;
  }
  table {
    min-width: 700px;
  }
}
@media (max-width: 700px) {
  .table-responsive {
    overflow-x: auto;
  }
  table, thead, tbody, th, td, tr {
    display: block;
  }
  thead {
    display: none;
  }
  tr {
    margin-bottom: 18px;
    border-radius: 12px;
    background: #23284a;
    box-shadow: 0 2px 8px #0002;
    padding: 8px 0;
  }
  td {
    border: none;
    position: relative;
    padding-left: 50%;
    min-height: 36px;
    text-align: left;
    background: none;
    box-shadow: none;
  }
  td[data-label]:before {
    content: attr(data-label) ": ";
    position: absolute;
    left: 12px;
    top: 8px;
    font-weight: bold;
    color: #bfc9e0;
    white-space: nowrap;
  }
  .delete-btn, .add-comment {
    margin-top: 8px;
  }
}
</style>
