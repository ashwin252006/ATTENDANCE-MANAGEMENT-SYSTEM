import { body } from 'express-validator';
import { login, refresh, logout } from '../services/auth.service.js';
import { validate } from '../middleware/validate.js';

export const loginValidator = [
  body('email').isEmail().normalizeEmail(),
  body('password').isString().isLength({ min: 8 }),
  validate
];

export async function loginCtrl(req, res, next) {
  try {
    const data = await login({ ...req.body, res });
    res.json({ message: 'Login successful', ...data });
  } catch (e) { next(e); }
}

export async function refreshCtrl(req, res, next) {
  try {
    const data = await refresh({ req, res });
    res.json({ message: 'Token refreshed', ...data });
  } catch (e) { next(e); }
}

export function logoutCtrl(req, res) {
  logout(res);
  res.json({ message: 'Logged out' });
}

export async function meCtrl(req, res) {
  res.json({ user: req.user });
}