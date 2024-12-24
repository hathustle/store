const { Client } = require('pg');

// Get connection string from command line args or default
const connectionString = process.argv[2] || 'postgres://postgres:yourpassword@hathustle-pg-db:5432/medusadb?sslmode=disable';

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
