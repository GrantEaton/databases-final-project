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

let server = app.listen(8000, () => {

  console.log('server running at http://localhost:8000');

});
