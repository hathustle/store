FROM node:20-bullseye

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY . .
RUN apt-get update && apt-get install -y python3 python3-pip python-is-python3
RUN yarn global add @medusajs/medusa-cli @mikro-orm/core @mikro-orm/knex @mikro-orm/migrations @mikro-orm/postgresql awilix pg

# Install project dependencies
RUN yarn install --frozen-lockfile

# Run database migrations
RUN node --experimental-modules --experimental-top-level-await $(yarn bin medusa) db:migrate --verbose

# Build the application
RUN yarn build

# Expose the backend service port
EXPOSE 9000

# Run the backend service
CMD ["yarn", "start"]
