const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/playground')
    .then(() => console.log('Connected to mongodb'))
    .catch(err => console.log('Could not connect to mongodb...', err));