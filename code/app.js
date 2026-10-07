export function createHandler({ version, commit, color, log = () => {} }) {
  return (request, response) => {
    const path = new URL(request.url, 'http://localhost').pathname;

    const send = (status, body) => {
      const payload = JSON.stringify(body);
      response.writeHead(status, {
        'cache-control': 'no-store',
        'content-length': Buffer.byteLength(payload),
        'content-type': 'application/json; charset=utf-8',
        'x-content-type-options': 'nosniff',
      });
      response.end(payload);
    };

    if (request.method !== 'GET') {
      response.setHeader('allow', 'GET');
      send(405, { error: 'method not allowed' });
      return;
    }

    if (path === '/healthz' || path === '/readyz') {
      send(200, { status: 'ok' });
      return;
    }

    if (path === '/version') {
      send(200, { version, commit, color });
      return;
    }

    if (path === '/api/greeting') {
      log({ event: 'greeting', version, commit, color });
      send(200, { message: `Hello from ${color}`, version });
      return;
    }

    if (path === '/') {
      const body = `${version}\n`;
      response.writeHead(200, {
        'cache-control': 'no-store',
        'content-length': Buffer.byteLength(body),
        'content-type': 'text/plain; charset=utf-8',
        'x-content-type-options': 'nosniff',
      });
      response.end(body);
      return;
    }

    send(404, { error: 'not found' });
  };
}
