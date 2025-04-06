extension StringExtension on String {
  List<String>? get nameParts {
    return trim().split(RegExp(r'\s+'));
  }
}
