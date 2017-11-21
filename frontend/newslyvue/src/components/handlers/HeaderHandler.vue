<template>
  <div class="headerhandler" >
    <div  v-bind:style="{ fontSize: '4vh'}">
      <p>
        Newsly
      </p>
    </div>
  </div>
</template>

<script>
import { Socket } from 'phoenix';
import EventBus from '../../bus/EventBus';
export default {
  name: 'HeaderHandler',
  props: [
  ],
  data () {
    return {

    }
  },
  created(){

  },
  methods:{
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}
</style>
