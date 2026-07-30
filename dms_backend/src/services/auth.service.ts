import bcrypt from 'bcrypt';

import {User} from '../models/user.model';
import {Role} from '../models/role.model';
import {RefreshToken} from '../models/refreshToken.model';

import fcmTokenService from './fcmToken.service';

import {
	generateAccessToken,
	generateRefreshToken,
	verifyRefreshToken,
	getRefreshTokenExpiryDate,
} from '../utils/jwt.util';

import {
	LoginRequestDto,
	LoginResponseDto,
	RefreshTokenResponseDto,
	RegisterRequestDto,
	RegisterResponseDto,
} from '../dtos/auth.dto';

export class AuthService {
	/**
	 * Register User
	 */
	public async register(
		payload: RegisterRequestDto
	): Promise<RegisterResponseDto> {
		const {
			full_name,
			email,
			password,
			phone,
			role_id,
		} = payload;

		const existingUser = await User.findOne({
			where: {
				email: email.trim().toLowerCase(),
			},
		});

		if (existingUser) {
			throw new Error('Email already exists');
		}

		const hashedPassword = await bcrypt.hash(password, 10);

		await User.create({
			full_name,
			email: email.trim().toLowerCase(),
			password: hashedPassword,
			phone,
			role_id,
			is_active: true,
		});

		return {
			success: true,
			message: 'User registered successfully',
		};
	}

	/**
	 * Login
	 */
	public async login(
		payload: LoginRequestDto
	): Promise<LoginResponseDto> {
		const {
			email,
			password,
			fcm_token,
			device_name,
		} = payload;

		const user = await User.findOne({
			where: {
				email: email.trim().toLowerCase(),
			},
			include: [
				{
					model: Role,
					as: 'role',
				},
			],
		});

		if (!user) {
			throw new Error('Invalid email or password');
		}

		if (!user.is_active) {
			throw new Error(
				'This account has been deactivated. Please contact support.'
			);
		}

		const isMatch = await bcrypt.compare(
			password,
			user.password
		);

		if (!isMatch) {
			throw new Error('Invalid email or password');
		}

		const tokenPayload = {
			id: user.id,
			email: user.email,
			role_id: user.role_id,
		};

		const accessToken = generateAccessToken(tokenPayload);
		const refreshToken = generateRefreshToken(tokenPayload);

		await RefreshToken.create({
			user_id: user.id,
			refresh_token: refreshToken,
			expires_at: getRefreshTokenExpiryDate(),
		});

		if (fcm_token) {
    console.log("Saving FCM token...");

    const result = await fcmTokenService.saveOrUpdateToken(
        user.id,
        fcm_token,
        device_name
    );

    console.log("Saved:", result.toJSON());
}

		const roleName = (user as any).role?.role_name;

		return {
			success: true,
			message: 'Login successful',
			accessToken,
			refreshToken,
			user: {
				id: user.id,
				full_name: user.full_name,
				email: user.email,
				phone: user.phone,
				role_id: user.role_id,
				role_name: roleName,
				profile_image: user.profile_image,
			},
		};
	}

	/**
	 * Refresh Token
	 */
	public async refreshAccessToken(
		refreshToken: string
	): Promise<RefreshTokenResponseDto> {
		let decoded: any;

		try {
			decoded = verifyRefreshToken(refreshToken);
		} catch {
			throw new Error('Invalid or expired refresh token');
		}

		const stored = await RefreshToken.findOne({
			where: {
				refresh_token: refreshToken,
			},
		});

		if (!stored) {
			throw new Error(
				'Refresh token not recognized. Please log in again.'
			);
		}

		if (
			stored.expires_at &&
			new Date(stored.expires_at) < new Date()
		) {
			await stored.destroy();

			throw new Error(
				'Refresh token expired. Please log in again.'
			);
		}

		const tokenPayload = {
			id: decoded.id,
			email: decoded.email,
			role_id: decoded.role_id,
		};

		const newAccessToken =
			generateAccessToken(tokenPayload);

		const newRefreshToken =
			generateRefreshToken(tokenPayload);

		await stored.destroy();

		await RefreshToken.create({
			user_id: decoded.id,
			refresh_token: newRefreshToken,
			expires_at: getRefreshTokenExpiryDate(),
		});

		return {
			success: true,
			accessToken: newAccessToken,
			refreshToken: newRefreshToken,
		};
	}

	/**
	 * Logout
	 */
	public async logout(
		refreshToken: string,
		userId?: number,
		fcmToken?: string
	): Promise<void> {
		await RefreshToken.destroy({
			where: {
				refresh_token: refreshToken,
			},
		});

		if (userId && fcmToken) {
			await fcmTokenService.removeToken(
				userId,
				fcmToken
			);
		}
	}
}

export default new AuthService();