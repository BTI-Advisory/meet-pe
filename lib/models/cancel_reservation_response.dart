class CancelReservationResponse {
  final String? message;
  final double? refundAmount;
  final String? status;
  final String? error;

  CancelReservationResponse({
    this.message,
    this.refundAmount,
    this.status,
    this.error,
  });

  // Factory constructor to parse JSON into the model
  factory CancelReservationResponse.fromJson(Map<String, dynamic> json) {
    return CancelReservationResponse(
      message: json['message'] as String?,
      refundAmount: (json['refund_amount'] as num?)?.toDouble(),
      status: json['status'] as String?,
      error: json['error'] as String?,
    );
  }

  // Convert model back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'refund_amount': refundAmount,
      'status': status,
      'error': error,
    };
  }
}
