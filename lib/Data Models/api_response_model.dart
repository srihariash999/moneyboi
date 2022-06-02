import 'package:dio/dio.dart';

class ApiResponseModel {
  final int statusCode;
  final String endPoint;
  final String? specificMessage;
  final Response? responseJson;
  ApiResponseModel({
    required this.statusCode,
    required this.endPoint,
    this.specificMessage,
    this.responseJson,
  });
}
