const express = require('express')
const db = require('../database')

let router = express.Router()

router.post('/', (req, res) => {

  db.createMessage(req.body)
    .then(message => {

      res.redirect('/inbox?folder=sent')

    })
    .catch(error => {

      res.render('error', {error})

    })

})

router.post('/:message/delete', (req, res) => {

  db.deleteMessage(req.params.message)
    .then(success => {

      res.redirect('/inbox')

    })
    .catch(error => {

      res.render('error', {error})

    })

})

module.exports = router
