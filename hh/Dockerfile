FROM node:22-bullseye

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json yarn.lock ./
RUN yarn install

# Copy the rest of the application code
COPY . .

# Expose the backend service port
EXPOSE 9000

# Run the backend service
CMD ["yarn", "start"]
