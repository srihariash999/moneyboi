import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Constants/box_names.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';

class NetworkService {
  final Box _authBox = Hive.box(authBoxName);

  final Dio _dio = Dio();

  Future<ApiResponseModel> networkCall({
    required NetworkCallMethod networkCallMethod,
    required String endPointUrl,
    required bool authenticated,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? bodyParameters,
  }) async {
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _resp = await _dio.request(
        baseUrl + endPointUrl,
        queryParameters: queryParameters,
        data: bodyParameters,
        options: Options(
          method: networkCallMethod.name,
        ),
      );

      return ApiResponseModel(
        statusCode: _resp.statusCode!,
        endPoint: endPointUrl,
        specificMessage: _resp.data.toString(),
        responseJson: _resp,
      );
    } on DioError catch (e) {
      debugPrint("Dio Error: $e");
      debugPrint("Dio Error: ${e.requestOptions.uri}");
      debugPrint("Dio Error: ${e.requestOptions.headers}");
      debugPrint("Dio Error: ${e.response?.data}");
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: endPointUrl,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: endPointUrl,
        specificMessage: " unknown error",
      );
    }
  }
}
