const { Client } = require('pg');

// Use environment variable or fallback to a default (optional)
const connectionString = process.env.DATABASE_URL || 'postgres://postgres:yourpassword@hathustle-pg-db:5432/medusadb?sslmode=disable';

const client = new Client({
  connectionString,
});

client.connect()
  .then(() => {
    console.log('Connected successfully');
    client.end();
  })
  .catch((err) => {
    console.error('Connection failed:', err);
  });
