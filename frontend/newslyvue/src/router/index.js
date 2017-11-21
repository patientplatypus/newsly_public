import Vue from 'vue'
import Router from 'vue-router'
import Newsly from '@/components/Newsly'
import SignOn from '@/components/SignOn'
import Profile from '@/components/Profile'


Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Newsly',
      component: Newsly
    },
    {
      path: '/newsly',
      name: 'Newsly',
      component: Newsly
    },
    {
      path: '/signon',
      name: 'SignOn',
      component: SignOn
    },
    {
      path: '/profile',
      name: 'Profile',
      component: Profile
    },
  ]
})
