<template>
  <!-- this is not the ideal way to do this, but its a cheap hack  -->
  <div class="imagehandler">
    <div v-if='location==="profile"'>
      <div v-bind:style="{ paddingLeft:'30%', paddingRight:'20%', width: '100%'}">
        <div v-bind:style="{ borderWidth: '5px', borderStyle: 'solid', borderColor: 'black', padding: '5px', margin: '5px', backgroundColor: 'skyblue', width:'40%'}">
          <div>
            <h1>
              Profile Pic 😆👐🙌🎉👍
            </h1>
          </div>
          <img :src='imageURL' v-bind:style="{ maxHeight: '200px', maxWidth: '200px'}"/>
          </div>
        </div>
      </div>
      <div v-if='location==="leftbox"'>
        <div v-bind:style="{ paddingLeft:'5%', paddingRight:'10%', width: '100%'}">
          <div v-bind:style="{ borderWidth: '5px', borderStyle: 'solid', borderColor: 'black', padding: '5px', margin: '5px', backgroundColor: 'skyblue', width:'80%'}">
            <div>
              <h1>
                Profile Pic 😆👐🙌🎉👍
              </h1>
            </div>
            <img :src='imageURL' v-bind:style="{ maxHeight: '200px', maxWidth: '200px'}"/>
          </div>
        </div>
      </div>
    </div>

</template>

<script>
import { Socket } from 'phoenix';
import EventBus from '../../bus/EventBus';
export default {
  name: 'ImageHandler',
  props: [
    "imageURL",
    "location"
  ],
  data () {
    return {
      paddingVar: null,
      widthVar: null,
    }
  },
  created(){
    console.log('here is the value of location in ImageHandler: ', this.location);
    // not used - doesnt work not sure why
    // if (this.location==="profile"){
    //   this.paddingVar = "40%";
    //   this.widthVar = "20%";
    // }
    // if (this.location==="leftbox"){
    //   this.paddingVar = "2%";
    //   this.widthVar = "96%";
    // }
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
