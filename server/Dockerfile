FROM oven/bun:1.2 as base

# Install the necessary packages
WORKDIR /app
COPY package.json /app/package.json
COPY bun.lock /app/bun.lock
RUN bun install

# Copy the source code
FROM base as runtime
COPY . /app

# Expose the port
EXPOSE 3000

# Start the server
CMD ["bun", "start"]
