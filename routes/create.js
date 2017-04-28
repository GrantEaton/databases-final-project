const express = require('express');
const api = require('../api/api');

let router = express.Router();

router.get('/', (req, res) => {

  res.render('create', {form: req.query});

});

router.post('/', (req, res) => {

  if (req.query.type == 'post') {

    api.createPost(Object.assign(req.body, {user_id: 1}))
      .then(post => {

        res.redirect('/topic/'+post.topic_id+'/post/'+post.post_id);

      })
      .catch(error => {

        let form = req.body;

        form.type = 'post';

        res.render('create', {form, error});

      });

  } else if (req.query.type == 'topic') {

    api.createTopic(Object.assign(req.body, {user_id: 1}))
      .then(topic => {

        res.redirect('/topic/'+topic.topic_id);

      })
      .catch(error => {

        let form = req.body;

        form.type = 'topic';

        res.render('create', {form, error});

      });

  } else if (req.query.type == 'message') {

    api.createMessage(Object.assign(req.body, {user_id: 1}))
      .then(message => {

        res.render('create', {message, form: req.query});

      })
      .catch(error => {

        let form = req.body;

        form.type = 'message';

        res.render('create', {form, error});

      });

  }

});

module.exports = router;
