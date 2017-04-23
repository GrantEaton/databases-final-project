const express = require('express');

let app = express();

app.get('/', (req, res) => {

  res.send('success');

});

let server = app.listen(8000);
