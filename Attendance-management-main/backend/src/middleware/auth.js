import { verifyAccess } from '../config/jwt.js';

export async function authenticate(req, res, next) {
  try {
    const token = req.cookies?.accessToken;
    if (!token) return res.status(401).json({ message: 'Access token missing' });
    const payload = verifyAccess(token);
    req.user = payload; // { id, email, role }
    next();
  } catch (e) {
    return res.status(401).json({ message: 'Invalid or expired access token' });
  }
}