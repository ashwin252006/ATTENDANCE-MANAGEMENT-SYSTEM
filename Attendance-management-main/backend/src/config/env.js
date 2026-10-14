import 'dotenv/config';

const required = [
  'PORT','DB_HOST','DB_PORT','DB_USER','DB_PASSWORD','DB_NAME',
  'JWT_ACCESS_SECRET','JWT_REFRESH_SECRET','JWT_ACCESS_EXPIRY','JWT_REFRESH_EXPIRY',
  'COOKIE_DOMAIN','COOKIE_SECURE','COOKIE_SAME_SITE'
];

for (const k of required) {
  if (!process.env[k]) throw new Error(`Missing env var: ${k}`);
}

export const config = Object.freeze({
  port: Number(process.env.PORT),
  db: {
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
  },
  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET,
    refreshSecret: process.env.JWT_REFRESH_SECRET,
    accessExpiry: process.env.JWT_ACCESS_EXPIRY,
    refreshExpiry: process.env.JWT_REFRESH_EXPIRY
  },
  cookie: {
    domain: process.env.COOKIE_DOMAIN,
    secure: process.env.COOKIE_SECURE === 'true',
    sameSite: process.env.COOKIE_SAME_SITE
  }
});