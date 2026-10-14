import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import mysql from 'mysql2/promise';
import 'dotenv/config';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const dbConfig = {
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  multipleStatements: true
};

async function run() {
  const schema = fs.readFileSync(path.resolve(__dirname, '../../database/schema.sql'), 'utf8');
  const seed = fs.readFileSync(path.resolve(__dirname, '../../database/seed.sql'), 'utf8');

  const conn = await mysql.createConnection(dbConfig);
  console.log('Creating database & tables...');
  await conn.query(schema);
  console.log('Seeding data...');
  await conn.query(seed);
  await conn.end();
  console.log('✅ Database ready');
}

run().catch(err => {
  console.error('❌ Setup failed', err);
  process.exit(1);
});