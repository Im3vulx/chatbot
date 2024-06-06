class ApiResponse {
  final bool success;
  final String message;
  final String? token;
  final String? id;

  ApiResponse(
      {required this.success, required this.message, this.token, this.id});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      token: json['token'],
      id: json['id'],
    );
  }
}