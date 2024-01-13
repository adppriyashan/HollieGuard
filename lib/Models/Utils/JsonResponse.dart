class JsonResponse {
  final dynamic data;
  final String message;
  final int statusCode;

  JsonResponse(this.data, this.message, this.statusCode);

  JsonResponse.fromJson(Map<String, dynamic> json, int code)
      : data = json['data'],
        statusCode = code,
        message = json['message'];
}
