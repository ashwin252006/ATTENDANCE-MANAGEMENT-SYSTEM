import { Router } from 'express';
import { authenticate } from '../middleware/auth.js';
import { loginValidator, loginCtrl, refreshCtrl, logoutCtrl, meCtrl } from '../controllers/auth.controller.js';

const router = Router();

router.post('/login', loginValidator, loginCtrl);
router.post('/refresh', refreshCtrl);
router.post('/logout', authenticate, logoutCtrl);
router.get('/me', authenticate, meCtrl);

export default router;