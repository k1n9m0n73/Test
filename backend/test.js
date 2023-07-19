const express = require('express')
const app = express()
const path = require('path')
const port = process.env.PORT || 3000

app.use(express.static(path.join(__dirname, '../frontend')))

app.get('/', (req, res) => {
  res.sendFile('Backend Service up and running')
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
