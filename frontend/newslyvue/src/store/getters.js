console.log('inside the getters file');

export const userName = state => state.userName;
export const userPass = state => state.userPass;
export const userPic = state => state.userPic;

export const userObj = state => state.userObj;

export const socket = state => state.socket;
export const channel = state => state.channel;
export const connectStatus = state => state.connectStatus;

export const messages = state => state.messages;
export const returnmessage = state => state.returnmessage;

export const articlesList = state => state.articlesList;
export const commentsList = state => state.commentsList;
