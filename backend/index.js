const express = require('express');
const app = express();

const mongoose = require('mongoose');
const expenses = require('./routes/expenses');
const users = require('./routes/users');
const auth = require('./routes/auth');

const config = require('config');

if(!config.get('jwtPrivateKey')){
    console.error('FATAL ERROR: jwtPrivateKey not defined');
    process.exit(1);
}

mongoose.connect('mongodb://localhost/moneyboi')
    .then(() => console.log('Connected to mongodb'))
    .catch(err => console.log('Could not connect to mongodb...', err));

app.use(express.json());
app.use('/api/users', users);
app.use('/api/auth', auth);
app.use('/api/expenses',expenses);


const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening on port ${port}...`));