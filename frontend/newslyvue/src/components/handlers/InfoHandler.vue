<template>
  <div class="infohandler" v-bind:style="{ borderWidth: '5px', borderStyle: 'solid', borderColor: 'black', padding: '5px', margin: '5px', backgroundColor: 'rgb(200,200,200)'}">

    <div  v-if='isArticleorComment==="article"'>
      <h1>
        Article Title: {{articleTitle}}
      </h1>
    </div>
    <div  v-if='isArticleorComment==="article"'>
      <h2>
        Article URL: {{articleURL}}
      </h2>
    </div>


    <div  v-if='isArticleorComment==="comment"'>
      <h2>
        Comment Body
      </h2>
      <h3>
        {{body}}
      </h3>
      <!-- <h3>
        Comment {{comment}}
      </h3> -->
    </div>

    <div>
      <h3>
        Submitting User: {{submittingUser}}
      </h3>
    </div>
    <!-- leaving this here for now as its useful to see the article (for debugging/development) -->
    <!-- <div>
      Article: {{article}}
    </div> -->



    <div v-bind:style='{display: "flex", flexDirection:"flex-row", width: "100%"}'>
      <div v-bind:style='{flex: "3"}'/>
      <div v-bind:style='{flex: "1"}'>
        <h3>
          Upvotes: {{upvotes}}
        </h3>
        <div v-if='userName!==null && userPass!==null'>
          <button v-on:click="voteHandler('upvote')">
            Upvote!
          </button>
        </div>
      </div>
      <div v-bind:style='{flex: "1"}'>
        <h3>
          Downvotes: {{downvotes}}
        </h3>
        <div v-if='userName!==null && userPass!==null'>
          <button v-on:click="voteHandler('downvote')">
            Downvote
          </button>
        </div>
      </div>
      <div v-bind:style='{flex: "1"}'>
        <h3>
          Flagged Count: {{flaggedcount}}
        </h3>
        <div v-if='userName!==null && userPass!==null'>
          <button v-on:click="voteHandler('flagvote')">
            Downvote
          </button>
        </div>
      </div>
      <div v-bind:style='{flex: "3"}'/>
    </div>

    <div v-if='userName==null && userPass==null'>
      <h2>
        You are not allowed to vote unless you are logged in!
      </h2>
    </div>

  </div>
</template>

<script>
import { Socket } from 'phoenix';
import EventBus from '../../bus/EventBus';
import { mapGetters, mapActions } from 'vuex'
export default {
  name: 'InfoHandler',
  props: [
    "submittingUser",
    "articleTitle",
    "articleURL",
    "article",
    "body",
    "comment",
    "upvotes",
    "downvotes",
    "flaggedcount",
    "isArticleorComment",
    "comment",
  ],
  data () {
    return {
      localupvotes: null,
      localdownvotes: null,
      localflaggedcount: null,
    }
  },
  created(){
    this.localupvotes = this.upvotes===null?0:this.upvotes
    this.localdownvotes = this.downvotes===null?0:this.downvotes
    this.localflaggedcount = this.flaggedcount===null?0:this.flaggedcount
  },
  computed: {
   ...mapGetters([
     'userName',
     'userPass',
   ])
  },
  methods:{
    voteHandler: function(type){
      let payload;
      if (this.isArticleorComment==="article"){
        payload = {aOrc:"a", type: type, article: this.article}
      }
      if(this.isArticleorComment==="comment"){
        payload = {aOrc:"c", type: type, comment: this.comment}
      }
      EventBus.$emit("voted", payload)
      // if (type === "upvote"){
      //   this.localupvotes+=1
      // }
      // if (type === "downvote"){
      //   this.localdownvotes+=1
      // }
      // if (type === "flagvote"){
      //   this.localflaggedcount+=1
      // }
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
