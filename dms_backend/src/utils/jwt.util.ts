import jwt, { SignOptions } from 'jsonwebtoken';

const ACCESS_SECRET = process.env.JWT_ACCESS_SECRET || 'your-secret-key';
const REFRESH_SECRET = process.env.JWT_REFRESH_SECRET || 'your-refresh-secret-key';

const ACCESS_EXPIRY = (process.env.JWT_ACCESS_EXPIRY || '15m') as SignOptions['expiresIn'];
const REFRESH_EXPIRY = (process.env.JWT_REFRESH_EXPIRY || '30d') as SignOptions['expiresIn'];

export interface JwtPayload {
	id: number;
	email: string;
	role_id: number;
}

export const generateAccessToken = (payload: JwtPayload): string => {
	return jwt.sign(payload, ACCESS_SECRET, { expiresIn: ACCESS_EXPIRY });
};

export const generateRefreshToken = (payload: JwtPayload): string => {
	return jwt.sign(payload, REFRESH_SECRET, { expiresIn: REFRESH_EXPIRY });
};

export const verifyRefreshToken = (token: string): JwtPayload => {
	return jwt.verify(token, REFRESH_SECRET) as JwtPayload;
};

/**
 * Turns "15m" / "30d" style expiry strings into a concrete Date,
 * used when persisting refresh_tokens.expires_at.
 */
export const getRefreshTokenExpiryDate = (): Date => {
	const raw = process.env.JWT_REFRESH_EXPIRY || '30d';
	const match = /^(\d+)([smhd])$/.exec(raw);

	const now = new Date();
	if (!match) {
		now.setDate(now.getDate() + 30);
		return now;
	}

	const value = parseInt(match[1], 10);
	const unit = match[2];

	switch (unit) {
		case 's':
			now.setSeconds(now.getSeconds() + value);
			break;
		case 'm':
			now.setMinutes(now.getMinutes() + value);
			break;
		case 'h':
			now.setHours(now.getHours() + value);
			break;
		case 'd':
			now.setDate(now.getDate() + value);
			break;
	}

	return now;
};