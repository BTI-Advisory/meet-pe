import 'dart:convert';

class AvailabilityListResponse {
  final int id;
  final int userId;
  final String day;
  final int isAvailableFullTime;
  final String createdAt;
  final String updatedAt;
  final List<ScheduleTime> scheduleTimes;

  AvailabilityListResponse({
    required this.id,
    required this.userId,
    required this.day,
    required this.isAvailableFullTime,
    required this.createdAt,
    required this.updatedAt,
    required this.scheduleTimes,
  });

  factory AvailabilityListResponse.fromJson(Map<String, dynamic> json) {
    var scheduleTimesList = json['schedule_times'] as List;
    List<ScheduleTime> scheduleTimes = scheduleTimesList.map((e) => ScheduleTime.fromJson(e)).toList();

    return AvailabilityListResponse(
      id: json['id'],
      userId: json['user_id'],
      day: json['day'],
      isAvailableFullTime: json['is_available_full_time'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      scheduleTimes: scheduleTimes,
    );
  }
}

class ScheduleTime {
  final int id;
  final int guideScheduleId;
  final String from;
  final String to;
  final String createdAt;
  final String updatedAt;

  ScheduleTime({
    required this.id,
    required this.guideScheduleId,
    required this.from,
    required this.to,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleTime.fromJson(Map<String, dynamic> json) {
    return ScheduleTime(
      id: json['id'],
      guideScheduleId: json['guide_schedule_id'],
      from: json['from'],
      to: json['to'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

List<AvailabilityListResponse> parseAvailabilityItem(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<AvailabilityListResponse>((json) => AvailabilityListResponse.fromJson(json)).toList();
}
