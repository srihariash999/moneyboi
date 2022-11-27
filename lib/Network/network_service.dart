import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Constants/box_names.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';

///
/// NetworkService class contains generic network call method.
/// Could be used from anywhere to make API calls.
///
class NetworkService {
  // Auth box instance.
  final Box _authBox = Hive.box(authBoxName);

  // Dio instance to make network call.
  final Dio _dio = Dio();

  ///
  /// Generic network call method, takes in endpoint url, http-method
  /// and parameters to make api call. Returns an ApiResponseModel which
  /// contains status codes, responses and any error messages.
  ///
  ///
  /// NOTE: This method only checks for dio error, does not check success
  ///       status codes. Any other checks should be done at the place of calling.
  ///
  Future<ApiResponseModel> networkCall({
    required NetworkCallMethod networkCallMethod,
    required String endPointUrl,
    required bool authenticated,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? bodyParameters,
  }) async {
    // If `authenticated` boolean is set to true, x-auth-token is added to
    // request headers after fetching it from authbox.
    if (authenticated) {
      final String _token = _authBox.get('token').toString();
      _dio.options.headers['x-auth-token'] = _token;
    }
    try {
      // Make the api request.
      final Response _resp = await _dio.request(
        // Base URL is added to the endpoint urls passed in.
        baseUrl + endPointUrl,
        // adding queryParameters from the value passed in.
        queryParameters: queryParameters,
        // adding bodyParameters from the value passed in.
        data: bodyParameters,
        // HTTP Method string adding from passed in Enum.
        options: Options(
          // Getter name defined for `NetworkCallMethod` type Enum.
          method: networkCallMethod.name,
        ),
      );

      // Returning `ApiResponseModel` with appropriate status code, endpoint and other data.
      return ApiResponseModel(
        statusCode: _resp.statusCode!,
        endPoint: endPointUrl,
        specificMessage: _resp.data.toString(),
        responseJson: _resp,
      );
    }
    // Catching any DioError thrown and returning appropriate response.
    on DioError catch (e) {
      debugPrint("Dio Error: $e");
      debugPrint("Dio Error: ${e.requestOptions.uri}");
      debugPrint("Dio Error: ${e.requestOptions.headers}");
      debugPrint("Dio Error: ${e.response?.data}");
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: endPointUrl,
        specificMessage: e.response?.data.toString(),
      );
    }
    // Catching all other errors and returning appropriate response.
    catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: endPointUrl,
        specificMessage: " unknown error",
      );
    }
  }
}
