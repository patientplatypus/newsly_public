// console.log('inside the actions file');


import axios from 'axios'

import services from '../services/index'
import store from './index'

// export const increment = ({ commit }) => commit('increment')
// export const decrement = ({ commit }) => commit('decrement')

export const userObjnamepass = ({ commit }, {username, password}) => {
  // console.log('inside saveString in the actions file');
  // console.log('value of e.target.value is ', e.target.value);
  // console.log('inside actions');
  // console.log('value of username, ', username);
  // console.log('value of password, ', password);

  commit('userObjnamepass',{username, password})
}


export const socketConnect = ({ commit }, {connectStatus}) => {
  // console.log('inside socketConnect actions');
  if (connectStatus === false){
    // console.log('inside socketConnect actions if statement');
    commit('socketConnect')
  }

}

export const testButtonAction = ({ commit }) => {
  console.log('inside testButtonAction in actions');
  axios.get('http://newslyproject2210.us-west-2.elasticbeanstalk.com:80/api/articles')
  .then(response=>{
    console.log("response from api/articles: ", response);
    // commit('updateArticles', {articlereturn: response.data})
  })
  .catch(error=>{
    console.log("PANIC ERROR IN api/articles : ", error);
  });
}

export const channelPushLogin = ({ commit }, {message, username, password}) => {
  commit('channelPushLogin', {message, username, password})
}

export const channelPushArticle = ({ commit }, { message, username, password, articletitle, articleurl}) => {
  commit('channelPushArticle', { message, username, password, articletitle, articleurl })
}

export const getArticles = ({ commit }) => {
  // console.log('inside getArticles in actions');

  axios.get('http://newslyproject2210.us-west-2.elasticbeanstalk.com:80/api/articles')
  .then(response=>{
    // console.log("response from api/articles: ", response);
    commit('updateArticles', {articlereturn: response.data})
  })
  .catch(error=>{
    // console.log("PANIC ERROR IN api/articles : ", error);
  });
}

export const articleVote = ({ commit }, {type, article}) => {
  // console.log('inside articleVote in actions');
  commit('channelPushArticleVote', {type, article})
}

export const commentVote = ({ commit }, {type, comment}) => {
  // console.log('inside articleVote in actions');
  console.log('inside commentVote');
  console.log('value of comment: ', comment);
  commit('channelPushCommentVote', {type, comment})
}


export const sendComment = ({ commit }, {articleid, message, user}) => {
  // console.log('inside sendComment in actions');
  commit('sendComment', {articleid, message, user})
}

export const handleCommentChannel = ({ commit }, {type, id})=>{
  // console.log('inside handleCommentChannel in actions');
  commit('handleCommentChannel', {type, id})
}

export const saveProfilePic = ({ commit }, {pic}) => {
  commit('saveProfilePic', {pic})
}

export const getUserObj = ({ commit }, { username, password }) => {

  console.log('value of username: ', username);
  console.log('value of password: ', password);

  axios.get('http://newslyproject2210.us-west-2.elasticbeanstalk.com:80/api/user', {
    params: {
      username: username,
      password: password
    }
  })
  .then(response=>{
    console.log("response from getUserObj: ", response);
    let sanitizeduser = {
      userupvotes: response.data.userupvotes,
      userdownvotes: response.data.userdownvotes,
      userflaggedcount: response.data.userflaggedcount,
      username: response.data.username
    }
    // commit('getUserObj', {})
    commit('getUserObj', {sanitizeduser: sanitizeduser})
  })
  .catch(error=>{
    console.log("PANIC ERROR IN getUserObj: ", error);
  });

}

export const getArticleComments = ({ commit }, {id}) => {
  axios.get('http://newslyproject2210.us-west-2.elasticbeanstalk.com:80/api/articles/'+id)
  .then(response=>{
    console.log("response from api/articles/id: ", response);
    commit('updateComments', {comments: response.data.comments})
  })
  .catch(error=>{
    console.log("PANIC ERROR IN api/articles : ", error);
  });
}
