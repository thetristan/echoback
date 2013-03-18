echoback = require('..')
{equal} = expect = require('assert')

process.env.NODE_ENV = 'test'

beforeEach (done) ->
  @server = echoback('Test Server', 3060, done)

afterEach (done) ->
  @server.close(done)

xdescribe 'module init', ->
xdescribe '#handler', ->

describe '#requestToJSON', ->
  beforeEach ->
    fakeReq =
      path: '/foo'
      query: { foo: 'bar' }
      cookies: { baz: 'qux' }
      headers: { 'x-foo': 'bar' }

    @result = @server.echoback.requestToJSON(fakeReq)
    @result = JSON.parse(@result)

  it 'returns server name', ->
    equal @result.server, 'Test Server'

  it 'returns port number', ->
    equal @result.port, 3060

  it 'returns query string args', ->
    equal @result.query.foo, 'bar'

  it 'returns cookies args', ->
    equal @result.cookies.baz, 'qux'

  it 'returns header args', ->
    equal @result.headers['x-foo'], 'bar'

describe '#requestToHTML', ->
  beforeEach ->
    fakeReq =
      path: '/foo'
      query: { foo: 'bar' }
      cookies: { baz: 'qux' }
      headers: { 'x-foo': 'bar' }

    result = @server.echoback.requestToHTML(fakeReq)
    @has = (substr) -> result.indexOf(substr) > -1

  it 'returns server name', ->
    expect @has('Test Server')

  it 'returns port number', ->
    expect @has('3060')

  it 'returns query string arguments', ->
    expect @has('foo: bar')

  it 'returns cookie arguments', ->
    expect @has('baz: qux')

  it 'returns request headers', ->
    expect @has('x-foo: bar')


describe '#shouldSendJSON', ->
  it 'returns true for paths ending in json', ->
    equal @server.echoback.shouldSendJSON('/index.json'), true
    equal @server.echoback.shouldSendJSON('/foo/bar.json'), true
    equal @server.echoback.shouldSendJSON('/.json'), true

  it 'returns false otherwise', ->
    equal @server.echoback.shouldSendJSON('/index.html'), false
    equal @server.echoback.shouldSendJSON('/foo/bar'), false
    equal @server.echoback.shouldSendJSON('/'), false


