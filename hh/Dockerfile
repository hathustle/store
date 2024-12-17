FROM node:20-bullseye

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY . .
RUN apt-get update && apt-get install -y python3 python3-pip python-is-python3
RUN npm install @medusajs/cli --global

# @mikro-orm/core @mikro-orm/knex @mikro-orm/migrations @mikro-orm/postgresql awilix pg

# Install project dependencies
# --frozen-lockfile

# Run database migrations
RUN npm install
RUN npm run build
RUN cd ./.medusa/server && npm run predeploy && npm run start

# Build the application
# RUN npm run deploy
RUN npm run seed

RUN cd ./.medusa/server



# Expose the backend service port
EXPOSE 9000

# Run the backend service
CMD ["npm", "run", "start"]
