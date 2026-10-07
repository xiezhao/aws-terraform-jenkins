import { createServer } from 'node:http';
import { createHandler } from './app.js';

const port = Number(process.env.PORT ?? 3000);
if (!Number.isInteger(port) || port < 1 || port > 65535) {
  throw new Error('PORT must be an integer between 1 and 65535');
}

const release = {
  version: process.env.APP_VERSION ?? 'dev',
  commit: process.env.GIT_SHA ?? 'unknown',
  color: process.env.DEPLOY_COLOR ?? 'local',
};

const server = createServer(createHandler({
  ...release,
  log: (event) => console.log(JSON.stringify(event)),
}));

server.listen(port, '0.0.0.0', () => {
  console.log(JSON.stringify({ event: 'started', port, ...release }));
});
