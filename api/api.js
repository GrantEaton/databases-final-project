const users = require('../mock/users.json');
const topics = require('../mock/topics.json');
const posts = require('../mock/posts.json');

function getTopics() {

  return new Promise((resolve, reject) => {

    resolve(topics);

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

module.exports = {getTopics, getNewestPostsByTopic};
