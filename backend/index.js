const express = require('express');
const app = express();

const mongoose = require('mongoose');

const users = require('./routes/users');
const auth = require('./routes/auth');

mongoose.connect('mongodb://localhost/playground')
    .then(() => console.log('Connected to mongodb'))
    .catch(err => console.log('Could not connect to mongodb...', err));

app.use(express.json());
app.use('/api/users', users);
app.use('/api/auth', auth);

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening on port ${port}...`));