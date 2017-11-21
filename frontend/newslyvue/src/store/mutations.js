console.log('inside the mutations file');
import { Socket } from 'phoenix';
import isEmpty from 'lodash';

export const userObjnamepass = (state, {username, password}) => {
  // console.log('inside userObj in mutations');
  // console.log('value of username: ', username);
  // console.log('value of password: ', password);
  state.userPass = password;
  state.userName = username;
  if (username===null&&password===null){
    state.userObj = null
  }
}

export const socketConnect = (state) => {
  // console.log('inside socketConnect');
  state.connectStatus = true;
  state.socket = new Socket("ws://newslyproject2210.us-west-2.elasticbeanstalk.com:80/socket", {params: {token: window.userToken}})
  state.socket.connect()
    // .receive("ok", response => { console.log("Joined socket successfully", response) })
    // .receive("error", response => { console.log("Unable to join socket", response) })

  state.channel =  state.socket.channel("room:lobby", {});
  state.broadcastChannel = state.socket.channel("room:broadcast", {})

  state.channel.join()
    .receive("ok", response => { console.log("Joined channel successfully", response) })
    .receive("error", response => { console.log("Unable to join", response) })

  state.broadcastChannel.join()
    .receive("ok", response => { console.log("Joined broadcastChannel successfully", response) })
    .receive("error", response => { console.log("Unable to join", response) })


  state.channel.on("new_msg", payload => {
    payload.received_at = Date();
    state.messages.push(payload);
  });
  state.channel.on("signonreturn", payload => {
    state.returnmessage = payload;
  });
  state.channel.on("newarticlereturn", payload =>{
    state.newarticlereturn = payload
    if ("articletitle" in payload && "articleurl" in payload){
      state.broadcastChannel.push("broadcastArticles", {payload: state.newarticlereturn})
    }
  })

  state.channel.on("articleUpdateReturn", payload=>{
    state.broadcastChannel.push("broadcastArticleVote", {payload: payload})
  })

  state.broadcastChannel.on("broadcastArticleReturn", payload=>{
    console.log('inside state.broadcastChannel');
    state.articlesList.push({article: payload})
    console.log('value of articlesList: ', state.articlesList);
  })

  state.broadcastChannel.on("broadcastVoteReturn", updatedpayload=>{
    // console.log('inside state.broadcastChannel');
    // console.log('value of payload: ', payload);
    let count = 0
    let replaceindex = null
    // console.log('value of state.articlesList: ', state.articlesList);
    let newupvotes
    let newdownvotes
    let newflaggedcount
    state.articlesList.forEach(obj=>{
      if (obj.article.id === updatedpayload.payload.id){
        replaceindex = count
        newupvotes = updatedpayload.payload.upvotes
        newdownvotes = updatedpayload.payload.downvotes
        newflaggedcount = updatedpayload.payload.flaggedcount
      }
      count = count + 1
    })
    // console.log('value of replaceindex: ', replaceindex);
    let temparticles = state.articlesList;
    console.log('value of temparticles: ', temparticles);
    console.log('value of temparticles.article: ', temparticles.article);

    temparticles[replaceindex]["article"]["upvotes"] = newupvotes
    temparticles[replaceindex]["article"]["downvotes"] = newdownvotes
    temparticles[replaceindex]["article"]["flaggedcount"] = newflaggedcount

    // temparticles.splice(replaceindex, 1, {article: payload});
    state.articlesList = temparticles;

    if (updatedpayload.sanitizeduser.username==state.userName){
      state.userObj = updatedpayload.sanitizeduser
    }
    // state.articlesList.splice(replaceindex, 1, {article: payload})
  })
}

export const updateArticles = (state, {articlereturn}) => {
  // console.log('inside mutation updateArticles');
  // console.log('value of articlereturn: ', articlereturn);
  state.articlesList = articlereturn
  // console.log('value of state.articlesList: ', state.articlesList);
}

export const updateComments = (state, {comments}) => {
  comments.sort(function(a,b){
    return a.id - b.id
  })

  state.commentsList = comments
}

export const channelPushLogin = (state, {message, username, password}) => {
  // console.log('value of state.channel: ', state.channel);
  // console.log('value of message: ', message);
  state.channel.push(message, {username: username, password: password})
}

export const channelPushArticle = (state, { message, username, password, articletitle, articleurl } ) => {
  state.channel.push(message, {username: username, password: password, articletitle: articletitle, articleurl: articleurl})
}

export const channelPushArticleVote = (state, {type, article}) => {
  // console.log('value of state.channel: ', state.channel);
  let pushtype = "article" + type
  state.channel.push(pushtype, {article: article})
}

export const channelPushCommentVote = (state, {type, comment}) => {
  // console.log('value of state.channel: ', state.channel);
  let pushtype = "comment" + type
  console.log('inside channelPushCommentVote');
  console.log('inside channelPushCommentVote, pushtype: ', pushtype);
  state.commentChannel.push(pushtype, {comment: comment})
}

export const sendComment = (state, {articleid, message, user}) => {
  console.log('inside sendcomment');
  state.commentVoteChannel.push("addComment", {articleid, message, user})
}

export const saveProfilePic = (state, {pic})=>{
  state.userPic = pic
}

export const getUserObj = (state, {sanitizeduser}) => {
  state.userObj = sanitizeduser
}

