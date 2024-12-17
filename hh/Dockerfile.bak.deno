# Use the lightweight Debian Bullseye Slim as the base image
FROM node:20-bullseye-slim

# Set the working directory
WORKDIR /app

# Install system dependencies: curl, Python, pip, and required tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    python3 \
    python3-pip \
    python-is-python3 \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh && \
    ln -s /root/.deno/bin/deno /usr/local/bin/deno

# Add Deno to PATH
ENV PATH="/root/.deno/bin:${PATH}"

# Copy the application code
COPY . .
RUN deno install
RUN deno run deploy
RUN deno run seed

# RUN cd ./.medusa/server



# Expose the backend service port
EXPOSE 9000

# Run the backend service
CMD ["deno", "run", "--allow-net", "--allow-read", "--allow-env"]
