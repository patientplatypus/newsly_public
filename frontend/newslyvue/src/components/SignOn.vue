<template>
  <div class="signon">
    <div v-bind:style="{backgroundColor: 'rgb(200,200,200)'}">
      <h1>
        Sign On page
      </h1>
    <div>
      <p>
        Test Button
      </p>
      <button v-on:click="testButton()">Test Button</button>
    </div>

    </div>
    <br/><br/>
    <div v-if='userName!==null && userPass!==null'>
      <div v-bind:style="{backgroundColor: 'rgb(200,200,200)', paddingTop:
      '2%', paddingBottom:'2%'}">
        <h2>
          Welcome {{userName}}!
        </h2>
        <p>
          You are already signed in. If you would like you can sign out.
        </p>
        <button v-on:click="signOut()">Sign Out</button>
      </div>
    </div>

    <div v-if='userName===null && userPass===null'>
      <div v-bind:style="{backgroundColor: 'rgb(160,160,160)', paddingTop:
      '2%', paddingBottom:'2%'}">
        <div>
          <h2>
            Username:
          </h2>
          <input type="text" v-model="username"/>
        </div>
        <br/><br/>
        <div>
          <h2>
            Password:
          </h2>
          <input type="text" v-model="password"/>
        </div>
        <br/><br/>
        <div>
          <button v-on:click="socketPush('login')">Login</button>
        </div>
        <br/><br/>
        <div>
          <button v-on:click="socketPush('signup')">Sign Up</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { Socket } from 'phoenix';
import axios from 'axios';
import { mapGetters, mapActions } from 'vuex'
export default {
  name: 'SignOn',
  data () {
    return {
      msg: 'placeholder',
      // channel: null,
      // socket: null,
      username: '',
      password: '',
    }
  },
  created(){
    this.connectSocket();
  },
  computed: {
   ...mapGetters([
     'userObj',
     'userName',
     'userPass',
     'socket',
     'channel',
     'connectStatus',
     'messages',
     'returnmessage'
   ])
  },
  watch:{
    returnmessage: {
      handler: function(newVal, oldVal){
        if (newVal!==oldVal){
          if(this.returnmessage.msg==="User added!"||this.returnmessage.msg==="password matches with database!"){
            console.log('success on watch!');
            console.log('value of this: ', this);
            console.log('value of this.username: ', this.username);
            console.log('value of this.password: ', this.password);
            this.userObjnamepass({username: this.username, password: this.password});
            if (this.returnmessage.profileImageURL!=null){
              if (this.returnmessage.profileImageURL.length>10){
                this.saveProfilePic({pic: this.returnmessage.profileImageURL})
              }
            }
            this.getUserObj({username: this.userName, password: this.userPass})
            this.username = '';
            this.password = '';
          }else{
            if (this.returnmessage.msg==="condition nil (record DNE)"){
              alert('Username does not exist!')
              this.username = '';
              this.password = '';
            }else if (this.returnmessage.msg==="password does not match database"){
              alert('Password incorrect!')
              this.username = '';
              this.password = '';
            }else if (this.returnmessage.msg==="username exists in database"){
              alert('Cannot add username ' + this.username + '; already exists in database!')
              this.username = '';
              this.password = '';
            }
          }
        }
      },
      deep: true
    },
    userName: {
      handler: function(newVal, oldVal){
        if (newVal!=oldVal){
          console.log('value of userName: ', newVal);
        }
      }
    },
    userPass: {
      handler: function(newVal, oldVal){
        if (newVal!=oldVal){
          console.log('value of userName: ', newVal);
        }
      }
    },
  },
  methods:{
    ...mapActions([
     'socketConnect',
     'channelPushLogin',
     'saveProfilePic',
     'getUserObj',
     'userObjnamepass',
     'testButtonAction'
    ]),
    connectSocket: function(){
      this.socketConnect({connectStatus: this.connectStatus})
    },
    socketPush: function(message){
      this.channelPushLogin({message: message, username: this.username, password: this.password})
    },
    signOut: function(){
      this.username = null;
      this.password = null;
      this.saveProfilePic({pic: null})
      this.userObjnamepass({username: this.username, password: this.password});
    },
    testButton: function(){
      this.testButtonAction()
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
