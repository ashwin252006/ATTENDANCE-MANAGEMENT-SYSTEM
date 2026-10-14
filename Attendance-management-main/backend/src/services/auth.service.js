import { findUserByEmail, findUserById } from '../dao/user.dao.js';
import { verifyPassword, hashPassword } from '../utils/password.js';
import { signAccess, signRefresh, verifyRefresh } from '../config/jwt.js';
import { setAuthCookies, clearAuthCookies } from '../utils/cookie.js';

export async function login({ email, password, res }) {
  const user = await findUserByEmail(email);
  if (!user || !user.is_active) throw Object.assign(new Error('Invalid credentials'), { status: 401 });
  const ok = await verifyPassword(password, user.password_hash);
  if (!ok) throw Object.assign(new Error('Invalid credentials'), { status: 401 });

  const payload = { id: user.id, email: user.email, role: user.role };
  const accessToken = signAccess(payload);
  const refreshToken = signRefresh(payload);
  setAuthCookies(res, accessToken, refreshToken);
  return { user: payload };
}

export async function refresh({ req, res }) {
  const token = req.cookies?.refreshToken;
  if (!token) throw Object.assign(new Error('Refresh token missing'), { status: 401 });
  let payload;
  try { payload = verifyRefresh(token); }
  catch { throw Object.assign(new Error('Invalid refresh token'), { status: 401 }); }

  const user = await findUserById(payload.id);
  if (!user || !user.is_active) throw Object.assign(new Error('User not found'), { status: 401 });

  const newPayload = { id: user.id, email: user.email, role: user.role };
  const newAccess = signAccess(newPayload);
  const newRefresh = signRefresh(newPayload);
  setAuthCookies(res, newAccess, newRefresh);
  return { user: newPayload };
}

export function logout(res) {
  clearAuthCookies(res);
}