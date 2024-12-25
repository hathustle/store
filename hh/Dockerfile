FROM node:20-bullseye

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json into the container
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code
COPY . ./

# Download Let's Encrypt root certificate
RUN curl -o /usr/local/share/ca-certificates/lets-encrypt-x1.crt https://letsencrypt.org/certs/isrgrootx1.pem

# Set the NODE_EXTRA_CA_CERTS environment variable to include the downloaded certificate
ENV NODE_EXTRA_CA_CERTS=/usr/local/share/ca-certificates/lets-encrypt-x1.crt
# Update CA certificates
# RUN update-ca-certificates


# Build the application
RUN npm run build
COPY .env ./.medusa/server/.env

# Expose the port Medusa will run on
EXPOSE 9000

# Add a healthcheck for the container
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:9000/health || exit 1

# Command to start the MedusaJS application
# CMD ["sh", "-c", "cd ./.medusa/server && npm run predeploy && npm run start"]
CMD ["tail", "-f", "/dev/null"]

# cd ./.medusa/server && npm run predeploy && npm run start