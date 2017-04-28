const path = require('path');
const express = require('express');
const bodyParser = require('body-parser');
const api = require('./api/api');

let app = express();

app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));

app.use('/create', require('./routes/create'));
app.use('/topic', require('./routes/topic'));

app.get('/', (req, res) => {

  Promise.all([api.getActivePosts(20), api.getNewPosts(3), api.getNewTopics(3), api.getNewUsers(3)])
    .then(([posts, newPosts, newTopics, newUsers]) => {

      res.render('home', {posts, newPosts, newTopics, newUsers});

    })
    .catch(message => {

      res.render('not-found', {message});

    });

});

app.get('/login', (req, res) => {

  res.render('login');

});

app.get('/profile', (req, res) => {

  Promise.all([api.getUser(1), api.getPostsByUser(1), api.getTopicsByUser(1)])
    .then(([user, posts, topics]) => {

      res.render('user', {user, posts, topics, profile: true});

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

  Promise.all([api.getMessagesReceivedByUser(1, 10), api.getMessagesSentByUser(1, 10)])
    .then(([received, sent]) => {

      res.render('inbox', {query: req.query, received, sent});

    })
    .catch(message => {

      res.render('not-found', {message})

    });

});

app.get('*', (req, res) => {

  res.render('not-found', {message: 'page not found'});

});

let port = process.env.PORT || 8000;

let server = app.listen(port, () => {

  console.log('server running at http://localhost:'+port);

});
