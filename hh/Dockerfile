FROM node:20-bullseye

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY . .
RUN apt-get update && apt-get install -y python3 python3-pip python-is-python3
RUN npm install @medusajs/medusa-cli --global

# @mikro-orm/core @mikro-orm/knex @mikro-orm/migrations @mikro-orm/postgresql awilix pg

# Install project dependencies
# --frozen-lockfile
# RUN echo $REDIS_URL
# RUN cat .env
# Run database migrations
RUN npm install
RUN npm run build
RUN cp .env .medusa/server/.env

RUN cd .medusa/server 
RUN npm install
RUN medusa migrations run
RUN NPM RUN seed

# RUN npm medusa db:migrate
# Build the application
# RUN npm run deploy

# Expose the backend service port
EXPOSE 9000

# Run the backend service
CMD run && medusa start
