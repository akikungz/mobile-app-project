FROM oven/bun:1.2 AS base

# Install the necessary packages
WORKDIR /app
COPY package.json /app/package.json
COPY bun.lock /app/bun.lock
RUN bun install

COPY . /app
RUN bun db:generate

RUN bun build --compile --target=bun-linux-x64 ./src/index.ts --outfile ./app

FROM debian:stable-slim AS final

WORKDIR /app

COPY --from=base /app/app /app

RUN ls /app -la

CMD [ "./app" ]
