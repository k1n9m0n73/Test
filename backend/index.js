const express = require('express')
const cors = require('cors')
const app = express()
const port = process.env.PORT || 3000

app.use(cors()) // Enable CORS for all routes


app.get('/', (req, res) => {
 res.send('Backend Service is Live - Hello World!')
})


app.get('/api/data', (req, res) => {
  const data = {
    message: 'Hello from the backend!',
    timestamp: new Date().toISOString(),
  }
  res.json(data)
})

app.listen(port, () => {
  console.log(`Backend Service listening at http://localhost:${port}`)
})
