import axios from 'axios'

//this is dumb and overcomplicated. saved for reference so i can remember how dumb it is

export default {
  articleGET() {
    // console.log('inside articleGET in services');
    axios.get('http://localhost:4000/api/articles')
    .then(response=>{
      // console.log("response from api/articles: ", response);
      return response.data;
    })
    .catch(error=>{
      // console.log("PANIC ERROR IN api/articles : ", error);
    });
  },
};
