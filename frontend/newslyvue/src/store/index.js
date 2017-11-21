
import Vue from 'vue'
import Vuex from 'vuex'
import * as getters from './getters'
import * as actions from './actions'
import * as mutations from './mutations'


Vue.use(Vuex)


console.log('inside the index/store file');


const state = {
  count: 0,
  userPass: null,
  userName: null,
  userPic: null,
  connectStatus: false,
  socket: null,
  channel: null,
  broadcastChannel: null,
  commentChannel: null,
  messages: [],
  returnmessage: '',
  articlesList: [],
  newarticlereturn: null,
  commentsList: [],
  userObj: null
}

const store = new Vuex.Store({
  state,
  getters,
  actions,
  mutations
})

if (module.hot) {
  module.hot.accept([
    './getters',
    './actions',
    './mutations'
  ], () => {
    store.hotUpdate({
      getters: require('./getters'),
      actions: require('./actions'),
      mutations: require('./mutations')
    })
  })
}

export default store
