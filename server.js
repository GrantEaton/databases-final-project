const path = require('path');
const express = require('express');

const api = require('./api/api');

let app = express();

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));

app.get('/', (req, res) => {

  api.getActivePosts(20).then(posts => {

    res.render('home', {posts});

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

  let topicId = req.params.topic;

  let postId = req.params.post;

  api.getPost(topicId, postId)
    .then(({topic, post}) => {

      res.render('post', {topic, post});

    })
    .catch(message => {

      res.render('not-found', {message})

    });

});

app.get('/login', (req, res) => {

  res.render('login');

});

app.get('/profile', (req, res) => {

  res.render('profile');

});

app.get('/inbox', (req, res) => {

  res.render('inbox');

});

app.get('/create', (req, res) => {

  res.render('create', {

    type: req.query.type || 'post',

    topic: req.query.topic || ''

  });

});

app.get('*', (req, res) => {

  res.render('not-found', {message: 'page not found'});

});

let port = process.env.PORT || 8000;

let server = app.listen(port, () => {

  console.log('server running at http://localhost:'+port);

});
