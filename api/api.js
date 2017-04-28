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

let topics = mock_topics.map(topic => {

  let user = users.find(user => user.user_id == topic.user_id);

  let date = moment(topic.date_created, 'M/D/YYYY');

  return Object.assign({}, topic, {user, date});

});

let posts = mock_posts.map(post => {

  let topic = topics.find(topic => topic.topic_id == post.topic_id);

  let user = users.find(user => user.user_id == post.user_id);

  let date = moment.unix(post.date_created);

  return Object.assign({}, post, {topic, user, date});

});

let replies = mock_replies.map(reply => {

  let post = posts.find(post => post.post_id == reply.post_id);

  let user = users.find(user => user.user_id == reply.user_id);

  let date = moment.unix(reply.date_created);

  return Object.assign({}, reply, {user, date});

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
        .sort((a, b) => b.date - a.date)
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
        .sort((a, b) => b.date - a.date)
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

      let post = posts.find(({post_id}) => post_id == postId);

      if (!post || post.topic_id != topicId) reject('post not found');

      else resolve(Object.assign({}, post, {replies:

        replies.filter(reply => reply.post_id == post.post_id)
          .sort((a, b) => b.date - a.date)

      }));

    });

  },

  getNewPosts(limit) {

    return new Promise((resolve, reject) => {

      let newPosts = posts
        .sort((a, b) => b.date - a.date)
        .slice(0, limit);

      resolve(newPosts);

    });

  },

  getActivePosts(limit) {

    return new Promise((resolve, reject) => {

      let activePosts = posts
        .map(post =>

          Object.assign({}, post, {replies:

            replies.filter(reply => reply.post_id == post.post_id)
              .sort((a, b) => b.date - a.date)

          })

        )
        .sort((a, b) => {

          let dateA = a.replies.length ? a.replies[0].date_created : 0;

          let dateB = b.replies.length ? b.replies[0].date_created : 0;

          return dateB - dateA;

        })
        .slice(0, limit);

      resolve(activePosts);

    });

  },

  getNewestPostsByTopic(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(posts
        .filter(post => post.topic_id == id)
        .map(post =>

          Object.assign({}, post, {replies:

            replies.filter(reply => reply.post_id == post.post_id)
              .sort((a, b) => b.date - a.date)

          })

        )
        .sort((a, b) => b.date - a.date)
        .slice(0, limit)
      );

    });

  },

  getPostsByTopic(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(posts
        .filter(post => post.topic_id == id)
        .sort((a, b) => b.date - a.date)
        .slice(0, limit)
      );

    });

  },

  getTopicsByUser(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(topics
        .filter(topic => topic.user_id == id)
        .sort((a, b) => b.date - a.date)
        .slice(0, limit)
      );

    });

  },

  getPostsByUser(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(posts
        .filter(post => post.user_id == id)
        .map(post =>

          Object.assign({}, post, {replies:

            replies.filter(reply => reply.post_id == post.post_id)
              .sort((a, b) => b.date - a.date)

          })

        )
        .sort((a, b) => b.date - a.date)
        .slice(0, limit)
      );

    });

  },

  getRepliesByPost(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(replies
        .filter(reply => reply.post_id == id)
        .sort((a, b) => b.date - a.date)
        .slice(0, limit)
      );

    });

  },

  getRepliesByUser(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(replies
        .filter(reply => reply.user_id == id)
        .sort((a, b) => b.date - a.date)
        .slice(0, limit)
      );

    });

  },

  getMessagesSentByUser(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(messages
        .filter(message => message.sender_id == id)
        .sort((a, b) => b.date - a.date)
        .slice(0, limit)
      );

    });

  },

  getMessagesReceivedByUser(id, limit) {

    return new Promise((resolve, reject) => {

      resolve(messages
        .filter(message => message.recipient_id == id)
        .sort((a, b) => b.date - a.date)
        .slice(0, limit)
      );

    });

  },

  createTopic({name, description, user_id}) {

    return new Promise((resolve, reject) => {

      let user = users.find(user => user.user_id == user_id);

      let topic_id = topics.length+1;

      let topic = {topic_id, name, description, user, date: moment()};

      topics.push(topic);

      resolve(topic);

    });

  },

  createPost({topic: topicName, title, text, user_id}) {

    return new Promise((resolve, reject) => {

      let topic = topics.find(topic => topicName.toLowerCase() == topic.name.toLowerCase());

      if (!topic) reject('topic not found');

      let user = users.find(user => user.user_id == user_id);

      let post_id = posts.length+1;

      let topic_id = topic.topic_id;

      let post = {post_id, topic_id, title, text, topic, user, date: moment()};

      posts.push(post);

      resolve(post);

    });

  },

  createReply({post_id, user_id, text}) {

    return new Promise((resolve, reject) => {

      let post = posts.find(post => post.post_id == post_id);

      let user = users.find(user => user.user_id == user_id);

      let reply_id = replies.length+1;

      let reply = {reply_id, post_id, text, post, user, date: moment()};

      replies.push(reply);

      resolve(reply);

    });

  },

  createMessage({to, subject, text, user_id}) {

    return new Promise((resolve, reject) => {

      let sender = users.find(user => user.user_id == user_id);

      let recipient = users.find(user => user.username.toLowerCase() == to.toLowerCase());

      if (!recipient) reject('user not found');

      let message_id = messages.length+1;

      let message = {message_id, sender_id: user_id, recipient_id: recipient.user_id, subject, text, sender, recipient, date: moment()};

      messages.push(message);

      resolve(message);

    });

  }

}
