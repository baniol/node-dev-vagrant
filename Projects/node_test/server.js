var http = require('http');

var server = http.Server(function (req, res) {
  res.writeHead('Content-Type', 'text/html');
  res.write('hello world nodejs');
  res.end();
});

server.listen(8000);