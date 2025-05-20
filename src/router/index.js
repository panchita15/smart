import { createRouter, createWebHistory } from 'vue-router'
import TaskTable from '../components/TaskTable.vue'
import AdminPanel from '../components/AdminPanel.vue'
// ...importa otros gestores si los tienes...

const routes = [
  { path: '/', redirect: '/admin/dashboard' },
  { path: '/admin/dashboard', name: 'AdminDashboard', component: () => import('../components/AdminPanel.vue') },
  { path: '/admin/usuarios', name: 'AdminUsuarios', component: () => import('../components/GestorUsuarios.vue') },
  { path: '/admin/tareas', name: 'AdminTareas', component: TaskTable },
  { path: '/admin/errores', name: 'AdminErrores', component: () => import('../components/GestorErrores.vue') },
  { path: '/admin/roles', name: 'AdminRoles', component: () => import('../components/GestorRoles.vue') }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
