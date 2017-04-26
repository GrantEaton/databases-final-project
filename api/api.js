const moment = require('moment');

const users = require('../mock/users.json');
const topics = require('../mock/topics.json');
const posts = require('../mock/posts.json');

function getTopics() {

  return new Promise((resolve, reject) => {

    resolve(topics);

  });

}

function getTopic(id) {

  return new Promise((resolve, reject) => {

    let topic = topics.find(({topic_id}) => topic_id == id);

    if (!topic) reject('topic not found');

    else resolve(topic);

  });

}

function getPost(topicId, postId) {

  return new Promise((resolve, reject) => {

    let topic = topics.find(({topic_id}) => topic_id == topicId);

    if (!topic) reject('topic not found');

    let post = posts.find(({post_id}) => post_id == postId);

    if (!post || post.topic_id != topic.topic_id) {

      reject('post not found');

    }

    else {

      post = Object.assign({}, post, {date_created: moment.unix(post.date_created)});

      resolve({topic, post});

    }

  });

}

function getActivePosts(limit) {

  return new Promise((resolve, reject) => {

    resolve(posts
      .sort((a, b) => b.date_created - a.date_created)
      .slice(0, limit)
      .map(post => Object.assign({}, post, {date_created: moment.unix(post.date_created)}))
    );

  });

}

function getPostsByTopic(id, limit) {

  return new Promise((resolve, reject) => {

    resolve(posts
      .filter(post => post.topic_id == id)
      .sort((a, b) => b.date_created - a.date_created)
      .slice(0, limit)
      .map(post => Object.assign({}, post, {date_created: moment.unix(post.date_created)}))
    );

  });

}

module.exports = {getTopics, getTopic, getPost, getActivePosts, getPostsByTopic};
