const path = require('path');
const express = require('express');

let app = express();

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, 'views'));

app.get('/', (req, res) => {

  res.render('home', {

    topics: ['General', 'Sports', 'Programming', 'Cooking']

  });

});

app.get('/topic/:topic', (req, res) => {

  res.render('topic', {

    topic: {

      id: req.params.topic,

      name: 'General'

    }

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

let server = app.listen(8000, () => {

  console.log('server running at http://localhost:8000');

});
