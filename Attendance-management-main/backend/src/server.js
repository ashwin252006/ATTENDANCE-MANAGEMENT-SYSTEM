import { app } from './app.js';
import { config } from './config/env.js';
import { testConnection } from './config/db.js';

async function start() {
  try {
    await testConnection();
    console.log('✅ MySQL connected');
    app.listen(config.port, () => console.log(`🚀 API listening on http://localhost:${config.port}`));
  } catch (e) {
    console.error('❌ Failed to start', e);
    process.exit(1);
  }
}

start();