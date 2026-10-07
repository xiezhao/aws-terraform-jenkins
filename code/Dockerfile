FROM node:24-alpine

WORKDIR /app

ARG APP_VERSION=dev
ARG GIT_SHA=unknown

ENV NODE_ENV=production \
    PORT=3000 \
    APP_VERSION=${APP_VERSION} \
    GIT_SHA=${GIT_SHA}

COPY --chown=node:node package.json app.js server.js ./

USER node
EXPOSE 3000
CMD ["node", "server.js"]
