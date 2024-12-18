import { loadEnv, defineConfig, Modules, ModuleRegistrationName } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())
const DB_USERNAME = process.env.DB_USERNAME
const DB_PASSWORD = process.env.DB_PASSWORD
const DB_HOST = process.env.DB_HOST
const DB_PORT = process.env.DB_PORT
const DB_DATABASE = process.env.DB_DATABASE

const DATABASE_URL =
  `postgres://${DB_USERNAME}:${DB_PASSWORD}` +
  `@${DB_HOST}:${DB_PORT}/${DB_DATABASE}`

module.exports = defineConfig({
  modules: [
    {
      resolve: "@medusajs/cache-redis",
      key: ModuleRegistrationName.CACHE,
      options: {
        redisUrl: process.env.REDIS_URL,
        // serviceName: "cacheService", 
      },
    },
    {
      resolve: "@medusajs/event-bus-redis",
      key: ModuleRegistrationName.EVENT_BUS,
      options: {
        redisUrl: process.env.REDIS_URL,
        // serviceName: "eventService", 
      },
    },
    {
      resolve: "@medusajs/workflow-engine-redis",
      key: ModuleRegistrationName.WORKFLOW_ENGINE,
      options: {
        redis: {
          url: process.env.REDIS_URL,
          // serviceName: "workflowService", 
        },
      },
    },
  ],
  admin: {
    disable: process.env.DISABLE_MEDUSA_ADMIN === "true",
  },
  projectConfig: {
    databaseUrl: DATABASE_URL, // process.env.DATABASE_URL, //: DATABASE_URL,
    redisUrl: process.env.REDIS_URL,
    workerMode: process.env.MEDUSA_WORKER_MODE as "shared" | "worker" | "server",
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
    },
  }
})
