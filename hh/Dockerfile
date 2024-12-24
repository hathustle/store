FROM node:20-bullseye

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json into the container
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code
COPY . ./

# Update CA certificates
RUN update-ca-certificates
COPY .env ./.medusa/server/.env

# Build the application
RUN npm run build

# Expose the port Medusa will run on
EXPOSE 9000

# Add a healthcheck for the container
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:9000/health || exit 1

# Command to start the MedusaJS application
CMD ["bash"] 
# cd ./.medusa/server && npm run predeploy && npm run start