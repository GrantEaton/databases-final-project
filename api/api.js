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

function getPostsByTopic(id) {

  return new Promise((resolve, reject) => {

    let filtered = posts.filter(post => post.topic_id == id);

    resolve(filtered);

  });

}

function getNewestPostsByTopic(id, limit) {

  return new Promise((resolve, reject) => {

    let active = posts
      .filter(post => post.topic_id == id)
      .sort((a, b) => a.date_created - b.date_created)
      .slice(0, limit);

    resolve(active);

  });

}

module.exports = {getTopics, getTopic, getPostsByTopic, getNewestPostsByTopic};
