FROM denoland/deno:latest

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY . .
RUN deno install --global npm:@medusajs/cli
RUN deno install
# @mikro-orm/core @mikro-orm/knex @mikro-orm/migrations @mikro-orm/postgresql awilix pg

# Install project dependencies
# --frozen-lockfile

# Run database migrations
# RUN npm install
# RUN npm run build
# RUN cd ./.medusa/server && npm run predeploy && npm run start
# RUN npm medusa db:migrate
# Build the application
RUN deno run deploy
RUN deno run seed

# RUN cd ./.medusa/server



# Expose the backend service port
EXPOSE 9000

# Run the backend service
CMD ["deno", "run", "--allow-net", "--allow-read", "--allow-env"]
