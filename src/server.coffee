express = require 'express'
http = require 'http'
{map} = require 'underscore'

VERSION = require('../package.json').version
CSS_URL = "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css"

module.exports = echoback = (serverName, port, cb) ->
  app = express()
  app.use express.cookieParser()

  log = (msg) ->
    console.log(msg)

  requestToJSON = (req) ->
    JSON.stringify
      server:   serverName
      port:     port
      path:     req.path
      query:    req.query
      cookies:  req.cookies
      headers:  req.headers

  requestToHTML = (req) ->
    query = map req.query, (val, key) -> "<li>#{key}: #{val}</li>"
    query = query.join('')

    cookies = map req.cookies, (val, key) -> "<li>#{key}: #{val}</li>"
    cookies = cookies.join('')

    headers = map req.headers, (val, key) -> "<li>#{key}: #{val}</li>"
    headers = headers.join('')

    """
    <!doctype html>
    <html>
    <head>
      <title>Echoback #{VERSION}</title>
      <link href="#{CSS_URL}" rel="stylesheet">
    </head>
    <body>
      <h1>#{serverName}</h1>
      <h3>Port: #{port}</h3>
      <h3>Path: #{req.path}</h3>
      <h3>Query:</h3>
      <ul>#{query}</ul>
      <h3>Cookies:</h3>
      <ul>#{cookies}</ul>
      <h3>Headers:</h3>
      <ul>#{headers}</ul>
    </body>
    </html>
    """

  shouldSendJSON = (path) ->
    /\.json$/.test(path)

  handler = (req, res) ->
    if shouldSendJSON(req.path)
      res.type('json')
      res.send requestToJSON(req)
    else
      res.type('html')
      res.send requestToHTML(req)

  app.get('*', handler)

  server = http.createServer(app).listen port, ->
    log("#{serverName} now listening on #{port}")
    cb?()

  if process.env.NODE_ENV == 'test'
    log = ->
    server.echoback = {
      requestToJSON
      requestToHTML
      shouldSendJSON
      handler
      log
      app
    }

  server