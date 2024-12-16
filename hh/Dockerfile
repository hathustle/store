FROM node:22-bullseye

# Set the working directory
WORKDIR /app
# Copy package files and install dependencies
COPY . .
RUN yarn global add @medusa/cli @medusajs/framework ink @medusajs/medusa @mikro-orm/core @mikro-orm/knex @mikro-orm/migrations @mikro-orm/postgresql awilix pg
RUN apt-get update && apt-get install -y python3 python3-pip python-is-python3

RUN yarn install  --frozen-lockfile

RUN medusa migrations run --verbose

RUN yarn

RUN yarn build

# Expose the backend service port
EXPOSE 9000

# Run the backend service
CMD ["yarn", "start"]
# CREATE ROLE admin WITH LOGIN SUPERUSER PASSWORD 'MGF6mE2R'