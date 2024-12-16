FROM node:20-bullseye

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY . .
RUN apt-get update && apt-get install -y python3 python3-pip python-is-python3
RUN npm install @medusajs/medusa-cli --global
# @mikro-orm/core @mikro-orm/knex @mikro-orm/migrations @mikro-orm/postgresql awilix pg

# Install project dependencies
RUN npm install 
# --frozen-lockfile

# Run database migrations
# RUN medusa migrations run --verbose

# Build the application
RUN npm run build
RUN cd ./.medusa/server
RUN node ./src/scripts/seed.js

# Expose the backend service port
EXPOSE 9000

# Run the backend service
CMD ["npm", "run", "start"]
