<template>
  <div class="dashboard-panel">
    <div class="dashboard-cards">
      <div class="card gold">
        <div class="card-value">98.5%</div>
        <div class="card-label">Antenas Online</div>
      </div>
      <div class="card purple">
        <div class="card-value">2,481</div>
        <div class="card-label">Nodos Activos</div>
      </div>
      <div class="card blue">
        <div class="card-value">31,124</div>
        <div class="card-label">Usuarios IA</div>
      </div>
      <div class="card red">
        <div class="card-value">2,125</div>
        <div class="card-label">Tareas Pendientes</div>
      </div>
    </div>
    <div class="dashboard-graphs big-graphs">
      <div class="graph-card big">
        <h3>Estado de Tareas</h3>
        <PieChart :data="pieData" :labels="pieLabels" />
      </div>
      <div class="graph-card big">
        <h3>Tiempo por tarea (horas)</h3>
        <BarChart :data="barData" :labels="barLabels" />
      </div>
      <div class="graph-card big">
        <h3>Tareas por Nodo</h3>
        <BarChart :data="nodeBarData" :labels="nodeBarLabels" color="#a259fa" />
      </div>
      <div class="graph-card big">
        <h3>Distribución de Recursos</h3>
        <DoughnutChart :data="doughnutData" :labels="doughnutLabels" />
      </div>
    </div>
    <div class="dashboard-line small">
      <LineChart :data="lineData" :labels="lineLabels" />
    </div>
    <div class="dashboard-cards bottom">
      <div class="card blue">
        <div class="card-value">68K</div>
        <div class="card-label">Alarmas</div>
      </div>
      <div class="card purple">
        <div class="card-value">33K</div>
        <div class="card-label">Eventos</div>
      </div>
      <div class="card red">
        <div class="card-value">21K</div>
        <div class="card-label">Notificaciones</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import PieChart from './charts/PieChart.vue'
import BarChart from './charts/BarChart.vue'
import DoughnutChart from './charts/DoughnutChart.vue'
import LineChart from './charts/LineChart.vue'

const pieLabels = ['Activas', 'Terminadas', 'Inactivas']
const pieData = [50, 20, 10]

const barLabels = ['Juan', 'Ana', 'Carlos', 'María', 'IA-Node']
const barData = [2.5, 3.1, 1.7, 2.9, 1.2]

const nodeBarLabels = ['Nodo 1', 'Nodo 2', 'Nodo 3', 'Nodo 4', 'Nodo 5']
const nodeBarData = [20, 15, 28, 10, 16]

const doughnutLabels = ['CPU', 'RAM', 'Almacenamiento']
const doughnutData = [9700, 15300, 7000]

const lineLabels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul']
const lineData = [320, 540, 700, 900, 600, 400, 650]
</script>

<style scoped>
.dashboard-panel {
  background: #23284a;
  border-radius: 18px;
  padding: 32px 12px;
  box-shadow: 0 2px 16px #0002;
  color: #fff;
  max-width: 1700px;
  margin: 32px auto;
}
.dashboard-cards {
  display: flex;
  gap: 24px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}
.dashboard-cards.bottom {
  margin-top: 24px;
}
.card {
  background: #181c2f;
  border-radius: 12px;
  padding: 24px 32px;
  min-width: 220px;
  text-align: center;
  box-shadow: 0 2px 8px #0002;
  flex: 1;
}
.card-value {
  font-size: 2.2rem;
  font-weight: bold;
}
.card-label {
  color: #bfc9e0;
  margin-top: 8px;
  font-size: 1.1rem;
}
.card.gold .card-value { color: #ffe066; }
.card.purple .card-value { color: #a259fa; }
.card.blue .card-value { color: #2ec4f1; }
.card.red .card-value { color: #ff5e69; }

.dashboard-graphs {
  display: flex;
  flex-wrap: wrap;
  gap: 18px;
  margin-bottom: 18px;
  justify-content: space-between;
}
.dashboard-graphs.big-graphs {
  gap: 15px;
}
.graph-card {
  background: #181c2f;
  border-radius: 15px;
  box-shadow: 0 2px 8px #0002;
  margin-bottom: 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.graph-card.big {
  padding: 12px 8px;
  flex: 1 1 320px;
  min-width: 260px;
  min-height: 260px;
  max-width: 350px;
}
.graph-card h3 {
  color: #fff;
  font-size: 1.05rem;
  margin-bottom: 8px;
}
.dashboard-line {
  background: #181c2f;
  border-radius: 12px;
  box-shadow: 0 2px 8px #0002;
  margin-bottom: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.dashboard-line.small {
  display: flex;
  flex-wrap: wrap;
  gap: 50px;
  margin-bottom: 50px;
}
@media (max-width: 1200px) {
  .dashboard-graphs, .dashboard-cards {
    flex-direction: row;
    flex-wrap: wrap;
    gap: 8px;
  }
  .graph-card, .card {
    min-width: 0;
    width: 48%;
    max-width: 100%;
  }
  .graph-card.big {
    width: 48%;
    min-width: 180px;
    max-width: 350px;
  }
}
@media (max-width: 900px) {
  .dashboard-graphs, .dashboard-cards {
    flex-direction: column;
    gap: 8px;
  }
  .graph-card, .card {
    width: 100%;
    min-width: 0;
    max-width: 100%;
  }
}
</style>
