import FcmToken from '../models/fcmToken.model';

export class FcmTokenService {
	/**
	 * Saves a device's FCM token for a user. If the same token already
	 * exists (device reinstalled the app, token unchanged) it just
	 * refreshes device_name instead of inserting a duplicate row.
	 */
	public async saveOrUpdateToken(userId: number, fcmToken: string, deviceName?: string): Promise<FcmToken> {
		const existing = await FcmToken.findOne({
			where: { user_id: userId, fcm_token: fcmToken },
		});

		if (existing) {
			existing.device_name = deviceName ?? existing.device_name;
			await existing.save();
			return existing;
		}

		return FcmToken.create({
			user_id: userId,
			fcm_token: fcmToken,
			device_name: deviceName,
		});
	}

	/**
	 * Removes a token, typically called on logout so the device
	 * stops receiving push notifications for that account.
	 */
	public async removeToken(userId: number, fcmToken: string): Promise<void> {
		await FcmToken.destroy({
			where: { user_id: userId, fcm_token: fcmToken },
		});
	}

	public async getTokensForUser(userId: number): Promise<string[]> {
		const rows = await FcmToken.findAll({ where: { user_id: userId } });
		return rows.map((r) => r.fcm_token);
	}
}

export default new FcmTokenService();