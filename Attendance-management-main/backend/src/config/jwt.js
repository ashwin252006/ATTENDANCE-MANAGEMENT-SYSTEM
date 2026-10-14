import jwt from 'jsonwebtoken';
import { config } from './env.js';

export function signAccess(payload) {
  return jwt.sign(payload, config.jwt.accessSecret, { expiresIn: config.jwt.accessExpiry });
}

export function signRefresh(payload) {
  return jwt.sign(payload, config.jwt.refreshSecret, { expiresIn: config.jwt.refreshExpiry });
}

export function verifyAccess(token) {
  return jwt.verify(token, config.jwt.accessSecret);
}

export function verifyRefresh(token) {
  return jwt.verify(token, config.jwt.refreshSecret);
}