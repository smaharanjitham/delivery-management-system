import {
	Body,
	Controller,
	Post,
	Route,
	Tags,
	Response,
	SuccessResponse,
} from 'tsoa';

import authService from '../services/auth.service';

import {
	RegisterRequestDto,
	RegisterResponseDto,
	LoginRequestDto,
	LoginResponseDto,
	RefreshTokenRequestDto,
	RefreshTokenResponseDto,
	LogoutRequestDto,
} from '../dtos/auth.dto';

@Route('auth')
@Tags('Auth')
export class AuthController extends Controller {

	/**
	 * Register User
	 */
	@Post('register')
	@SuccessResponse('201', 'User Registered')
	@Response('400', 'Bad Request')
	public async register(
		@Body() body: RegisterRequestDto
	): Promise<RegisterResponseDto> {

		try {
			this.setStatus(201);

			return await authService.register(body);

		} catch (err: any) {

			this.setStatus(400);

			return {
				success: false,
				message: err.message,
			};
		}
	}

	/**
	 * Login
	 */
	@Post('login')
	@SuccessResponse('200', 'Login successful')
	@Response('401', 'Invalid credentials')
	public async login(
		@Body() body: LoginRequestDto
	): Promise<LoginResponseDto> {

		try {
			return await authService.login(body);

		} catch (err: any) {

			this.setStatus(401);

			return {
				success: false,
				message: err.message || 'Invalid email or password',
				accessToken: '',
				refreshToken: '',
				user: {} as any,
			};
		}
	}

	/**
	 * Refresh Token
	 */
	@Post('refresh-token')
	@SuccessResponse('200', 'Token refreshed')
	@Response('401', 'Invalid refresh token')
	public async refreshToken(
		@Body() body: RefreshTokenRequestDto
	): Promise<RefreshTokenResponseDto> {

		try {
			return await authService.refreshAccessToken(body.refreshToken);

		} catch {

			this.setStatus(401);

			return {
				success: false,
				accessToken: '',
				refreshToken: '',
			};
		}
	}

	/**
	 * Logout
	 */
	@Post('logout')
	@SuccessResponse('200', 'Logout successful')
	public async logout(
		@Body() body: LogoutRequestDto
	): Promise<{ success: boolean; message: string }> {

		await authService.logout(
			body.refreshToken,
			undefined,
			body.fcm_token
		);

		return {
			success: true,
			message: 'Logged out successfully',
		};
	}
}