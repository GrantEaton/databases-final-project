const express = require('express');
const api = require('../api/api');

let router = express.Router();

router.param('topic', (req, res, next, id) => {

  api.getTopic(id)
    .then(topic => {

      req.topic = topic;
      next();

    })
    .catch(message => {

      res.render('not-found', {message});

    });

})

router.param('post', (req, res, next, id) => {

  api.getPost(req.topic.topic_id, id)
    .then(post => {

      req.post = post;
      next();

    })
    .catch(message => {

      res.render('not-found', {message});

    });

})

router.get('/:topic', (req, res) => {

  let topic = req.topic;

  api.getNewestPostsByTopic(topic.topic_id, 10)
    .then(posts => {

      res.render('topic', {topic, posts});

    })
    .catch(message => {

      res.render('not-found', {message});

    });

});

router.get('/:topic/post/:post', (req, res) => {

  let topic = req.topic;

  let post = req.post;

  res.render('post', {topic, post});

});

router.post('/:topic/post/:post', (req, res) => {

  api.createReply({post_id: req.post.post_id, user_id: 1, text: req.body.text})
    .then(reply => {

      let topicId = reply.post.topic.topic_id;

      let postId = reply.post.post_id;

      res.redirect('/topic/'+topicId+'/post/'+postId);

    })
    .catch(error => {

      res.sendStaus(400, error);

    });

});



module.exports = router;
