const express = require('express')
const db = require('../database')

let router = express.Router()

router.post('/', (req, res) => {

  db.createUser(req.body)
    .then(user => {

      res.json(user)

    })
    .catch(error => res.render('error', {error}))

})

router.get('/:user', (req, res) => {

  let id = req.params.user

  Promise.all([db.getUser(id), db.getTopicsByUser(id, 3), db.getPostsByUser(id, 3), db.getRepliesByUser(id, 3)])
    .then(([user, topics, posts, replies]) => {

      res.render('user', {user, topics, posts, replies})

    })

})

router.post('/:user/delete', (req, res) => {

  db.deleteUser(req.params.user)
    .then(success => {

      res.redirect('/')

    })
    .catch(error => {

      res.render('error', {error})

    })

})

module.exports = router
