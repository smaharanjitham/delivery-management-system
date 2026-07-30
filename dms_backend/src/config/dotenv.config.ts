import dotenv from 'dotenv';

dotenv.config();

export const env = {
	PORT: Number(process.env.PORT) || 5000,

	DB_HOST: process.env.DB_HOST ?? 'localhost',
	DB_USER: process.env.DB_USER ?? 'root',
	DB_PASSWORD: process.env.DB_PASSWORD ?? 'password',
	DB_NAME: process.env.DB_NAME ?? 'delivery_management',

	CORS_ALLOW_ORIGINS: process.env.ALLOW_ALL_ORIGINS,

	ACCESS_SECRET: process.env.JWT_ACCESS_SECRET ?? '',
};
