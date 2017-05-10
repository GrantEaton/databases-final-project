const moment = require('moment');
const marked = require('marked');
const sql = require('mssql');
const config = require('./config');

let pool = new sql.ConnectionPool(config.connection);
pool.connect(console.log);

function mapUser(record) {

  return {
    id: record.UserID,
    username: record.Username,
    email: record.EmailAddress,
    bio: {md: marked(record.Biography), raw: record.Biography},
    date: moment(record.DateCreated)
  }

}

function mapTopic(record) {

  return {
    id: record.TopicID,
    name: record.Name,
    description: {md: marked(record.Description), raw: record.Description},
    date: moment(record.DateCreated),
    user: {
      id: record.UserID,
      username: record.Username
    }
  }

}

function mapPost(record) {

  return {
    id: record.PostID,
    title: record.Title,
    text: {md: marked(record.Text), raw: record.Text},
    date: moment(record.DateCreated),
    replies: record.ReplyCount,
    stickied: record.Stickied,
    topic: {
      id: record.TopicID,
      name: record.Name
    },
    user: {
      id: record.UserID,
      username: record.Username
    }
  }

}

function mapReply(record) {

  return {
    id: record.ReplyID,
    text: record.Text,
    date: moment(record.DateCreated),
    post: {
      id: record.PostID,
    },
    user: {
      id: record.UserID,
      username: record.Username
    }
  }

}

function mapMessage(record) {

  return {
    id: record.MessageID,
    subject: record.Subject,
    text: record.Text,
    date: moment(record.DateCreated),
    sender: {
      id: record.SenderID,
      username: record.SenderUsername
    },
    recipient: {
      id: record.RecipientID,
      username: record.RecipientUsername
    }
  }

}

function logResult(proc) {
  return function(result) {
    console.log(proc, result);
    return result;
  }
}

