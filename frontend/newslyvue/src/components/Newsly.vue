<template>
  <div class="newsly">

    <!-- <div v-if='userName!==null && userPass!==null'>
      <div v-if='userPic!=null'>
        <ImageHandler :imageURL='userPic'></ImageHandler>
      </div>
    </div> -->

    <div v-if='showComments!==true'>
      <div v-if='userName===null && userPass===null'>
        <div v-bind:style="{backgroundColor: 'rgb(200,200,200)'}">
          <h3>
            You must sign in to submit posts~
          </h3>
        </div>
      </div>
      <br/><br/>
      <div v-if='userName!==null && userPass!==null && popArticle === false'>
        <button v-on:click="popArticle=true">Submit New Article</button>
      </div>
      <div v-if='userName!==null && userPass!==null && popArticle !== false'>
        <div v-bind:style="{backgroundColor: 'rgb(160,160,160)', paddingTop:
        '2%', paddingBottom:'2%'}">
          <h3>
            Post Title:
          </h3>
          <input type="text" v-model="postTitle"/>
          <!-- later may just extract title element to autopopulate source title -->
          <h3>
            Post URL:
          </h3>
          <input type="text" v-model="postURL"/>
          <br/><br/>
          <button v-on:click="submitArticle()">Submit!</button>
        </div>
      </div>
    </div>

      <br/><br/>

    <div v-if='showComments!==true'>
      <div v-for="article in articlesList">
        <div>
          <InfoHandler
            :article="article"
            :submittingUser="article.article.user"
            :articleTitle="article.article.articletitle"
            :articleURL="article.article.articleurl"
            :upvotes="article.article.upvotes"
            :downvotes="article.article.downvotes"
            :flaggedcount="article.article.flaggedcount"
            isArticleorComment="article"
          ></InfoHandler>
          <br/>
          <div>
            <button v-on:click="commentsGo(article)">Go to the Comments Section!</button>
          </div>
        </div>
        <br/><br/>
        <br/><br/>
      </div>
    </div>

    <br/><br/>
    <div v-if='showComments===true'>
      <Comments
        :commentArticle="commentArticle"
        :articlesList="articlesList"
        :userName="userName"
        :userPass="userPass"
        :handleCommentChannel="handleCommentChannel"
        :commentsList="commentsList"
        :articleUpvotes="articleUpvotes"
        :articleDownvotes="articleDownvotes"
        :articleFlaggedCount="articleFlaggedCount">
      </Comments>
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
  name: 'Newsly',
  data () {
    return {
      msg: 'placeholder',
      postURL: null,
      postTitle: null,
      popArticle: false,
      message: '',
      showComments: false,
      commentArticle: null,
      passedArticle: null,
      articleUpvotes: null,
      articleDownvotes: null,
      articleFlaggedCount: null,
      commentMessageWait: false,
      tempComment: null
      // cleanedArticleslist: null,
    }
  },
  components: {Comments, InfoHandler, ImageHandler},
  computed: {
   ...mapGetters([
     'userName',
     'userPass',
     'userPic',
     'userObj',
     'userVotes',
     'socket',
     'channel',
     'connectStatus',
     'messages',
     'returnmessage',
     'articlesList',
     'commentsList',
   ])
  },
  created(){
    this.connectSocket();
    // console.log('inside created in Newsly.vue');
    this.getArticles({})
    var self = this;
    EventBus.$on('goBack', (value)=>{
      // console.log('value from child component: ', value);
      // console.log('value of this.showComments; ', this.showComments);
      console.log('value of article :', self.article);
      this.showComments = false;
      // console.log('value of this.showComments; ', this.showComments);
    })
    this.$on('commentMessage', (payload)=>{ //note there is something funky going
      //on here - essentially when I use the EventBus on this command the bus
      //gets emmitted to once and it listens $on twice, and throwing in timeouts
      //doesnt work - bad voodoo
      this.sendComment(payload)
    })
    EventBus.$on('voted', (payload)=>{
      // console.log('inside voted and value of payload; ', payload);
      if (payload.aOrc==="a"){
        console.log('value of payload in newsly voted: ', payload);
        this.voteButtonA(payload.type, payload.article)
      }else if (payload.aOrc==="c"){
        this.voteButtonC(payload.type, payload)
      }
    })
  },
  destroyed(){
    EventBus.$off()
    this.$off()
  },
  // watch: {
  //   articlesList: {
  //     handler: function(newVal, oldVal){
  //       console.log('inside articlesList watcher');
  //       console.log('value of newVal: ', newVal);
  //       console.log('value of oldVal: ', oldVal);
  //
  //       // this.cleanedArticleslist = oldVal
  //     }
  //   }
  // },
  methods:{
    ...mapActions([
     'socketConnect',
     'channelPushArticle',
     'getArticles',
     'articleVote',
     'commentVote',
     'sendComment',
     'handleCommentChannel',
     'getArticleComments',
     'getUserObj'
    ]),
    commentsGo: function(article){
      console.log('inside commentsGo, watchid: ', this.watchid);
      this.showComments = true
      this.commentArticle = article
      this.getArticleComments({id: article.article.id})
      this.articleUpvotes = article.article.upvotes
      this.articleDownvotes = article.article.downvotes
      this.articleFlaggedCount = article.article.flaggedcount
      // vm.$forceUpdate();
    },
    connectSocket: function(){
      //need to check whether socket was already connected and only connect if it was not. Consider throwing this inside the vuex controller.
      // console.log('inside socketConnect');
      this.socketConnect({connectStatus: this.connectStatus})
    },
    submitArticle: function(){
      if (this.postURL === null)
      {
        alert("Post URL cannot be blank!")
      }
      if (this.postTitle === null)
      {
        alert("Post Title cannot be blank!")
      }
      if (this.postURL!==null && this.postTitle!==null){
        console.log('inside submitArticle and: ');
        console.log('value of username: ', this.userName);
        this.channelPushArticle({message: 'newArticle', username: this.userName, password: this.userPass, articletitle: this.postTitle, articleurl: this.postURL})
        this.postURL = null;
        this.postTitle = null;
        this.popArticle = false;
      }
    },
    voteButtonA: function(type, article){
      this.articleVote({type: type, article: article.article})
    },
    voteButtonC: function(type, comment){
      console.log('inside voteButtonC');
      this.commentVote({type: type, comment: comment})
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
