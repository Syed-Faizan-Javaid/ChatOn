class ApiResponse<T> {
  bool success = false;
  String? error;
  T? data;
  ApiResponse({this.success = false});
}
