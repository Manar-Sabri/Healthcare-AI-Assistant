class BaseApiResponse<T> {
  final int statusCode;
  final String message;
  final String? traceId;
  final T? value;

  BaseApiResponse({
    required this.statusCode,
    required this.message,
    this.traceId,
    this.value,
  });

  factory BaseApiResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    return BaseApiResponse<T>(
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      traceId: json['traceId'] as String?,
      value: json['value'] != null ? fromJsonT(json['value']) : null,
    );
  }
}