module.exports = {

  getUsers() {

    return pool.request()
      .execute('spGetUsers')
      .then(logResult('getUsers'))
      .then(result => result.recordset.map(mapUser))

  },

  getUser(id) {

    return pool.request()
      .input('userId', sql.Int, id)
      .execute('spGetUserById')
      .then(logResult('getUser'))
      .then(result => mapUser(result.recordset[0]))

  },

  getNewUsers(limit) {

    return pool.request()
      .input('limit', sql.Int, limit)
      .execute('spGetNewUsers')
      .then(logResult('getNewUsers'))
      .then(result => result.recordset.map(mapUser))

  },

  getTopics() {

    return pool.request()
      .execute('spGetTopics')
      .then(logResult('getTopics'))
      .then(result => result.recordset.map(mapTopic))

  },

  getTopic(id) {

    return pool.request()
      .input('topicId', sql.Int, id)
      .execute('spGetTopicById')
      .then(logResult('getTopic'))
      .then(result => mapTopic(result.recordset[0]))

  },

  getNewTopics(limit) {

    return pool.request()
      .input('limit', sql.Int, limit)
      .execute('spGetNewTopics')
      .then(logResult('getNewTopics'))
      .then(result => result.recordset.map(mapTopic))

  },

  getTopicsByUser(id, limit) {

    return pool.request()
      .input('userId', sql.Int, id)
      .input('limit', sql.Int, limit)
      .execute('spGetTopicsByUser')
      .then(logResult('getTopicsByUser'))
      .then(result => result.recordset.map(mapTopic))

  },

  getTopicByName(name) {

    return pool.request()
      .input('name', sql.NVarChar, name)
      .execute('spGetTopicByName')
      .then(logResult('getTopicByName'))
      .then(result => mapTopic(result.recordset[0]))

  },

  getPost(id) {

    return pool.request()
      .input('postId', sql.Int, id)
      .execute('spGetPostById')
      .then(logResult('getPost'))
      .then(result => mapPost(result.recordset[0]))

  },

  getNewPosts(limit) {

    return pool.request()
      .input('limit', sql.Int, limit)
      .execute('spGetNewPosts')
      .then(logResult('getNewPosts'))
      .then(result => result.recordset.map(mapPost))

  },

  getActivePosts(limit) {

    return pool.request()
      .input('limit', sql.Int, limit)
      .execute('spGetActivePosts')
      .then(logResult('getActivePosts'))
      .then(result => result.recordset.map(mapPost))

  },

  getPostsByTopic(id, limit) {

    return pool.request()
      .input('topicId', sql.Int, id)
      .input('limit', sql.Int, limit)
      .execute('spGetPostsByTopic')
      .then(logResult('getPostsByTopic'))
      .then(result => result.recordset.map(mapPost))

  },

  getStickiedPostsByTopic(id, limit) {

    return pool.request()
      .input('topicId', sql.Int, id)
      .input('limit', sql.Int, limit)
      .execute('spGetStickiedPostsByTopic')
      .then(logResult('getStickiedPostsByTopic'))
      .then(result => result.recordset.map(mapPost))

  },

  getPostsByUser(id, limit) {

    return pool.request()
      .input('userId', sql.Int, id)
      .input('limit', sql.Int, limit)
      .execute('spGetPostsByUser')
      .then(logResult('getPostsByUser'))
      .then(result => result.recordset.map(mapPost))

  },

  getRepliesByPost(id, limit) {

    return pool.request()
      .input('postId', sql.Int, id)
      .input('limit', sql.Int, limit)
      .execute('spGetRepliesByPost')
      .then(logResult('getRepliesByPost'))
      .then(result => result.recordset.map(mapReply))

  },

  getRepliesByUser(id, limit) {

    return pool.request()
      .input('userId', sql.Int, id)
      .input('limit', sql.Int, limit)
      .execute('spGetRepliesByUser')
      .then(logResult('getRepliesByUser'))
      .then(result => result.recordset.map(mapReply))

  },

  getMessagesSentByUser(id, limit) {

    return pool.request()
      .input('userId', sql.Int, id)
      .input('limit', sql.Int, limit)
      .execute('spGetMessagesSentByUser')
      .then(logResult('getMessagesSentByUser'))
      .then(result => result.recordset.map(mapMessage))

  },

  getMessagesReceivedByUser(id, limit) {

    return pool.request()
      .input('userId', sql.Int, id)
      .input('limit', sql.Int, limit)
      .execute('spGetMessagesReceivedByUser')
      .then(logResult('getMessagesReceivedByUser'))
      .then(result => result.recordset.map(mapMessage))

  },

  getMessagesDeletedByUser(id, limit) {

    return pool.request()
      .input('userId', sql.Int, id)
      .input('limit', sql.Int, limit)
      .execute('spGetMessagesDeletedByUser')
      .then(logResult('getMessagesDeletedByUser'))
      .then(result => result.recordset.map(mapMessage))

  },

  getMessagesArchivedByUser(id, limit) {

    return pool.request()
      .input('userId', sql.Int, id)
      .input('limit', sql.Int, limit)
      .execute('spGetMessagesDeletedByUser')
      .then(logResult('getMessagesArchivedByUser'))
      .then(result => result.recordset.map(mapMessage))

  },

  createUser({username, email, password}) {

    return pool.request()
      .input('Username', sql.NVarChar, username)
      .input('EmailAddress', sql.NVarChar, email)
      .input('Password', sql.NVarChar, password)
      .execute('spCreateUser')
      .then(logResult('createUser'))
      .then(result => mapUser(result.recordset[0]))

  },

  createTopic({user, name, description}) {

    return pool.request()
      .input('UserID', sql.Int, user)
      .input('Name', sql.NVarChar, name)
      .input('Description', sql.NVarChar, description)
      .execute('spCreateTopic')
      .then(logResult('createTopic'))
      .then(result => mapTopic(result.recordset[0]))

  },

  createPost({user, topic, title, text}) {

    return pool.request()
      .input('UserID', sql.Int, user)
      .input('TopicID', sql.Int, topic)
      .input('Title', sql.NVarChar, title)
      .input('Text', sql.NVarChar, text)
      .execute('spCreatePost')
      .then(logResult('createPost'))
      .then(result => mapPost(result.recordset[0]))

  },

  createReply({user, post, text}) {

    return pool.request()
      .input('UserID', sql.Int, user)
      .input('PostID', sql.Int, post)
      .input('Text', sql.NVarChar, text)
      .execute('spCreateReply')
      .then(logResult('createReply'))
      .then(result => mapReply(result.recordset[0]))

  },

  createMessage({user, recipient, subject, text}) {

    return pool.request()
      .input('SenderID', sql.Int, user)
      .input('RecipientID', sql.Int, recipient)
      .input('Subject', sql.NVarChar, subject)
      .input('Text', sql.NVarChar, text)
      .execute('spCreateMessage')
      .then(logResult('createMessage'))
      .then(result => mapReply(result.recordset[0]))

  },

  createLoginAttempt({username, password}) {

    return pool.request()
      .input('username', sql.NVarChar, username)
      .input('password', sql.NVarChar, password)
      .execute('spCreateLoginAttempt')
      .then(logResult('createLoginAttempt'))
      .then(result => mapUser(result.recordset[0]))

  },

  updateUser({user, username, email, biography}) {

    return pool.request()
      .input('userId', sql.Int, user)
      .input('username', sql.NVarChar, username)
      .input('emailAddress', sql.NVarChar, email)
      .input('biography', sql.NVarChar, biography)
      .execute('spUpdateUser')
      .then(logResult('updateUser'))
      .then(result => mapUser(result.recordset[0]))

  },

  updateUserPassword({user, oldpassword, newpassword}) {

    return pool.request()
      .input('userId', sql.Int, user)
      .input('oldPassword', sql.NVarChar, oldpassword)
      .input('newPassword', sql.NVarChar, newpassword)
      .execute('spUpdateUserPassword')
      .then(logResult('updateUserPassword'))
      .then(result => result.returnValue == 1)

  },

  updateTopic({topic, name, description}) {

    return pool.request()
      .input('topicId', sql.Int, topic)
      .input('name', sql.NVarChar, name)
      .input('description', sql.NVarChar, description)
      .execute('spUpdateTopic')
      .then(logResult('updateTopic'))
      .then(result => mapTopic(result.recordset[0]))

  },

  updatePost({post, topic, title, text, stickied}) {

    return pool.request()
      .input('postId', sql.Int, post)
      .input('topicId', sql.Int, topic)
      .input('title', sql.NVarChar, title)
      .input('text', sql.NVarChar, text)
      .input('stickied', sql.Bit, stickied)
      .execute('spUpdatePost')
      .then(logResult('updatePost'))
      .then(result => mapPost(result.recordset[0]))

  },

  deleteUser(id) {

    return pool.request()
      .input('userId', sql.Int, id)
      .execute('spDeleteUser')
      .then(logResult('deleteUser'))
      .then(result => result.returnValue == 1)

  },

  deleteTopic(id) {

    return pool.request()
      .input('topicId', sql.Int, id)
      .execute('spDeleteTopic')
      .then(logResult('deleteTopic'))
      .then(result => result.returnValue == 1)

  },

  deletePost(id) {

    return pool.request()
      .input('postId', sql.Int, id)
      .execute('spDeletePost')
      .then(logResult('deletePost'))
      .then(result => result.returnValue == 1)

  },

  deleteReply(id) {

    return pool.request()
      .input('replyId', sql.Int, id)
      .execute('spDeleteReply')
      .then(logResult('deleteReply'))
      .then(result => result.returnValue == 1)

  },

  deleteMessage(id) {

    return pool.request()
      .input('messageId', sql.Int, id)
      .execute('spDeleteMessage')
      .then(logResult('deleteMessage'))
      .then(result => result.returnValue == 1)

  },

}
