FROM oven/bun:1.2-slim AS base

# Install the necessary packages
WORKDIR /app
COPY package.json /app/package.json
COPY bun.lock /app/bun.lock
RUN bun install

COPY . /app
RUN bun db:generate

RUN bun build --compile --target=bun ./src/index.ts --outfile ./app

# CMD [ "bun", "run", "index.ts" ]

FROM debian:stable-slim AS final

WORKDIR /app

COPY --from=base /app/app /app

# EXPOSE 3001/tcp
CMD ["/app/app"]