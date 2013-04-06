express = require 'express'
http = require 'http'
{map} = require 'underscore'

VERSION = require('../package.json').version
CSS_URL = "//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css"

module.exports = echoback = (serverName, port, cb) ->
  app = express()
  app.use express.cookieParser()
  app.use express.bodyParser()

  log = (msg) ->
    console.log(msg)

  requestToJSON = (req) ->
    JSON.stringify
      route:    "#{req.method} #{req.path}"
      server:   serverName
      port:     port
      path:     req.path
      query:    req.query
      cookies:  req.cookies
      headers:  req.headers
      body:     req.body

  requestToHTML = (req) ->
    query = map req.query, (val, key) -> "<li>#{key}: #{val}</li>"
    query = query.join('')

    cookies = map req.cookies, (val, key) -> "<li>#{key}: #{val}</li>"
    cookies = cookies.join('')

    headers = map req.headers, (val, key) -> "<li>#{key}: #{val}</li>"
    headers = headers.join('')

    body = if Object.keys(req.body).length > 0 then req.body else ""

    """
    <!doctype html>
    <html>
    <head>
      <title>#{serverName} | Echoback #{VERSION}</title>
      <style>* { font-family: Helvetica, Arial, sans-serif; }</style>
    </head>
    <body>
      <h1>#{req.method} #{req.path}</h1>
      <h3>Port: #{port}</h3>
      <h3>Query:</h3>
      <ul>#{query}</ul>
      <h3>Cookies:</h3>
      <ul>#{cookies}</ul>
      <h3>Headers:</h3>
      <ul>#{headers}</ul>
      <h3>Body:</h3>
      <div>#{body}</div>
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

  app.all('*', handler)

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