export const handleCommentChannel = (state, {type, id})=>{
  console.log('inside handleCommentChannel');

  let channelroom = 'room:commentsForArticleID'+id
  state.commentChannel = state.socket.channel(channelroom, {})

  let channelvoteroom = 'room:commentVotesForArticleID'+id
  state.commentVoteChannel = state.socket.channel(channelvoteroom, {})

  if (type === "created"){
    state.commentChannel.join()
      .receive("ok", response => { console.log("Joined commentChannel successfully", response) })
      .receive("error", response => { console.log("Unable to join", response) })
    state.commentVoteChannel.join()
      .receive("ok", response => { console.log("Joined commentChannel successfully", response) })
      .receive("error", response => { console.log("Unable to join", response) })
  }else if (type === "destroyed"){
    // console.log('inside destroyed in handleCommentChannel in mutations');
    state.commentChannel.leave()
    state.commentsList = []
  }
  state.commentVoteChannel.on("broadcastCommentReturn", payload=>{
    console.log('inside broadcastCommentReturn in mutations and payload returned: ', payload);
    console.log('value of state.commentsList', state.commentsList);
    let temparray = state.commentsList
    console.log('value of temparray: ', temparray);

    temparray.push(payload)
    state.commentsList = temparray
    // state.commentsList.push(payload)
  })

  state.commentChannel.on("commentUpdateReturn", payload=>{
    console.log('inside commentUpdateReturn');
    state.broadcastChannel.push("broadcastCommentVote", {payload: payload})
  })
  // console.log('above state.commentChannel.on.commentUpdateReturn');
  // state.commentChannel.on("commentUpdateReturn", payload=>{
  //   console.log('inside commentUpdateReturn');
  // })
  // console.log('after state.commentChannel.on.commentUpdateReturn');

  state.broadcastChannel.on("broadcastCommentVote", updatedpayload=>{
    // console.log('inside broadcastCommentVote');
    let count = 0
    let commentCount = 0
    let replaceindex = null
    let replaceindexCount = null

    // console.log('value of state.commentslist.length: ', state.commentsList.length);

    if (state.commentsList.length>1){
      state.commentsList.forEach(obj=>{
        if (obj.id === updatedpayload.payload.id){
          replaceindex = count
          // console.log('inside if equality and value of replaceindex is ; ', replaceindex);
        }
        count = count + 1
        // console.log('count should be iterated : ', count);
      })
    }
    if (state.commentsList.length===1){
      replaceindex = 0
    }

    // console.log("*******");
    //
    // console.log('value of state.commentsList before inserting, ', state.commentsList);
    // console.log('value of replaceindex: ', replaceindex);
    let tempreplace = state.commentsList;
    tempreplace[replaceindex]["upvotes"] = updatedpayload.payload["upvotes"]
    tempreplace[replaceindex]["downvotes"] = updatedpayload.payload["downvotes"]
    tempreplace[replaceindex]["flaggedcount"] = updatedpayload.payload["flaggedcount"]
    console.log('value of state.commentsList before assign in broadcastCommentVote: ', state.commentsList);
    console.log('value of updatedpayload.payload: ', updatedpayload.payload);
    console.log('value of tempreplace after replaceindex in broadcastCommentVote: ', tempreplace);
    state.commentsList = tempreplace

    // console.log('&&&&&&&&inside comment vote return and value of state.commentsList is &&&&&&&&& ', state.commentsList);
    //
    // console.log("*******");

    if (updatedpayload.sanitizeduser.username==state.userName){
      state.userObj = updatedpayload.sanitizeduser
      // console.log('inside if userobj: ', state.userObj);
    }


    //unnecesssary to replace

    // console.log('value of state.articlesList: ', state.articlesList);
    // console.log('value of id: ', id);
    // state.articlesList.forEach(obj=>{
    //   if (count+1 === id){
    //     // console.log('value of obj.comments: ', obj.comments.length);
    //     replaceindex = count
    //     console.log('typeof(obj.comments): ', obj["comments"]);
    //     if (typeof(obj.comments) != "undefined"){
    //       if (typeof(obj.comments.length) != "undefined"){
    //         obj.comments.forEach(commentObj => {
    //           if (commentCount+1 === commentObj.id){
    //             console.log('found comment match');
    //             console.log('value of match: ', commentObj);
    //             replaceindexCount = commentCount
    //           }
    //           commentCount+=1
    //         })
    //       }else{
    //         replaceindex = 0
    //       }
    //     }else{
    //       replaceindex = 0
    //     }
    //     console.log('value of payload.id: ', payload.id);
    //   }
    //   count+=1
    // })
    // // console.log('value of replaceindex: ', replaceindex);
    // let tempreplace = state.articlesList;
    // console.log('value of tempreplace: ', state.articlesList);
    // let testcomments = tempreplace[replaceindex]
    // if (testcomments.comments != undefined){
    //   tempreplace[replaceindex]['comments'][replaceindexCount] = payload
    // }else{
    //   tempreplace[replaceindex] = {comments: payload}
    // }
    //
    // state.articlesList = tempreplace;



  })
}


//Retrieving individual comments is possible, but not necessary if comments are returned as part of the article list :D

// export const getArticleComments = (state, {type, id}) => {
//
// }
