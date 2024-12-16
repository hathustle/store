FROM node:22-bullseye

# Set the working directory
WORKDIR /app
RUN yarn global add @medusajs/cli
# Copy package files and install dependencies
COPY . .
RUN yarn install --frozen-lockfile

RUN medusa db:migrate --verbose

# Expose the backend service port
EXPOSE 9000

# Run the backend service
CMD ["yarn", "start"]
