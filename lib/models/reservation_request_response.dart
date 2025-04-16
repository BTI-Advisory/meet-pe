import 'package:json_annotation/json_annotation.dart';

part 'reservation_request_response.g.dart';

@JsonSerializable(createToJson: false)
class ReservationRequestResponse {
  const ReservationRequestResponse({
    this.clientSecret,
    this.paymentIntentId,
    this.error,
  });

  @JsonKey(name: 'clientSecret')
  final String? clientSecret;

  @JsonKey(name: 'payment_intent_id')
  final String? paymentIntentId;

  @JsonKey(name: 'error')
  final String? error;

  factory ReservationRequestResponse.fromJson(Map<String, dynamic> json) {
    return ReservationRequestResponse(
      clientSecret: json['clientSecret'] as String?,
      paymentIntentId: json['payment_intent_id'] as String?,
      error: json['error'] as String?,
    );
  }
}
