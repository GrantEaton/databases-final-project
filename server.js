const path = require('path');
const express = require('express');
const bodyParser = require('body-parser');
const pug = require('pug');
const db = require('./database');

let app = express();

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));

app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/users', require('./routes/users'));
app.use('/topics', require('./routes/topics'));
app.use('/posts', require('./routes/posts'));
app.use('/messages', require('./routes/messages'));

app.get('/', (req, res) => {

  Promise.all([db.getActivePosts(20), db.getNewPosts(3), db.getNewTopics(3), db.getNewUsers(3)])
    .then(([activePosts, newPosts, newTopics, newUsers]) => {

      res.render('home', {activePosts, newPosts, newTopics, newUsers});

    })
    .catch(error => {

      res.render('error', {error});

    });

});

app.get('/profile', (req, res) => {

  res.render('layout', {request: 'profile.js'})

})

app.post('/profile', (req, res) => {

  db.updateUser(req.body)
    .then(user => {
      res.redirect('/profile')
    })
    .catch(error => res.render('error', {error}))

})

app.post('/profile/password', (req, res) => {

  db.updateUserPassword(req.body)
    .then(success => {
      res.redirect('/profile')
    })
    .catch(error => res.render('error', {error}))

})

app.get('/profile/:user', (req, res) => {

  let id = req.params.user

  Promise.all([db.getUser(id), db.getTopicsByUser(id, 10), db.getPostsByUser(id, 10), db.getRepliesByUser(id, 3)])
    .then(([user, topics, posts, replies]) => {

      let html = pug.renderFile('./views/profile.pug',

        {user, topics, posts, replies, profile: true}

      )

      res.json({html})

    })

})

app.get('/inbox', (req, res) => {

  res.render('layout', {request: 'inbox.js'})

})

app.get('/inbox/:user', (req, res) => {

  let id = req.params.user

  Promise.all([db.getMessagesSentByUser(id, 10), db.getMessagesReceivedByUser(id, 10), db.getMessagesDeletedByUser(id, 10)])
    .then(([sent, received, archived]) => {

      let html = pug.renderFile('./views/inbox.pug', {sent, received, archived, query: req.query})

      res.json({html})

    })

})

app.get('/create', (req, res) => {

  Promise.all([db.getTopics(), db.getUsers()])
    .then(([topics, users]) => {

      res.render('create', {form: req.query, topics, users})

    })

});

app.get('/login', (req, res) => {

  res.render('login');

});

app.get('/logout', (req, res) => {

  res.render('logout');

});

app.post('/login', (req, res) => {

  db.createLoginAttempt(req.body)
    .then(user => {

      res.json(user)

    })
    .catch(error => res.render('error', {error}))

})

app.get('*', (req, res) => {

  res.render('error', {error: 'page not found'});

});

let port = process.env.PORT || 8000;

let server = app.listen(port, () => {

  console.log('server running at http://localhost:'+port);

});
