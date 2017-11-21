<template>
  <div class="LeftboxComponent">
    <HeaderHandler/>
    <div v-if='userName!==null && userPass!==null'>
      <div v-if='userPic!=null'>
        <ImageHandler :imageURL='userPic' location='leftbox'></ImageHandler>
      </div>
    </div>
    <br/><br/>
    <KarmaHandler/>
  </div>
</template>

<script>
import { Socket } from 'phoenix';
import EventBus from '../bus/EventBus';
import { mapGetters, mapActions } from 'vuex';
import HeaderHandler from './handlers/HeaderHandler';
import KarmaHandler from './handlers/KarmaHandler';
import ImageHandler from './handlers/ImageHandler.vue'
export default {
  name: 'LeftboxComponent',
  props: [
  ],
  components:{ HeaderHandler, KarmaHandler, ImageHandler},
  computed: {
   ...mapGetters([
     'userPic',
     'userName',
     'userPass'
   ])
  },
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
