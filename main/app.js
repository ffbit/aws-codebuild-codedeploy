const express = require('express')
const app = express()
const port = process.env.PORT || 3000
const region = process.env.MY_AWS_REGION || 'localhost'

app.get('/', (req, res) => {
  res.send(`Hello from a sample Node.js web application with AWS CodeBuild/CodeDeploy/CodePipeline integration deployed to an EC2 instance in ${region}, listening on port: ${port}.`)
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
});

