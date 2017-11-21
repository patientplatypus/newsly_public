
<template>
  <div class="Profile">
    <br/>
    <div v-bind:style="{backgroundColor: 'rgb(200,200,200)', paddingTop:
    '2%', paddingBottom:'2%'}">
      <h1>Profile</h1>
      <h2>
        Not much here for now, but you can upload an image to be used on your avatar. Huzzah!
      </h2>
    </div>

    <br/>

    <div v-if='userPic!=null&&imageURL===null'>
      <div v-bind:style="{backgroundColor: 'rgb(160,160,160)', paddingTop:
      '2%', paddingBottom:'2%'}">
        <h1>
          Here is your current profile pic. Updating the profile pic will overwrite this image!
        </h1>
        <ImageHandler :imageURL='userPic' location='profile'></ImageHandler>
      </div>
    </div>

    </br>

    <div v-if='userName!==null && userPass!==null'>
      <div v-bind:style="{backgroundColor: 'rgb(200,200,200)', paddingTop:
      '2%', paddingBottom:'2%'}">
        <div v-if="image!==null">
          <h2>
            Here is the image you are going to upload:
          </h2>
          <br/><br/>
            <ImageHandler :imageURL='image' location='profile'></ImageHandler>
        </div>
        <br/><br/>
        <input type="file" v-on:change="onFileChange" class="form-control">
        <br/><br/>
        <button class="btn btn-success btn-block" @click="upload">Upload</button>
        <br/><br/>
        <h2>
          Once the image is uploaded to the database it should appear below:
        </h2>
        <br/><br/>

        <div v-if='imageURL!==null'>
          <ImageHandler :imageURL='imageURL' location='profile'></ImageHandler>
        </div>
      </div>
    </div>

    <div v-if='userName==null && userPass==null'>
      <div v-bind:style="{backgroundColor: 'rgb(200,200,200)', paddingTop:
      '2%', paddingBottom:'2%'}">
        <h1>
          You must log in if you want to set a profile pic!
        </h1>
      </div>
    </div>

  </div>
</template>

<script>
import { Socket } from 'phoenix';
import axios from 'axios';
import { mapGetters, mapActions } from 'vuex'
import Comments from './Comments.vue'
import InfoHandler from './handlers/InfoHandler.vue'
import ImageHandler from './handlers/ImageHandler.vue'
import EventBus from '../bus/EventBus';
export default {
  name: 'Profile',
  data () {
    return {
     image: null,
     sendimage: '',
     imageURL: null
    }
  },
  components: {ImageHandler},
  computed: {
    ...mapGetters([
      'userName',
      'userPass',
      'userPic'
    ])
  },
  created(){

  },
  methods:{
    ...mapActions([
     'saveProfilePic',
    ]),
    onFileChange(e) {
      let files = e.target.files || e.dataTransfer.files;
      if (!files.length)
          return;
      this.createImage(files[0]);
    },
    createImage(file) {
      let reader = new FileReader();
      let self = this;
      reader.onload = (e) => {
          self.image = e.target.result;
          self.sendimage = self.image.substr(self.image.indexOf(',') + 1)
          console.log('value of sendimage; ', self.sendimage);
      };
      reader.readAsDataURL(file);
    },
    upload(){
        axios.post('http://newslyproject2210.us-west-2.elasticbeanstalk.com:80/api/upload',{
          image: this.sendimage,
          username: this.userName,
          password: this.userPass
        })
        .then(response => {
          console.log('value from response: ', response);
          console.log('value of response.data.url: ', response.data.url);
          this.imageURL = response.data.url
          console.log('value of this.returnedimage: ', this.imageURL);
          this.saveProfilePic({pic: this.imageURL})
        })
        .catch(error =>{
          console.log('value from error ', error);
        })
    }
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
