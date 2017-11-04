const http = require('http');
const net = require('net');
const Proxy = require('http-mitm-proxy');
const proxy = Proxy();

const { TARGET_HOST } = process.env;

/*
 * Intercept all requests to TARGET_HOST, and respond directly
 */

proxy.onRequest(function(context, continueRequestCallback) {
  context.use(Proxy.gunzip);

  if (hostContains(context, TARGET_HOST || 'example.com')) {
    console.log("Overriding request to " + context.clientToProxyRequest.headers.host);
    context.proxyToClientResponse.end(`<html>
      <body style="display: flex; align-items: center; justify-content: center;">
        <h1 style="font-family: sans-serif; font-size: 100pt">PANIC</h1>
      </body>
    </html>`);
    return;
  }

  continueRequestCallback();
});

function hostContains(context, match) {
  return context.clientToProxyRequest.headers.host.indexOf(match) !== -1;
}

/*
 * Generic setup to handle errors, and pass through real HTTPS untouched
 */

proxy.onError(function(context, err) {
  console.error('proxy error:', err);
});

proxy.onConnect(function(req, socket, head) {
  var host = req.url.split(":")[0]
  var port = req.url.split(":")[1]

  console.log('Tunnel to', req.url)
  var conn = net.connect(port, host, function(){
    socket.write('HTTP/1.1 200 OK\r\n\r\n', 'UTF-8', function(){
      conn.pipe(socket);
      socket.pipe(conn);
    })
  })

  conn.on("error",function(e){
    console.log('Tunnel error', e);
  })
});

console.log('Waiting for proxy to be ready...');
proxy.listen({port: 8080}, (err) => {
  if (err) {
    console.error(err);
  } else {
    console.log('Proxy ready');
  }
});

