import mysql from 'mysql2/promise';
import { config } from './env.js';

export const pool = mysql.createPool(config.db);

export async function testConnection() {
  const conn = await pool.getConnection();
  conn.release();
}