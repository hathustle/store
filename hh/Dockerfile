FROM node:20-bullseye

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json into the container
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code
COPY . ./

# Copy SSL certificate from the host machine (outside Git)
COPY /etc/easypanel/projects/admin/files/0.txt /usr/local/share/ca-certificates/postgres.crt

# Update CA certificates
RUN update-ca-certificates

# Build the application
RUN npm run build

# Expose the port Medusa will run on
EXPOSE 9000

# Add a healthcheck for the container
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:9000/health || exit 1

# Command to start the MedusaJS application
CMD ["sh", "-c", "cd ./.medusa/server && npm run predeploy && npm run start"]