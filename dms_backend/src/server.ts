import 'reflect-metadata';
import dotenv from 'dotenv';
import http from 'http';

dotenv.config();

import app from './app';
import { sequelize } from './config/database';

// Import models here so Sequelize registers every table/association
// before sync() runs. Add new models to this list as you create them.
// import './models/role.model';
// import './models/user.model';
// import './models/fcmToken.model';
// import './models/refreshToken.model';

const PORT = Number(process.env.PORT) || 3000;

let server: http.Server;

const startServer = async () => {
	try {
		await sequelize.sync();
		console.log('✅ Database synced');

		// alter: true keeps existing data and adjusts columns to match models.
		// Switch to sequelize.sync() (no options) once schema is stable,
		// or drop this entirely if you manage schema via the SQL file instead.
		//await sequelize.sync({ alter: true });
		//console.log('✅ Database synced');

		const server = http.createServer(app);

		server.listen(PORT, () => {
			console.log(`🚀 Server running at http://localhost:${PORT}`);
			console.log(`📘 Swagger at http://localhost:${PORT}/api-docs`);
		});
	} catch (err) {
		console.error('❌ Failed to start server', err);
		process.exit(1);
	}
};

const shutdown = async (signal: string) => {
	console.log(`\n${signal} received. Shutting down gracefully...`);

	if (server) {
		server.close(async () => {
			await sequelize.close();
			console.log('✅ Server and DB connections closed');
			process.exit(0);
		});
	} else {
		process.exit(0);
	}
};

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));

process.on('unhandledRejection', (reason) => {
	console.error('❌ Unhandled Rejection:', reason);
});

startServer();