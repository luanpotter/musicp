const ApiBuilder = require('claudia-api-builder');
const app = new ApiBuilder();

app.get('/', () => ({ message: 'Hello, World!' }));
app.get('/details', () => ({ foo: 'bar' }));

module.exports = app;