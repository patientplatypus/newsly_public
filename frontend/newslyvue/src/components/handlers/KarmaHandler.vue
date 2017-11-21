<template>
  <div class="karmahandler" >
    <div v-if='userObj!=null'>
      <div>
        <h1>
          Hi {{userObj.username}}
        </h1>
        <h1>
          Karma Breakdown
        </h1>
        <h2>
          Upvotes: {{userObj.userupvotes}}
        </h2>
        <h2>
          Downvotes: {{userObj.userdownvotes}}
        </h2>
        <h2>
          Flagged: {{userObj.userflaggedcount}}
        </h2>
      </div>
    </div>
  </div>
</template>

<script>
import { Socket } from 'phoenix';
import EventBus from '../../bus/EventBus';
import { mapGetters, mapActions } from 'vuex'
export default {
  name: 'KarmaHandler',
  computed: {
   ...mapGetters([
     'userObj',
   ])
  },
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
