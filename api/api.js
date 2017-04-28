const moment = require('moment');
const marked = require('marked');

const mock_users = require('../mock/users.json');
const mock_topics = require('../mock/topics.json');
const mock_posts = require('../mock/posts.json');
const mock_replies = require('../mock/replies.json');
const mock_messages = require('../mock/messages.json');

let users = mock_users.map(user => {

  let date = moment.unix(user.date_created);

  let login = moment.unix(user.last_login);

  return Object.assign({}, user, {date, login});

});

let replies = mock_replies.map(reply => {

  let user = users.find(user => user.user_id == reply.user_id);

  let date = moment.unix(reply.date_created);

  let text = marked(reply.text);

  return Object.assign({}, reply, {user, date, text});

});

let posts = mock_posts.map(post => {

  let post_replies = replies
    .filter(reply => reply.post_id == post.post_id)
    .sort((a, b) => b.date_created - a.date_created);

  let text = marked(post.text);

  let topic = mock_topics.find(topic => topic.topic_id == post.topic_id);

  let user = users.find(user => user.user_id == post.user_id);

  let date = moment.unix(post.date_created);

  return Object.assign({}, post, {replies: post_replies, text, topic, user, date});

});

let topics = mock_topics.map(topic => {

  let topic_posts = posts.filter(post => post.topic_id == topic.topic_id);

  let user = users.find(user => user.user_id == topic.user_id);

  let date = moment(topic.date_created, 'M/D/YYYY');

  return Object.assign({}, topic, {posts: topic_posts, user, date});

});

let messages = mock_messages.map(message => {

  let sender = users.find(user => user.user_id == message.sender_id);

  let recipient = users.find(user => user.user_id == message.recipient_id);

  let date = moment.unix(message.date_created);

  return Object.assign({}, message, {sender, recipient, date});

});


module.exports = {

  getUser(id) {

    return new Promise((resolve, reject) => {

      let user = users.find(({user_id}) => user_id == id);

      if (!user) reject('user not found');

      else resolve(user);

    });

  },

  getNewUsers(limit) {

    return new Promise((resolve, reject) => {

      let newUsers = users
        .sort((a, b) => b.date_created - a.date_created)
        .slice(0, limit);

      resolve(newUsers);

    });

  },

  getTopics() {

    return new Promise((resolve, reject) => {

      resolve(topics);

    });

  },

  getNewTopics(limit) {

    return new Promise((resolve, reject) => {

      let newTopics = topics
        .sort((a, b) => b.date_created - a.date_created)
        .slice(0, limit);

      resolve(newTopics);

    });

  },

  getTopic(id) {

    return new Promise((resolve, reject) => {

      let topic = topics.find(({topic_id}) => topic_id == id);

      if (!topic) reject('topic not found');

      else resolve(topic);

    });

  },

  getPost(topicId, postId) {

    return new Promise((resolve, reject) => {

      let topic = topics.find(({topic_id}) => topic_id == topicId);

      if (!topic) reject('topic not found');

      let post = posts.find(({post_id}) => post_id == postId);

      if (!post || post.topic_id != topic.topic_id) reject('post not found');

      else resolve(post);

    });

  },

  getNewPosts(limit) {

    return new Promise((resolve, reject) => {

      let newPosts = posts
        .sort((a, b) => b.date_created - a.date_created)
        .slice(0, limit);

      resolve(newPosts);

    });

  },

  getActivePosts(limit) {

    return new Promise((resolve, reject) => {

      let activePosts = posts
        .sort((a, b) => {

          let dateA = a.replies.length ? a.replies[0].date_created : 0;

          let dateB = b.replies.length ? b.replies[0].date_created : 0;

          return dateB - dateA;

        })
        .slice(0, limit);

      resolve(activePosts);

    });

  },

  getPostsByTopic(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(posts
        .filter(post => post.topic_id == id)
        .sort((a, b) => b.date_created - a.date_created)
        .slice(0, limit)
      );

    });

  },

  getTopicsByUser(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(topics
        .filter(topic => topic.user_id == id)
        .sort((a, b) => b.date_created - a.date_created)
        .slice(0, limit)
      );

    });

  },

  getPostsByUser(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(posts
        .filter(post => post.user_id == id)
        .sort((a, b) => b.date_created - a.date_created)
        .slice(0, limit)
      );

    });

  },

  getRepliesByUser(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(replies
        .filter(reply => reply.user_id == id)
        .sort((a, b) => b.date_created - a.date_created)
        .slice(0, limit)
      );

    });

  },

  getMessagesSentByUser(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(messages
        .filter(message => message.sender_id == id)
        .sort((a, b) => b.date_created - a.date_created)
        .slice(0, limit)
      );

    });

  },

  getMessagesReceivedByUser(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(messages
        .filter(message => message.recipient_id == id)
        .sort((a, b) => b.date_created - a.date_created)
        .slice(0, limit)
      );

    });

  }

}
