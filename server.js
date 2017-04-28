const path = require('path');
const express = require('express');
const api = require('./api/api');

let app = express();

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));

app.get('/', (req, res) => {

  Promise.all([api.getActivePosts(20), api.getNewPosts(3), api.getNewTopics(3), api.getNewUsers(3)])
    .then(([posts, newPosts, newTopics, newUsers]) => {

      res.render('home', {posts, newPosts, newTopics, newUsers});

    })
    .catch(message => {

      res.render('not-found', {message});

    });

});

app.get('/topic/:topic', (req, res) => {

  api.getTopic(req.params.topic)
    .then(topic => {

      res.render('topic', {topic});

    })
    .catch(message => {

      res.render('not-found', {message});

    });

});

app.get('/topic/:topic/post/:post', (req, res) => {

  api.getPost(req.params.topic, req.params.post)
    .then(post => {

      res.render('post', {post});

    })
    .catch(message => {

      res.render('not-found', {message})

    });

});

app.get('/login', (req, res) => {

  res.render('login');

});

app.get('/profile', (req, res) => {

  Promise.all([api.getUser(1), api.getPostsByUser(1), api.getTopicsByUser(1)])
    .then(([user, posts, topics]) => {

      res.render('user', {user, posts, topics});

    })
    .catch(message => {

      res.render('not-found', {message})

    });

});

app.get('/user/:user', (req, res) => {

  let id = req.params.user;

  Promise.all([api.getUser(id), api.getPostsByUser(id, 3), api.getRepliesByUser(id, 3), api.getTopicsByUser(id)])
    .then(([user, posts, replies, topics]) => {

      res.render('user', {user, posts, replies, topics});

    })
    .catch(message => {

      res.render('not-found', {message})

    });

});

app.get('/inbox', (req, res) => {

  res.render('inbox', {query: req.query});

});

app.get('/create', (req, res) => {

  res.render('create', {query: req.query});

});

app.get('*', (req, res) => {

  res.render('not-found', {message: 'page not found'});

});

let port = process.env.PORT || 8000;

let server = app.listen(port, () => {

  console.log('server running at http://localhost:'+port);

});
