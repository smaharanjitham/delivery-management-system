import 'reflect-metadata';
import express from 'express';
import cors from 'cors';
import path from 'path';
import swaggerUi from 'swagger-ui-express';
import swaggerDocument from './swagger/swagger.json';
import { RegisterRoutes } from './routes-tsoa/routes';
import { errorHandler } from './middlewares/error.middleware';

const app = express();

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// CORS setup
const allowAll = process.env.ALLOW_ALL_ORIGINS === 'true';
const allowedOrigins = process.env.ALLOWED_ORIGINS
	? process.env.ALLOWED_ORIGINS.split(',').map((o) => o.trim())
	: [];

app.use(
	cors({
		origin: allowAll ? true : allowedOrigins,
		credentials: true,
	})
);

// tsoa-generated routes (auth, fcm-token, delivery orders, etc.)
// Regenerate with `tsoa routes` whenever a controller changes.
// RegisterRoutes signature expects only the Express app instance.
RegisterRoutes(app);

// Static file serving for uploaded proof-of-delivery / profile images
app.use('/api/v1/uploads', express.static(path.join(__dirname, '../uploads')));

// Swagger docs
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Health check
app.get('/', (req, res) => {
	res.send('Hello World! Server is working 🚀');
});

// Catch-all 404 for unmatched routes (must come after RegisterRoutes)
app.use((req, res) => {
	res.status(404).json({
		success: false,
		message: `Route ${req.method} ${req.originalUrl} not found`,
	});
});

// Centralized error handler — must be registered last
app.use(errorHandler);

export default app;