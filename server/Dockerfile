FROM oven/bun:1.2 AS base

# Install the necessary packages
WORKDIR /app
COPY package.json /app/package.json
COPY bun.lock /app/bun.lock
RUN bun install

COPY . /app
RUN bun db:generate

RUN bun build --target=node ./src/index.ts --outfile ./app.js

# FROM debian:stable-slim AS final

# WORKDIR /app

# COPY --from=base /app/app /app

# EXPOSE 3001/tcp
# CMD ["/app/app"]

FROM node:22-alpine AS runner

# Install the necessary packages
WORKDIR /app
COPY package.json /app/package.json

RUN npm install

COPY --from=base /app/app.js /app/app.js

CMD [ "node", "app.js" ]
