// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettingsResponse _$NotificationSettingsResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationSettingsResponse(
      reservationEmail: json['reservation_email'] as bool,
      reservationApp: json['reservation_app'] as bool,
      reservationSms: json['reservation_sms'] as bool,
      reservationAppelTelephone: json['reservation_appel_telephone'] as bool,
      notificationMeetpeEmail: json['notification_meetpe_email'] as bool,
      notificationMeetpeApp: json['notification_meetpe_app'] as bool,
      notificationMeetpeSms: json['notification_meetpe_sms'] as bool,
      notificationMeetpeAppelTelephone:
          json['notification_meetpe_appel_telephone'] as bool,
      userId: json['user_id'] as int,
      updatedAt: json['updated_at'] as String,
      createdAt: json['created_at'] as String,
      id: json['id'] as int,
    );
