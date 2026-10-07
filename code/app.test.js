import assert from 'node:assert/strict';
import { test } from 'node:test';
import { createHandler } from './app.js';

const events = [];
const handle = createHandler({
  version: '0.0.2',
  commit: 'abc123',
  color: 'green',
  log: (event) => events.push(event),
});

function request(path, method = 'GET') {
  const headers = new Map();
  const result = { status: null, body: null, headers };
  const response = {
    setHeader(name, value) {
      headers.set(name.toLowerCase(), value);
    },
    writeHead(status, values) {
      result.status = status;
      for (const [name, value] of Object.entries(values)) {
        headers.set(name.toLowerCase(), value);
      }
    },
    end(payload) {
      result.body = headers.get('content-type')?.startsWith('text/plain')
        ? payload
        : JSON.parse(payload);
    },
  };

  handle({ url: path, method }, response);
  return result;
}

test('health endpoints report readiness', () => {
  for (const path of ['/healthz', '/readyz']) {
    const result = request(path);
    assert.equal(result.status, 200);
    assert.deepEqual(result.body, { status: 'ok' });
  }
});

test('version identifies the image and active color without caching', () => {
  const result = request('/version');
  assert.equal(result.headers.get('cache-control'), 'no-store');
  assert.deepEqual(result.body, {
    version: '0.0.2',
    commit: 'abc123',
    color: 'green',
  });
});

test('business endpoint responds and emits a structured log', () => {
  const result = request('/api/greeting');
  assert.deepEqual(result.body, { message: 'Hello from green', version: '0.0.2' });
  assert.deepEqual(events.at(-1), {
    event: 'greeting',
    version: '0.0.2',
    commit: 'abc123',
    color: 'green',
  });
});

test('home page shows only the release version', () => {
  const firstRelease = createHandler({ version: '0.0.1', commit: 'abc123', color: 'blue' });
  const firstResponse = { writeHead(status, headers) { this.status = status; this.headers = headers; }, end(body) { this.body = body; } };
  firstRelease({ url: '/', method: 'GET' }, firstResponse);
  const secondResponse = request('/');

  assert.equal(firstResponse.status, 200);
  assert.equal(firstResponse.headers['content-type'], 'text/plain; charset=utf-8');
  assert.equal(firstResponse.body, '0.0.1\n');
  assert.equal(secondResponse.body, '0.0.2\n');
});

test('unknown routes and unsupported methods fail explicitly', () => {
  assert.equal(request('/missing').status, 404);

  const result = request('/version', 'POST');
  assert.equal(result.status, 405);
  assert.equal(result.headers.get('allow'), 'GET');
});
