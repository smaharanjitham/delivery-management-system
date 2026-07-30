/**
 * Payload sent by the client to log in.
 * fcm_token / device_name are optional — pass them when the
 * request comes from the mobile app so the device is registered
 * for push notifications right at login time.
 */
export interface LoginRequestDto {
	email: string;
	password: string;
	fcm_token?: string;
	device_name?: string;
}

export interface UserSummaryDto {
	id: number;
	full_name: string;
	email: string;
	phone?: string;
	role_id: number;
	role_name?: string;
	profile_image?: string;
}

export interface LoginResponseDto {
	success: boolean;
	message: string;
	accessToken: string;
	refreshToken: string;
	user: UserSummaryDto;
}

export interface RefreshTokenRequestDto {
	refreshToken: string;
}

export interface RefreshTokenResponseDto {
	success: boolean;
	accessToken: string;
	refreshToken: string;
}

export interface SaveFcmTokenRequestDto {
	user_id: number;
	fcm_token: string;
	device_name?: string;
}

export interface SaveFcmTokenResponseDto {
	success: boolean;
	message: string;
}

export interface LogoutRequestDto {
	refreshToken: string;
	fcm_token?: string;
}

export interface RegisterRequestDto {
  full_name: string;
  email: string;
  password: string;
  phone?: string;
  role_id: number;
}

export interface RegisterResponseDto {
  success: boolean;
  message: string;
}