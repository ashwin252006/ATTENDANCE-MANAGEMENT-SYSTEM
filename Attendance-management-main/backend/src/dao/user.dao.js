import { pool } from '../config/db.js';

export async function findUserByEmail(email) {
  const [rows] = await pool.execute(
    `SELECT id, email, password_hash, role, is_active FROM users WHERE email = ?`,
    [email]
  );
  return rows[0] ?? null;
}

export async function findUserById(id) {
  const [rows] = await pool.execute(
    `SELECT id, email, role, is_active FROM users WHERE id = ?`,
    [id]
  );
  return rows[0] ?? null;
}

export async function createUser({ email, passwordHash, role }) {
  const [result] = await pool.execute(
    `INSERT INTO users (email, password_hash, role) VALUES (?,?,?)`,
    [email, passwordHash, role]
  );
  return result.insertId;
}