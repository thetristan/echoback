# echoback

Simple server that echoes back request parameters for verification purposes. Responds with HTML or JSON based on the Request URI (e.g. `http://localhost:3002/foo` vs `http://localhost:3002/foo.json`)

### Usage

```
$ echoback <server name> <port>

  Options:

    -h, --help                     output usage information
    -V, --version                  output the version number
```

### Examples

```
$ echoback "Test Server" 3002

Test Server now listening on 3002
```

```
$ curl http://localhost:3002/

<!doctype html>
<html>
<head>
  <title>Test Server | Echoback 0.0.2</title>
</head>
<body>
  <h1>GET /</h1>
  <h3>Port: 3002</h3>
  <h3>Path: /</h3>
  <h3>Query:</h3>
  <ul></ul>
  <h3>Cookies:</h3>
  <ul></ul>
  <h3>Headers:</h3>
  <ul>
    <li>user-agent: curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5</li>
    <li>host: localhost:3002</li>
    <li>accept: */*</li>
  </ul>
  <h3>Body:</h3>
</body>
</html>%
```

```
$ curl http://localhost:3002/foo/bar.json
{
    "route": "GET /foo/bar.json",
    "server": "Test Server",
    "port": "3002",
    "path": "/foo/bar.json",
    "query": {},
    "cookies": {},
    "headers": {
        "user-agent": "curl/7.24.0 (x86_64-apple-darwin12.0) libcurl/7.24.0 OpenSSL/0.9.8r zlib/1.2.5",
        "host": "localhost:3002",
        "accept": "*/*"
    },
    body: {}
}
```

