<template>
  <Bar :data="chartData" :options="options" />
</template>

<script setup>
import { Bar } from 'vue-chartjs'
import { Chart, BarElement, CategoryScale, LinearScale, Tooltip, Legend } from 'chart.js'
Chart.register(BarElement, CategoryScale, LinearScale, Tooltip, Legend)

const props = defineProps({ data: Array, labels: Array, color: { type: String, default: '#ffe066' } })
const chartData = {
  labels: props.labels,
  datasets: [{
    label: 'tiempo',
    data: props.data,
    backgroundColor: props.color,
    borderWidth: 0
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
