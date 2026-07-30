import { Body, Controller, Post, Route, Security, Tags, SuccessResponse } from 'tsoa';
import fcmTokenService from '../services/fcmToken.service';
import { SaveFcmTokenRequestDto, SaveFcmTokenResponseDto } from '../dtos/auth.dto';

@Route('fcm-token')
@Tags('FCM Token')
export class FcmTokenController extends Controller {
	/**
	 * Saves or refreshes a device's FCM token. Called by the app both
	 * right after login and whenever Firebase rotates the token
	 * (NotificationService.instance.onTokenRefresh in the Flutter app).
	 */
	@Post('save')
	@Security('BearerAuth')
	@SuccessResponse('200', 'Token saved')
	public async saveToken(@Body() body: SaveFcmTokenRequestDto): Promise<SaveFcmTokenResponseDto> {
		await fcmTokenService.saveOrUpdateToken(body.user_id, body.fcm_token, body.device_name);
		return { success: true, message: 'FCM token saved successfully' };
	}
}