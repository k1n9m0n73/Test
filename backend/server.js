const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Backend Service - Hello World!');
});

app.get('/api/data', (req, res) => {
  const data = {
    message: 'This is data from the backend!',
  };
  res.json(data);
});

app.listen(port, () => {
  console.log(`Backend Service listening at http://localhost:${port}`);
});
