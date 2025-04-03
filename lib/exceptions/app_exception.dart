class AppException implements Exception {
  final String message;
  final String? devDetails;
  final String? prettyDetails;

  AppException({
    required this.message,
    this.devDetails,
    this.prettyDetails,
  });

  @override
  String toString() {
    return 'FirestoreApiException: $message ${devDetails != null ? '- $devDetails' : ''}';
  }
}
