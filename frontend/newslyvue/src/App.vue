<template>
  <div id="app">
    <!-- <router-link class='routerlink' to="/">Home</router-link> -->
    <!-- Above commented out because it's the boiler plate for Vue. booo! -->
    <div class='topbox' v-bind:style="{fontSize: '4vh', display: 'flex', flexDirection:'flex-row'}">
      <div v-bind:style='{flex: "1"}'/>
      <div v-bind:style='{flex: "1"}'>
        <router-link
          v-on:mouseover.native="barhover(1)"
          v-on:mouseleave.native="barleave(1)"
          class='routerlink' to="/newsly"
          v-on:click.native='setCurrentPage("newsly")' v-bind:style="{color:currentpage==='newsly'?'tomato':barhover1===true?'red':'black'}">Newsly</router-link>
      </div>
      <div v-bind:style='{flex: "1"}'>
        <router-link
          v-on:mouseover.native="barhover(2)"
          v-on:mouseleave.native="barleave(2)"
          class='routerlink' to="/signon"
          v-on:click.native='setCurrentPage("signon")' v-bind:style="{color:currentpage==='signon'?'tomato':barhover2===true?'red':'black'}">Sign On</router-link>
      </div>
      <div v-bind:style='{flex: "1"}'>
        <router-link
          v-on:mouseover.native="barhover(3)"
          v-on:mouseleave.native="barleave(3)"
          class='routerlink' to="/profile"
          v-on:click.native='setCurrentPage("profile")' v-bind:style="{color:currentpage==='profile'?'tomato':barhover3===true?'red':'black'}">Profile</router-link>
      </div>
      <div v-bind:style='{flex: "1"}'/>
    </div>
    <div class='leftbox'>
      <LeftboxComponent/>
    </div>
    <router-view class='contentbox'></router-view>

  </div>
</template>

<script>
import LeftboxComponent from './components/LeftboxComponent'
import EventBus from './bus/EventBus';
export default {
  name: 'app',
  components: {LeftboxComponent},
  data(){
    return {
      currentpage: "newsly",
      barhover1: false,
      barhover2: false,
      barhover3: false
    }
  },
  created(){

  },
  methods:{
    setCurrentPage: function(page){
      this.currentpage = page
    },
    barhover: function(number){
      if (number === 1){
        this.barhover1 = true;
        this.barhover2 = false;
        this.barhover3 = false;
      }
      if (number === 2){
        this.barhover1 = false;
        this.barhover2 = true;
        this.barhover3 = false;
      }
      if (number === 3){
        this.barhover1 = false;
        this.barhover2 = false;
        this.barhover3 = true;
      }
    },
    barleave: function(number){
      if (number === 1){
        this.barhover1 = false;
      }
      if (number === 2){
        this.barhover2 = false;
      }
      if (number === 3){
        this.barhover3 = false;
      }
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  display: grid;
  grid-template-columns: 15vw 85vw;
  grid-template-rows: 10vh 90vh;
  grid-gap: 0vw;
  overflow: hidden;
  background-color: #fff;
  color: #444;
}
a{
  text-decoration: none !important;
}
.contentbox{
  grid-column: 2 / 3;
  grid-row: 2 / 3;
  background-color: grey;
  overflow: hidden;
  overflow-y: scroll;
}
.topbox{
  grid-column: 2 / 3;
  grid-row: 1 / 2;
  background-color: skyblue;
  padding-top: 0.75%;
}
.leftbox{
  grid-column: 1 / 2;
  grid-row: 1 / 3;
  background-color: tomato;
}
</style>
