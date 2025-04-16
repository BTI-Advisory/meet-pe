import 'package:json_annotation/json_annotation.dart';

part 'notification_settings_response.g.dart';

@JsonSerializable(createToJson: false)
class NotificationSettingsResponse {
  const NotificationSettingsResponse({required this.reservationEmail, required this.reservationApp, required this.reservationSms, required this.reservationAppelTelephone, required this.notificationMeetpeEmail, required this.notificationMeetpeApp, required this.notificationMeetpeSms, required this.notificationMeetpeAppelTelephone, required this.userId, required this.updatedAt, required this.createdAt, required this.id});

  @JsonKey(name: 'reservation_email')
  final bool reservationEmail;
  @JsonKey(name: 'reservation_app')
  final bool reservationApp;
  @JsonKey(name: 'reservation_sms')
  final bool reservationSms;
  @JsonKey(name: 'reservation_appel_telephone')
  final bool reservationAppelTelephone;
  @JsonKey(name: 'notification_meetpe_email')
  final bool notificationMeetpeEmail;
  @JsonKey(name: 'notification_meetpe_app')
  final bool notificationMeetpeApp;
  @JsonKey(name: 'notification_meetpe_sms')
  final bool notificationMeetpeSms;
  @JsonKey(name: 'notification_meetpe_appel_telephone')
  final bool notificationMeetpeAppelTelephone;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'id')
  final int id;

  factory NotificationSettingsResponse.fromJson(Map<String, dynamic> json) => _$NotificationSettingsResponseFromJson(json);
}
