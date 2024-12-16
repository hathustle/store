FROM node:22-bullseye

# Set the working directory
WORKDIR /app
# Copy package files and install dependencies
COPY . .
RUN yarn global add @medusa/cli@2.1.1 @medusajs/framework@2.1.1 ink @medusajs/medusa@2.1.1 @mikro-orm/core@5.9.7 @mikro-orm/knex@5.9.7 @mikro-orm/migrations@5.9.7 @mikro-orm/postgresql@5.9.7 awilix pg
RUN apt-get update && apt-get install -y python3 python3-pip python-is-python3

RUN yarn install  --frozen-lockfile

RUN medusa db:migrate --verbose

RUN yarn

RUN yarn build

# Expose the backend service port
EXPOSE 9000

# Run the backend service
CMD ["yarn", "start"]
# CREATE ROLE admin WITH LOGIN SUPERUSER PASSWORD 'MGF6mE2R'