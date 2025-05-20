<template>
  <Doughnut :data="chartData" :options="options" />
</template>

<script setup>
import { Doughnut } from 'vue-chartjs'
import { Chart, ArcElement, Tooltip, Legend } from 'chart.js'
Chart.register(ArcElement, Tooltip, Legend)

const props = defineProps(['data', 'labels'])
const chartData = {
  labels: props.labels,
  datasets: [{
    data: props.data,
    backgroundColor: ['#a259fa', '#43e97b', '#ffe066'],
    borderWidth: 0
  }]
}
const options = {
  plugins: { legend: { labels: { color: '#fff' } } }
}
</script>
