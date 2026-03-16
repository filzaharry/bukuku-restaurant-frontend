import 'pagination_meta.dart';

class BaseResponse<T> {
  final int statusCode;
  final String message;
  final T? data;
  final PaginationMeta? meta;
  final List<dynamic>? traceId;

  BaseResponse({
    required this.statusCode,
    required this.message,
    this.data,
    this.meta,
    this.traceId,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT, {
    bool hasMeta = false,
  }) {
    // Determine if data is wrapped in another object (like from FilterHelper)
    final dynamic rawData = json['data'];

    // Prioritize 'meta' key at top level, then 'pagination' at top level,
    // then 'pagination' nested within 'data' if 'data' is a map and hasMeta is true.
    final dynamic metaData = json['meta'] ?? json['pagination'] ?? (hasMeta && rawData is Map ? rawData['pagination'] : null);

    final dynamic actualData = (hasMeta && rawData is Map && rawData.containsKey('data')) ? rawData['data'] : rawData;

    return BaseResponse(
      statusCode: json['statusCode'],
      message: json['message'] ?? "",
      data: actualData != null ? fromJsonT(actualData) : null,
      meta: metaData != null ? PaginationMeta.fromJson(metaData) : null,
      traceId: json['traceId'] != null ? List<dynamic>.from(json['traceId']) : null,
    );
  }
}
