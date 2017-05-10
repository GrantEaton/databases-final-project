const express = require('express')
const db = require('../database')

let router = express.Router()

router.post('/', (req, res) => {

  db.createPost(Object.assign(req.body, {user_id: 1}))
    .then(post => {

      res.redirect('/posts/'+post.id)

    })
    .catch(error => {

      res.render('error', {error})

    })

})

router.get('/:post', (req, res) => {

  let id = req.params.post;

  Promise.all([db.getPost(id), db.getRepliesByPost(id, 10), db.getTopics()])

    .then(([post, replies, topics]) => {

      res.render('post', {post, replies, topics})

    })
    .catch(error => {

      res.render('error', {error})

    })

})

router.post('/:post', (req, res) => {

  db.updatePost(req.body)
    .then(post => {
      res.redirect('/posts/'+req.params.post)
    })
    .catch(error => res.render('error', {error}))

})

router.post('/:post/replies', (req, res) => {

  let id = req.params.post

  db.createReply(req.body)
    .then(reply => {

      res.redirect('/posts/'+id)

    })
    .catch(error => {

      res.render('error', {error})

    })

})

router.post('/:post/delete', (req, res) => {

  db.deletePost(req.params.post)
    .then(success => {

      res.redirect('/')

    })
    .catch(error => {

      res.render('error', {error})

    })

})

module.exports = router
