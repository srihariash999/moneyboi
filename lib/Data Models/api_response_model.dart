class ApiResponseModel {
  final int statusCode;
  final String endPoint;
  final String? specificMessage;
  final String? responseJson;
  ApiResponseModel({
    required this.statusCode,
    required this.endPoint,
    this.specificMessage,
    this.responseJson,
  });
}
