const ApiBuilder = require('claudia-api-builder');
const app = new ApiBuilder();

const myDetails = {
    name: 'Musicp Server Node',
    protocol: 'musicp',
};

app.get('/', () => ({ message: 'Welcome to the Musicp server!' }));
app.get('/details', () => myDetails);

module.exports = app;