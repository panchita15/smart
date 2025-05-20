<template>
  <Line :data="chartData" :options="options" />
</template>

<script setup>
import { Line } from 'vue-chartjs'
import { Chart, LineElement, PointElement, CategoryScale, LinearScale, Tooltip, Legend } from 'chart.js'
Chart.register(LineElement, PointElement, CategoryScale, LinearScale, Tooltip, Legend)

const props = defineProps(['data', 'labels'])
const chartData = {
  labels: props.labels,
  datasets: [{
    label: 'IA',
    data: props.data,
    borderColor: '#2ec4f1',
    backgroundColor: '#2ec4f1',
    tension: 0.4
  }]
}
const options = {
  plugins: { legend: { labels: { color: '#fff' } } },
  scales: {
    x: { ticks: { color: '#fff' } },
    y: { ticks: { color: '#fff' } }
  }
}
</script>
