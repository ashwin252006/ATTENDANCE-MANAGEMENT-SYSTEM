import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import cookieParser from 'cookie-parser';
import rateLimit from 'express-rate-limit';
import { config } from './config/env.js';
import authRoutes from './routes/auth.routes.js';
import { errorHandler } from './middleware/errorHandler.js';

export const app = express();

app.use(helmet());
app.use(cors({ origin: 'http://localhost:5173', credentials: true }));
app.use(morgan('dev'));
app.use(express.json());
app.use(cookieParser());

const authLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 30, standardHeaders: true, legacyHeaders: false });
app.use('/api/auth', authLimiter);

app.use('/api/auth', authRoutes);

app.get('/api/health', (_req, res) => res.json({ status: 'ok' }));

app.use('/api', (_req, res) => res.status(404).json({ message: 'API route not found' }));

app.use(errorHandler);