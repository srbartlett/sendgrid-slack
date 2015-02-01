require "coffee-script/register"

express = require("express")
logger = require("morgan")
bodyParser = require("body-parser")
app = express()

app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)

if process.env.SLACK_DOMAIN == undefined || process.env.SLACK_TOKEN == undefined
  throw "SLACK_DOMAIN and SLACK_TOKEN must be defined"

Slack = require('node-slack')
slack = new Slack(process.env.SLACK_DOMAIN, process.env.SLACK_TOKEN)

app.post '/', (req, res) ->
  for event in req.body
    slack.send
      text: event.event + " event for: " + event.email,
      channel: process.env.SLACK_CHANNEL || 'general'
      icon_emoji: ':email:',
      username: 'sendgrid'
  res.status 200
  res.send ''

module.exports = app

port = 3000
app.listen(process.env.PORT || port)

console.log('Express started on port ' + port)
