FROM oven/bun:1.2 as base

# Install the necessary packages
WORKDIR /app
COPY package.json /app/package.json
COPY bun.lock /app/bun.lock
RUN bun install

COPY . /app
RUN bun db:generate

RUN bun build --compile --target=bun-linux-x64 ./src/index.ts --outfile myapp

FROM alpine:3.14 as final

WORKDIR /app

COPY --from=base /app/myapp /app/myapp

EXPOSE 3000

CMD [ "/app/myapp" ]
