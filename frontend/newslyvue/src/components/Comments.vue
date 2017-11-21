<template>
  <div class="comments">
    <h1>Comments Section</h1>
    <InfoHandler
      :article="commentArticle"
      :submittingUser="fullArticle.user"
      :articleTitle="fullArticle.articletitle"
      :articleURL="fullArticle.articleurl"
      :upvotes="fullArticle.upvotes"
      :downvotes="fullArticle.downvotes"
      :flaggedcount="fullArticle.flaggedcount"
      isArticleorComment="article"
    ></InfoHandler>

    <br/><br/>


    <div  v-bind:style='{width: "85%", backgroundColor: "rgb(180,180,180)", height: "20%", paddingLeft: "7.5%", paddingRight: "7.5%", paddingTop: "2%", paddingBottom: "2%"}'>
      <div v-if='userName!==null && userPass!==null'>
        <textarea rows="4" cols="50" v-model="message"  v-bind:style='{width: "100%", fontSize: "3vh"}'></textarea>
        <br/><br/>
        <button v-on:click="submitMsg()">Submit Comment</button>
        <button v-on:click="goBack()">Back to Article List</button>
      </div>
      <div v-if='userName===null && userPass===null'>
        <p>
          You must sign in to submit comments~
        </p>
        <br/>
        <button v-on:click="goBack()">Back to Article List</button>
      </div>
    </div>


    <div>
      <h1>
        Here are the comments:
      </h1>
        <div v-for="comment in fullCommentsList">
          <!-- {{comment}} -->
          <!-- { "user": "adsfasdfasdf", "upvotes": null, "flaggedcount": null, "downvotes": null, "body": "asdfasdf", "article_id": 4 } -->
          <InfoHandler
            :comment="comment"
            :submittingUser="comment.user"
            :commentID="comment.id"
            :body="comment.body"
            :articleid="comment.article_id"
            :upvotes="comment.upvotes"
            :downvotes="comment.downvotes"
            :flaggedcount="comment.flaggedcount"
            isArticleorComment="comment"
          ></InfoHandler>

        </div>
    </div>

  </div>
</template>

<script>
import { Socket } from 'phoenix';
import axios from 'axios';
import { mapGetters, mapActions } from 'vuex'
import InfoHandler from './handlers/InfoHandler'
import EventBus from '../bus/EventBus';
export default {
  name: 'Comments',
  props: [
    "commentArticle",
    "userPass",
    "userName",
    "handleCommentChannel",
    "commentsList",
    "articlesList",
    "articleUpvotes",
    "articleDownvotes",
    "articleFlaggedCount"
  ],
  components: {InfoHandler},
  data () {
    return {
      msg: 'placeholder',
      message: '',
      postURL: null,
      postTitle: null,
      popArticle: false,
      message: '',
      fullCommentsList: [],
      fullArticlesList: []
    }
  },
  created(){
    let payload = {type: "created", id: this.commentArticle.article.id}
    this.handleCommentChannel(payload)
    this.upvotes = this.articleUpvotes
    this.downvotes = this.articleDownvotes
    this.flaggedcount = this.articleFlaggedCount
    this.fullCommentsList = this.commentArticle.comments||[]
    this.fullArticle = this.commentArticle.article || null
    console.log('inside created and value of this.fullCommentsList - ', this.fullCommentsList);
  },
  destroyed(){
    let payload = {type: "destroyed", id: this.commentArticle.article.id}
    this.handleCommentChannel(payload)
  },
  watch: {
    commentArticle: {
      handler: function(newVal, oldVal){
        console.log('value of ');
        this.fullArticle = newVal.article
      }
    },
    commentsList: {
      handler: function (newVal, oldVal) {
        console.log('inside commentsList watcher');
        // console.log('value of this.fullCommentsList: ', this.fullCommentsList);
        // console.log('value of newVal: ', newVal);
        // console.log('value of this.fullCommentsList.length; ', this.fullCommentsList.length);
        // console.log('value of newVal.length: ', newVal.length);
        if (newVal.length>this.fullCommentsList.length){
          console.log('in first if');
          this.fullCommentsList.push(newVal[newVal.length-1])
        }else {
          let idsaved;
          let newupvotes;
          let newdownvotes;
          let newflaggedcount;
          console.log('in first else');
          if (newVal.length>1){
            console.log('in second if');
            this.fullCommentsList.forEach(comment=>{
              newVal.forEach(val=>{
                if (val.id === comment.id){
                  newupvotes = val.upvotes
                  newdownvotes = val.downvotes
                  newflaggedcount = val.flaggedcount
                  idsaved = val.id
                }
              })
            })
          }else{
            console.log('in second else');
            this.fullCommentsList.forEach(comment=>{
              if (newVal.id === comment.id){
                newupvotes = newVal.upvotes
                newdownvotes = newVal.downvotes
                newflaggedcount = newVal.flaggedcount
                idsaved = newVal.id
              }
            })
          }

          for(var x = 0; x<this.fullCommentsList.length; x++){
            if (this.fullCommentsList[x]["id"]===idsaved){
              this.fullCommentsList[x]["upvotes"] = newupvotes
              this.fullCommentsList[x]["downvotes"] = newdownvotes
              this.fullCommentsList[x]["flaggedcount"] = newflaggedcount
            }
          }
          console.log('value of this.fullCommentsList after: ', this.fullCommentsList);
          // this.$forceUpdate()
        }
      },
      deep: true
    },
    // articlesList: {
    //   handler: function(newVal, oldVal){
    //     articlesList.comments.forEach(comment=>{
    //       if comment.id ===
    //     })
    //   }
    // }
  },
  methods:{
    goBack: function(){
      EventBus.$emit("goBack", "back from comments")
    },
    submitMsg: function(){
      let payload = {articleid: this.commentArticle.article.id, message: this.message, user: this.userName}
      console.log('inside submitMsg in Comments');
      this.$parent.$emit("commentMessage", payload)
    },
  }
}
</script>
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
