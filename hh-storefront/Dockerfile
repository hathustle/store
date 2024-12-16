FROM node:22-bullseye

WORKDIR /storefront

RUN yarn global add @medusajs/cli

COPY . .

RUN rm -rf ./node_modules

RUN apt-get update && apt-get install

RUN yarn install --frozen-lockfile

RUN medusa db:migrate --verbose

CMD yarn start