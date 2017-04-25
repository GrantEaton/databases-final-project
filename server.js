const path = require('path');
const express = require('express');

const api = require('./api/api');

let app = express();

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));

app.get('/', (req, res) => {

  api.getTopics().then(topics => {

    Promise.all(topics.map(topic => api.getNewestPostsByTopic(topic.topic_id, 3)))
      .then(posts => {

        for (let i in topics) {

          topics[i].posts = posts[i];

        }

        res.render('home', {topics});

      });

  });

});

app.get('/topic/:topic', (req, res) => {

  let id = req.params.topic;

  let payload = {};

  api.getTopic(id)
    .then(topic => {

      payload.topic = topic;

      return api.getPostsByTopic(id);

    })
    .then(posts => {

      payload.posts = posts;

      res.render('topic', payload);

    })
    .catch(message => {

      res.render('not-found', {message});

    });

});

app.get('/topic/:topic/post/:post', (req, res) => {

  res.render('post', {

    topic: {

      id: req.params.topic,

      name: 'General'

    },

    post: {

      id: req.params.post,

      name: 'Post title goes here'

    }

  });

});

app.get('*', (req, res) => {

  res.redirect('/');

});

let port = process.env.PORT || 8000;

let server = app.listen(port, () => {

  console.log('server running at http://localhost:'+port);

});
