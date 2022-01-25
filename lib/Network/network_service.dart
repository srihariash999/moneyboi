import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';

class NetworkService {
  final Box _authBox = Hive.box('authBox');
  Future<ApiResponseModel> login(
      {required String email, required String password}) async {
    final Dio _dio = Dio();

    try {
      final Response _loginResp = await _dio.post(
        '$baseUrl$loginEndPoint',
        data: {
          "email": email,
          "password": password,
        },
      );

      if (_loginResp.statusCode == 200) {
        _authBox.put('token', _loginResp.data['token']);
        debugPrint(_loginResp.data['token'].toString());
        return ApiResponseModel(
            statusCode: _loginResp.statusCode!,
            endPoint: loginEndPoint,
            specificMessage: "Login Successful");
      } else {
        return ApiResponseModel(
          statusCode: _loginResp.statusCode ?? 400,
          endPoint: loginEndPoint,
          specificMessage: _loginResp.data.toString(),
        );
      }
    } on DioError catch (e) {
      debugPrint("Dio Error: $e");
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: loginEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: loginEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> signup(
      {required String name,
      required String email,
      required String password}) async {
    final Dio _dio = Dio();

    try {
      final Response _signupResp = await _dio.post(
        '$baseUrl$signupEndPoint',
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );

      if (_signupResp.statusCode == 200) {
        return ApiResponseModel(
            statusCode: _signupResp.statusCode!,
            endPoint: loginEndPoint,
            specificMessage: "Signup Successful");
      } else {
        return ApiResponseModel(
          statusCode: _signupResp.statusCode ?? 400,
          endPoint: loginEndPoint,
          specificMessage: _signupResp.data.toString(),
        );
      }
    } on DioError catch (e) {
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: loginEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: loginEndPoint,
        specificMessage: " unknown error",
      );
    }
  }

  Future<ApiResponseModel> getExpenseRecords(
      {String? dateIn, String? dateOut}) async {
    final Dio _dio = Dio();
    final String _token = _authBox.get('token').toString();
    _dio.options.headers['x-auth-token'] = _token;
    try {
      final Response _expenseRecordsResp;

      if (dateIn != null && dateOut != null) {
        _expenseRecordsResp = await _dio.get(
          '$baseUrl$expenseRecordsListingEndPoint',
          queryParameters: {
            "date_in": dateIn,
            "date_out": dateOut,
          },
        );
      } else if (dateIn == null && dateOut != null) {
        _expenseRecordsResp = await _dio.get(
          '$baseUrl$expenseRecordsListingEndPoint',
          queryParameters: {
            "date_out": dateOut,
          },
        );
      } else if (dateIn != null && dateOut == null) {
        _expenseRecordsResp = await _dio.get(
          '$baseUrl$expenseRecordsListingEndPoint',
          queryParameters: {
            "date_in": dateIn,
          },
        );
      } else {
        _expenseRecordsResp = await _dio.get(
          '$baseUrl$expenseRecordsListingEndPoint',
        );
      }

      if (_expenseRecordsResp.statusCode == 200) {
        return ApiResponseModel(
          statusCode: _expenseRecordsResp.statusCode!,
          endPoint: expenseRecordsListingEndPoint,
          responseJson: _expenseRecordsResp,
        );
      } else {
        return ApiResponseModel(
          statusCode: _expenseRecordsResp.statusCode ?? 400,
          endPoint: expenseRecordsListingEndPoint,
        );
      }
    } on DioError catch (e) {
      debugPrint("Dio Error: $e");
      debugPrint(e.response?.data.toString());
      return ApiResponseModel(
        statusCode: e.response?.statusCode ?? 404,
        endPoint: expenseRecordsListingEndPoint,
        specificMessage: e.response?.data.toString(),
      );
    } catch (e) {
      debugPrint(" unknown error : $e");
      return ApiResponseModel(
        statusCode: 400,
        endPoint: expenseRecordsListingEndPoint,
        specificMessage: " unknown error",
      );
    }
  }
}
