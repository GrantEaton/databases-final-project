const express = require('express')
const db = require('../database')

let router = express.Router()

router.post('/', (req, res) => {

  db.createTopic(req.body)
    .then(topic => {

      res.redirect('/topics/'+topic.id)

    })
    .catch(error => {

      let form = {type: 'topic'}

      res.render('create', {form, error})

    });

})

router.post('/:topic', (req, res) => {

  db.updateTopic(req.body)
    .then(topic => {
      res.redirect('/topics/'+req.params.topic)
    })
    .catch(error => res.render('error', {error}))

})

router.get('/:topic', (req, res) => {

  let id = req.params.topic

  Promise.all([db.getTopic(id), db.getPostsByTopic(id, 10), db.getStickiedPostsByTopic(id, 2)])
    .then(([topic, posts, stickied]) => {

      res.render('topic', {topic, posts, stickied})

    })
    .catch(error => {

      res.render('error', {error})

    })

})


router.post('/:topic/delete', (req, res) => {

  db.deleteTopic(req.params.topic)
    .then(success => {

      res.redirect('/')

    })
    .catch(error => {

      res.render('error', {error})

    })

})

module.exports = router
